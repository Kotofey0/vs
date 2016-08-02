//
//  LoginViewController.h
//  vs_test
//
//  Created by Fedor on 13.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
- (IBAction)jump:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)registerNewUser:(id)sender;
    
@end
