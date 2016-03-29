//
//  LCAddFriends.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-1.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCAddFriends.h"

@implementation LCAddFriends
+ (instancetype)shareAddFriend
{
    static  LCAddFriends *addFriend = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addFriend = [[LCAddFriends alloc] init];
    });
    return addFriend;

}
- (void)addFriendWith:(NSString *)userName vc:(UIViewController *)vc
{
    NSArray * resultArray =  [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:[MyUserDefult objectForKey:@"userName"]];
    for (int i = 0; i < resultArray.count; i++) {
        NSString * str = resultArray[i];
        if ([str isEqualToString:userName]) {
            
            
            
            XMPPJID *jid = [XMPPJID jidWithString:[self bindDomain:userName]];
            [[XmppService shareXmppService] acceptBuddy:jid];
            [[OperationalDatabase sharedDataBase] updateFriendApplyStatusWithUnionId:[NSString stringWithFormat:@"%@_%@",userName,[[XmppService shareXmppService] userJid]]];
            [[SystemManager shareSystemManager]showHUDInView:vc.view messge:@"已同意" forError:YES];
            return;
        }
    }
    
    
    
    
    [[XmppService shareXmppService] addUser:userName];
    [[SystemManager shareSystemManager]showHUDInView:vc.view messge:@"好友请求已发送" forError:YES];

}
- (NSString *)bindDomain:(NSString *)jid
{
    NSString *str = [NSString stringWithFormat:@"%@@%@",jid,XMPP_SERVER_URL];
    return str;
}

@end
