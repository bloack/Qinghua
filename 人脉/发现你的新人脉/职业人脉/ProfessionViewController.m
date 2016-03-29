//
//  ProfessionViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ProfessionViewController.h"
#import "UserDetailViewController.h"
#import "LCRenMaiTableViewCell.h"
/*
 
 *类似行业人脉
 */
@interface ProfessionViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@property (nonatomic, retain)NSArray * indusDic;
@end

@implementation ProfessionViewController

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
    self.titleString = @"职业人脉";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.indus_id = @"1";
    self.page = 1;
    self.array = [NSMutableArray arrayWithCapacity:0];
    
    
    [self.myNavbar.chooseTypeBtn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    self.indusDic = [[LCAppDelegate shared].dict_Profession allValues];
    int a = self.indusDic.count;
    
    isOpened = NO;
    __weak ProfessionViewController * blockSelf = self;

    [_tableViewBlock initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return a;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:blockSelf options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.lb.text = [blockSelf.indusDic[indexPath.row] objectForKey:@"name"];
        cell.lb.font = [UIFont systemFontOfSize:13.0];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        blockSelf.indus_id = [blockSelf.indusDic[indexPath.row] objectForKey:@"id"];
        blockSelf.page = 1;
        [blockSelf.myNavbar.chooseTypeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@", blockSelf.indus_id);
    }];

    
    [blockSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [blockSelf.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [blockSelf.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
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
- (void)chooseTypeBtn:(UIButton *)btn
{
    __weak ProfessionViewController * blockSelf = self;

    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=blockSelf.tableViewBlock.frame;
            
            frame.size.height=0;
            [blockSelf.tableViewBlock setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened=NO;
            [blockSelf getNearListWith:1];
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=blockSelf.tableViewBlock.frame;
            frame.size.height = 180;
            [blockSelf.tableViewBlock setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpened=YES;
        }];
        
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getNearListWith:1];
}
- (void)getNearListWith:(NSInteger)pag
{
    /*
     
     *获取推荐人脉列表
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"current_page":[NSString stringWithFormat:@"%d", pag], @"occupation_id":self.indus_id};
    __weak ProfessionViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:ByOccupation_URL dic:dic setSuccessBlock:^(id dictionary) {
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

#pragma mark NetWorkDelegate
- (void)recieveDataSuccessWithNetwork:(NetWork *)net Object:(id)object
{

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
//    /**
//     *  城市
//     */
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
    cell.province.text = [NSString stringWithFormat:@"%d 米", str];
    
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
