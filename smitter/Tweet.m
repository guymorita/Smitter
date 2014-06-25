//
//  MainTimelineCellModel.m
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.tweetText = dictionary[@"text"];
        NSDictionary *user = dictionary[@"user"];
        self.profilePicURL = user[@"profile_image_url"];
        NSString *userat = @"@";
        self.username = [userat stringByAppendingString:user[@"screen_name"]];
        self.datePosted = user[@"created_at"];
        self.retweetedCount = user[@"retweet_count"];
        self.favoritedCount = user[@"favorite_count"];
        self.fullName = user[@"name"];
        NSDictionary *entities = dictionary[@"entities"];
        NSArray *media = entities[@"urls"];
        if (media.count > 0) {
            NSDictionary *urls = media[0];
            self.linkURL = urls[@"display_url"];
        }
        self.tweetID = dictionary[@"id"];
    }
    return self;
}

@end
