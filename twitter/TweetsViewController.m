//
//  TweetsViewController.m
//  twitter
//
//  Created by Dhanya R on 9/24/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetDetailsViewController.h"
#import "ComposeTweetViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
- (void)onRefresh;
-(void)onLogout;
-(void)onCompose;
@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Home";
    
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.tweets = [[NSArray alloc] init];
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetTableViewCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110.0;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self onRefresh];
    
}

- (void)onRefresh {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        for (Tweet *tweet in tweets) {
            NSLog(@"tweet: %@, created At: %@", tweet.text, tweet.createdAt);
        }
       [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)onLogout:(id)sender {
    [User logout];
}
*/
-(void)onLogout{
    [User logout];
}

-(void)onCompose {
    ComposeTweetViewController *ctvc = [[ComposeTweetViewController alloc] init];
    [self.navigationController pushViewController:ctvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   //NSLog(@"tweet count: %lu", self.tweets.count);
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
    
    // NSLog(@"tweets: %@", self.tweets);
    
    [cell setTweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   Tweet *tweet = self.tweets[indexPath.row];
    
    TweetDetailsViewController *tdvc = [[TweetDetailsViewController alloc] init];
    tdvc.tweet = tweet;
    [self.navigationController pushViewController:tdvc animated:YES];
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
