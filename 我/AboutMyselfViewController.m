//
//  AboutMyselfViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "AboutMyselfViewController.h"
#import "LCMyActivityViewController.h"
#import "LCMyCompanyViewController.h"
#import "LCMyHelpViewController.h"
#import "LCMyMainViewController.h"
#import "LCMyProductViewController.h"
#import "LCMyReviewViewController.h"
#import "LCMySupplyViewController.h"
#import "LCSettingViewController.h"
#import "LCMyIntegrationViewController.h"
#import "LCMyFileViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCMyNeedViewController.h"
#import "LCIconAndBackTableViewCell.h"
#import "CircleOfFriendViewController.h"
#import "LCMyProjectViewController.h"
#import "LCMyFavouriteViewController.h"
#import "LCRecruitmentViewController.h"
@interface AboutMyselfViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSArray * titleArray, *VCArray, *iconArray;
@property (nonatomic, retain)NSDictionary * dic;
@end

@implementation AboutMyselfViewController
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)settingButton:(id)sender {
    [self.navigationController pushViewController:[[LCSettingViewController alloc] init] animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tab-5.png"];
        self.title = @"我";
        // Custom initialization
    }
    return self;
}
- (void)myFile:(UITapGestureRecognizer*)uitap
{
    [self.navigationController pushViewController:[[LCMyFileViewController alloc] init] animated:YES];
}
- (void)loadTableView
{
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.titleArray = @[@"我的积分", @"最近访客", @"我的主页", @"我的求助", @"我的产品", @"我的活动", @"我的企业", @"我的供应", @"我的需求", @"我的项目", @"我的收藏", @"我的招聘"];
    self.iconArray = @[[UIImage imageNamed:@"lcsj_mine_1.png"],[UIImage imageNamed:@"lcsj_mine_2.png"],[UIImage imageNamed:@"lcsj_mine_3.png"],[UIImage imageNamed:@"lcsj_faxian_6.png"],[UIImage imageNamed:@"lcsj_mine_5.png"],[UIImage imageNamed:@"lcsj_mine_6.png"],[UIImage imageNamed:@"lcsj_mine_7.png"],[UIImage imageNamed:@"lcsj_faxian_3.png"],[UIImage imageNamed:@"lcsj_faxian_4.png"],[UIImage imageNamed:@"lcsj_faxian_5.png"],[UIImage imageNamed:@"lcsj_mine_11.png"],[UIImage imageNamed:@"lcsj_faxian_7.png"]
                       ];
    self.VCArray = @[@"LCMyIntegrationViewController", @"LCMyReviewViewController", @"LCMyMainViewController", @"LCMyHelpViewController", @"LCMyProductViewController", @"LCMyActivityViewController", @"LCMyCompanyViewController", @"LCMySupplyViewController", @"LCMyNeedViewController", @"LCMyProjectViewController", @"LCMyFavouriteViewController", @"LCRecruitmentViewController"];
    __weak AboutMyselfViewController * blockSelf = self;
    
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"我";
    [self hidenLeftButton];
    [self getData];
    [self.myNavbar setRight1ButtonWithnormalImageName:@"lcsj_mine_setting.png" highlightedImageName:@"lcsj_mine_setting.png" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectMake(268, 7, 32, 30)];
    [self loadTableView];
    UIBarButtonItem *moveButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lcsj_mine_setting.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(settingButton:)];
    
    self.navigationItem.rightBarButtonItem = moveButton;
    // Do any additional setup after loading the view from its nib.
}
-(void)right1ButtonClick
{
    [self settingButton:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)getData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block AboutMyselfViewController * blockSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:UserDetail_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        blockSelf.dic = [dictionary objectForKey:@"data"];
        [[NetWork shareNetWork] getDataWithURLStr:Credit_URL aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"]} aSuccessBlock:^(id myDictionary) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
            blockSelf.credit_total = [[[myDictionary[@"data"] objectForKey:@"list"] firstObject] objectForKey:@"credit"];
            [blockSelf.tableView reloadData];
        } setFailBlock:^(id obj) {
            
        }];
    }            setFailBlock:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
                                [blockSelf.tableView.pullToRefreshView stopAnimating];
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellID = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];

        }
        cell.firstButton.hidden = YES;
        cell.secButton.hidden = YES;
        cell.intro.hidden = YES;
        NSArray * aArray = [self.dic objectForKey:@"company_list"];
        NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
        NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];;
        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,[[aArray firstObject] objectForKey:@"city"],[[aArray firstObject] objectForKey:@"industry_id"], Right_Brackets];
        cell.company.text = company;
        cell.position.text = position;
        [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
        cell.name.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"real_name"]];
        cell.level.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"parent_level_name"]];
        [cell buildChild:[self.dic objectForKey:@"child_level_icon"] parent:[self.dic objectForKey:@"parent_level_icon"]];
        return cell;
    }
    else
    {
    static NSString * cellID = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == Nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLable.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.iconImage.image = [self.iconArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 60, 30)];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.font = [UIFont systemFontOfSize:13.0];
            lab.text = self.credit_total;
            [cell addSubview:lab];
        }
    return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LCMyFileViewController * vc = [[LCMyFileViewController alloc] init];
            vc.user_id = [MyUserDefult objectForKey:@"UserId"];
            vc.isMe = YES;
            vc.isChat = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    else
    {
        
        //我的主页
        if (indexPath.row == 2)
        {
            LCMyMainViewController * myController = [[LCMyMainViewController alloc] init];
            myController.userId = [MyUserDefult objectForKey:@"UserId"];
            
            myController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myController animated:YES];
        }
        else if(indexPath.row == 6){
            LCMyCompanyViewController *vc = [[LCMyCompanyViewController alloc] init];
            vc.user_id = [MyUserDefult objectForKey:@"UserId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == self.titleArray.count - 1)
        {
            LCRecruitmentViewController *vc = [[LCRecruitmentViewController alloc] init];
            vc.user_id = [MyUserDefult objectForKey:@"UserId"];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else
        {
            UIViewController * vc = [[NSClassFromString(self.VCArray[indexPath.row]) alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
