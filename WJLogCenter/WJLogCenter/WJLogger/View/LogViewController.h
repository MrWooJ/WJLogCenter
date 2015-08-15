//
//  LogViewController.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTableViewCell.h"

@interface LogViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ChangeLogStatus,UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@end
