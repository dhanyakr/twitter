//
//  User.h
//  twitter
//
//  Created by Dhanya R on 9/23/15.
//  Copyright © 2015 Dhanya R. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
- (id)initWithDictionary: (NSDictionary *) dictionary;

+(User *)currentUser;
+(void)setCurrentUser:(User *)user;
+ (void)logout;
@end
