//
//  ZapposItemView.m
//  Zappify
//
//  Created by Ian Burns on 9/15/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// ZapposItemView is the "expanded" cell view that allows a user to enter their email
// address and choose at what percentage discount they want to be notified

#import "ZapposItemView.h"

@implementation ZapposItemView


// setup the view programmatically
- (id)initWithZapposItem:(ZapposItem *)item favorite:(BOOL)favoriteItem {
    
    self = [super initWithFrame:CGRectMake(0, 0, 300, 320)];
    self.zapposItem = item;
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // setup the brand name
        
        self.brandNameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 21)];
        self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
        self.brandNameLabel.font = [UIFont fontWithName:@"Optima-Bold" size:18.0f];
        self.brandNameLabel.text = item.brandName;
        
        [self addSubview:self.brandNameLabel];
        self.brandNameLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, 15);
        
        // setup the product name
        
        self.productNameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 21)];
        self.productNameLabel.textAlignment = NSTextAlignmentCenter;
        self.productNameLabel.font = [UIFont fontWithName:@"Optima-Regular" size:16.0f];
        self.productNameLabel.minimumScaleFactor = 0.6f;
        self.productNameLabel.adjustsFontSizeToFitWidth = YES;
        self.productNameLabel.text = item.productName;
        
        [self addSubview:self.productNameLabel];
        self.productNameLabel.center = CGPointMake(self.brandNameLabel.center.x, self.brandNameLabel.center.y + 22);
        
        // setup the product image
        
        self.imageView = [[UIImageView alloc] initWithImage:item.thumbnailImage];
        
        [self addSubview:self.imageView];
        self.imageView.center = CGPointMake(75, self.productNameLabel.center.y + 75);
        
        // setup the price, one if it's not currently discounted, two if it is.
        
        if ([item.normalPrice isEqualToString:item.discountedPrice]) {
            self.originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 21)];
            self.originalPriceLabel.text = item.discountedPrice;
            self.originalPriceLabel.textAlignment = NSTextAlignmentCenter;
            self.originalPriceLabel.font = [UIFont fontWithName:@"Optima-Bold" size:15];
            self.originalPriceLabel.textColor = [UIColor colorWithRed:1.000 green:0.237 blue:0.000 alpha:1.000];
            
            [self addSubview:self.originalPriceLabel];
            self.originalPriceLabel.center = CGPointMake(CGRectGetWidth(self.frame) - 75, self.imageView.center.y - 18);
        } else {
            
            NSDictionary* attributes = @{
                                         NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                         };
            
            NSAttributedString* strikedThroughText = [[NSAttributedString alloc] initWithString:item.normalPrice attributes:attributes];
            
            self.originalPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 22)];
            self.originalPriceLabel.font = [UIFont fontWithName:@"Optima-Bold" size:15];
            self.originalPriceLabel.attributedText = strikedThroughText;
            self.originalPriceLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.originalPriceLabel];
            self.originalPriceLabel.center = CGPointMake(CGRectGetWidth(self.frame) - 109, self.imageView.center.y - 18);
            
            self.discountedPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 22)];
            self.discountedPriceLabel.font = [UIFont fontWithName:@"Optima-Bold" size:15];
            self.discountedPriceLabel.text = item.discountedPrice;
            self.discountedPriceLabel.textColor = [UIColor colorWithRed:1.000 green:0.237 blue:0.000 alpha:1.000];
            self.discountedPriceLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:self.discountedPriceLabel];
            self.discountedPriceLabel.center = CGPointMake(CGRectGetWidth(self.frame) - 43, self.imageView.center.y - 18);
            
        }
        
        // setup the discount label
        
        self.percentOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 21)];
        self.percentOffLabel.textAlignment = NSTextAlignmentCenter;
        self.percentOffLabel.font = [UIFont fontWithName:@"Optima-Bold" size:16.0f];
        self.percentOffLabel.text = [NSString stringWithFormat:@"Currently %@ off", item.percentOff];
        
        [self addSubview:self.percentOffLabel];
        self.percentOffLabel.center = CGPointMake(CGRectGetWidth(self.frame) - 78, self.originalPriceLabel.center.y + 32);
        
        // setup the email address field
        
        self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 230, 30)];
        self.emailTextField.font = [UIFont fontWithName:@"Optima-Regular" size:16.0f];
        self.emailTextField.placeholder = @"Enter email address";
        self.emailTextField.textAlignment = NSTextAlignmentCenter;
        self.emailTextField.layer.cornerRadius = 16.0f;
        if (favoriteItem) {
            self.emailTextField.text = item.emailAddressToAlert;
        } else {
            self.emailTextField.layer.borderWidth = 1.0f;
        }
        self.emailTextField.layer.borderColor = [UIColor redColor].CGColor;
        self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.emailTextField.delegate = self;
        
        [self addSubview:self.emailTextField];
        
        // setup the positioning if it's a search item or favorite item
        // setup the star and email icons
        
        if (!favoriteItem) {
            
            self.emailTextField.center = CGPointMake(130, self.imageView.center.y + 101);
            
            self.percentOffPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
            self.percentOffPickerView.dataSource = self;
            self.percentOffPickerView.delegate = self;
            [self.percentOffPickerView selectRow:19 inComponent:0 animated:NO];
            [self addSubview:self.percentOffPickerView];
            self.percentOffPickerView.center = CGPointMake(CGRectGetWidth(self.frame) - 30, self.emailTextField.center.y + 35);
            
            
            self.startMonitoringButton = [[IBRoundedButton alloc] initWithButtonTitle:[NSString stringWithFormat:@"Send email when 20%% off"] WithAccentColor:[UIColor redColor]];
            [self.startMonitoringButton addTarget:self action:@selector(setUpMonitoringForDiscount) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.startMonitoringButton];
            self.startMonitoringButton.center = CGPointMake(self.emailTextField.center.x, CGRectGetHeight(self.frame) - 40);
            
        } else {
            
            self.emailTextField.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, self.imageView.center.y + 101);
            if ([self.emailTextField.text isEqualToString:@""]) {
                self.emailTextField.layer.borderWidth = 1.0f;
            }
            
            self.stopMonitoringButton = [[IBRoundedButton alloc] initWithButtonTitle:@"Stop Watching this item" WithAccentColor:[UIColor redColor]];
            [self.stopMonitoringButton addTarget:self action:@selector(stopMonitoringItemForDiscount) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.stopMonitoringButton];
            self.stopMonitoringButton.center = CGPointMake(self.emailTextField.center.x, CGRectGetHeight(self.frame) - 40);
        }
        
        if (!item.notify && favoriteItem) {
            self.starredView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
            [self addSubview:self.starredView];
            self.starredView.center = CGPointMake(CGRectGetWidth(self.starredView.frame) / 2.0 + 4, (CGRectGetHeight(self.starredView.frame) / 2.0) + 1);
        } else if ([zapposBrain.itemsToWatch indexOfObject:item] != NSNotFound && !favoriteItem) {
            self.starredView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
            [self addSubview:self.starredView];
            self.starredView.center = CGPointMake(CGRectGetWidth(self.starredView.frame) / 2.0 + 2, (CGRectGetHeight(self.starredView.frame) / 2.0) + 2);
        }
        
        
    }
    
    return self;
}

