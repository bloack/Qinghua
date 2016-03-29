//
//  ActivtyAlertViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ActivtyAlertViewController.h"
#import "LCSystmeTableViewCell.h"
#import "LCAlertDetailViewController.h"
#import "LCActivityDetailViewController.h"
@interface ActivtyAlertViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation ActivtyAlertViewController

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
    self.titleString = @"活动提醒";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.array = [MyUserDefult objectForKey:@"activeArray"];
    [self.tableView reloadData];
    if (self.array.count == 0) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"没有数据" forError: YES];
    }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCSystmeTableViewCell";
    LCSystmeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
 //   cell.time.text  = ;
    cell.titleLable.text = [dic[@"aps"] objectForKey:@"alert"];
    cell.content.text = [NSString stringWithFormat:@"%@活动开始", [dic objectForKey:@"start_time"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LCAlertDetailViewController * vc = [[LCAlertDetailViewController alloc] init];
    LCActivityDetailViewController * vc = [[LCActivityDetailViewController alloc] init];
    vc.isMian = YES;
    vc.active_id = [self.array[indexPath.row] objectForKey:@"activity_id"];
    vc.group_id = [self.array[indexPath.row] objectForKey:@"group_id"];
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
