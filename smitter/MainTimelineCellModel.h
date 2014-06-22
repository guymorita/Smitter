//
//  MainTimelineCellModel.h
//  smitter
//
//  Created by Guy Morita on 6/21/14.
//  Copyright (c) 2014 geemoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTimelineCellModel : NSObject

@property (strong, nonatomic) NSString *tweetText;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *profilePicURL;
@property (strong, nonatomic) NSString *linkURL;
@property (strong, nonatomic) NSString *datePosted;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
