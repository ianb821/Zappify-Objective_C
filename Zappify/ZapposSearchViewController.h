//
//  ZapposSearchViewController.h
//  Zappify
//
//  Created by Ian Burns on 9/13/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposSearchViewController allows a user to search for any item, displays the results
// and allows them to choose to be notified via email when an item is discounted x percent, default is 20%
// items being watched already are surrounded in a red/orange border color, and are marked with a star in the upper
// left corner of the cell

#import <UIKit/UIKit.h>
#import "ZapposBrain.h"
#import "ZapposItemView.h"
#import "ZapposItemCell.h"

@interface ZapposSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>


@property ZapposItemView *itemView;
@property UIImageView *cellImageView;
@property NSIndexPath *indexPathToAnimate;
@property UICollectionView *collectionView;
@property UIView *cellView, *semiTransparentView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;






@end
