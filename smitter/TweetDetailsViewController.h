//
//  TweetDetailsViewController.h
//  smitter
//
//  Created by Guy Morita on 6/24/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailsViewController : UIViewController

@property (strong, nonatomic) Tweet *tweetModel;
- (void)configure;

@end
