//
//  TweetTableViewCell.h
//  twitter
//
//  Created by Dhanya R on 9/24/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;

- (void)setTweet:(Tweet *)tweet;

@end
