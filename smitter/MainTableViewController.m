//
//  MainTableViewController.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTimelineTableViewCell.h"
#import "TwitterClient.h"
#import "User.h"
#import "ComposeViewController.h"
#import "TweetDetailsViewController.h"

@interface MainTableViewController ()
{
    MainTimelineTableViewCell *_stubCell;
}
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation MainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Smitter";
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Compose"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(openCompose:)];
    
    self.navigationItem.rightBarButtonItem = composeButton;
    self.navigationItem.hidesBackButton = YES;
    
    self.mainTableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"MainTimelineTableViewCell" bundle:nil];
    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:@"MainTimelineCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.client = [TwitterClient instance];
    [self refreshTweets:nil];
    
    [self.client currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [User setCurrentUser:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get current user");
    }];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:self.refreshControl];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(slideHamba)];

}

- (void)pullToRefresh:(UIRefreshControl *)refreshControl {
    [self refreshTweets:nil];
}

- (void)refreshTweets:(NSString *)lastTweetID {
    [self.client homeTimelineWithSuccess:lastTweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.mainTimelineTweets.count > 0) {
            [self.mainTimelineTweets addObjectsFromArray:responseObject];
        } else {
            self.mainTimelineTweets = [[NSMutableArray alloc] initWithArray: responseObject];
            NSLog(@"initial stuff");
        }
        [self.mainTableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Home timeline failure %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.mainTimelineTweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    MainTimelineTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"MainTimelineCell" forIndexPath:indexPath];
    NSDictionary *tweetDict = self.mainTimelineTweets[indexPath.row];
    Tweet *tweetModel = [[Tweet alloc] initWithDictionary:tweetDict];
    tweetCell.tweetModel = tweetModel;
    [tweetCell configure];
    
    return tweetCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweetDict = self.mainTimelineTweets[indexPath.row];
    Tweet *tweetModel = [[Tweet alloc] initWithDictionary:tweetDict];
    _stubCell.tweetModel = tweetModel;
    [_stubCell configure];
        
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    NSDictionary *tweetDict = self.mainTimelineTweets[indexPath.row];
    TweetDetailsViewController *tweetDetails = [[TweetDetailsViewController alloc] init];
    tweetDetails.tweetModel = [[Tweet alloc] initWithDictionary:tweetDict];
    
    [self.navigationController pushViewController:tweetDetails animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.mainTimelineTweets.count -1) {
        [self refreshTweets:self.mainTimelineTweets[self.mainTimelineTweets.count -1][@"id"]];
    }
}

- (IBAction)openCompose:(id)sender {
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:composeVC animated:YES];
}

- (void)slideHamba {
    [self.ham slideHamba];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
