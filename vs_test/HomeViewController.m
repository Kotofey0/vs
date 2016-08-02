//
//  HomeViewController.m
//  vs_test
//
//  Created by Fedor on 24.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getContent{

    NSMutableURLRequest * _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://work.p69e.com/melnis/ios/json.php"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [_request setHTTPMethod:@"GET"];
    NSError * _err = nil;
    NSURLResponse * _response = nil;
    NSData * response = [NSURLConnection sendSynchronousRequest:_request returningResponse:&_response error:&_err];

    if(_err) {
        NSLog(@"%@\n", _err);
        records = nil;
        return;
    }

    NSString * buf1 = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"}{" withString:@"},\n{"];
    NSString * _json = [NSString stringWithFormat:@"[\n%@\n]", [[buf1 stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] stringByReplacingOccurrencesOfString:@"," withString:@",\n"]];


    NSArray * dict = [NSJSONSerialization JSONObjectWithData:[_json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&_err];

    records = [NSArray arrayWithArray:dict];


}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl * refresh_Control = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refresh_Control];
    [refresh_Control addTarget:self action:@selector(refreshContent:) forControlEvents:UIControlEventValueChanged];


    [self getContent];

    loadedImages = [[NSMutableDictionary alloc] initWithCapacity:[records count]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [records count]; //20!

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger index = [indexPath row];

    NSDictionary * record = records[index];


    NSString * img1_path = [@"http://work.p69e.com/melnis/ios/" stringByAppendingString:[record objectForKey:@"img_1"]];
    NSString * img2_path = [@"http://work.p69e.com/melnis/ios/" stringByAppendingString:[record objectForKey:@"img_2"]];

    if([loadedImages objectForKey:img1_path] == nil){

        NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:img1_path] completionHandler:^(NSData * data, NSURLResponse * response, NSError * error){
            if(data){
                UIImage * image = [UIImage imageWithData:data];
                if(image){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HomeCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if(updateCell)
                            updateCell.imgView1.image = image;
                            [loadedImages setObject:image forKey:img1_path];

                    });
                }
            }
        }];

        [task resume];

    }else
        cell.imgView1.image  = [loadedImages objectForKey:img1_path];

    if([loadedImages objectForKey:img2_path] == nil){

        NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:img2_path] completionHandler:^(NSData * data, NSURLResponse * response, NSError * error){
            if(data){
                UIImage * image = [UIImage imageWithData:data];
                if(image){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HomeCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if(updateCell)
                            updateCell.imgView2.image = image;
                        [loadedImages setObject:image forKey:img2_path];

                    });
                }
            }
        }];

        [task resume];
        NSLog(@"id%@ loaded\n", [record objectForKey:@"id"]);

    }else
        cell.imgView2.image = [loadedImages objectForKey:img2_path];
    NSString * string1 = [record objectForKey:@"string_1"];
    NSString * string2 = [record objectForKey:@"string_2"];
    NSString * title = [record objectForKey:@"login"];


    

   // if((img1 == nil) || (img2 == nil)) return cell;

    cell.lable1.text = string1;
    cell.lable2.text = string2;
    cell.titleLable.text = title;

    return cell;

}

-(void)refreshContent:(UIRefreshControl *)refreshControl{
    NSLog(@"Refresh");

    [self getContent];

    [refreshControl endRefreshing];
    [self.tableView reloadData];

}


@end
