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
//            currentUser = [[User alloc] initWithDictionary:dict];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
}

@end
