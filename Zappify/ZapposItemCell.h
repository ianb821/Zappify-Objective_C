//
//  ZapposItemCell.h
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItemCell is UICollectionViewCell subclass that displays info about an item in the Zappos Store

#import <UIKit/UIKit.h>
#import "ZapposBrain.h"

@interface ZapposItemCell : UICollectionViewCell

- (void)setUpCellWithZapposItem:(ZapposItem *)item FavoriteItem:(BOOL)favorite;


@property (strong, nonatomic) IBOutlet UILabel *percentOff;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UIImageView *imageView, *starredView;


@end
