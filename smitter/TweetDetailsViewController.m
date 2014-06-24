//
//  TweetDetailsViewController.m
//  smitter
//
//  Created by Guy Morita on 6/24/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
- (IBAction)fireReply:(id)sender;
- (IBAction)fireRetweet:(id)sender;
- (IBAction)fireFavorite:(id)sender;


@end

@implementation TweetDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

- (void)configure {
    self.fullName.text = self.tweetModel.fullName;
    self.username.text = self.tweetModel.username;
    self.tweetText.text = self.tweetModel.tweetText;
    self.numRetweets.text = self.tweetModel.retweetedCount;
    self.numFavorites.text = self.tweetModel.favoritedCount;
    self.date.text = self.tweetModel.datePosted;
    self.navigationItem.title = self.tweetModel.username;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view from its nib.
    [self configure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fireRetweet:(id)sender {
}

- (IBAction)fireFavorite:(id)sender {
}

- (IBAction)fireReply:(id)sender {
//    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
}

@end
