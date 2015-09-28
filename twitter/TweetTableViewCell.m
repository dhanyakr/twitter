//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Dhanya R on 9/24/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "TwitterClient.h"
@interface TweetTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
/*
@property (nonatomic, weak) NSNumber *retweeted;
@property (nonatomic, weak) NSNumber *favorited;
*/
@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.height;
}
/*
- (IBAction)onReply:(id)sender {
}
- (IBAction)onRetweet:(id)sender {
    
    if (self.retweeted == [NSNumber numberWithBool:(BOOL)0]) {
        self.retweeted = [NSNumber numberWithBool:(BOOL)1];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
        self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] + 1];
        [[TwitterClient sharedInstance] retweetTweet:self.tweet];
    } else{
        self.retweeted = [NSNumber numberWithBool:(BOOL)0];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] - 1];
        [[TwitterClient sharedInstance] unfavoriteTweet:self.tweet];
    }
   
}
- (IBAction)onFavorite:(id)sender {
    if (self.favorited == [NSNumber numberWithBool:(BOOL)0]) {
        self.favorited = [NSNumber numberWithBool:(BOOL)1];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
        self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] + 1];
        [[TwitterClient sharedInstance] favoriteTweet:self.tweet];
    }else {
        self.favorited = [NSNumber numberWithBool:(BOOL)0];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] - 1];
        [[TwitterClient sharedInstance] unfavoriteTweet:self.tweet];
    }
   
}
*/
- (void) setTweet: (Tweet *) tweet {
    
    User *user = tweet.user;
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:user.profileImageUrl]];
    /*
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[author.profileImageUrl stringByReplacingOccurrencesOfString:@"http"                                                                                                                       withString:@"https"]]];
    */
    [self.profileImageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        self.profileImageView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            self.profileImageView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.createdAtLabel.text = [tweet.createdAt timeAgo];
    self.tweetLabel.text = tweet.text;
    [self.tweetLabel sizeToFit];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;

    [self.replyButton setImage:[UIImage imageNamed:@"reply_hover"] forState:UIControlStateHighlighted];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_hover"] forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_hover"] forState:UIControlStateHighlighted];
    
    
   
    if (tweet.retweeted == [NSNumber numberWithBool:(BOOL)1]) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    if (tweet.favorited == [NSNumber numberWithBool:(BOOL)1]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.height;
}

@end
