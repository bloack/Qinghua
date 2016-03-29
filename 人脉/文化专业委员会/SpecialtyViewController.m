//
//  SpecialtyViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "SpecialtyViewController.h"
#import "LCClassFriendsViewController.h"
#import "LCClassTableViewCell.h"
#import "LCDiscoveryTableViewCell.h"

@interface SpecialtyViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation SpecialtyViewController

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
    self.titleString = @"群组";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak SpecialtyViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Group_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        vc.array = [[dictionary objectForKey:@"data"] objectForKey:@"group_list"];
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
    static NSString * cellId = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle   mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDictionary * dic = self.array[indexPath.row];
    cell.nameLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"group_name"]];
    [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"qinghua-qunzu.png"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：用户详情
     */
    LCClassFriendsViewController * friendsVC = [[LCClassFriendsViewController alloc] init];
    friendsVC.titleStr = [NSString stringWithFormat:@"%@", [self.array[indexPath.row]objectForKey:@"group_name"]];
    friendsVC.type = @"Group";
    friendsVC.class_id = [NSString stringWithFormat:@"%d", [self.array[indexPath.row]objectForKey:@"class_id"]];
    [self.navigationController pushViewController:friendsVC  animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
