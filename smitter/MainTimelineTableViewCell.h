//
//  MainTimelineTableViewCell.h
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface MainTimelineTableViewCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweetModel;

- (void)configure;
+ (NSDateFormatter *)dateFormatter;
@end
