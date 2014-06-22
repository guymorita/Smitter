//
//  TwitterClient.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    // execute this only once
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"8v8TCRwXW1Fcivlu8SSFoSP6A" consumerSecret:@"r8DqqbfIG1CPKVrzNoWPGKdjHS9Zn9oJnuA013hdHpoyWKWEEh"];
    });
    
    return instance;
}

- (void)login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cpsmitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Didn't get ze token, %@", [error description]);
    }];
    
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

@end