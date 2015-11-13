//
//  AppDelegate.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#define GaoDeMapKey @"a2e61c9e5050c2521c806bb2908b25d2"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)configureGaoDeMapAPIKey
{
    [MAMapServices sharedServices].apiKey = (NSString *)GaoDeMapKey;
}

#pragma mark - life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGaoDeMapAPIKey];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
