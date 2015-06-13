//
//  LogService.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogService : NSObject

- (void)initWithTitle:(NSString *)title eventDescription:(NSString *)eventDescription;

- (NSString *)title;
- (NSString *)eventDescription;
- (NSString *)timeInterval;

- (void)setIsNewEvent:(BOOL)isNewEvent;
- (BOOL)isNewEvent;

@end
