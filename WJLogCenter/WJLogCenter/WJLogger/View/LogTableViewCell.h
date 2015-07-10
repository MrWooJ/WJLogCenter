//
//  LogTableViewCell.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeLogStatus

@required

- (void)changeLogStatusToImportant:(NSString *)identifier;

@end

@interface LogTableViewCell : UITableViewCell

@property (strong, nonatomic) id <ChangeLogStatus> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) NSString *logIdentifier;

@property (strong, nonatomic) IBOutlet UIButton *eventStatus;

- (IBAction)changeLogToImportant:(id)sender;

@end
