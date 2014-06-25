//
//  TwitterClient.h
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)login;

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(NSString *)lastTweetID success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)submitWithSuccess:(NSString *)tweetText success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)retweetWithSuccess:(NSString *)tweetID success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)favoriteWithSuccess:(NSString *)tweetID success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

@end
