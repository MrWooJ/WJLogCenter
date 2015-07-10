//
//  LogService.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogService : NSObject

- (void)initWithTitle:(NSString *)title eventDescription:(NSString *)eventDescription UserInfo:(NSObject *)userInfo;

@property (nonatomic,strong) NSString *logServiceID;

- (NSString *)title;
- (NSString *)eventDescription;
- (NSString *)timeInterval;

- (NSString *)logTag;

- (void)changeLogToImportant;
- (void)changeLogToOld;

- (BOOL)importantLog;
- (BOOL)newLog;

@end
