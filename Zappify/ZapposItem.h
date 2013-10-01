//
//  ZapposItem.h
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItem is a class to contain all the important info about a Zappos Item

#import <Foundation/Foundation.h>

@interface ZapposItem : NSObject

@property int desiredPercentOff;
@property UIImage *thumbnailImage;
@property NSString *productName, *normalPrice, *discountedPrice, *percentOff, *productId, *imageURL, *brandName, *productUrl, *emailAddressToAlert; // Now that is a lot of strings!
@property BOOL notify;

@end
