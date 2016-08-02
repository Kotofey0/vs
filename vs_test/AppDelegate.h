//
//  AppDelegate.h
//  vs_test
//
//  Created by kino on 03.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL auth;
}

- (void)showLoginScreen:(BOOL)animated;

@property (strong, nonatomic) UIWindow *window;

@end
