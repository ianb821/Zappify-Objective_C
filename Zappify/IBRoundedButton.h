//
//  IBRoundedButton.h
//  E.G.G.Components
//
//  Created by Ian Burns on 8/17/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// IBRoundedButton is a little helper class that I wrote to have a nice rounded UIButton that reverses
// text and background color on press.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IBRoundedButton : UIButton

- (void)setColor:(UIColor *)color;
- (id)initWithButtonTitle:(NSString *)title;
- (id)initWithButtonTitle:(NSString *)title WithAccentColor:(UIColor *)color;

@property BOOL firstTime;
@property UIColor *accentColor, *theBackgroundColor;

@end
