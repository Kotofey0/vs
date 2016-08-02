//
//  TapViewController.h
//  vs_test
//
//  Created by kino on 03.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{ //используется пикер изображений на iPhone
    int imagePickerTargetIndex;
    BOOL firstTextEditted, secondTextEditted, mainTextEditted;
}
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UITextField *mainTextField;
- (IBAction)firstTextDidBeginEdition:(id)sender;
- (IBAction)secondTextDidBeginEdition:(id)sender;
- (IBAction)mainTextDidBeginEdition:(id)sender;

- (void) pickImageFromLib;
- (void) firstHandleTap:(UITapGestureRecognizer *) tapGestureRecognizer;
- (void) secondHandleTap:(UITapGestureRecognizer *) tapGestureRecognizer;
- (IBAction)sendButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingStatus;



@end
