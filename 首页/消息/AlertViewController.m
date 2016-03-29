//
//  AlertViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "AlertViewController.h"
#import "LCAlertTableViewCell.h"
#import "LCAlertDetailViewController.h"
@interface AlertViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation AlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"通知";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"通知";
    self.tbaleView.dataSource = self;
    self.tbaleView.delegate = self;
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}
- (void)getdata
{
    __weak AlertViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:SystemAlert_url  dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        vc.array = [[dictionary objectForKey:@"data"] objectForKey:@"list"];
        [vc.tbaleView reloadData];
    }];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"LCAlertTableViewCell";
    LCAlertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == Nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    
    NSDictionary * dicc = self.array[indexPath.row];
    cell.time.text = dicc[@"create_time"];
    cell.titleLable.text = dicc[@"title"];
    cell.content.text = dicc[@"content"];
    cell.myNewL.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *次级菜单或者跳转页面？待定
     */
    LCAlertDetailViewController * vc = [[LCAlertDetailViewController alloc] init];
    vc.sys_id = [self.array[indexPath.row] objectForKey:@"system_message_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
