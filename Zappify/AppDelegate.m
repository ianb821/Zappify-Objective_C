//
//  AppDelegate.m
//  Zappify
//
//  Created by Ian Burns on 9/21/13.
//  Copyright (c) 2013 Ian Burns. All rights reserved.
//
// Zappify is built for iOS 7, it was tested on an actual iPhone 5, and the simulator for the 3.5" screen

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [zapposBrain loadItemsBeingMonitored];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [zapposBrain saveItemsBeingMonitored];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [zapposBrain loadItemsBeingMonitored];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
