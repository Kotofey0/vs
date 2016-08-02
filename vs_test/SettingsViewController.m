//
//  SettingsViewController.m
//  vs_test
//
//  Created by kino on 16.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {

    

    id plist;       // Assume this property list exists.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    NSData *xmlData;
    NSString *error;

    xmlData = [NSPropertyListSerialization dataFromPropertyList:plist
                                                         format:NSPropertyListXMLFormat_v1_0
                                               errorDescription:&error];
    if(xmlData) {
        NSLog(@"No error creating XML data.");
        [xmlData writeToFile:path atomically:YES];
    }
    else {
        NSLog(@"%@",error);
    }
}
@end
