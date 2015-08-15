//
//  NSArray+ReverseArray.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 7/8/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "NSArray+ReverseArray.h"

@implementation NSArray (ReverseArray)

- (NSArray *)reversedArray {
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	
	for (id element in enumerator)
		[array addObject:element];
	
	return array;
}

@end
