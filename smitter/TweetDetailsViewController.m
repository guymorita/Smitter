//
//  TweetDetailsViewController.m
//  smitter
//
//  Created by Guy Morita on 6/24/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *numRetweets;
@property (weak, nonatomic) IBOutlet UILabel *numFavorites;
@property (weak, nonatomic) TwitterClient *client;
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
    NSURL *url = [NSURL URLWithString:self.tweetModel.profilePicURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.profilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profilePic.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load picture on compose");
    }];
    self.client = [TwitterClient instance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view from its nib.
    [self configure];
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fireRetweet:(id)sender {
    [self.client retweetWithSuccess:self.tweetModel.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweet Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet Failure %@", error);
    }];
    
}

- (IBAction)fireFavorite:(id)sender {
    [self.client favoriteWithSuccess:self.tweetModel.tweetID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Favorite with Success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Favorite failed %@", error);
    }];
}

- (IBAction)fireReply:(id)sender {
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    [composeVC preloadText:self.tweetModel.username];
    [self.navigationController pushViewController:composeVC animated:YES];
}

@end
