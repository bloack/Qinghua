//
//  ClassViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//


/*
 
 *我的通讯录，班级，文化专业委员会页面类似
 */
#import "ClassViewController.h"
#import "UserDetailViewController.h"
#import "LCClassTableViewCell.h"
#import "LCClassFriendsViewController.h"
#import "ChatViewController.h"
@interface ClassViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation ClassViewController

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
    self.titleString = @"班级";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getClassFriendsList];
}

- (void)getClassFriendsList
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak ClassViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Class_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        NSLog(@"%@", dictionary);
        vc.array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"class_list"]];
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCClassTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageTBViewCellID];
    }

    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 40)];
    lable.font = [UIFont systemFontOfSize:13.0];
    [cell addSubview:lable];
    lable.text = [NSString stringWithFormat:@"%@ %@级", [self.array[indexPath.row]objectForKey:@"class_name"], [self.array[indexPath.row] objectForKey:@"year"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：用户详情
     */
    LCClassFriendsViewController * friendsVC = [[LCClassFriendsViewController alloc] init];
    friendsVC.titleStr = [NSString stringWithFormat:@"%@ %@级", [self.array[indexPath.row]objectForKey:@"class_name"], [self.array[indexPath.row] objectForKey:@"year"]];
    friendsVC.type = @"Class";
    friendsVC.class_id = [self.array[indexPath.row]objectForKey:@"class_id"];
    
    [self.navigationController pushViewController:friendsVC  animated:YES];
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
