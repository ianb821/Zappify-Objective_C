//
//  ZapposSearchViewController.m
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


#import "ZapposSearchViewController.h"

@interface ZapposSearchViewController ()

@end

@implementation ZapposSearchViewController


// Stop listening for notifications
- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView name:@"Reload" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.searchDisplayController.searchResultsTableView name:@"ReloadSearch" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DismissZapposItemView" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"Search Zappos";
    self.searchBar.delegate = self;
	
    
    // set up the collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.searchBar.frame) + 20 - CGRectGetHeight(self.tabBarController.tabBar.frame)) collectionViewLayout:flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[ZapposItemCell class] forCellWithReuseIdentifier:@"ZapposItemCell"];
    self.collectionView.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2.0, (CGRectGetHeight(self.collectionView.frame) / 2.0) + CGRectGetHeight(self.searchBar.frame) + 20);
    
    [self registerForNotifications];
    
}

- (void)registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView selector:@selector(reloadData) name:@"Reload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.searchDisplayController.searchResultsTableView selector:@selector(reloadData) name:@"ReloadSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearZapposItemView:) name:@"DismissZapposItemView" object:nil];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return zapposBrain.searchResults.count;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZapposItemCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ZapposItemCell" forIndexPath:indexPath];
    
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell setUpCellWithZapposItem:[zapposBrain.searchResults objectAtIndex:indexPath.row] FavoriteItem:NO];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate


// animates a cell expanding on selection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathToAnimate = indexPath;
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    self.cellView = [[UIView alloc] initWithFrame:cell.bounds];
    self.cellImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    self.semiTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.semiTransparentView.backgroundColor = [UIColor blackColor];
    self.semiTransparentView.alpha = 0.0f;
    
    UITapGestureRecognizer *clearItemViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearZapposItemView:)];
    [self.semiTransparentView addGestureRecognizer:clearItemViewTap];
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.cellImageView.image = cellScreenShot;
    
    [self.cellView addSubview:self.cellImageView];
    [self.view addSubview:self.semiTransparentView];
    [self.view addSubview:self.cellView];
    
    cell.alpha = 0.0;
    
    self.cellView.center = CGPointMake(cell.center.x, cell.center.y - self.collectionView.contentOffset.y + CGRectGetHeight(self.searchBar.frame) + 20);
    
    
    [UIView animateWithDuration:0.25f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.cellView.transform = CGAffineTransformMakeScale(2.10, 1.85);
                         if (CGRectGetHeight([UIScreen mainScreen].bounds) > 500) {
                             self.cellView.center = CGPointMake(self.collectionView.center.x, 230);
                         } else {
                             self.cellView.center = CGPointMake(self.collectionView.center.x, 180);
                         }
                         self.cellImageView.alpha = 0.0f;;
                         self.semiTransparentView.alpha = 0.7f;
                         cell.layer.masksToBounds = NO;
                         self.cellView.layer.contentsScale = [UIScreen mainScreen].scale;
                         self.cellView.layer.shadowOpacity = .75;
                         self.cellView.layer.shadowOffset = CGSizeZero;
                         self.cellView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.cellView.bounds].CGPath;
                         self.cellView.layer.borderWidth = 0.0f;
                         self.cellView.backgroundColor = [UIColor whiteColor];
                     }
                     completion:^(BOOL finished){
                         [self setUpTheZapposItemView];
                     }];
}

- (void)setUpTheZapposItemView {
    
    self.itemView = [[ZapposItemView alloc] initWithZapposItem:[zapposBrain.searchResults objectAtIndex:self.indexPathToAnimate.row] favorite:NO];
    [self.view addSubview:self.itemView];
    self.itemView.alpha = 0.0f;
    self.itemView.center = self.cellView.center;
    
    //fade in animation
    [UIView animateWithDuration:0.45f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.itemView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


// dismisses ZapposItemView (animates shrinking back into place)
- (void)clearZapposItemView:(UITapGestureRecognizer *)gesture {
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.indexPathToAnimate];
    self.itemView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.cellView.transform = CGAffineTransformMakeScale(1, 1);
                         self.cellView.center = CGPointMake(cell.center.x, cell.center.y - self.collectionView.contentOffset.y  + CGRectGetHeight(self.searchBar.frame) + 20);
                         self.itemView.alpha = 0.0f;
                         self.cellImageView.alpha = 1.0;
                         self.semiTransparentView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         [self.collectionView cellForItemAtIndexPath:self.indexPathToAnimate].alpha = 1.0;
                         [self.cellImageView removeFromSuperview];
                         [self.cellView  removeFromSuperview];
                         [self.semiTransparentView removeFromSuperview];
                         [self.itemView removeFromSuperview];
                         
                         self.itemView = nil;
                         self.cellView = nil;
                         self.cellImageView = nil;
                         [self.collectionView reloadData];
                     }];
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize rect = CGSizeMake(145, 175);
    return rect;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(25, 10, 50, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [zapposBrain updateAutoCompleteResultsForTerm:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [zapposBrain getSearchResultsForTerm:searchBar.text];
    self.searchDisplayController.active = NO;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
}

#pragma UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return zapposBrain.autoCompleteResults.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultsCell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.searchBar.text;
    } else {
        
        // sanity check, if the user types too fast and the network connection is slow,
        // by the time this is called, the results could have updated in the background
        // makes sure we aren't displaying a result that has been updated
        if (indexPath.row - 1 <= zapposBrain.autoCompleteResults.count - 1)
            cell.textLabel.text = [zapposBrain.autoCompleteResults objectAtIndex:(indexPath.row - 1)];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [zapposBrain getSearchResultsForTerm:self.searchBar.text];
    } else {
        [zapposBrain getSearchResultsForTerm:[zapposBrain.autoCompleteResults objectAtIndex:(indexPath.row - 1)]];
    }
    
    [self.searchBar resignFirstResponder];
    self.searchDisplayController.active = NO;
}

@end