//
//  WJLogCenter.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "WJLogCenter.h"
#import "LogService.h"

#define ENABLESYSTEM	@"EnableSystem"

@interface WJLogCenter ()

@end

@implementation WJLogCenter

#pragma mark - Enable Service

+ (void)SetEnableLogServiceManager:(BOOL)enable {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:enable forKey:ENABLESYSTEM];
	[userDefault synchronize];
	
	[WJLogCenter SetReadingIsEnable:NO];
}

+ (BOOL)ServiceEnable {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	return [userDefault boolForKey:ENABLESYSTEM];
}

#pragma mark - Insert Log

+ (void)NewLogTitle:(NSString *)title LogDescription:(NSString *)description UserInfo:(NSObject *)userInfo {

	if ([WJLogCenter ServiceEnable]) {

		@try {
			
			NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
			
			LogService *newLog = [[LogService alloc]init];
			[newLog initWithTitle:title eventDescription:description UserInfo:userInfo];
			
			NSData *logEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:newLog];
			
			if ([WJLogCenter ReadingIsEnable]) {
				
				NSLog(@"Reading is Enable");
				
				NSMutableArray *logsArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:TEMPORALLOGS]];
				
				[logsArray addObject:logEncodedObject];
				
				[userDefault setObject:logsArray forKey:TEMPORALLOGS];
			}
			else {
				
				NSLog(@"Reading is Disable");
				
				NSMutableArray *logsArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:LOGSERVICES]];
				
				[logsArray addObject:logEncodedObject];
				
				[userDefault setObject:logsArray forKey:LOGSERVICES];
			}
			
			[userDefault synchronize];
		}
		@catch (NSException *exception) {
			
			NSLog(@"Exception Is: %@",exception);
		}
	}
}

#pragma mark - Retrive Log

+ (NSArray *)AllLogs {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSMutableArray *tempArray = [NSMutableArray array];
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *dataObject in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
			[tempArray addObject:log];
		}
		
		return tempArray;
	}
	return nil;
}

+ (LogService *)LogServiceWithIdentifier:(NSString *)identifier {

	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *logData in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];

			if ([[log logServiceID] isEqualToString:identifier]) {
				return log;
			}
		}
	}
	return nil;
}

#pragma mark - Remove Log

+ (void)RemoveAllLogs {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		[userDefault removeObjectForKey:LOGSERVICES];
		[userDefault synchronize];
	}
}

+ (NSArray *)RemoveLogServiceWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		logsArray = [userDefault objectForKey:LOGSERVICES];
		

		for (int i = 0; i < [logsArray count]; i++) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:[logsArray objectAtIndex:i]];

			if ([[log logServiceID] isEqualToString:identifier]) {
				
				[logsArray removeObjectAtIndex:i];

				[userDefault setObject:logsArray forKey:LOGSERVICES];
				[userDefault synchronize];
			}
		}
		return logsArray;
	}
	return nil;
}

#pragma mark - Functional Services

+ (void)MarkAllLogsAsOld {
	
	if ([WJLogCenter ServiceEnable]) {

		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *dataObject in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
			[log changeLogToOld];

			NSData *logEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:log];
			
			[tempArray addObject:logEncodedObject];
		}
		
		[userDefault setObject:tempArray forKey:LOGSERVICES];
		[userDefault synchronize];
	}
}

+ (void)MarkLogServiceAsOldWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {

		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];

		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (int i = 0; i < [logsArray count]; i++) {
			
			NSData *logData = [logsArray objectAtIndex:i];
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log logServiceID] isEqualToString:identifier] && [log newLog]) {
				
				[log changeLogToOld];
				
				NSData *logEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:log];
				
				[logsArray replaceObjectAtIndex:i withObject:logEncodedObject];
			}
			
			[userDefault setObject:logsArray forKey:LOGSERVICES];
			[userDefault synchronize];
		}
	}
}

+ (void)MarkAllLogsAsImportant {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *dataObject in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
			[log changeLogToImportant];
			
			NSData *logEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:log];
			
			[tempArray addObject:logEncodedObject];
		}
		
		[userDefault setObject:tempArray forKey:LOGSERVICES];
		[userDefault synchronize];
	}
}

+ (void)MarkLogServiceAsImportantWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (int i = 0; i < [logsArray count]; i++) {
			
			NSData *logData = [logsArray objectAtIndex:i];
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log logServiceID] isEqualToString:identifier] && ![log importantLog]) {
				
				[log changeLogToImportant];
				
				NSData *logEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:log];

				[logsArray replaceObjectAtIndex:i withObject:logEncodedObject];
			}
		}
		
		[userDefault setObject:logsArray forKey:LOGSERVICES];
		[userDefault synchronize];
	}
}

+ (void)MoveTemporaryLogsToLogCenter {
	
	if ([WJLogCenter ServiceEnable]) {

		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *tempLogs = [userDefault objectForKey:TEMPORALLOGS];
		NSMutableArray *mainLogs = [userDefault objectForKey:LOGSERVICES];
		
		if ([tempLogs count] > 0)
			[mainLogs addObjectsFromArray:tempLogs];
		
		[userDefault removeObjectForKey:TEMPORALLOGS];
		[userDefault setObject:mainLogs forKey:LOGSERVICES];
		[userDefault synchronize];
	}
}

#pragma mark - Search Services

+ (NSArray *)SearchLogByTitle:(NSString *)title {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *logData in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log title]isEqualToString:title]) {
				
				[tempArray addObject:log];
			}
		}
		return tempArray;
	}
	return nil;
}

+ (NSArray *)SearchLogByTag:(NSString *)tag {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *logData in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log logTag]isEqualToString:[tag lowercaseString]]) {
				
				[tempArray addObject:log];
			}
		}
		return tempArray;
	}
	return nil;
}

+ (NSArray *)SearchLogByMinimumTimeStamp:(NSString *)minTime {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *logData in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log timeInterval] floatValue] <= [minTime floatValue]) {
				
				[tempArray addObject:log];
			}
		}
		return tempArray;
	}
	return nil;
}

+ (NSArray *)SearchLogByMaximumTimeStamp:(NSString *)maxTime {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		NSMutableArray *tempArray = [NSMutableArray array];
		
		logsArray = [userDefault objectForKey:LOGSERVICES];
		
		for (NSData *logData in logsArray) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:logData];
			
			if ([[log timeInterval] floatValue] >= [maxTime floatValue]) {
				
				[tempArray addObject:log];
			}
		}
		return tempArray;
	}
	return nil;
}

#pragma mark - Reading Enable

+ (void)SetReadingIsEnable:(BOOL)isEnable {

	if ([WJLogCenter ServiceEnable]) {

		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		[userDefault setBool:isEnable forKey:READINGENABLE];
		[userDefault synchronize];
		
		if (!isEnable)
			[WJLogCenter MoveTemporaryLogsToLogCenter];
	}

}

+ (BOOL)ReadingIsEnable {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		return [userDefault boolForKey:READINGENABLE];
	}
	return false;
}

@end