- (void)setUpMonitoringForDiscount {
    self.zapposItem.emailAddressToAlert = self.emailTextField.text;
    self.zapposItem.desiredPercentOff = [self.percentOffPickerView selectedRowInComponent:0] + 1;
    [zapposBrain.itemsToWatch addObject:self.zapposItem];
    [zapposBrain startCheckingForUpdatedPricing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissZapposItemView" object:self];
}

- (void)stopMonitoringItemForDiscount {
    
    [zapposBrain.itemsToWatch removeObject:self.zapposItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissZapposItemViewFromFavorites" object:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// surround the email field with a red border if it is empty
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        textField.layer.borderWidth = 0.0f;
    } else {
        textField.layer.borderWidth = 1.0f;
    }
    
    
    int index = [zapposBrain.itemsToWatch indexOfObject:self.zapposItem];
    self.zapposItem.emailAddressToAlert = textField.text;
    if (index != NSNotFound)
        [zapposBrain.itemsToWatch replaceObjectAtIndex:index withObject:self.zapposItem];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (![string isEqualToString:@""]) {
        textField.layer.borderWidth = 0.0f;
    } else {
        if (textField.text.length > 1) {
            textField.layer.borderWidth = 0.0f;
        } else {
            textField.layer.borderWidth = 1.0f;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.layer.borderWidth = 1.0f;
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 99;
}

#pragma mark -UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", (row + 1)];
}

// change the text on the button to reflect the current percentage chosen
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.startMonitoringButton setTitle:[NSString stringWithFormat:@"Send email when %d%% off", (row + 1)] forState:UIControlStateAll];
    [self.startMonitoringButton setNeedsDisplay];
}

@end
