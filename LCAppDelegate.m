//
//  LCAppDelegate.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
/**
 *  http://120.131.65.210/dokuwiki/doku.php?id=wiki:api:president_club
 */
#import "SystemManager.h"
#import "LCAppDelegate.h"
#import "LCFirstViewController.h"
#import <JSONKit/JSONKit.h>
#import "LCFirstLoadViewController.h"
#import "LCGroupData.h"
#import "LogInViewController.h"
#import "DistrictDao.h"
#import "InterestDao.h"
#import "IndustryDao.h"
#import "OccupationDao.h"
#import "APService.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@implementation LCAppDelegate
@synthesize friendsArray = _friendsArray;


+(LCAppDelegate *)shared{

    return [UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    GetFriend = NO;
    MessageStore = [[NSMutableArray alloc]init];
    addFriendRequstArray = [[NSMutableArray alloc]init];
    
    [ShareSDK registerApp:@"2e889c729f70"];
    
    [ShareSDK connectSinaWeiboWithAppKey:@"2046521072" appSecret:@"b91dcb6b1b35e4905ffdf971cb6026ef" redirectUri:@"http://www.qinghuaceo.com"];
    
    [ShareSDK connectWeChatWithAppId:@"wx24e34a18a6cbe403" wechatCls:[WXApi class]];
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    /**
     *  极光
     */
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    

    /**
     *分享相关
     */
 
    [MyUserDefult setBool:YES forKey:@"setSound"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
     [self.window makeKeyAndVisible];
    
    /**
     *  拷贝数据库文件
     */
    [SystemManager copyDataBaseFile];
    
    
    [[OperationalDatabase sharedDataBase] openDatabase];
    
    bHasLogin = YES;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"faceImage" ofType:@"plist"];
    //NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    FaceData = [[NSMutableDictionary  alloc] initWithContentsOfFile:plistPath];
    
    
    [self firstLoad];
    // 目前这个是写死的, 如果在登录页面获取userid的话, 请把这段Code 删除... 之所以要使用UserID, 因为朋友圈用到..
     if ([MyUserDefult objectForKey:@"userName"])
         {
             [self getMyFriendsWithId:[MyUserDefult objectForKey:@"userName"]];
         }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}




- (void)getMyFriendsWithId:(NSString *)ID
{
        [[XmppService shareXmppService] setupXmpp];
  __weak  LCAppDelegate *dele = self;
        [XmppService shareXmppService].xmppDelegate = [SystemManager shareSystemManager].rootController;
        [[XmppService shareXmppService] login:ID PassWord:@"123456" setSuccessBlock:^(void){
            
            
            [[XmppService shareXmppService] getBuddysetBlock:^(id dict){
                
                
                
                dele.friendsArray = [NSMutableArray arrayWithArray:[dict objectAtIndex:0]];
            }];
        } setFailBlock:^(id dict){
            
        }];
    
    
}
#pragma mark NetWorkDelegate

/**
 *  判断首次登陆
 *  判断记录密码
 */
- (void)firstLoad
{
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *lastVersionCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[key];
    NSLog(@"%@", currentVersionCode);
    if ([lastVersionCode isEqualToString:currentVersionCode]) {
        /**
         *  不是第一次登陆
         */
        if ([MyUserDefult objectForKey:@"userName"]) {
            LCFirstViewController * controller = [[LCFirstViewController alloc] init];
            [SystemManager shareSystemManager].rootController = controller;
            self.window.rootViewController = controller;
        }
        else if(![MyUserDefult objectForKey:@"userName"]){
            self.window.rootViewController = [[LogInViewController alloc] init];
        }
        self.dict_City = [[MyUserDefult objectForKey:@"cityList"] objectForKey:@"data"];
        
        
        
        
        self.dict_Favorite = [[MyUserDefult objectForKey:@"favouriteList"] objectForKey:@"data"];
        
        
        
        self.dict_Industry = [[MyUserDefult objectForKey:@"industryList"] objectForKey:@"data"];
        
        
        self.dict_Profession =  [[MyUserDefult objectForKey:@"professionList"] objectForKey:@"data"];
        
        
    } else {
        /**
         *  第一次登陆
         */
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionCode forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIViewController * controller = [[LCFirstLoadViewController alloc] init];
        self.window.rootViewController = controller;
        
    }
}




//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    /*
//    if ([TencentOAuth CanHandleOpenURL:url]) {
//        return [TencentOAuth HandleOpenURL:url];
//    }else if ([WeiboSDK handleOpenURL:url delegate:self])
//    {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }
//    else if ([url.scheme isEqualToString:@"AlixPayDemo"])
//    {
//        [self parseURL:url application:application];
//    }
//     */
////    return [UMSocialSnsService handleOpenURL:url];
//}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
////    return  [UMSocialSnsService handleOpenURL:url];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [[XmppService shareXmppService].xmppStream disconnect];
    [[XmppService shareXmppService] goOffline];
//    [XmppService shareXmppService].xmppDelegate = nil;
//    [[XmppService shareXmppService] removeAllDelegate];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    if ([MyUserDefult objectForKey:@"userName"] && bHasLogin)
    {
        [self getMyFriendsWithId:[MyUserDefult objectForKey:@"userName"]];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    NSLog(@"%@", userInfo);
    
}
#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);

    [[NSNotificationCenter defaultCenter] postNotificationName:kAPNetworkDidReceiveMessageNotification object:nil userInfo:userInfo];
    NSLog(@"---*** %@", userInfo);
}
#endif



/**
 *  极光的一些通知
 */
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSLog(@"userinfo == %@", userInfo);
    NSLog(@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]],title,content);
}

@end
