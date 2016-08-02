//
//  PreferencesViewController.h
//  vs_test
//
//  Created by Fedor on 15.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
- (IBAction)loguotButtonClick:(id)sender;


@end
