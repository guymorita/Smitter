//
//  ComposeViewController.m
//  smitter
//
//  Created by Guy Morita on 6/23/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *textBox;
@property (strong, nonatomic) NSString *preloadedText;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) UIBarButtonItem *tweetLength;
@property (strong, nonatomic) UIBarButtonItem *submitButton;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Compose";
        
        self.tweetLength = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.tweetLength setEnabled:NO];
        
        self.submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(submit:)];
        
        self.navigationItem.rightBarButtonItems = @[self.submitButton, self.tweetLength];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTweet:)];
        self.navigationItem.leftBarButtonItem = cancelButton;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.currentUser = [User currentUser];
    
    self.fullName.text = self.currentUser.fullName;
    self.username.text = self.currentUser.username;
    NSURL *url = [NSURL URLWithString:self.currentUser.profilePicURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.profilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profilePic.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load picture on compose");
    }];
    if (self.preloadedText) {
            self.textBox.text = self.preloadedText;
    }
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.cornerRadius = 5;
    
    self.textBox.delegate = self;

    [self.textBox becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)changeTweetLength {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)preloadText:(NSString *)username {
    NSString *preloadedText = [username stringByAppendingString:@" "];
    self.preloadedText = preloadedText;
}

- (void)textViewDidChange:(UITextView *)textView {
    int currentLength = [self.textBox.text length];
    int lengthToGo = 140 - currentLength;
    NSString *tweetLengthToGo = [NSString stringWithFormat:@"%i", lengthToGo];
    [self.tweetLength setTitle:tweetLengthToGo];
    if (lengthToGo < 0 || lengthToGo == 140) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil];
        [self.tweetLength setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self.submitButton setEnabled:NO];
        
    } else {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil];
        [self.tweetLength setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self.submitButton setEnabled:YES];
    }
    
}

- (IBAction)submit:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    [client submitWithSuccess:self.textBox.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweeted with success %@", responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet failed %@", error);
    }];
}

- (IBAction)cancelTweet:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
