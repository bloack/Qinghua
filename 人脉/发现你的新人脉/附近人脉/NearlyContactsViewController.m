//
//  NearlyContactsViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "NearlyContactsViewController.h"
#import "UserDetailViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "LCAddFriends.h"
@interface NearlyContactsViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation NearlyContactsViewController

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
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.titleString = @"附近人脉";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.page = 1;
    // Do any additional setup after loading the view from its nib.
    
    __weak NearlyContactsViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    self.array =  [NSMutableArray arrayWithCapacity:0];

    [self.tableView triggerPullToRefresh];
}
- (void)nextPage
{
    self.page ++;
    [self getNearListWith:self.page];
}
- (void)getData
{
    self.page = 1;
    [self getNearListWith:self.page];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)getNearListWith:(NSInteger)pag
{
    /*
     
     *获取推荐人脉列表
     */
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"current_lng":[NSString stringWithFormat:@"%f", self.location.coordinate.longitude], @"current_lat":[NSString stringWithFormat:@"%f", self.location.coordinate.latitude], @"current_page":[NSString stringWithFormat:@"%d", pag]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak NearlyContactsViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Nearby_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (pag == 1) {
            [vc.tableView.pullToRefreshView stopAnimating];

            vc.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"user_list"]];
        }
        else
        {
            [vc.tableView.infiniteScrollingView stopAnimating];

            [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"user_list"]];
        }
        [vc.tableView reloadData];
        
        
    }
     setFailBlock:^(id obj) {
         [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError:YES];
     }
     ];
}

#pragma mark NetWorkDelegate

#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCRenMaiTableViewCell";
    LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = [self.array objectAtIndex:indexPath.row];
    NSLog(@"%@", dic);
    [cell.iconImage setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
//    NSArray * aArray = [dic objectForKey:@"company_list"];
//    NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
//    NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
//    cell.companyName.text = company;
//    NSString * cityStr = [NSString getAllArea:[aArray firstObject]];
//    NSString * indusstr = [NSString getIndusryName:[aArray firstObject]];

    if ([dic[@"is_friend"] integerValue] == 1) {
        cell.addFriendImage.image = [UIImage imageNamed:@"gotoChat.png"];
        [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoChat:)]];
    }
    else{
        [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)]];
    }
//    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
    cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parent_level_name"]];
    [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];
    NSInteger str =  [[NSString stringWithFormat:@"%@", [dic objectForKey:@"distance"]] integerValue];
    cell.province.text = [NSString stringWithFormat:@"%d 米", str * 1000];
    return cell;
}
- (void)addFriend:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * userName = nil;
    userName = [self.array[path.row] objectForKey:@"user_name"];
    [[LCAddFriends shareAddFriend] addFriendWith:userName vc:self];
}
- (void)gotoChat:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    ChatViewController * userVC = [[ChatViewController alloc] init];
    NSDictionary *dic = self.array[path.row];
    userVC.friendModel = [[FriendModel alloc]initWithDic:dic];
    [FriendDao insertFriendTableWith:userVC.friendModel];
    
    NSString * userName = [dic objectForKey:@"username"];
    NSString * realName = [dic objectForKey:@"real_name"];
    NSString * avatar = [dic  objectForKey:@"avatar"];
    ;
    userVC.unionNickName = [NSString stringWithFormat:@"%@@%@,%@,%@",userName,XMPP_SERVER_URL, realName,avatar];
    
    userVC.user_id = dic[@"user_id"];
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.array[indexPath.row] objectForKey:@"is_friend"] integerValue] == 1) {
        LCMyFileViewController *vc = [[LCMyFileViewController alloc] init];
        vc.isChat = NO;
        vc.isMe = NO;
        vc.user_id =[self.array[indexPath.row] objectForKey:@"user_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UserDetailViewController * userVC = [[UserDetailViewController alloc] init];
        userVC.userid = [[self.array objectAtIndex:indexPath.row] objectForKey:@"user_id"];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
