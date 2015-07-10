//
//  ViewController.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "ViewController.h"

#import "WJLogCenter.h"
#import "LogViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addTarget:self
			   action:@selector(showLogView:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	[button setTitle:@"Log Service" forState:UIControlStateNormal];
	button.frame = CGRectMake(0,0, 160.0, 40.0);
	button.center = self.view.center;
	[self.view addSubview:button];
	
	[WJLogCenter SetEnableLogServiceManager:YES];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(newLog) userInfo:nil repeats:YES];
	
	// Random Log Generator
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)newLog {
	int lowerBound = 1;
	int upperBound1 = 20;
	int upperBound2 = 100;

	int rndValue1 = lowerBound + arc4random() % (upperBound1 - lowerBound);
	int rndValue2 = lowerBound + arc4random() % (upperBound2 - lowerBound);
	
	[WJLogCenter NewLogTitle:[self randomStringWithLength:rndValue1] LogDescription:[self randomStringWithLength:rndValue2] UserInfo:nil];
}

- (NSString *)randomStringWithLength:(int)len {

	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	
	NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	
	for (int i=0; i<len; i++)
		[randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
	
	return randomString;
}

- (void)showLogView:(id)sender {
	LogViewController *LVC = [[LogViewController alloc]init];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:LVC];
	[self presentViewController:nav animated:YES completion:nil];
}

@end
