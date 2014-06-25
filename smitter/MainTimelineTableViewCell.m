//
//  MainTimelineTableViewCell.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "MainTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <MHPrettyDate.h>

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

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZZ yyyy";
    return dateFormatter;
}

- (void)configure {
    self.tweetText.text = self.tweetModel.tweetText;
    self.fullName.text = self.tweetModel.fullName;
    self.username.text = self.tweetModel.username;
    self.linkURL.text = self.tweetModel.linkURL;
    NSDate *date = [[MainTimelineTableViewCell dateFormatter] dateFromString:self.tweetModel.datePosted];
    NSString *prettyDate = [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
    self.sinceDatePosted.text = prettyDate;
    
    NSURL *url = [NSURL URLWithString:self.tweetModel.profilePicURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.profilePic setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profilePic.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load picture");
    }];
}

@end
