//
//  LCAddFriends.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-1.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "LCMyFileViewController.h"
#import "NSString+MD5.h"
@interface LCAddFriends : NSObject
+ (instancetype)shareAddFriend;
- (void)addFriendWith:(NSString *)userName vc:(UIViewController *)vc;
@end
