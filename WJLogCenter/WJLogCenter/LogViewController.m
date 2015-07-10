//
//  LogViewController.m
//  WJLogCenter
//
//  Created by Alireza Arabi on 6/13/15.
//  Copyright (c) 2015 Alireza Arabi. All rights reserved.
//

#import "LogViewController.h"
#import "SearchLogViewController.h"
#import "NSArray+ReverseArray.h"
#import "WJLogCenter.h"
#import "LogService.h"

@interface LogViewController ()
{
	BOOL isSearching;
}

@property (strong, nonatomic) IBOutlet UITableView *logTableView;

@property (strong, nonatomic) NSArray *logsServicesArray;
@property (strong, nonatomic) NSArray *searchResultArray;

@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *markAlOldBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *markAsImportantBarButton;

@end

@implementation LogViewController

- (id)init {
	NSString *nibName = @"LogViewController";
	NSBundle *bundle = nil;
	self = [super initWithNibName:nibName bundle:bundle];
	if (self) {
		
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	isSearching = NO;

	self.searchResultArray = [NSMutableArray array];
	
	[WJLogCenter SetReadingIsEnable:YES];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.logTableView.backgroundColor = [UIColor whiteColor];
	
	UIView *whiteView = [[UIView alloc]initWithFrame:self.logTableView.frame];
	whiteView.backgroundColor = [UIColor whiteColor];
	self.logTableView.backgroundView = whiteView;
	
	[self setTitle:@"Log Service"];
	self.navigationController.navigationBar.translucent = NO;

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Back"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(backToRoot:)];

	UIBarButtonItem *removeButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Remove"
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(removeAllLogs)];

	self.navigationItem.rightBarButtonItem = removeButton;
	self.navigationItem.leftBarButtonItem = backButton;

	self.logTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
	self.logsServicesArray = [self.logsServicesArray reversedArray];
	
	[self.logTableView registerNib:[UINib nibWithNibName:@"LogTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LogCellIdentifier"];
	[self.logTableView setAllowsSelection:YES];
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.logTableView addSubview:self.refreshControl];
	
	
	SearchLogViewController *searchLogController = [[SearchLogViewController alloc]initWithNibName:@"SearchLogViewController" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:searchLogController];
	
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nav];
	
	self.searchController.searchResultsUpdater = self;
	
	self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

	[self.searchController.searchBar setDelegate:self];
	[self.searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
	
	self.logTableView.tableHeaderView = self.searchController.searchBar;
	
	self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self.logTableView setContentOffset:CGPointMake(0, 44)];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	[WJLogCenter MarkAllLogsAsOld];
	[WJLogCenter SetReadingIsEnable:NO];
}

- (void)backToRoot:(id)sender {
	
	if (isSearching) {
		
		[self enableSearchEnvironment:NO];
		[self.logTableView reloadData];
	}
	else {
		
		[WJLogCenter MarkAllLogsAsOld];
		[WJLogCenter SetReadingIsEnable:NO];
		
		id viewController = [self.navigationController popViewControllerAnimated:YES];
		if (!viewController)
			[self dismissViewControllerAnimated:YES completion:nil];
	}
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
	if (isSearching)
		return [self.searchResultArray count];
	else
		return [self.logsServicesArray count];
}

