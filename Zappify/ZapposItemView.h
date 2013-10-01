//
//  ZapposItemView.h
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItemView is the "expanded" cell view that allows a user to enter their email
// address and choose at what percentage discount they want to be notified

// handy macro
#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted

#import <UIKit/UIKit.h>
#import "ZapposBrain.h"
#import "IBRoundedButton.h"

@interface ZapposItemView : UIView <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

- (id)initWithZapposItem:(ZapposItem *)item favorite:(BOOL)favoriteItem;


@property ZapposItem *zapposItem;
@property UITextField *emailTextField;
@property UIPickerView *percentOffPickerView;
@property UIImageView *imageView, *starredView;
@property IBRoundedButton *startMonitoringButton, *stopMonitoringButton;
@property UILabel *brandNameLabel, *productNameLabel, *originalPriceLabel, *discountedPriceLabel, *percentOffLabel; // lots of labels


@end
