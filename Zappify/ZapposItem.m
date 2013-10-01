//
//  ZapposItem.m
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItem is a class to contain all the important info about a Zappos Item

#import "ZapposItem.h"

@implementation ZapposItem

- (id)init {
    self = [super init];
    self.notify = YES;
    return self;
}

// override isEqual to be used when checking new search results for items already being watched
//lots of ifs!

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[ZapposItem class]]) {
        if ([((ZapposItem *)object).productId isEqualToString:self.productId])
            if ([((ZapposItem *)object).productName isEqualToString:self.productName])
                if ([((ZapposItem *)object).productUrl isEqualToString:self.productUrl])
                    if ([((ZapposItem *)object).discountedPrice isEqualToString:self.discountedPrice])
                        return YES;
        
    }
    
    return NO;
}

#pragma mark - Encoder / Decoder

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:self.notify forKey:@"notify"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.productId forKey:@"productId"];
    [encoder encodeObject:self.brandName forKey:@"brandName"];
    [encoder encodeObject:self.percentOff forKey:@"percentOff"];
    [encoder encodeObject:self.productUrl forKey:@"productUrl"];
    [encoder encodeObject:self.productName forKey:@"productName"];
    [encoder encodeObject:self.normalPrice forKey:@"normalPrice"];
    [encoder encodeObject:self.thumbnailImage forKey:@"thumbnailImage"];
    [encoder encodeObject:self.discountedPrice forKey:@"discountedPrice"];
    [encoder encodeInt:self.desiredPercentOff forKey:@"desiredPercentOff"];
    [encoder encodeObject:self.emailAddressToAlert forKey:@"emailAddressToAlert"];
    
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.notify = [decoder decodeBoolForKey:@"notify"];
    self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    self.productId = [decoder decodeObjectForKey:@"productId"];
    self.brandName = [decoder decodeObjectForKey:@"brandName"];
    self.percentOff = [decoder decodeObjectForKey:@"percentOff"];
    self.productUrl = [decoder decodeObjectForKey:@"productUrl"];
    self.productName = [decoder decodeObjectForKey:@"productName"];
    self.normalPrice = [decoder decodeObjectForKey:@"normalPrice"];
    self.productName = [decoder decodeObjectForKey:@"productName"];
    self.thumbnailImage = [decoder decodeObjectForKey:@"thumbnailImage"];
    self.discountedPrice = [decoder decodeObjectForKey:@"discountedPrice"];
    self.desiredPercentOff = [decoder decodeIntForKey:@"desiredPercentOff"];
    self.emailAddressToAlert = [decoder decodeObjectForKey:@"emailAddressToAlert"];
    
    return self;
}


@end
