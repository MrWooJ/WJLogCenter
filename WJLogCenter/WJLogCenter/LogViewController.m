//
//  LogViewController.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "LogViewController.h"
#import "LogTableViewCell.h"

@interface LogViewController ()

@property (strong, nonatomic) IBOutlet UITableView *logTableView;
@property (strong, nonatomic) NSArray *logsServicesArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self setTitle:@"Log Service"];
	self.navigationController.navigationBar.translucent = NO;

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Back"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(backToRoot:)];

	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Reload"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(refresh:)];

	self.navigationItem.rightBarButtonItem = refreshButton;
	self.navigationItem.leftBarButtonItem = backButton;

	self.logTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	self.logsServicesArray = [NSMutableArray array];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.logTableView addSubview:self.refreshControl];
}

-(IBAction)backToRoot:(id)sender {
	id viewController = [self.navigationController popViewControllerAnimated:YES];
	if (!viewController)
		[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data Source Delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.logsServicesArray count];
}

- (LogTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCellIdentifier"];
	
	if (cell == nil) {
		cell = [[LogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LogCellIdentifier"];
	}
	
	[cell setUserInteractionEnabled:NO];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {

		
	}
}

#pragma mark - Refresh Handler

- (void)refresh:(UIRefreshControl *)refreshControl {
	
	[refreshControl endRefreshing];
}

@end
