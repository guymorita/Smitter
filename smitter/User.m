//
//  User.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *)currentUser{
    if (currentUser == nil) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dict) {
            currentUser = [User setCurrentUser:dict];
        }
    }
    
    return currentUser;
}

+ (User *)setCurrentUser:(NSDictionary *)user {
    User *us = [[User alloc] init];
    us.username = [@"@" stringByAppendingString:user[@"screen_name"]]
    ;
    us.location = user[@"location"];
    us.followersCount = user[@"followers_count"];
    us.fullName = user[@"name"];
    us.profilePicURL = user[@"profile_image_url"];
    us.backgroundURL = user[@"profile_background_image_url"];
    us.following = user[@"friends_count"];
    us.favorites = user[@"favourites_count"];
    currentUser = us;
    return currentUser;
}

@end
