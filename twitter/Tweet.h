//
//  Tweet.h
//  twitter
//
//  Created by Dhanya R on 9/23/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject
@property (nonatomic, strong) NSNumber *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *retweetCount;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *retweeted;
@property (nonatomic, strong) NSNumber *favorited;


- (id)initWithDictionary: (NSDictionary *) dictionary;
+(NSArray *)tweetsWithArray:(NSArray *) array;
@end
