//
//  ZapposBrain.m
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposBrain handles all of the network calls and price monitoring for the user
// it keeps up with items that need to be monitored, and notifies them via email
// using the SendGrid API, when an item has met the desired discount.

#import "ZapposBrain.h"

@implementation ZapposBrain

#pragma mark - ZapposBrain singleton methods

+ (ZapposBrain *)sharedZapposBrain {
    static ZapposBrain *sharedZapposBrain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedZapposBrain = [[self alloc] init];
    });
    return sharedZapposBrain;
}

- (id)init {
    if (self = [super init]) {
        
        self.searchResults = [[NSMutableArray alloc] init];
        self.autoCompleteResults = [[NSMutableArray alloc] init];
        self.itemsToWatch = [[NSMutableArray alloc] init];
        
    }
    return self;
}

#pragma mark - Search API Call

// processes a search made by the user
- (void)getSearchResultsForTerm:(NSString *)term {
    
    NSString *searchURL = [NSString stringWithFormat:@"http://api.zappos.com/Search/term/%@?limit=20%@", [self prepareStringForURLRequest:term], API_KEY];
    
    [self getJSONDataFromRequest:[NSURL URLWithString:searchURL] completionBlock:^(NSURL *requestURL, NSDictionary *resultsDictionary, NSError *error) {
        
        
        NSArray *resultsArray = [resultsDictionary objectForKey:@"results"];
        if (self.searchResults.count) {
            [self.searchResults removeAllObjects];
        }
        for (NSDictionary *dict in resultsArray) {
            [self loadZapposItemFromDictionary:dict];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
    }];
    
}

#pragma mark - AutoComplete API Call

// processes the autocomplete API call for the current term in the search bar
- (void)updateAutoCompleteResultsForTerm:(NSString *)term {
    
    NSString *searchURL = [NSString stringWithFormat:@"http://api.zappos.com/AutoComplete?term=%@", [self prepareStringForURLRequest:term]];
    [self getJSONDataFromRequest:[NSURL URLWithString:searchURL] completionBlock:^(NSURL *requestURL, NSDictionary *resultsDictionary, NSError *error) {
        
        if (resultsDictionary.count) {
            NSArray *resultsArray = [resultsDictionary objectForKey:@"results"];
            if (self.autoCompleteResults.count) {
                [self.autoCompleteResults removeAllObjects];
            }
            for (NSString *term in resultsArray) {
                [self.autoCompleteResults addObject:term];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSearch" object:self];
            });
            
        } else {
            NSLog(@"No results for term: %@\nURL:%@\nError:%@", term, requestURL, error.localizedDescription);
        }
        
    }];
}

#pragma mark - Email User (SendGrid)

