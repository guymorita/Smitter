//
//  TabBarViewController.m
//  smitter
//
//  Created by Guy Morita on 7/1/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "HambaaagaViewController.h"
#import "ComposeViewController.h"
#import "MainTableViewController.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"

@interface HambaaagaViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UINavigationController *appNavController;
@property (assign, nonatomic) BOOL hambaOut;
@property (weak, nonatomic) IBOutlet UIImageView *hambaProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *hambaFullName;
@property (weak, nonatomic) IBOutlet UILabel *hambaUsername;
@property (strong, nonatomic) User *currentUser;
- (IBAction)onCompose:(id)sender;
- (IBAction)onTimeline:(id)sender;
- (IBAction)onProfile:(id)sender;

@end

@implementation HambaaagaViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TwitterClient *client = [TwitterClient instance];
        BDBOAuthToken *token = [client.requestSerializer accessToken];
        MainTableViewController *mainVC = [[MainTableViewController alloc] init];
        mainVC.delegate = self;
        NSArray *vcs = @[[[LoginViewController alloc] init], mainVC];
        NSInteger vcToStart = 0;
        if (token) {
            vcToStart = 1;
        }

        self.appNavController = [[UINavigationController alloc] init];
        [self.appNavController setViewControllers:vcs];
        self.appNavController.navigationBar.barTintColor = [UIColor colorWithRed:80.0f/255.0f green:172.0f/255.0f blue:240.0f/255.0f alpha:1.0f];

        self.appNavController.navigationBar.opaque = YES;

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [self.appNavController.navigationBar setTitleTextAttributes:attributes];
        self.appNavController.navigationBar.tintColor = [UIColor whiteColor];
        self.appNavController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(slideHamba)];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TwitterClient *client = [TwitterClient instance];
    
    [client currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [User setCurrentUser:responseObject];
        self.currentUser = [User currentUser];
        
        self.hambaFullName.text = self.currentUser.fullName;
        self.hambaUsername.text = self.currentUser.username;
        NSURL *url = [NSURL URLWithString:self.currentUser.profilePicURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.hambaProfilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.hambaProfilePic.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Failed to load picture on compose");
        }];
        self.hambaProfilePic.clipsToBounds = YES;
        self.hambaProfilePic.layer.cornerRadius = 5;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get current user");
    }];
    

    
    UIView *mainView = ((UIViewController *)self.appNavController).view;
    mainView.frame = self.contentView.frame;
    
    [self.contentView addSubview:mainView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTimeline:(id)sender {
    [self slideHamba];
}

- (IBAction)onCompose:(id)sender {
    [self.appNavController pushViewController:[[ComposeViewController alloc] init] animated:YES];
    [self slideHamba];
}

- (IBAction)onProfile:(id)sender {
    [self.appNavController pushViewController:[[ProfileViewController alloc] initWithUsername:self.currentUser.username] animated:YES];
    [self slideHamba];
}

- (void)pushToTimeline {
    
}
                                                                  
                                                                  
- (void)slideHamba {
    BOOL hambaOut = [self hambaOut];
    CGRect frame = self.contentView.frame;
    if (hambaOut) {
        frame.origin.x -= 240;
        [self setHambaOut:NO];
    } else {
        frame.origin.x += 240;
        [self setHambaOut:YES];
    }
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}
                                                                  
                                                                  
#pragma mark - GuyProtocol

- (void)showProfile:(id)sender username:(NSString *)username
{
    [self.appNavController pushViewController:[[ProfileViewController alloc] initWithUsername:username] animated:YES];
}



@end
