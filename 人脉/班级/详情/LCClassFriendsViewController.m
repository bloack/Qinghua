//
//  LCClassFriendsViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-4.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCClassFriendsViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "UserDetailViewController.h"
#import "NSString+MD5.h"
#import "LCMyFileViewController.h"
@interface LCClassFriendsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain)NSArray * array;
@end

@implementation LCClassFriendsViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleString = self.titleStr;
    if ([self.type isEqualToString:@"Class"]) {
        [self classFriend];
    }
    else
    {
        [self groupFriends];
    }
}
- (void)classFriend
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCClassFriendsViewController *vc = self;

    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"class_id":self.class_id};
    [[NetWork shareNetWork] getDataWithURLStr:Class_Friend aImage:nil aBody:dic aSuccessBlock:^(id myDictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.array = [NSArray arrayWithArray:[[[myDictionary[@"data"] objectForKey:@"class_list"] firstObject] objectForKey:@"friend_list"]];
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
    }];
}
- (void)groupFriends
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCClassFriendsViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Group_friends dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"group_id":self.class_id} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.array = [NSArray arrayWithArray:[[[[dictionary objectForKey:@"data"] objectForKey:@"group_list"] firstObject] objectForKey:@"friend_list"]];
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"LCRenMaiTableViewCell";
    LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellid owner:nil options:nil] firstObject];
    }
        NSDictionary * dic = [self.array objectAtIndex:indexPath.row];
        NSLog(@"%@", dic);
        [cell.iconImage setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
        cell.addFriendImage.hidden = YES;

        cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
        NSArray * aArray = [dic objectForKey:@"company_list"];
        NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
        NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
        cell.companyName.text = company;
        cell.position.text = position;
        /**
         *  城市
         */
    NSString * cityStr = [NSString getCity:[aArray firstObject]];
    NSString * indusstr = [NSString getIndusryName:[aArray firstObject]];

        
        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
        cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parent_level_name"]];
        [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMyFileViewController * vc = [[LCMyFileViewController   alloc] init];
    vc.isMe = NO;
    vc.isChat = NO;
    vc.user_id = [self.array[indexPath.section] objectForKey:@"user_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
