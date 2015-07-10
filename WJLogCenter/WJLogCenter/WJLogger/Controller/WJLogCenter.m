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
#define ENABLELOGGER	@"EnableLogger"
#define LOGGERVERSION	@"LoggerVersion"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface WJLogCenter ()

@end

@implementation WJLogCenter

#pragma mark - Enable Service

+ (void)SetEnableLogServiceManager:(BOOL)enable {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:enable forKey:ENABLESYSTEM];
	[userDefault synchronize];
	
	[WJLogCenter SetLoggerVersion:@"1.0.0"];
	
	NSString *loggerStart = [NSString stringWithFormat:@"[WJLogCenter] START WORKING WITH VERSION %@",[WJLogCenter LogegrVersion]];
	NSLog(loggerStart);
	
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
				
				NSString *logString = [NSString stringWithFormat:@"[READING ENABLE] LOG [%@] ADDED SUCCESSFULY!",[newLog title]];
				[WJLogCenter PrintDeveloperLog:logString];
				
				NSMutableArray *logsArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:TEMPORALLOGS]];
				
				[logsArray addObject:logEncodedObject];
				
				[userDefault setObject:logsArray forKey:TEMPORALLOGS];
			}
			else {
				
				NSString *logString = [NSString stringWithFormat:@"[READING DISABLE] LOG [%@] ADDED SUCCESSFULY!",[newLog title]];
				[WJLogCenter PrintDeveloperLog:logString];
				
				NSMutableArray *logsArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:LOGSERVICES]];
				
				[logsArray addObject:logEncodedObject];
				
				[userDefault setObject:logsArray forKey:LOGSERVICES];
			}
			
			[userDefault synchronize];
		}
		@catch (NSException *exception) {
			
			NSLog(@"Exception Is: %@",exception);
		}
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *numberOfLogs = [NSString stringWithFormat:@"%i",(int)[tempArray count]];
		NSString *Log = [NSString stringWithFormat:@"[Retrive Log] GET [%@] LOG!",numberOfLogs];
		[WJLogCenter PrintDeveloperLog:Log];
		
		return tempArray;
		
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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

				NSString *Log = [NSString stringWithFormat:@"[Retrive Log] GET LOG [%@]",[log title]];
				[WJLogCenter PrintDeveloperLog:Log];
				
				return log;
			}
		}
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
	return nil;
}

#pragma mark - Remove Log

+ (void)RemoveAllLogs {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		[userDefault removeObjectForKey:LOGSERVICES];
		[userDefault synchronize];
		
		[WJLogCenter PrintDeveloperLog:@"[Remove Log] ALL LOGS DELETED!"];

	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
}

+ (NSArray *)RemoveLogServiceWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSString *logTitle = @"";
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		NSMutableArray *logsArray = [NSMutableArray array];
		logsArray = [userDefault objectForKey:LOGSERVICES];
		

		for (int i = 0; i < [logsArray count]; i++) {
			
			LogService *log = [NSKeyedUnarchiver unarchiveObjectWithData:[logsArray objectAtIndex:i]];

			logTitle = [log title];
			
			if ([[log logServiceID] isEqualToString:identifier]) {
				
				[logsArray removeObjectAtIndex:i];

				[userDefault setObject:logsArray forKey:LOGSERVICES];
				[userDefault synchronize];
			}
		}
		
		NSString *Log = [NSString stringWithFormat:@"[Remove Log] LOG [%@] DELETED!",logTitle];
		[WJLogCenter PrintDeveloperLog:Log];
		
		return logsArray;
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		[WJLogCenter PrintDeveloperLog:@"[Mark Log] MARK ALL LOGS AS [OLD]"];

	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
}

+ (void)MarkLogServiceAsOldWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {

		int numberOfMarkedLogs = 0;
		
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
				
				numberOfMarkedLogs ++;
			}
			
			[userDefault setObject:logsArray forKey:LOGSERVICES];
			[userDefault synchronize];
			
			NSString *Log = [NSString stringWithFormat:@"[Mark Log] %i LOG MARKED AS [OLD]!",numberOfMarkedLogs];
			[WJLogCenter PrintDeveloperLog:Log];
		}
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		[WJLogCenter PrintDeveloperLog:@"[Mark Log] MARK ALL LOGS AS [IMPORTANT]"];

	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
}

+ (void)MarkLogServiceAsImportantWithIdentifier:(NSString *)identifier {
	
	if ([WJLogCenter ServiceEnable]) {
		
		int numberOfMarkedLogs = 0;
		
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
				
				numberOfMarkedLogs ++;
			}
		}
		
		[userDefault setObject:logsArray forKey:LOGSERVICES];
		[userDefault synchronize];
		
		NSString *Log = [NSString stringWithFormat:@"[Mark Log] %i LOG MARKED AS [OLD]!",numberOfMarkedLogs];
		[WJLogCenter PrintDeveloperLog:Log];
		
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *Log = [NSString stringWithFormat:@"[Move Log] %i LOG MOVED TO MAIN!",(int)[tempLogs count]];
		[WJLogCenter PrintDeveloperLog:Log];

	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *Log = [NSString stringWithFormat:@"[Search Log] %i LOG FOUNDED!",(int)[tempArray count]];
		[WJLogCenter PrintDeveloperLog:Log];
		
		return tempArray;
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *Log = [NSString stringWithFormat:@"[Search Log] %i LOG FOUNDED!",(int)[tempArray count]];
		[WJLogCenter PrintDeveloperLog:Log];

		return tempArray;
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *Log = [NSString stringWithFormat:@"[Search Log] %i LOG FOUNDED!",(int)[tempArray count]];
		[WJLogCenter PrintDeveloperLog:Log];
		
		return tempArray;
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
		
		NSString *Log = [NSString stringWithFormat:@"[Search Log] %i LOG FOUNDED!",(int)[tempArray count]];
		[WJLogCenter PrintDeveloperLog:Log];

		return tempArray;
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
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
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
}

+ (BOOL)ReadingIsEnable {
	
	if ([WJLogCenter ServiceEnable]) {
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		return [userDefault boolForKey:READINGENABLE];
	} else {
		
		NSLog(@"[WJLogCenter] SERVICE IS DISABLE!");
	}
	return false;
}

#pragma mark - Developer Logging

+ (void)SetEnableDeveloperLogs:(BOOL)enable {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:enable forKey:ENABLELOGGER];
	[userDefault synchronize];
}

+ (BOOL)EnableDeveloperLogs {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	return [userDefault boolForKey:ENABLELOGGER];
}

+ (void)PrintDeveloperLog:(NSString *)log {
	
	if ([WJLogCenter EnableDeveloperLogs])
		NSLog(@"[WJLogCenter] %@",log);
}

#pragma mark - Version

+ (void)SetLoggerVersion:(NSString *)version {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:version forKey:LOGGERVERSION];
	[userDefault synchronize];
}

+ (NSString *)LogegrVersion {
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	return [userDefault objectForKey:LOGGERVERSION];
}

@end
