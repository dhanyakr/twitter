//
//  Tweet.m
//  twitter
//
//  Created by Dhanya R on 9/23/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
- (id)initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        NSLog(@"Tweet : %@", dictionary);
        self.tweetId = dictionary[@"id"];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.retweetCount = dictionary[@"retweet_count"];
        self.favoriteCount = dictionary[@"favorite_count"];
        self.retweeted = dictionary[@"retweeted"];
        self.favorited = dictionary[@"favorited"];

    }
    return self;
}

+(NSArray *)tweetsWithArray:(NSArray *) array{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
