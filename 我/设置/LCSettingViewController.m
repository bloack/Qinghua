//
//  LCSettingViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCSettingViewController.h"
#import "LCMyFileViewController.h"
#import "LCModificationKeyViewController.h"
#import "LCSecurityViewController.h"
#import "LogInViewController.h"
@interface LCSettingViewController ()

@end

@implementation LCSettingViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"设置";
    NSLog(@"设置");
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)myFiles:(id)sender {
    
  LCMyFileViewController * vc = [[LCMyFileViewController alloc] init] ;
    vc.user_id = [MyUserDefult objectForKey:@"UserId"];
    vc.isMe = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)mySecurate:(id)sender {
    [self.navigationController pushViewController:[[LCSecurityViewController alloc] init] animated:YES];
}
- (IBAction)key:(id)sender {
    [self.navigationController pushViewController:[[LCModificationKeyViewController alloc] init] animated:YES];
}
- (void)currentVerson
{

}
- (IBAction)checkVerson:(id)sender {
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[key];
    NSLog(@"%@", currentVersionCode);
    [[NetWork shareNetWork] netWorkWithURL:Version_Check dic:@{@"version": @"1.0.0"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    } setFailBlock:^(id obj) {
        NSLog(@"%@", obj);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  退出登陆
 *
 *  @param sender openFier上线
 */
- (IBAction)signOut:(id)sender {
   
    //openfier下线
    GetFriend = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NetWork shareNetWork] networkCancle];
//    [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:[LCAppDelegate shared]];
    [[XmppService shareXmppService].xmppStream disconnect];
    [[XmppService shareXmppService] goOffline];
    [XmppService shareXmppService].xmppDelegate = nil;
    [[XmppService shareXmppService] removeAllDelegate];
    [MyUserDefult  setObject:nil forKey:@"messageArray"];
    [MyUserDefult setObject:nil forKey:@"commentArray"];
    [MyUserDefult  setObject:nil forKey:@"activeArray"];
    [MyUserDefult  setObject:nil forKey:@"likeArray"];
    [MyUserDefult setObject:nil forKey:@"introduceArray"];
    [MyUserDefult setObject:nil forKey:@"groupArray"];
    [MyUserDefult  setObject:nil forKey:@"messageCount"];
    [MyUserDefult setObject:nil forKey:@"commentCount"];
    [MyUserDefult  setObject:nil forKey:@"activeCount"];
    [MyUserDefult  setObject:nil forKey:@"likeCount"];
    [MyUserDefult setObject:nil forKey:@"introduceCount"];
    [MyUserDefult setObject:nil forKey:@"groupCount"];
    
    [self presentViewController:[[LogInViewController alloc] init] animated:YES completion:^{
        [MyUserDefult setObject:nil forKey:@"userName"];
        [MyUserDefult setObject:nil forKey:@"UserId"];
        
    }];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)dealloc
{
    
}
@end
