//
//  LogService.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "LogService.h"

@interface LogService ()

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *eventDescription;
@property (nonatomic,strong) NSString *timeInterval;

@property (nonatomic) BOOL isNewEvent;

@end

@implementation LogService

- (void)initWithTitle:(NSString *)title eventDescription:(NSString *)eventDescription {
	self.title = title;
	self.eventDescription = eventDescription;
	self.timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
	self.isNewEvent = YES;
}

- (void)setTitle:(NSString *)title {
	self.title = title;
}

- (NSString *)title {
	return self.title;
}

- (void)setEventDescription:(NSString *)eventDescription {
	self.eventDescription = eventDescription;
}

- (NSString *)eventDescription {
	return self.eventDescription;
}

- (void)setTimeInterval:(NSString *)timeInterval {
	self.timeInterval = timeInterval;
}

- (NSString *)timeInterval {
	return self.timeInterval;
}

- (void)setIsNewEvent:(BOOL)isNewEvent {
	self.isNewEvent = isNewEvent;
}

- (BOOL)isNewEvent {
	return self.isNewEvent;
}

@end
