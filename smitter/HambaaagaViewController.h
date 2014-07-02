//
//  TabBarViewController.h
//  smitter
//
//  Created by Guy Morita on 7/1/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HambaaagaViewControllerDelegate <NSObject>
- (void)showProfile:(id)sender username:(NSString *)username;
- (void)slideHamba;
@end


@interface HambaaagaViewController : UIViewController <HambaaagaViewControllerDelegate>
- (void)pushToTimeline;
- (void)slideHamba;

@end
