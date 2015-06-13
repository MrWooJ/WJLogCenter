//
//  WJLogCenter.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "WJLogCenter.h"
#import "LogService.h"

@interface WJLogCenter ()

@end

@implementation WJLogCenter

+ (void)NewLogTitle:(NSString *)title LogDescription:(NSString *)description {

	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	LogService *newLog = [[LogService alloc]init];
	[newLog initWithTitle:title eventDescription:description];
	
	NSMutableArray *logsArray = [NSMutableArray array];
	logsArray = [userDefault objectForKey:LOGSERVICES];
	
	[logsArray addObject:newLog];
	
	[userDefault setObject:logsArray forKey:LOGSERVICES];
	[userDefault synchronize];
}

+ (NSArray *)AllLogs {

	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *logsArray = [NSMutableArray array];
	logsArray = [userDefault objectForKey:LOGSERVICES];
	
	return logsArray;
}

@end
