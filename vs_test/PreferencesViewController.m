//
//  PreferencesViewController.m
//  vs_test
//
//  Created by Fedor on 15.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "PreferencesViewController.h"
#import "AppDelegate.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

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
	// Do any additional setup after loading the view.

    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];

    self.usernameTextField.text = [userdefaults objectForKey:@"username"];
    [self.usernameTextField setDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loguotButtonClick:(id)sender {

    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Выход" message:@"Вы уверены что хотите выйти?" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Выйти", nil];
    [alertview show];


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == [alertView cancelButtonIndex]) return;

    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:nil forKey:@"username"];
    [userdefaults setObject:nil forKey:@"password"];
    [userdefaults setObject:nil forKey:@"id"];

    AppDelegate * appDelegateTemp = [[UIApplication sharedApplication] delegate];
    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Login"];

}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    if(([[textField restorationIdentifier] isEqualToString:@"username"]) && (![[textField text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) ){

        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];


        NSDictionary * data = [[NSDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:@"id"], @"id",self.usernameTextField.text , @"username", nil];

        NSError * _err;
        NSData * _JSONData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&_err];

        NSLog(@"%@\n", [[NSString alloc] initWithData:_JSONData encoding:NSUTF8StringEncoding]);


        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];

        NSString * stringBoundary = @"g-ofkidnjfu094jufn__furjuf84-----grhf---oo";

        [request setURL:[NSURL URLWithString:@"http://www.work.p69e.com/melnis/ios/resave_registration.php"]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
        NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"json\";  \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/x-www-form-urlencoded \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:_JSONData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [request setHTTPBody:body];

        NSURLResponse * _response = nil;

        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:&_response error:&_err];

        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&_err];

        
        

    }
    
    return YES;
}
@end
