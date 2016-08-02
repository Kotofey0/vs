//
//  RegistrationViewController.m
//  vs_test
//
//  Created by Fedor on 15.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "ConnectToServer.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

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

    self.emailTextField.placeholder = @"email";
    [self.emailTextField setDelegate:self];
    self.usernameTextField.placeholder = @"Имя";
    [self.usernameTextField setDelegate:self];
    self.passwordTextField.placeholder = @"Пароль";
    [self.passwordTextField setDelegate:self];
    [self.passwordTextField setSecureTextEntry:YES];
    self.confirmTextFied.placeholder = @"Повторить пароль";
    [self.confirmTextFied setDelegate:self];
    [self.confirmTextFied setSecureTextEntry:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (IBAction)buttonClick:(id)sender {

    if(![self.passwordTextField.text isEqualToString:self.confirmTextFied.text]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Пароли не совпадают" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        self.passwordTextField.text = self.confirmTextFied.text = @"";

    }else if ([self.emailTextField.text isEqualToString:@""] || [self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]){

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не все поля заполнены" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        self.passwordTextField.text = self.confirmTextFied.text = @"";


    }else{
        NSString * md5Password = [self.confirmTextFied.text MD5];
        NSString * username = self.usernameTextField.text;
        NSString * email = self.emailTextField.text;

        NSDictionary * registrationData = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"login", md5Password, @"pass", email, @"email", nil];

        NSError * _err;
        NSData * response = [ConnectToServer sendRequestToURL:@"http://www.work.p69e.com/melnis/ios/registration.php" withJSONDictionary:registrationData];



        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&_err];

        NSString * responseString = [dict objectForKey:@"response"];

        if(![responseString isEqualToString:@"suc"]){

            NSInteger error = [responseString integerValue];

            NSString * mess;

            switch(error){
                case 1: mess = @"Данный логин уже занят";break;
                case 2: mess = @"Ошибка данных";break;
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
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        appDelegateTemp.window.rootViewController = [storyboard instantiateInitialViewController];
    }

}

- (IBAction)cancelButtonClick:(id)sender {

    AppDelegate * appDelegateTemp = [[UIApplication sharedApplication] delegate];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    appDelegateTemp.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];

}
@end
