//
//  AreaContactsViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "AreaContactsViewController.h"
#import "UserDetailViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "LCUserDataViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "DistrictDao.h"
#import "DistrictSheet.h"
/*
 
 *类似行业人脉
 */
@interface AreaContactsViewController ()
@property (nonatomic, retain)NSMutableArray * array, *typeArray;
@end

@implementation AreaContactsViewController

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
    self.titleString = @"地区人脉";
    self.array = [NSMutableArray arrayWithCapacity:0];
    [self.myNavbar.chooseTypeBtn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    if ([MyUserDefult objectForKey:@"city"]) {
        self.city_id = [MyUserDefult objectForKey:@"city"];
    }
    else
    {
        self.city_id = @"1";
    }
    
    // Do any additional setup after loading the view from its nib..
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    __weak AreaContactsViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
}
- (void)chooseTypeBtn:(UIButton *)btn
{
    DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择地区" delegate:self sheetType:sheetType_picker];
    
    [sheet showInView:self.view];
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
-(void)districtSheet:(DistrictSheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex;
{
    NSArray * resultArray = [DistrictDao selectAllDataForDistrict];
    District * firstModel = resultArray[index];
    District * secondModel = firstModel.cityArray[secondIndex];
    if (firstModel.cityArray.count > 0) {
        self.city_id = secondModel.ID;
    }
    [MyUserDefult setObject:self.city_id forKey:@"city"];
    self.page = 1;
    [self getNearListWith:1];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self   getNearListWith:1];
}
- (void)getNearListWith:(NSInteger)pag
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"city":self.city_id, @"current_page":[NSString stringWithFormat:@"%d", pag]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak AreaContactsViewController *vc = self;
        [[NetWork shareNetWork] netWorkWithURL:ByLocation_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ([[[dictionary objectForKey:@"data"] objectForKey: @"user_list"] count] == 0) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有数据" forError:YES];
            }
            else
            {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError:YES];
            }
            if (pag == 1) {
                vc.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"user_list"]];
            }
            else
            {
                [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"user_list"]];
            }
            [vc.tableView reloadData];
            
            
            if (pag == 1) {
                [vc.tableView.pullToRefreshView stopAnimating];
            }else
            {
                [vc.tableView.infiniteScrollingView stopAnimating];
            }

        [vc.tableView reloadData];
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
//    cell.position.text = position;
    /**
     *  城市
     */
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
    
    [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)]];
    return cell;
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

- (void)addFriend:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * userName = nil;
    userName = [self.array[path.row] objectForKey:@"user_name"];
    [[LCAddFriends shareAddFriend] addFriendWith:userName vc:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (IBAction)choose:(id)sender {
}
@end
