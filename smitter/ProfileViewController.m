//
//  ProfileViewController.m
//  smitter
//
//  Created by Guy Morita on 7/1/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPic;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *favorites;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (strong, nonatomic) NSString *curUsername;
@property (strong, nonatomic) User *user;


@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.navigationItem.title = @"Profile";


    return self;
}

- (id) initWithUsername:(NSString *)username {
    self = [self initWithNibName:nil bundle:nil];
    
    self.curUsername = username;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    TwitterClient *client = [TwitterClient instance];
    
    [client getUserWithSuccess:self.curUsername success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user = [User getUser:responseObject];
        self.fullName.text = self.user.fullName;
        self.username.text = self.user.username;
        self.favorites.text = [self.user.favorites stringValue];
        self.following.text = [self.user.following stringValue];
        self.followers.text = [self.user.followersCount stringValue];
        NSURL *url = [NSURL URLWithString:self.user.profilePicURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.profilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.profilePic.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Failed to load picture on compose");
        }];
        NSURL *backgroundURL = [NSURL URLWithString:self.user.backgroundURL];
        NSURLRequest *backgroundUrlRequest = [NSURLRequest requestWithURL:backgroundURL];
        [self.backgroundPic setImageWithURLRequest:backgroundUrlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.backgroundPic.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Failed to load picture on compose");
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get user on profile page %@", error);
    }];

    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.cornerRadius = 5;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePic.layer.borderWidth = 5;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
