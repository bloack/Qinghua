
//
//  LCFirstViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-14.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCFirstViewController.h"
#import "RootViewController.h"
#import "ContactsViewController.h"
#import "DiscoveryViewController.h"
#import "BusinessViewController.h"
#import "AboutMyselfViewController.h"
#import "VoiceConverter.h"
@interface LCFirstViewController ()<NetWorkDelegate, UITabBarControllerDelegate>
{
    BOOL isPlaying;
}
@end

@implementation LCFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];    
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:[[ContactsViewController alloc] init]];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:[[DiscoveryViewController alloc] init]];
    UINavigationController * nav4 = [[UINavigationController alloc] initWithRootViewController:[[BusinessViewController alloc] init]];
    UINavigationController * nav5 = [[UINavigationController alloc] initWithRootViewController:[[AboutMyselfViewController alloc] init]];

    
    self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
    
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"barImage"]];
  //  self.tabBar.delegate = self;
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"lcsj_tabhost_true.png"]];
    [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    self.tabBar.tintColor = [UIColor whiteColor];
//    [self loadDataProfession];
    
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - redPush
//文本消息
- (void)didReadMessage:(NSString *)message fromPerson:(NSString *)jid andTime:(NSString *)time
{
    //
    SoundPlaySound *sound = [[SoundPlaySound alloc]initForPlayingVibrate];
    [sound play];
    
    
    /*
    isPlaying = YES;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorTime) userInfo:nil repeats:YES];
    
    if([MyUserDefult boolForKey:@"setSound"])
    {
        while (!isPlaying) {
            AudioServicesPlaySystemSound(1007);
            isPlaying = YES;
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorTime) userInfo:nil repeats:YES];
        }
    }
     */
    //设置bedgenumber
//    [self setBedgeNumberInbutton:_firstBtn andNumber:1];
    __weak LCFirstViewController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
                   {
                       NSLog(@"%@",jid);
                       ChatEntity *entity = [[ChatEntity alloc] init];
                       //                       NSArray *arr = [[self.unionNickName componentsSeparatedByString:@","] retain];
                       entity.unionId = [NSString stringWithFormat:@"%@_%@",[[XmppService shareXmppService] userJid],jid];
                       entity.fromId = jid;
                       entity.toId = [[XmppService shareXmppService] userJid];
                       entity.timeSince1970 = time;
                       //文本0 音频1 图片2
                       entity.contentType = @"0";
                       entity.message = message;
                       //没读0 读了1
                       entity.isRead = @"0";
                       //人对人0 人对群1
                       entity.sourceType = @"0";
                       //                       NSString *temp_nickName = [[[OperationalDatabase sharedDataBase] getNickName:jid] retain];
                       NSString *temp_nickName = [self getNick:jid];
                       if(!temp_nickName)
                       {
//                           return;
                       }
                       NSMutableArray *_arr = [[NSMutableArray alloc] initWithArray:[temp_nickName componentsSeparatedByString:@","]];
                       if([_arr count] != 4 && _arr.count > 1)
                       {
                           [_arr removeLastObject];
                           NSMutableString *mulStr = [[NSMutableString alloc] init];
                           for (int i = 0; i < [_arr count]; i ++) {
                               [mulStr appendString:_arr[i]];
                               [mulStr appendString:@","];
                           }
                           NSString *result_str = [mulStr substringToIndex:mulStr.length - 1];
                           entity.nickName = result_str;
                       }
                       else
                       {
                           entity.nickName = temp_nickName;
                       }
                       [[OperationalDatabase sharedDataBase] insertChatModel:entity];
                       NSString *entityUnionId = entity.unionId;
                       
                       AudioServicesPlaySystemSound(1007);
                       [vc notifWithChatEntity:entity];
//                       [self performSelector:@selector(updateBedgeNum:withType:) withObject:entityUnionId withObject:[NSString stringWithFormat:@"%@[#]%@",entityUnionId,@"0"]];
                       
                   });
}

