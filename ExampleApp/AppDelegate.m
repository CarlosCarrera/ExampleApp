//
//  AppDelegate.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "AppDelegate.h"
#import "DataBaseManager.h"
#import "SearchVC.h"
#import "MoviesVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self launchFirstVC];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DataBaseManager sharedDataBaseManager] saveDatabase];
}

#pragma mark - Private Methods

- (void)launchFirstVC {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UITabBarController *firstVC = [UITabBarController new];
    
    UINavigationController *moviesNC = [[UINavigationController alloc] initWithRootViewController:[MoviesVC new]];
    UINavigationController *musicNC = [[UINavigationController alloc] initWithRootViewController:[SearchVC new]];
    
    [firstVC setViewControllers:@[moviesNC,musicNC]];

    moviesNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"movies", nil) image:nil tag:1];
    musicNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"music", nil) image:nil tag:2];
    
    self.window.rootViewController = firstVC;
    
    [self.window makeKeyAndVisible];
}

@end
