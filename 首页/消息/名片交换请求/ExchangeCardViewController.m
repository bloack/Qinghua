//
//  ExchangeCardViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ExchangeCardViewController.h"
#import "UserDetailViewController.h"
#import "LCCardTableViewCell.h"
#import "NetWork.h"
#import "AddFriend.h"
@interface ExchangeCardViewController ()

@end

@implementation ExchangeCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"名片交换请求";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"名片交换请求";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFriend) name:@"newFriendApply" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newFriendApply" object:nil];
}

/**
 *  添加好友通知
 */
-(void)AddFriend
{
    [self reloadData];
}

/**
 *  刷新数据源
 */
-(void)reloadData
{
    NSArray * resultArray = [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:[MyUserDefult objectForKey:@"userName"]];
    if (resultArray.count == 0) {
        return;
    }
    
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"正在获取..." forError:NO];
    NSString * visit_usernames = [resultArray componentsJoinedByString:@","];
    

    NSDictionary * requstDic = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],visit_usernames] forKeys:@[@"user_id",@"visit_usernames"]];
    __weak ExchangeCardViewController *vc = self;
    [[NetWork shareNetWork]netWorkWithURL:@"/api/user/user/getBaseInfo" dic:requstDic setSuccessBlock:^(id dictionary) {
        
        
        if ([dictionary[@"status"] intValue] == 200) {
            
            [vc.dataArray removeAllObjects];
            [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
            
            NSArray * userInfoArray = dictionary[@"data"][@"user_base_info"];
            for (int i = 0; i < userInfoArray.count; i++) {
                AddFriend * friendModel = [[AddFriend alloc]initWithDic:userInfoArray[i]];
                friendModel.user_name = resultArray[i];
                [vc.dataArray addObject:friendModel];
            }
            
            
            
            
            
            [vc.tableView reloadData];
            
            
        }else
        {
            [[SystemManager shareSystemManager] HUDHidenWithMessage:dictionary[@"message"]];
        }
        
        
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] HUDHidenWithMessage:@"网络有问题"];
    }];
    
}
/**
 *  同意添加好友
 *
 *  @param btn
 */
-(void)agreeButtonClick:(UIButton *)btn
{
    AddFriend * friendModel = self.dataArray[btn.tag];
    
    XMPPJID *jid = [XMPPJID jidWithString:[self bindDomain:friendModel.user_name]];
    [[XmppService shareXmppService] acceptBuddy:jid];
    [[OperationalDatabase sharedDataBase] updateFriendApplyStatusWithUnionId:[NSString stringWithFormat:@"%@_%@",friendModel.user_name,[[XmppService shareXmppService] userJid]]];
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"已同意" forError:YES];
    
    
//    [[XmppService shareXmppService] addUser:jid];
    
    [self.dataArray removeObject:friendModel];
    [self.tableView reloadData];
    
}

-(void)rejectButtonClick:(UIButton *)btn
{
    AddFriend * friendModel = self.dataArray[btn.tag];

    
    
    XMPPJID *jid = [XMPPJID jidWithString:[self bindDomain:friendModel.user_name]];
    [[XmppService shareXmppService]rejectBuddyFrom:jid];
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"已拒绝" forError:YES];
    [[OperationalDatabase sharedDataBase] deleteFriendApplyWithFrom:friendModel.user_name andTo:[MyUserDefult objectForKey:@"userName"]];
    
    [self.dataArray removeObject:friendModel];
    [self.tableView reloadData];
}

                    
- (NSString *)bindDomain:(NSString *)jid
{
    NSString *str = [NSString stringWithFormat:@"%@@%@",jid,XMPP_SERVER_URL];
    return str;
}
                    
- (void)getMessageList
{
    /*
     
     *获取名片交换列表
     */
    
    NetWork * net = [NetWork shareNetWork];
    net.delegate = self;
    /*
     
     *URL按需求更换
     */
    [net netWorkWithType:@"GET" url:URL_BASE body:nil];
}
- (void)agreeExchange:(UIButton *)button
{
     /*
 
       *统一按钮的方法
     */

}
#pragma mark NetWorkDelegate
- (void)recieveDataSuccessWithObject:(id)object
{
    /*
     
     *发布成功
     *
     
     
     *发布失败
     *
     */
}
- (void)recieveDataFailure
{
    /*
     
     *网络请求失败
     */
}
#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCCardTableViewCell";
    LCCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.rejectButton addTarget:self action:@selector(rejectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /*
         
         *按UI更换
         *不行就贴图！
         */
    }
    
    cell.agreeButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
    AddFriend * friendModel = self.dataArray[indexPath.row];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:friendModel.avatar] placeholderImage:DefaultImage];
    cell.nameLabel.text = friendModel.real_name;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *按照标识符跳转
     *下级页面：用户详情
     */
    AddFriend * friendModel = self.dataArray[indexPath.row];
    UserDetailViewController * controller = [[UserDetailViewController alloc] init];
    controller.userid = friendModel.user_id;
    controller.isEXchange = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