//声音
- (void)didReadVoiceUrl:(NSString *)urlStr fromPerson:(NSString *)jid andTime:(NSString *)time andSustainTime:(int)timeCount
{
    //
    if([MyUserDefult boolForKey:@"setSound"])
    {
        while (!isPlaying) {
            AudioServicesPlaySystemSound(1007);
            isPlaying = YES;
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorTime) userInfo:nil repeats:YES];
        }
    }
    //设置bedgenumber
//    [self setBedgeNumberInbutton:_firstBtn andNumber:1];
    __weak LCFirstViewController *vc = self;
    bool b = [urlStr rangeOfString:@"_and_"].location == NSNotFound;
    [[RequestCenter shareRequestCenter] downloadXmppFile:b?urlStr:[[urlStr componentsSeparatedByString:@"_and_"] objectAtIndex:1] setOpt:@"/chatfile/download" setSuccessBlock:^(id filePath)
     {
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                        {
                            ChatEntity *entity = [[ChatEntity alloc] init];
                            //                       NSArray *arr = [[self.unionNickName componentsSeparatedByString:@","] retain];
                            entity.unionId = [NSString stringWithFormat:@"%@_%@",[[XmppService shareXmppService] userJid],jid];
                            entity.fromId = jid;
                            entity.toId = [[XmppService shareXmppService] userJid];
                            //时间
                            entity.timeSince1970 = time;
                            //文本0 音频1 图片2
                            entity.contentType = @"1";
                            [VoiceConverter amrToWav:filePath wavSavePath:[filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"]];
                            entity.message = [NSString stringWithFormat:@"%@_and_%@",[[urlStr componentsSeparatedByString:@"_and_"] objectAtIndex:0],[filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"]];
                            //没读0 读了1
                            entity.isRead = @"0";
                            //人对人0 人对群1
                            entity.sourceType = @"0";
                            
                            NSString *unionName = [vc getNick:jid];
                            if(!unionName)
                            {
                                return;
                            }
                            NSMutableArray *_arr = [[NSMutableArray alloc] initWithArray:[unionName componentsSeparatedByString:@","]];
                            if([_arr count] != 4)
                            {
                                [_arr removeLastObject];
                                NSMutableString *mulStr = [[NSMutableString alloc] init];
                                for (int i = 0; i < [_arr count]; i ++) {
                                    [mulStr appendString:_arr[i]];
                                    [mulStr appendString:@","];
                                }
                                NSString *result_str = [mulStr substringToIndex:mulStr.length - 1];
                                entity.nickName = result_str;
                            }
                            else
                            {
                                entity.nickName = unionName;
                            }
                            [[OperationalDatabase sharedDataBase] insertChatModel:entity];
                            NSString *entityUnionId = entity.unionId;
                            [self notifWithChatEntity:entity];
//                            [self performSelector:@selector(updateBedgeNum:withType:) withObject:entityUnionId withObject:[NSString stringWithFormat:@"%@[#]%@",entityUnionId,@"0"]];
                            
                            
                        });
     }
                                            setFailBlock:^(id error)
     {
         
     }
     ];
}
//图片
- (void)didReadPictureUrl:(NSString *)urlStr fromPerson:(NSString *)jid andTime:(NSString *)time
{
    //
    if([MyUserDefult boolForKey:@"setSound"])
    {
        while (!isPlaying) {
            AudioServicesPlaySystemSound(1007);
            isPlaying = YES;
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorTime) userInfo:nil repeats:YES];
        }
    }
    //设置bedgenumber
//    [self setBedgeNumberInbutton:_firstBtn andNumber:1];
    __weak LCFirstViewController *vc = self;

    [[RequestCenter shareRequestCenter] downloadXmppFile:urlStr setOpt:@"2" setSuccessBlock:^(id filePath)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                        {
                            ChatEntity *entity = [[ChatEntity alloc] init];
                            
                            entity.unionId = [NSString stringWithFormat:@"%@_%@",[[XmppService shareXmppService] userJid],jid];
                            entity.fromId = jid;
                            entity.toId = [[XmppService shareXmppService] userJid];
                            //时间
                            entity.timeSince1970 = time;
                            //文本0 音频1 图片2
                            entity.contentType = @"2";
                            [VoiceConverter amrToWav:filePath wavSavePath:[filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"]];
                            entity.message = [filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
                            //没读0 读了1
                            entity.isRead = @"0";
                            //人对人0 人对群1
                            entity.sourceType = @"0";
                            
                            NSString *unionName = [self getNick:jid];
                            if(!unionName)
                            {
                                return;
                            }
                            NSMutableArray *_arr = [[NSMutableArray alloc] initWithArray:[unionName componentsSeparatedByString:@","]];
                            if([_arr count] != 4)
                            {
                                [_arr removeLastObject];
                                NSMutableString *mulStr = [[NSMutableString alloc] init];
                                for (int i = 0; i < [_arr count]; i ++) {
                                    [mulStr appendString:_arr[i]];
                                    [mulStr appendString:@","];
                                }
                                NSString *result_str = [mulStr substringToIndex:mulStr.length - 1];
                                entity.nickName = result_str;
                            }
                            else
                            {
                                entity.nickName = unionName;
                            }
                            [[OperationalDatabase sharedDataBase] insertChatModel:entity];
                            NSString *entityUnionId = entity.unionId;
                            [vc notifWithChatEntity:entity];
//                            [self performSelector:@selector(updateBedgeNum:withType:) withObject:entityUnionId withObject:[NSString stringWithFormat:@"%@[#]%@",entityUnionId,@"0"]];
                            
                            
                        });
     }
                                            setFailBlock:^(id error)
     {}];
}


/**
 *  发送通知  通知传递信息  entity对象  更改提示角标值  并且更新最后一条聊天数据
 *
 *  @param entity 模型类
 */
-(void)notifWithChatEntity:(ChatEntity *)entity
{
    [[NSNotificationCenter defaultCenter]postNotificationName:_READ_MESSAGE object:entity];
}



//设置在指定按钮上面画红色的数字
- (void)setBedgeNumberInbutton:(UIImageView *)btn andNumber:(int)count WithNumID:(NSString *)numID
{
    //self.messageCount += count;

    //[[DrawHelper shareDrawHelper] draw:[NSString stringWithFormat:@"%d",self.messageCount] withView:btn withCGRect:CGRectMake(38, 0, 17, 17)];
}

//读消息之后更新bedgenumber
- (void)removeBedgeNumberInButton:(UIImageView *)btn andNumber:(int)count WithNumID:(NSString *)numID
{
    //self.messageCount -= count;
    //self.messageCount = self.messageCount < 0? 0:self.messageCount;
    //[[DrawHelper shareDrawHelper] draw:[NSString stringWithFormat:@"%d",self.messageCount] withView:btn withCGRect:CGRectMake(38, 0, 17, 17)];
}
- (void)monitorTime
{
    isPlaying = NO;
}

#pragma mark - unbindDomain  获取IM号码
- (NSString *)unbindDomain:(NSString *)group
{
    return [[group componentsSeparatedByString:@"@"] objectAtIndex:0];
}

#pragma mark - personal
- (NSString *)getNick:(NSString *)jid
{
    userArr = [[OperationalDatabase sharedDataBase] getUserInfoA];
    blackStr = [[OperationalDatabase sharedDataBase] getBlackUser];
    for (int i = 0; i < [userArr count]; i ++) {
        NSString *str = [userArr objectAtIndex:i];
        if([[[str componentsSeparatedByString:@"[#]"] objectAtIndex:1] isEqualToString:jid])
        {
            return [[str componentsSeparatedByString:@"[#]"] objectAtIndex:0];
        }
    }
    
    return @"";
    sleep(1);
    return [self getNick:jid];
}


#pragma mark - group
- (NSString *)getUserNameFromGroup:(NSString *)groupName andJid:(NSString *)strJid
{
    groupUser = [[OperationalDatabase sharedDataBase] getGroupUserInfo];
    for (int i = 0; i < [groupUser count]; i ++) {
        NSString *_temp = [groupUser objectAtIndex:i];
        NSString *_jid = [[_temp componentsSeparatedByString:@"[#]"] objectAtIndex:0];
        NSString *_groupName = [[_temp componentsSeparatedByString:@"[#]"] objectAtIndex:1];
        if([groupName isEqualToString:_groupName]
           && [strJid isEqualToString:_jid])
        {
            return [[_temp componentsSeparatedByString:@"[#]"] objectAtIndex:2];
        }
    }
    sleep(1);
    return [self getUserNameFromGroup:groupName andJid:strJid];
}

#pragma mark - 接受好友请求
//接收到XX好友请求
- (void)didReceiveFriendRequest:(XMPPPresence *)presence
{
    if([[self unbindDomain:[presence fromStr]] isEqualToString:[[XmppService shareXmppService] userJid]])
        return;
    
    NSString * toID = [self unbindDomain:[[XmppService shareXmppService] userJid]];
    
    NSArray * noPassArray = [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:toID];
    
    NSString * fromID = [[presence fromStr] componentsSeparatedByString:@"@"][0];
    
    for (NSString * str in noPassArray) {
        if ([str isEqualToString:fromID]) {
            return;
        }
    }
    
    
    //插入到数据库
    [[OperationalDatabase sharedDataBase] insertFriendApply:[self unbindDomain:[presence fromStr]] andTo:[self unbindDomain:[presence toStr]] andUnionId:[NSString stringWithFormat:@"%@_%@",[self unbindDomain:[presence fromStr]],[self unbindDomain:[presence toStr]]] andStatus:@"0"];
    if([[self unbindDomain:[presence toStr]] isEqualToString:[[XmppService shareXmppService] userJid]])
    {
        
        //查询
        NSArray *friendArr = [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:[self unbindDomain:[[XmppService shareXmppService] userJid]]];
         
        
        //
        //        [DrawHelper draw:[NSString stringWithFormat:@"%d",[friendArr count]] withView:_thirdBtn withCGRect:CGRectMake(44, 0, 17, 17)];
//        NSLog(@"______%@",[MyUserDefult objectForKey:@"UserId"]);
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newFriendApply" object:[NSString stringWithFormat:@"%d",[friendArr count]==0?1:[friendArr count]]];
    }
}

#pragma mark - 已经通过验证
//XX已经通过验证
- (void)hasBeenAcceptFriend:(XMPPPresence *)presence
{
    if([[self unbindDomain:[presence toStr]] isEqualToString:[[XmppService shareXmppService] userJid]])
    {
        XMPPJID *jid = [XMPPJID jidWithString:[presence fromStr]];
        [[XmppService shareXmppService] acceptBuddy:jid];
        
        
        
        [[OperationalDatabase sharedDataBase] updateFriendApplyStatusWithUnionId:[NSString stringWithFormat:@"%@_%@",[presence to].user,[presence from].user]];
        
        NSLog(@"%@,%@",presence,[presence from]);
        
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:[NSString stringWithFormat:@"%@已通过您的好友申请",[presence from].user] forError:YES];
        
        
        
        /*
        NSDictionary *dict_request = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString stringWithFormat:@"%@",[presence fromStr]] substringToIndex:11],@"phone",@"4",@"headtype",@"1",@"type",nil];
        [[RequestCenter shareRequestCenter] sendRequest:dict_request
                                                 setOpt:@"/friend/get_friend_info"
                                        setSuccessBlock:^(id dict)
         {
             NSString *user_name = [[dict objectForKey:@"data"] objectForKey:@"user_name"];
             [RequestCenter showAlertMessage:[NSString stringWithFormat:@"%@已通过您的好友申请",user_name ]];
             
         }
                                           setFailBlock:^(id error)
         {
         }
         ];
        
        */
    }
}

@end
