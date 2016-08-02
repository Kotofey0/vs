//
//  RegistrationViewController.h
//  vs_test
//
//  Created by Fedor on 15.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextFied;
- (IBAction)buttonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

@end