- (LogTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCellIdentifier"];
	
	if (cell == nil) {
		cell = [[LogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LogCellIdentifier"];
	}
	
	LogService *log = [[LogService alloc]init];
	
	if (isSearching)
		log = [self.searchResultArray objectAtIndex:indexPath.row];
	else
		log = [self.logsServicesArray objectAtIndex:indexPath.row];
	
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
	if (isSearching)
		return NO;
	else
		return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	LogTableViewCell *cell = (LogTableViewCell *)[(UITableView *)self.logTableView cellForRowAtIndexPath:indexPath];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {

		[WJLogCenter RemoveLogServiceWithIdentifier:cell.logIdentifier];
		
		self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
		self.logsServicesArray = [self.logsServicesArray reversedArray];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
	}
}

#pragma mark - Refresh Handler

- (void)removeAllLogs {
	
	[WJLogCenter RemoveAllLogs];
	self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
	self.logsServicesArray = [self.logsServicesArray reversedArray];
	[self.logTableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
	
	[WJLogCenter MarkAllLogsAsOld];
	
	[WJLogCenter SetReadingIsEnable:NO];
	
	self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
	self.logsServicesArray = [self.logsServicesArray reversedArray];
	
	[WJLogCenter SetReadingIsEnable:YES];
	
	[refreshControl endRefreshing];
	[self.logTableView reloadData];
}

#pragma mark - Change Status Delegate

- (void)changeLogStatusToImportant:(NSString *)identifier {
	
	if (!isSearching) {
		
		[WJLogCenter MarkLogServiceAsImportantWithIdentifier:identifier];
	
		self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
		self.logsServicesArray = [self.logsServicesArray reversedArray];
	
		[self.logTableView reloadData];
	}
}

#pragma mark - BarButtonItem Actions

- (IBAction)markAllLogsAsImportant:(id)sender {
	
	if (!isSearching) {
		
		[WJLogCenter MarkAllLogsAsImportant];
		
		self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
		self.logsServicesArray = [self.logsServicesArray reversedArray];
		
		[self.logTableView reloadData];
	}
}

- (IBAction)markAllLogsAsOld:(id)sender {
	
	if (!isSearching) {
		
		[WJLogCenter MarkAllLogsAsOld];
		
		self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
		self.logsServicesArray = [self.logsServicesArray reversedArray];
		
		[self.logTableView reloadData];
	}
}

- (IBAction)removeAllLogs:(id)sender {
	
	if (!isSearching) {

		[WJLogCenter RemoveAllLogs];
		
		self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
		self.logsServicesArray = [self.logsServicesArray reversedArray];
		
		[self.logTableView reloadData];
	}
}

#pragma mark - Search Deleate

- (void)enableSearchEnvironment:(BOOL)enable {
	
	isSearching = enable;
	self.markAlOldBarButton.enabled = !enable;
	self.markAsImportantBarButton.enabled = !enable;
	self.navigationItem.rightBarButtonItem.enabled = !enable;
	
	if (enable) {
		[self setTitle:@"Search Result"];
		[self.navigationItem.leftBarButtonItem setTitle:@"Back Main"];
	}
	else {
		[self setTitle:@"Log Service"];
		[self.navigationItem.leftBarButtonItem setTitle:@"Back"];
	}
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	
	UISearchBar *searchBar = searchController.searchBar;
	NSString *searchString = searchBar.text;
	
	if ([searchBar.text hasPrefix:@"#"]) {
		NSString *newStr = [searchString substringFromIndex:1];
		self.searchResultArray = [WJLogCenter SearchLogByTag:newStr];
	}
	else if ([searchBar.text hasPrefix:@"Min "] || [searchBar.text hasPrefix:@"min "]) {
		NSString *newStr = [searchString substringFromIndex:4];
		self.searchResultArray = [WJLogCenter SearchLogByMinimumTimeStamp:newStr];
	}
	else if ([searchBar.text hasPrefix:@"Max "] || [searchBar.text hasPrefix:@"max "]) {
		NSString *newStr = [searchString substringFromIndex:4];
		self.searchResultArray = [WJLogCenter SearchLogByMaximumTimeStamp:newStr];
	}
	else {
		
		self.searchResultArray = [WJLogCenter SearchLogByTitle:searchString];
	}
	
	self.searchResultArray = [self.searchResultArray reversedArray];
	
	if (self.searchController.searchResultsController) {
		
		UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
		
		SearchLogViewController *vc = (SearchLogViewController *)navController.topViewController;
		vc.searchString = searchString;
		vc.searchLogResult = [self.searchResultArray copy];
		[vc.searchResultTableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	
	[WJLogCenter SetReadingIsEnable:NO];

	self.logsServicesArray = [NSMutableArray arrayWithArray:[WJLogCenter AllLogs]];
	self.logsServicesArray = [self.logsServicesArray reversedArray];

	[WJLogCenter SetReadingIsEnable:YES];

	[self.logTableView reloadData];
}

@end
