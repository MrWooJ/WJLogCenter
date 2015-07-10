//
//  WJLogCenter.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGSERVICES		@"LogServices"
#define TEMPORALLOGS	@"TemporaryLog"
#define READINGENABLE	@"ReadingIsEnable"

@class LogService;

@interface WJLogCenter : NSObject

+ (void)SetEnableLogServiceManager:(BOOL)enable;

+ (BOOL)ServiceEnable;

+ (void)NewLogTitle:(NSString *)title LogDescription:(NSString *)description UserInfo:(NSObject *)userInfo;

+ (NSArray *)AllLogs;

+ (LogService *)LogServiceWithIdentifier:(NSString *)identifier;

+ (void)RemoveAllLogs;

+ (NSArray *)RemoveLogServiceWithIdentifier:(NSString *)identifier;

+ (void)MarkAllLogsAsOld;

+ (void)MarkLogServiceAsOldWithIdentifier:(NSString *)identifier;

+ (void)MarkAllLogsAsImportant;

+ (void)MarkLogServiceAsImportantWithIdentifier:(NSString *)identifier;

+ (void)MoveTemporaryLogsToLogCenter;

+ (NSArray *)SearchLogByTitle:(NSString *)title;

+ (NSArray *)SearchLogByTag:(NSString *)tag;

+ (NSArray *)SearchLogByMinimumTimeStamp:(NSString *)minTime;

+ (NSArray *)SearchLogByMaximumTimeStamp:(NSString *)maxTime;

+ (void)SetReadingIsEnable:(BOOL)isEnable;

+ (BOOL)ReadingIsEnable;

+ (void)SetEnableDeveloperLogs:(BOOL)enable;

+ (BOOL)EnableDeveloperLogs;

+ (void)PrintDeveloperLog:(NSString *)log;

@end
