//
//  TapViewController.m
//  vs_test
//
//  Created by kino on 03.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "TapViewController.h"
#import "AppDelegate.h"
@interface TapViewController ()

@end

@implementation TapViewController

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
    UITapGestureRecognizer * firstSingleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHandleTap:)]; //На imgView добавляем опработчик тапов
    firstSingleTapGestureRecognizer.cancelsTouchesInView = YES;
    firstSingleTapGestureRecognizer.numberOfTapsRequired = 1;
    _firstImageView.userInteractionEnabled = YES;

    [self.firstImageView addGestureRecognizer:firstSingleTapGestureRecognizer];



    UITapGestureRecognizer * secondSingleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondHandleTap:)];
    secondSingleTapGestureRecognizer.cancelsTouchesInView = YES;
    secondSingleTapGestureRecognizer.numberOfTapsRequired = 1;
    _secondImageView.userInteractionEnabled = YES;

    [self.secondImageView addGestureRecognizer:secondSingleTapGestureRecognizer];
    imagePickerTargetIndex = 0;

    firstTextEditted = secondTextEditted = mainTextEditted = NO;
    [self.firstTextField setDelegate:self];
    [self.secondTextField setDelegate:self];
    [self.mainTextField setDelegate:self];

    [self.mainTextField becomeFirstResponder];

    [self.loadingStatus setHidesWhenStopped:YES];
    [self.loadingStatus stopAnimating];



}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    NSLog(@"Hide keyboard\n");

    return YES;
}


- (IBAction)firstTextDidBeginEdition:(id)sender {

   if(firstTextEditted) return;
    _firstTextField.text = @"";
    firstTextEditted = YES; 

}

- (IBAction)secondTextDidBeginEdition:(id)sender {

    if(secondTextEditted) return;
    _secondTextField.text = @"";
    secondTextEditted = YES;

}

- (IBAction)mainTextDidBeginEdition:(id)sender {

    if(mainTextEditted) return;
    _mainTextField.text = @"";
    mainTextEditted = YES;

}


- (void) pickImageFromLib{


    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){

        NSLog(@"photo lib avalible\n");
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [picker setAllowsEditing:YES];


        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){

            [self presentViewController:picker animated:YES completion:nil];


    }

    
}


}

- (void) firstHandleTap:(UITapGestureRecognizer *)tapGestureRecognizer{



    imagePickerTargetIndex = 1;

    [self pickImageFromLib];


    NSLog(@"Load first image\n");

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if([navigationController.viewControllers count] == 3){



    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"Picked img%i\n",imagePickerTargetIndex);
    if(imagePickerTargetIndex){

        if(imagePickerTargetIndex == 1) _firstImageView.image = pickedImage;
        if(imagePickerTargetIndex == 2) _secondImageView.image = pickedImage;

    }
    [self dismissViewControllerAnimated:YES completion:NULL];

    if(imagePickerTargetIndex == 1) [self.firstTextField becomeFirstResponder];
    if(imagePickerTargetIndex == 2) [self.secondTextField becomeFirstResponder];

}

- (void) secondHandleTap:(UITapGestureRecognizer *)tapGestureRecognizer{

    imagePickerTargetIndex = 2;
    [self pickImageFromLib];

    NSLog(@"Load second image");


}

- (IBAction)sendButtonClick:(id)sender {




    [[self loadingStatus] startAnimating];

    if(([[self firstImageView] image] == nil)||([[self secondImageView] image] == nil)){

        NSLog(@"No img\n");
        return;
        [[self loadingStatus] stopAnimating];

    }




    NSString * firstDescription = [self.firstTextField text];
    NSString * secondDescription = [self.secondTextField text];
    NSString * title = [self.mainTextField text];
    NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString * comments = @"Any comment";

    NSDictionary * dataForSending = [NSDictionary dictionaryWithObjectsAndKeys:
                                     username, @"username",
                                     title, @"title",
                                     firstDescription, @"string1",
                                     secondDescription, @"string2",
                                     comments, @"comments",
                                     nil];

    NSString * stringBoundary = @"g-ofkidnjfu094jufn__furjuf84-----grhf---oo";

    NSError * _JSONerror;
    NSData * _JSONData = [NSJSONSerialization dataWithJSONObject:dataForSending options:0 error:&_JSONerror];




    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:@"http://work.p69e.com/melnis/ios/index.php"]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];




    NSData * image1Data = UIImagePNGRepresentation([[self firstImageView] image]);

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile_1\"; filename=\"%@_img1\"\r\n", username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:image1Data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

    NSData * image2Data = UIImagePNGRepresentation([[self secondImageView] image]);

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile_2\"; filename=\"%@_img2\"\r\n", username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:image2Data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"json\";  \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/x-www-form-urlencoded \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:_JSONData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];



    [request setHTTPBody:body];


    //замутить:
    //Парсить ответ сервера
    //В зависимости от этого выкидывать на домашнюю страницу или заставлять переотправить
    //ответ сервера ждать 10 сек

    NSLog(@"%@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);

    
    NSError * _err;

    NSURLResponse * _response = nil;

    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:&_response error:&_err];

    NSString * responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

    NSLog(@"%@/n", responseString);

    [self.loadingStatus stopAnimating];

    if(![responseString isEqualToString:@"Success"]){

        [[[UIAlertView alloc] initWithTitle:@"Упс" message:@"Что-то пошло не так" delegate:nil cancelButtonTitle:@"Оkay" otherButtonTitles: nil] show];
        return;
    }

    AppDelegate * appDelegateTemp = [[UIApplication sharedApplication] delegate];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    appDelegateTemp.window.rootViewController = [storyboard instantiateInitialViewController];



}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
