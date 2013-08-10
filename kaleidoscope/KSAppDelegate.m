//
//  KSAppDelegate.m
//  kaleidoscope
//
//  Created by Mike Chen on 5/11/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "CommonUtils.h"
#import "KSAppDelegate.h"

@implementation KSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];*/

    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    tabController.selectedIndex = KS_TAB_INDEX_LOOKAHEAD;

    return YES;
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

# pragma mark - URL open delegate
// http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (!url) { return NO; }

    // first, switches to observer view
    // which will register to observe the following notification
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    tabController.selectedIndex = KS_TAB_INDEX_LOOKUP;

    // second, posts the notification.
    // the sequence of the 2 steps is critical
    NSDictionary *params = [CommonUtils parseQueryToParams: [url query]];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"bringQueryToLookupView"
     object:nil
     userInfo:params];
    return YES;
}

@end
