//
//  IPAppDelegate.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPAppDelegate.h"
#import "CKSideBarController.h"
#import "IPChooseConstituencyViewController.h"
#import "IPMyConstituencyViewController.h"

@implementation IPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    CKSideBarController *rootViewController = [[CKSideBarController alloc] init];
    [rootViewController setViewControllers:@[[[IPMyConstituencyViewController alloc] initWithNibName:NSStringFromClass([IPMyConstituencyViewController class]) bundle:nil], [[UIViewController alloc] init]]];
    
    self.window.rootViewController = rootViewController;

    [self.window makeKeyAndVisible];
    return YES;
}

@end