//
//  ZapposItemCell.m
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItemCell is UICollectionViewCell subclass that displays info about an item in the Zappos Store

#import "ZapposItemCell.h"

@implementation ZapposItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.masksToBounds = NO;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.shadowOpacity = 0.75f;
        self.layer.shadowRadius = 2.5f;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)setUpCellWithZapposItem:(ZapposItem *)item FavoriteItem:(BOOL)favorite {
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[item.thumbnailImage CGImage]
                                                                            scale:(item.thumbnailImage.scale * 1.25)
                                                                      orientation:(item.thumbnailImage.imageOrientation)]];
    [self addSubview:self.imageView];
    
    self.imageView.center = CGPointMake(self.contentView.center.x, 52);
    
    // setup brand name
    
    UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 22)];
    brandName.text = item.brandName;
    brandName.textAlignment = NSTextAlignmentCenter;
    brandName.font = [UIFont fontWithName:@"Optima-Bold" size:16];
    brandName.minimumScaleFactor = 0.6f;
    brandName.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:brandName];
    brandName.center = CGPointMake(72.5, 115.0);
    
    // setup product name
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 22)];
    productName.text = item.productName;
    productName.textAlignment = NSTextAlignmentCenter;
    productName.font = [UIFont fontWithName:@"Optima-Regular" size:16];
    productName.minimumScaleFactor = 0.6f;
    productName.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:productName];
    productName.center = CGPointMake(brandName.center.x, brandName.center.y + 22);
    
    // setup prices
    
    if ([item.normalPrice isEqualToString:item.discountedPrice]) {
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 22)];
        price.text = item.discountedPrice;
        price.textAlignment = NSTextAlignmentCenter;
        price.font = [UIFont fontWithName:@"Optima-Bold" size:15];
        price.textColor = [UIColor colorWithRed:1.000 green:0.237 blue:0.000 alpha:1.000];
        
        [self addSubview:price];
        price.center = CGPointMake(productName.center.x, productName.center.y + 22);
    } else {
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        
        NSAttributedString *strikeThroughText;
        
        if (item.normalPrice != nil) {
            strikeThroughText = [[NSAttributedString alloc] initWithString:item.normalPrice attributes:attributes];
        } else {
            strikeThroughText = [[NSAttributedString alloc] initWithString:@"Original" attributes:attributes];
        }
        
        UILabel *originalPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 22)];
        originalPriceLabel.font = [UIFont fontWithName:@"Optima-Bold" size:15];
        originalPriceLabel.attributedText = strikeThroughText;
        originalPriceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:originalPriceLabel];
        originalPriceLabel.center = CGPointMake(productName.center.x - 33, productName.center.y + 22);
        
        UILabel *discountedPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 22)];
        discountedPriceLabel.font = [UIFont fontWithName:@"Optima-Bold" size:15];
        discountedPriceLabel.text = item.discountedPrice;
        discountedPriceLabel.textColor = [UIColor colorWithRed:1.000 green:0.237 blue:0.000 alpha:1.000];
        discountedPriceLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:discountedPriceLabel];
        discountedPriceLabel.center = CGPointMake(productName.center.x + 33, productName.center.y + 22);
        
    }
    
    // setup icons if item is favorited/has sent email
    
    if (!item.notify && favorite) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.starredView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
        [self addSubview:self.starredView];
        self.starredView.center = CGPointMake(CGRectGetWidth(self.starredView.frame) / 2.0 + 4, (CGRectGetHeight(self.starredView.frame) / 2.0) + 1);
    } else if ([zapposBrain.itemsToWatch indexOfObject:item] != NSNotFound && !favorite) {
        self.layer.borderColor = [UIColor colorWithRed:1.000 green:0.237 blue:0.000 alpha:1.000].CGColor;
        self.layer.borderWidth = 1.5f;
        self.starredView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
        [self addSubview:self.starredView];
        self.starredView.center = CGPointMake(CGRectGetWidth(self.starredView.frame) / 2.0 + 2, (CGRectGetHeight(self.starredView.frame) / 2.0) + 2);
        
    } else {
        [self.starredView removeFromSuperview];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
}


@end
