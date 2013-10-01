//
//  IBRoundedButton.m
//  E.G.G.Components
//
//  Created by Ian Burns on 8/17/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen
//
// IBRoundedButton is a little helper class that I wrote to have a nice rounded UIButton that reverses
// text and background color on press.

#import "IBRoundedButton.h"

@implementation IBRoundedButton


- (id)initWithButtonTitle:(NSString *)title {
    return [self initWithButtonTitle:title  WithAccentColor:[UIColor blackColor]];
}

- (id)initWithButtonTitle:(NSString *)title WithAccentColor:(UIColor *)color {
    
    self.firstTime = YES;
    self.accentColor = color;
    self = [self initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.clipsToBounds = YES;
    [self setTitle:title forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:@"Optima-Regular" size:16];
    self.titleLabel.textColor = color;
    [self setColor:color];
    self.theBackgroundColor = self.backgroundColor;
    
    [self sizeToFit];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) + 20, CGRectGetHeight(self.frame));
    
    self.layer.cornerRadius = 16.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color.CGColor;
    
    
    [self addTarget:self action:@selector(highlightPressedButton:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(unhighlightPressedButton:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
    
    return self;
}

- (void)highlightPressedButton:(UIButton *)button {
    
    self.theBackgroundColor = self.backgroundColor;
    
    [button setBackgroundColor:self.accentColor];
    button.titleLabel.textColor= self.theBackgroundColor;
    [button setTitleColor:self.theBackgroundColor forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
}

- (void)unhighlightPressedButton:(UIButton *)button {
    
    [button setBackgroundColor:self.theBackgroundColor];
    button.titleLabel.textColor = self.accentColor;
    [button setTitleColor:self.accentColor forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
}


- (void)setColor:(UIColor *)color {
    
    self.titleLabel.textColor = color;
    [self setTitleColor:color forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.layer.borderColor = color.CGColor;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.firstTime) {
        self.titleLabel.textColor = self.accentColor;
        self.firstTime = NO;
    }
}

@end
