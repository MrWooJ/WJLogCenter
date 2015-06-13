//
//  WJLogCenter.h
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGSERVICES		@"LogServices"

@class LogService;

@interface WJLogCenter : NSObject

+ (void)NewLogTitle:(NSString *)title LogDescription:(NSString *)description;
@end
