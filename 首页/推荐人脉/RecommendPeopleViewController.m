//
//  RecommendPeopleViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "RecommendPeopleViewController.h"
#import "UserDetailViewController.h"
#import "LCRecommendTableViewCell.h"
#import "LCAddFriends.h"
#import "NSString+MD5.h"
/*
 
 *类似推荐企业
 *cell按照布局进行
 */
@interface RecommendPeopleViewController ()
@property (nonatomic, retain)NSArray * listArray;
@end

@implementation RecommendPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"推荐人脉";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"推荐人脉";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    __weak RecommendPeopleViewController * blockSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getMessageList];
    }];
    [blockSelf.tableView triggerPullToRefresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)getMessageList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"]};
    __weak RecommendPeopleViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:ByRecommend_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.listArray = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"user_list"]];
        [vc.tableView.pullToRefreshView stopAnimating];
        [vc.tableView reloadData];
    }  setFailBlock:^(id obj) {
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
    return self.listArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCRecommendTableViewCell";
    LCRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
    }
    NSDictionary * dic = [self.listArray objectAtIndex:indexPath.row];
    [cell.icon setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"] ];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
    NSArray * aArray = [dic objectForKey:@"company_list"];
    NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
    NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
    cell.company.text = company;
    cell.position.text = position;
    /**
     *  城市
     */
    NSString * cityStr = [NSString getAllArea:[aArray firstObject]];
    NSString * indusstr = [NSString getIndusryName:[aArray firstObject]];

     cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
    cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parent_level_name"]];
    [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];
    
    [cell.addButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)]];
    return cell;
}
- (void)addFriend:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = [(UITableViewCell *)[[tap.view superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * userName = nil;
    userName = [self.listArray[path.row] objectForKey:@"user_name"];
    [[LCAddFriends shareAddFriend] addFriendWith:userName vc:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：个人详情
     */
    NSDictionary * dic = [self.listArray objectAtIndex:indexPath.row];

   UserDetailViewController * vc = [[UserDetailViewController alloc] init];
    vc.userid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"user_id"]];
    NSLog(@"userid = %@", vc.userid);
    [self.navigationController pushViewController:vc  animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
