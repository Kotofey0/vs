//
//  LoginViewController.m
//  vs_test
//
//  Created by Fedor on 13.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "ConnectToServer.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.usernameField.placeholder = @"Логин";
    self.passwordField.placeholder = @"Пароль";

    [self.passwordField setSecureTextEntry:YES];

    [self.passwordField setDelegate:self];
    [self.usernameField setDelegate:self];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)jump:(id)sender {

    NSString * md5Password = [self.passwordField.text MD5];

    NSString * username = [self.usernameField text];

    if([username isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]){
        self.passwordField.text = @"";
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Поле не заполнено" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSDictionary * loginData = [[NSDictionary alloc] initWithObjectsAndKeys:md5Password, @"pass", username, @"login", nil];

    NSError * _err;

    NSData * response = [ConnectToServer sendRequestToURL:@"http://work.p69e.com/melnis/ios/auth.php" withJSONDictionary:loginData];

    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&_err];

    NSString * responseString = [dict objectForKey:@"response"];

    if(![responseString isEqualToString:@"suc"]){

        NSInteger error = [responseString integerValue];

        NSString * mess;

        switch(error){
            case 1: mess = @"Не верный пароль";break;
            case 2: mess = @"Пользователь не зарегистрирован";break;
            case 3: mess = @"Ошибка данных";break;
            default: mess = @"Нет подключения к интернету";break;
        }

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

        return;
    }

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];




    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:md5Password forKey:@"password"];
    [userDefaults setObject:[dict objectForKey:@"id"] forKey:@"id"];

    AppDelegate * appDelegateTemp = [[UIApplication sharedApplication] delegate];

    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    

}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{

    if([[textField restorationIdentifier] isEqualToString:@"usr"]) [self.passwordField setSelected:YES];
    else [textField resignFirstResponder];

    return YES;

}
- (IBAction)registerNewUser:(id)sender {

    AppDelegate * appDelegateTemp = [[UIApplication sharedApplication] delegate];
    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Registration"];

}
@end
