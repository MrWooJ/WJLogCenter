//
//  NSMutableArray+ReversArray.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 7/8/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "NSMutableArray+ReversArray.h"

@implementation NSMutableArray (ReversArray)

- (void)reverseArray {
	
	if ([self count] <= 1)
		return;
	
	NSUInteger i = 0;
	NSUInteger j = [self count] - 1;
	
	while (i < j) {
	
		[self exchangeObjectAtIndex:i withObjectAtIndex:j];
		
		i++;
		j--;
	}
}

@end
