//
//  User.h
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;
+ (User *)setCurrentUser:(NSDictionary *)user;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *fullName;
@property (assign, nonatomic) NSNumber *followersCount;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *profilePicURL;
@property (strong, nonatomic) NSString *backgroundURL;
@property (strong, nonatomic) NSNumber *following;
@property (strong, nonatomic) NSNumber *favorites;

@end
