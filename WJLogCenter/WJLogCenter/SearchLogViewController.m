//
//  SearchLogViewController.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 7/10/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "SearchLogViewController.h"
#import "LogService.h"
#import "WJLogCenter.h"
#import "NSArray+ReverseArray.h"
#import "NSMutableArray+ReversArray.h"

@interface SearchLogViewController ()

@end

@implementation SearchLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.searchResultTableView registerNib:[UINib nibWithNibName:@"LogTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LogCellIdentifier"];
	[self.searchResultTableView setAllowsSelection:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"%i",self.searchLogResult.count);
	return [self.searchLogResult count];
}

- (LogTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCellIdentifier"];
	
	if (cell == nil) {
		cell = [[LogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LogCellIdentifier"];
	}
	
	LogService *log = [[LogService alloc]init];
	
	log = [self.searchLogResult objectAtIndex:indexPath.row];
	
	[cell.titleLabel setText:[log title]];
	cell.delegate = self;
	cell.logIdentifier = [log logServiceID];
	[cell.descriptionTextView setText:[log eventDescription]];
	[cell.timeLabel setText:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:[[log timeInterval]floatValue]]]];
	
	if ([log importantLog]) {
		[cell.eventStatus setTitle:@"IMP" forState:UIControlStateNormal];
		[cell.eventStatus setBackgroundColor:[UIColor colorWithRed:255/255.0 green:128/255.0 blue:0 alpha:1]];
	}
	else {
		if ([log newLog]) {
			[cell.eventStatus setTitle:@"NEW" forState:UIControlStateNormal];
			[cell.eventStatus setBackgroundColor:[UIColor colorWithRed:0 green:204/255.0 blue:0 alpha:1]];
		}
		else {
			[cell.eventStatus setTitle:@"OLD" forState:UIControlStateNormal];
			[cell.eventStatus setBackgroundColor:[UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1]];
		}
	}
	
	[cell setUserInteractionEnabled:YES];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	LogTableViewCell *cell = (LogTableViewCell *)[(UITableView *)self.searchResultTableView cellForRowAtIndexPath:indexPath];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[WJLogCenter RemoveLogServiceWithIdentifier:cell.logIdentifier];
		
		[self searchAgainAfterChanges];

		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
		
		[self.searchResultTableView reloadData];
	}
}

#pragma mark - Change Status Delegate

- (void)changeLogStatusToImportant:(NSString *)identifier {
	
	[WJLogCenter MarkLogServiceAsImportantWithIdentifier:identifier];
		
	[self searchAgainAfterChanges];
	
	[self.searchResultTableView reloadData];
}

#pragma mark - Search Controller

- (void)searchAgainAfterChanges {

	if ([self.searchString hasPrefix:@"#"]) {
		NSString *newStr = [self.searchString substringFromIndex:1];
		self.searchLogResult = [WJLogCenter SearchLogByTag:newStr];
	}
	else if ([self.searchString  hasPrefix:@"Min "] || [self.searchString hasPrefix:@"min "]) {
		NSString *newStr = [self.searchString substringFromIndex:4];
		self.searchLogResult = [WJLogCenter SearchLogByMinimumTimeStamp:newStr];
	}
	else if ([self.searchString  hasPrefix:@"Max "] || [self.searchString hasPrefix:@"max "]) {
		NSString *newStr = [self.searchString substringFromIndex:4];
		self.searchLogResult = [WJLogCenter SearchLogByMaximumTimeStamp:newStr];
	}
	else {
		
		self.searchLogResult = [WJLogCenter SearchLogByTitle:self.searchString];
	}
	
	self.searchLogResult = [self.searchLogResult reversedArray];
}


@end
