//
//  MainTimelineTableViewCell.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "MainTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface MainTimelineTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *linkURL;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *sinceDatePosted;


@end
@implementation MainTimelineTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure {
    self.tweetText.text = self.tweetModel.tweetText;
    self.fullName.text = self.tweetModel.fullName;
    NSString *username = @"@";
    self.username.text = [username stringByAppendingString:self.tweetModel.username];
    self.linkURL.text = self.tweetModel.linkURL;
    self.sinceDatePosted.text = self.tweetModel.datePosted;
    NSURL *url = [NSURL URLWithString:self.tweetModel.profilePicURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.profilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profilePic.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load picture");
    }];
}

@end
