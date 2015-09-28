//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Dhanya R on 9/25/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "TwitterClient.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
-(void)onReply;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, weak) NSNumber *retweeted;
@property (nonatomic, weak) NSNumber *favorited;
@end

@implementation TweetDetailsViewController
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

    self.retweetCount.text = [NSString stringWithFormat:@"%@ retweets", self.tweet.retweetCount];
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

    self.favoriteCount.text = [NSString stringWithFormat:@"%@ favorites", self.tweet.favoriteCount];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"Tweet";
    
   
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    User *user = self.tweet.user;
    
    /*
     [self.profileImageView setImageWithURL:[NSURL URLWithString:[author.profileImageUrl stringByReplacingOccurrencesOfString:@"http"                                                                                                                       withString:@"https"]]];
     */
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:user.profileImageUrl]];
    [self.profileImageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        self.profileImageView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            self.profileImageView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.screenNameLabel.text = [NSString stringWithFormat:@"%@", user.name];
    self.createdAtLabel.text = [self.tweet.createdAt timeAgo];
    self.tweetLabel.text = self.tweet.text;
    [self.tweetLabel sizeToFit];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
    self.retweetCount.text = [NSString stringWithFormat:@"%@ retweets", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%@ favorites", self.tweet.favoriteCount];
    
    [self.replyButton setImage:[UIImage imageNamed:@"reply_hover"] forState:UIControlStateHighlighted];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_hover"] forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_hover"] forState:UIControlStateHighlighted];

    
    self.retweeted = self.tweet.retweeted;
    self.favorited = self.tweet.favorited;
    
    if (self.tweet.retweeted == [NSNumber numberWithBool:(BOOL)1]) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    if (self.tweet.favorited == [NSNumber numberWithBool:(BOOL)1]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onReply{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
