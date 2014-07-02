//
//  MainTableViewController.h
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HambaaagaViewController.h"


@interface MainTableViewController : UITableViewController <UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *mainTimelineTweets;
@property (weak, nonatomic) id <HambaaagaViewControllerDelegate> delegate;

- (void)showProfile:(NSString *)username;


@end
