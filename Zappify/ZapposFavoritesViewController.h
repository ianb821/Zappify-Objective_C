//
//  ZapposFavoritesViewController.h
//  Zappify
//
//  Created by Ian Burns on 9/16/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposFavoritesViewController shows all the items that the user is currently monitoring,
// it allows them to change the email address that they want to use to be notified, or
// to discontinue watching an item.  An envelope is shown on the items that a user has been emailed about

#import <UIKit/UIKit.h>
#import "ZapposBrain.h"
#import "ZapposItemView.h"
#import "ZapposItemCell.h"

@interface ZapposFavoritesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate>

@property ZapposItemView *itemView;
@property UIImageView *cellImageView;
@property NSIndexPath *indexPathToAnimate;
@property UICollectionView *collectionView;
@property UIView *semiTransparentView, *cellView;

@end
