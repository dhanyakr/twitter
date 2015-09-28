//
//  TwitterClient.m
//  twitter
//
//  Created by Dhanya R on 9/23/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"


NSString * const kTwitterConsumerKey = @"KinfEgpmh0L53XpH0uCR7lVve";
NSString * const kTwitterConsumerSecret = @"dcPimhA6MbTcKEowmePgUn4h51NaDxvDteo9qnilm2kMF40fO9";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()
@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient
+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}
-(void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the token");
        self.loginCompletion(nil, error);
    }];
}
-(void)openURL:(NSURL *)url{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token");
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed getting current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token");
        self.loginCompletion(nil, error);
    }];

    /*
     [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //NSLog(@"tweets: %@", responseObject);
     NSArray *tweets = [Tweet tweetsWithArray:responseObject];
     for (Tweet *tweet in tweets) {
     NSLog(@"tweet: %@, created At: %@", tweet.text, tweet.createdAt);
     }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Failed getting tweets");
     }];
     */

}

-(void) homeTimelineWithParams: (NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error)) completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"tweets: %@", responseObject);
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
        NSLog(@"Failed getting tweets");
    }];
}

- (void) tweetWithString: (NSString *) tweetText { // need to use block
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: tweetText forKey: @"status"];
    [self POST: @"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed submitting tweet");
    }];
}

- (void) favoriteTweet: (Tweet *)tweet {
    NSString *url = [NSString stringWithFormat: @"1.1/favorites/create.json?id=%@", tweet.tweetId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: tweet.tweetId forKey: @"id"];
    
    [self POST: url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed favoring tweet");
        
    }];
}

- (void) unfavoriteTweet: (Tweet *)tweet {
    NSString *url = [NSString stringWithFormat: @"1.1/favorites/destroy.json?id=%@", tweet.tweetId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: tweet.tweetId forKey: @"id"];
    
    [self POST: url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed unfavoring tweet");
        
    }];
}

- (void) retweetTweet: (Tweet *)tweet {
    NSString *url = [NSString stringWithFormat: @"1.1/statuses/retweet/%@.json", tweet.tweetId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: tweet.tweetId forKey: @"id"];
    
    [self POST: url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed retweeting");
        
    }];
}

/*
- (void) replyToTweet: (Tweet *)tweet withString: (NSString *) replyText {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: replyText forKey: @"status"];
    [params setObject: tweet.tweetId forKey: @"in_reply_to_status_id"];
    
    [self POST: @"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed reply to tweet");
        
    }];
}
 */
@end
