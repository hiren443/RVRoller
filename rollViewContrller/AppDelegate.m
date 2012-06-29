//
//  AppDelegate.m
//  rollViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "RVViewContrller.h"
#import "TTViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RVViewContrller alloc] init];
    self.viewController.contentView.spacing = 45;
    
    [self setViewShow:1];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"click me!"
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(clicked)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(20, 35, 100, 28);
    [self.window addSubview:button];
    
    return YES;
}

static int _type;

- (void)setViewShow:(NSInteger)type
{
    _type = type;
    if (type == 1) {
        NSMutableArray *viewControllers = [NSMutableArray array];
        UIViewController *ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Foot";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Milk&Moo";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Key";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Omiga";
        [viewControllers addObject:ctrl];
        [self.viewController setViewControllers:viewControllers
                                       aniamted:YES];
    }else {
        NSMutableArray *viewControllers = [NSMutableArray array];
        UIViewController *ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Foot2";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Milk&Moo2";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Key2";
        [viewControllers addObject:ctrl];
        
        ctrl = [[TTViewController alloc] init];
        ctrl.title = @"Omiga2";
        [viewControllers addObject:ctrl];
        [self.viewController setViewControllers:viewControllers
                                       aniamted:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)clicked
{
    [self setViewShow:!_type];
}

@end
