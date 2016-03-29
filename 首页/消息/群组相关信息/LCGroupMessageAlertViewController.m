//
//  LCGroupMessageViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCGroupMessageAlertViewController.h"
#import "LCGroupSureTableViewCell.h"
@interface LCGroupMessageAlertViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain)NSArray * array;
@end

@implementation LCGroupMessageAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"群组相关信息";
    self.array = [MyUserDefult objectForKey:@"groupArray"];
    if (self.array.count == 0) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"没有数据" forError: YES];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCGroupSureTableViewCell";
    LCGroupSureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = self.array[indexPath.row];
    if ([dic[@"type"] intValue] == 10) {
        [cell.makeSure addTarget:self action:@selector(agreeJoinGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.disAgree addTarget:self action:@selector(disAgreeJoin:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([dic[@"type"] intValue] == 11){
        [cell.makeSure addTarget:self action:@selector(agreeOtherJoin:) forControlEvents:UIControlEventTouchUpInside];
        [cell.disAgree addTarget:self action:@selector(disAgreeOther:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([dic[@"type"] intValue] == 12)
    {
        cell.makeSure.hidden = YES;
        cell.disAgree.hidden = YES;
    }
    cell.content.text = [dic[@"aps"] objectForKey:@"alert"];
    return cell;
}
- (void)agreeJoinGroup:(UIButton *)button
{
    UITableViewCell * cell = [[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * ver_id = [[self.array[path.row] objectForKey:@"data"] objectForKey:@"id"];
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"verify_id":ver_id, @"type":@"2", @"status":@"1"};
    __weak LCGroupMessageAlertViewController*vc = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] netWorkWithURL:Group_Agree dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
             [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"已同意群组邀请" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:dictionary[@"message"] forError: YES];        }
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

           [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
}
- (void)agreeOtherJoin:(UIButton *)button
{
    UITableViewCell * cell = [[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * ver_id = [[self.array[path.row] objectForKey:@"data"] objectForKey:@"id"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCGroupMessageAlertViewController*vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Group_Agree dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"verify_id":ver_id, @"type":@"1", @"status":@"1"} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
             [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"已同意用户申请" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:dictionary[@"message"] forError: YES];
        }
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
    
    
   
}
- (void)disAgreeJoin:(UIButton *)button
{
    UITableViewCell * cell = [[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * ver_id = [[self.array[path.row] objectForKey:@"data"] objectForKey:@"id"];
    
    __weak LCGroupMessageAlertViewController*vc = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] netWorkWithURL:Group_Agree dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"verify_id":ver_id, @"type":@"2", @"status":@"-1"} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
           [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"拒绝加入群组" forError: YES];
            
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
    


}
- (void)disAgreeOther:(UIButton *)button
{
    UITableViewCell * cell = [[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * ver_id = [[self.array[path.row] objectForKey:@"data"] objectForKey:@"id"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCGroupMessageAlertViewController*vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Group_Agree dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"verify_id":ver_id, @"type":@"1", @"status":@"-1"} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"拒绝用户申请" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
    

    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
