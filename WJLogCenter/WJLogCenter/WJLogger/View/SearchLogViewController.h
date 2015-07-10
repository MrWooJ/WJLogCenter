//
//  SearchLogViewController.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 7/10/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTableViewCell.h"

@interface SearchLogViewController : UIViewController <ChangeLogStatus,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSArray *searchLogResult;

@property (strong, nonatomic) IBOutlet UITableView *searchResultTableView;

@end
