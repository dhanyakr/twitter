//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Dhanya R on 9/25/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
-(void)onCancel;
-(void)onTweet;
@property (weak, nonatomic) IBOutlet UITextField *tweetText;
@end

@implementation ComposeTweetViewController
- (IBAction)onEditingChanged:(UITextField *)sender {
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    
    UIBarButtonItem *rightBarLabelItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%lu", (140 - sender.text.length)] style:UIBarButtonItemStylePlain target:self action:nil];
    rightBarLabelItem.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarButtonItem, rightBarLabelItem, nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    UIBarButtonItem *rightBarLabelItem = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:nil];
    rightBarLabelItem.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarButtonItem, rightBarLabelItem, nil];

    User *currentUser = [User currentUser];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    [self.profileImageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        self.profileImageView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            self.profileImageView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    self.usernameLabel.text = currentUser.screenName;

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tweetText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onCancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onTweet{
    [[TwitterClient sharedInstance] tweetWithString:self.tweetText.text];
    [self.navigationController popViewControllerAnimated:YES];
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
