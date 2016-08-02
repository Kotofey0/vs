//
//  HomeViewController.h
//  vs_test
//
//  Created by Fedor on 24.03.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray * records;
    NSMutableDictionary * loadedImages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
-(void) getContent;
-(void) refreshContent:(UIRefreshControl *)refreshControl;
@end
