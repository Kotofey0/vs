 //
//  AppDelegate.m
//  vs_test
//
//  Created by kino on 03.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "AppDelegate.h"
#import "ConnectToServer.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    NSString * md5Password = [userDefaults objectForKey:@"password"];
    NSString * username = [userDefaults objectForKey:@"username"];;

    NSDictionary * loginData = [[NSDictionary alloc] initWithObjectsAndKeys:md5Password, @"pass", username, @"login", nil];

    NSError * _err;

    NSData * response = [ConnectToServer sendRequestToURL:@"http://www.work.p69e.com/melnis/ios/auth.php" withJSONDictionary:loginData];

    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&_err];

    NSString * responseString = [dict objectForKey:@"response"];
    
    auth = [responseString isEqualToString:@"suc"];

    if(auth) self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    else{

        [self showLoginScreen:YES];

    }

    return YES;
}

- (void)showLoginScreen:(BOOL)animated{

    UIViewController * rootController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Login"];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:rootController];

    self.window.rootViewController = navigation;



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

@end
