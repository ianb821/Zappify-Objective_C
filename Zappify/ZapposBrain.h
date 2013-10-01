//
//  ZapposBrain.h
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


// Handy macros
#define zapposBrain [ZapposBrain sharedZapposBrain]
#warning Add your API key here
#define API_KEY @"&key=YOUR_API_KEY_HERE"

#import <Foundation/Foundation.h>
#import "ZapposItem.h"

// Completion blocks used in network calls
typedef void (^URLRequestCompletionBlock)(NSURL *request, NSDictionary *resultsDictionary, NSError *error);
typedef void (^ZapposItemPhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface ZapposBrain : NSObject


+ (ZapposBrain *)sharedZapposBrain;

- (void)loadItemsBeingMonitored;
- (void)saveItemsBeingMonitored;
- (void)startCheckingForUpdatedPricing;
- (void)checkFavoritesForUpdatedPricing;
- (void)getSearchResultsForTerm:(NSString *)term;
- (void)notifyUserAboutZapposItem:(ZapposItem *)item;
- (void)updateAutoCompleteResultsForTerm:(NSString *)term;


@property NSMutableArray *itemsToWatch;
@property NSMutableArray *searchResults;
@property NSMutableArray *autoCompleteResults;
@property NSTimer *checkForUpdatedPricingTimer;

@end
