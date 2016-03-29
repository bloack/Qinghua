//
//  DiscoveryViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "WeiboViewController.h"
#import "LCNeedViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCRecruitmentViewController.h"
#import "LCProjectViewController.h"
#import "QHCircleOfFriendController.h"
#import "MiniTalkViewController.h"
#import "UserDetailViewController.h"
#import "LCProductDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "LCDirectoryViewController.h"
@interface DiscoveryViewController ()
@property (nonatomic, retain)NSArray * array1, *array2;
@property (nonatomic, retain)NSArray * secondArray1, *secondArray2;
@property (nonatomic, retain)NSArray * iconArray1, *iconArray2,*adArray;
@end

@implementation DiscoveryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tab-3.png"];
        self.title = @"发现";
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.adArray.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak DiscoveryViewController *vc = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [vc getBackImage];
        });
        
    }
}
- (void)getBackImage
{
    __weak DiscoveryViewController * vc = self;
    [[NetWork shareNetWork] netWorkWithURL:AD_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"position":@"0"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        
        self.adArray = [[dictionary objectForKey:@"data"] objectForKey:@"ad_list"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [self loadScrollView];
        });
    }
                              setFailBlock:^(id obj) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                                      [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                                  });
                              }
     ];
}
- (void)loadScrollView
{
    /*
     
     *循环滚动
     */
    if (self.adArray.count > 1) {
        NSMutableArray *viewsArray = [@[] mutableCopy];
        NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
        for (int i = 0; i < self.adArray.count; ++i) {
            
            
            UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
            [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.adArray[i] objectForKey:@"image"]]]];
            UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 30)];
            bView.backgroundColor = [UIColor grayColor];
            [image addSubview:bView];
            image.userInteractionEnabled = YES;
            UILabel * lable = [[UILabel  alloc] initWithFrame:CGRectMake(20, 90, 320, 30)];
            lable.text = [self.adArray[i] objectForKey:@"title"];
            lable.textColor = [UIColor whiteColor];
            lable.font = [UIFont systemFontOfSize:13.0];
            bView.alpha = 0.5;
            [image addSubview:lable];
            [viewsArray addObject:image];
        }
        
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 44 + ADJUST_HEIGHT, 320, 120) animationDuration:2.0];
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        
        __weak DiscoveryViewController * blockSelf = self;
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%d个",pageIndex);
            NSString * type = [blockSelf.adArray[pageIndex] objectForKey:@"x_type"];
            NSString * infoId = [blockSelf.adArray[pageIndex] objectForKey:@"x_id"];
            switch ([type integerValue]) {
                case 22:
                {
                    LCProductDetailViewController * vc = [[LCProductDetailViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.product_id = infoId;
                    [blockSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 50:
                {
                    UserDetailViewController * vc = [[UserDetailViewController   alloc] init];
                    vc.userid = infoId;
                    vc.hidesBottomBarWhenPushed = YES;
                    [blockSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 51:
                {
                    CompanyDetailViewController * vc = [[CompanyDetailViewController alloc] init];
                    vc.com_id = infoId;
                    vc.hidesBottomBarWhenPushed = YES;
                    [blockSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    
                    break;
            }
            
        };
        [self.view addSubview:self.mainScorllView];

    }
    else
    {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 + ADJUST_HEIGHT, 320, 120)];
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.adArray firstObject] objectForKey:@"image"]]]];
        UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 30)];
        
        UILabel * lable = [[UILabel  alloc] initWithFrame:CGRectMake(20, 90, 320, 30)];
        lable.text = [[self.adArray firstObject] objectForKey:@"title"];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:13.0];
        bView.backgroundColor = [UIColor grayColor];

        bView.alpha = 0.5;
        [image addSubview:bView];
        
        [image addSubview:lable];
        [self.view addSubview:image];
    }

}
- (void)loadTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"朋友圈", @"群组", @"供应信息",@"需求信息",@"项目信息", @"求助信息", @"招聘信息",@"产品黄页", @"商业资讯", @"微访谈回放", @"企业名录"];
    self.array2 = @[];
    self.iconArray1 = @[[UIImage imageNamed:@"lcsj_faxian_1.png"], [UIImage imageNamed:@"lcsj_faxian_2.png"],[UIImage imageNamed:@"lcsj_faxian_3.png"],[UIImage imageNamed:@"lcsj_faxian_4.png"],[UIImage imageNamed:@"lcsj_faxian_5.png"],[UIImage imageNamed:@"lcsj_faxian_6.png"],[UIImage imageNamed:@"lcsj_faxian_7.png"],[UIImage imageNamed:@"lcsj_faxian_8.png"],[UIImage imageNamed:@"lcsj_faxian_9.png"],[UIImage imageNamed:@"lcsj_faxian_10.png"],[UIImage imageNamed:@"lcsj_shangwu_6.png"]];
 
//    CircleOfFriendViewController * cf = [[CircleOfFriendViewController alloc] init];
    QHCircleOfFriendController * cf = [[QHCircleOfFriendController alloc]init];
    
    cf.hidesBottomBarWhenPushed = YES;
    self.secondArray1 = [NSArray arrayWithObjects:@"QHCircleOfFriendController", @"GroupsViewController",@"LCSupplyInfoViewController",@"LCNeedViewController",@"LCProjectViewController",
                         @"AskForHelpViewController",
                         @"LCRecruitmentViewController",@"YellowPagesViewController", @"InformationViewController", @"MiniTalkViewController", @"LCDirectoryViewController",  nil];
    self.secondArray2 = @[];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hidenLeftButton];
    self.titleString = @"发现";
//    [self loadScrollView];
    [self loadTableView];

    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /**
     *  根据网络请求返回的数据
     */
    if (section == 0) {
        return self.array1.count;
    }
    else
    {
        return self.array2.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.nameLable.text = [self.array1 objectAtIndex:indexPath.row];
        cell.iconImage.image = [self.iconArray1 objectAtIndex:indexPath.row];
    }
    else
    {
    
        cell.nameLable.text = [self.array2 objectAtIndex:indexPath.row];
        cell.iconImage.image = [self.iconArray2 objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        QHCircleOfFriendController * cf = [[QHCircleOfFriendController alloc]init];
        cf.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cf animated:YES];
        return;
    }
    
    /*
     
     *按照标识符跳转
     *下级页面：用户详情
     */
    UIViewController * vc = [[NSClassFromString(self.secondArray1[indexPath.row]) alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
