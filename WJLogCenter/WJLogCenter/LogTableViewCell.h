//
//  LogTableViewCell.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *isNewTag;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