// Notifies a user about a Zappos Item by email using the SendGrid API
- (void)notifyUserAboutZapposItem:(ZapposItem *)item {
    
    NSString *subjectForEmail = [self prepareStringForURLRequest:item.productName];

    
    // format the email body with the item link and current discount
    NSString *textBodyForEmail = [self prepareStringForURLRequest:[NSString stringWithFormat:@"It's your lucky day, %@ is now %@ off! Click the following link and head on over to Zappos to purchase it before it's too late!\n%@", item.productName, item.percentOff, item.productUrl]];
    
    __block NSString *coreValueForEmail, *valueID, *valueSummary;;
    
    
    // get a random Zappos Family Core Value to include at the bottom of the notification email
    [self getJSONDataFromRequest:[NSURL URLWithString:@"http://api.zappos.com/CoreValue/random"] completionBlock:^(NSURL *request, NSDictionary *coreValueDictionary, NSError *error) {
        
        if (error == nil) {
            
            NSArray *dictArray = [coreValueDictionary objectForKey:@"values"];
            for (NSDictionary *dict in dictArray)
                for (NSString *key in dict) {
                    if ([key isEqualToString:@"id"])
                        valueID = [dict objectForKey:key];
                    if ([key isEqualToString:@"summary"])
                        valueSummary = [dict objectForKey:key];
                }
            
            coreValueForEmail = [[NSString stringWithFormat:@"\n\nZappos Family Core Value #%@:\n%@", valueID, valueSummary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        } else {
            
            // default Zappos Family Core Value in the case of an error requesting one
            NSLog(@"Error getting Core Value:%@", error.localizedDescription);
            coreValueForEmail = [@"\n\nZappos Family Core Value #9:\nPassion is the fuel that drives us and our company forward." stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        // create the call to the SendGrid API to send an email notification
        NSString * urlString = [NSString stringWithFormat:@"https://sendgrid.com/api/mail.send.json?api_user=%@&api_key=%@&to=%@&subject=%@&text=%@%@&from=ianb821@gmail.com", SG_USERNAME, SG_PASSWORD item.emailAddressToAlert, subjectForEmail , textBodyForEmail, coreValueForEmail];
        
        
        [self getJSONDataFromRequest:[NSURL URLWithString:urlString] completionBlock:^(NSURL *request, NSDictionary *emailResultsDictionary, NSError *error) {
            
            if (error == nil) {
                if ([[emailResultsDictionary objectForKey:@"message"] isEqualToString:@"success"])
                    NSLog(@"Email sent");
            } else {
                NSLog(@"Error sending email:%@", error.localizedDescription);
            }
            
        }];
    }];
}

#pragma mark - Price Monitoring


// check every x seconds to see if the price of each item has met the desired discount.  Currently set to one hour
- (void)startCheckingForUpdatedPricing {
    [self checkFavoritesForUpdatedPricing];
    if (!self.checkForUpdatedPricingTimer.isValid) {
        self.checkForUpdatedPricingTimer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(checkFavoritesForUpdatedPricing) userInfo:nil repeats:YES];
    }
}

- (void)checkFavoritesForUpdatedPricing {
    for (ZapposItem *item in self.itemsToWatch)
        [self verifyIfShouldAlertUserAboutZapposItem:item];
}

// stop monitoring a specific item if the user has already been notified of the price
- (void)stopMonitoringForPriceOfItem:(ZapposItem *)item {
    if (item.notify) {
        NSUInteger index = [self.itemsToWatch indexOfObject:item];
        item.notify = NO;
        if (index != NSNotFound)
            [self.itemsToWatch replaceObjectAtIndex:index withObject:item];
    }
}


// check to see if the item is discounted to the desired discount, notifies the user if so and stops monitoring the item
- (void)verifyIfShouldAlertUserAboutZapposItem:(ZapposItem *)item {
    
    if (item.notify) {
        
        NSString *searchURL = [NSString stringWithFormat:@"http://api.zappos.com/Search?term=%@%@", item.productId, API_KEY];
        
        [self getJSONDataFromRequest:[NSURL URLWithString:searchURL] completionBlock:^(NSURL *request, NSDictionary *resultsDictionary, NSError *error) {
            
            if (error == nil) {
                
                NSArray *resultsArray = [resultsDictionary objectForKey:@"results"];
                NSDictionary *dict = [resultsArray objectAtIndex:0];
                if ([[dict objectForKey:@"productId"] isEqualToString:item.productId]) {
                    NSString *percentOffString = [dict objectForKey:@"percentOff"];
                    int currentPercentOff = [[percentOffString substringToIndex:percentOffString.length - 1] intValue];
                    if (currentPercentOff >= item.desiredPercentOff) {
                        [self notifyUserAboutZapposItem:item];
                        [self stopMonitoringForPriceOfItem:item];
                    }
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                
                
            } else {
                NSLog(@"Error searching for product by product ID:%@", error.localizedDescription);
            }
            
        }];
    }
}

#pragma mark - JSON Requests

// Encode an NSString
- (NSString *)prepareStringForURLRequest:(NSString *)string {
    
    CFStringRef buffer = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (CFStringRef)string,
                                                                 NULL,
                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                 kCFStringEncodingUTF8);
    
    return [NSString stringWithString:(NSString *)CFBridgingRelease(buffer)];
}

// processes a URL request and returns (via completion block) the JSON Dictionary result
- (void)getJSONDataFromRequest:(NSURL *)requestUrl completionBlock:(URLRequestCompletionBlock) completionBlock{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak __block NSString *resultString;
    __weak __block NSDictionary *resultDictionary;
    __weak __block NSError *error = nil;
    

    
    dispatch_async(queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        
        resultString = [NSString stringWithContentsOfURL:requestUrl
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
        if (error != nil) {
            completionBlock(requestUrl, nil, error);
        } else {
            
            NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
            resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:kNilOptions
                                                                 error:&error];
            
            if (error != nil) {
                completionBlock(requestUrl, nil, error);
            } else {
                completionBlock(requestUrl, resultDictionary, error);
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

#pragma mark - Zappos Item/Image Loading

// loads a Zappos Item into the zapposBrain.searchResults array, handles loading the thumbnail image
- (void)loadZapposItemFromDictionary:(NSDictionary *)dict  {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        ZapposItem *item = [[ZapposItem alloc] init];
        item.imageURL = [dict objectForKey:@"thumbnailImageUrl"];
        item.productName = [dict objectForKey:@"productName"];
        item.percentOff = [dict objectForKey:@"percentOff"];
        item.discountedPrice = [dict objectForKey:@"price"];
        item.productId = [dict objectForKey:@"productId"];
        item.brandName = [dict objectForKey:@"brandName"];
        item.normalPrice = [dict objectForKey:@"originalPrice"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
        item.imageURL = [dict objectForKey:@"thumbnailImageUrl"];
        item.thumbnailImage = [UIImage imageWithData:imageData];
        item.productUrl = [dict objectForKey:@"productUrl"];
        [zapposBrain.searchResults addObject:item];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object:self];
        });
        
    });
}

#pragma mark - Save items

- (void)saveItemsBeingMonitored {
    
    // clear out old saved info
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSData *data;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:self.itemsToWatch
            ];
    [defaults setObject:data forKey:@"itemsToWatch"];
}

#pragma mark - Load items

- (void)loadItemsBeingMonitored {
    
    NSData *data;
    NSArray *arr;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"itemsToWatch"]) {
        data = [defaults objectForKey:@"itemsToWatch"];
        arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.itemsToWatch = [arr mutableCopy];
        [self startCheckingForUpdatedPricing];
    }
    
}

@end
