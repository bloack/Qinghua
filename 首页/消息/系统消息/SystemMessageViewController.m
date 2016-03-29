//
//  SystemMessageViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "LCSystmeTableViewCell.h"
#import "LCAlertDetailViewController.h"


@interface SystemMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SystemMessageViewController

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
    self.titleString = @"系统消息";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessageList];
}
- (void)getMessageList
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"]};
    __weak SystemMessageViewController *vc = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] getDataWithURLStr:SystemAlert_url aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.array = [[dictionary objectForKey:@"data"] objectForKey:@"list"];
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
    
}
#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCSystmeTableViewCell";
    LCSystmeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.time.text = dic[@"create_time"];
    cell.titleLable.text = dic[@"title"];
    cell.content.text = dic[@"content"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCAlertDetailViewController * vc = [[LCAlertDetailViewController alloc] init];
    vc.sys_id = [self.array[indexPath.row] objectForKey:@"system_message_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
