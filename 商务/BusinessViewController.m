//
//  BusinessViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BusinessViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCGetHelpViewController.h"
#import "UserDetailViewController.h"
#import "LCProductDetailViewController.h"
#import "CompanyDetailViewController.h"
@interface BusinessViewController ()
@property (nonatomic, retain)NSArray * array, *VCArray;
@property (nonatomic, retain)NSArray * iconArray, *adArray;
@end

@implementation BusinessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tab-4.png"];
        self.title = @"商务";
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.adArray.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak BusinessViewController *vc = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getBackImage];
            
        });
    }
}
- (void)getBackImage
{
    __weak BusinessViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:AD_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"position":@"1"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        
        vc.adArray = [[dictionary objectForKey:@"data"] objectForKey:@"ad_list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [vc loadScrollView];
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
        
        __weak BusinessViewController * blockSelf = self;
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
        bView.backgroundColor = [UIColor grayColor];

        lable.font = [UIFont systemFontOfSize:13.0];
        bView.alpha = 0.5;
        [image addSubview:bView];

        [image addSubview:lable];
        [self.view addSubview:image];
    }
    
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
    static NSString * messageTBViewCellID = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLable.text = [self.array objectAtIndex:indexPath.row];
    cell.iconImage.image = [self.iconArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  按照标识符跳转
     *  下级页面：用户详情
     */
    UIViewController * vc = [[NSClassFromString(self.VCArray[indexPath.row]) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)initArrays
{
    self.array = @[@"供应", @"需求", @"求助", @"产品", @"项目", @"招聘", @"企业维护"];
    self.iconArray = @[[UIImage imageNamed:@"lcsj_faxian_3.png"], [UIImage imageNamed:@"lcsj_faxian_4.png"],[UIImage imageNamed:@"lcsj_faxian_6.png"],[UIImage imageNamed:@"lcsj_shangwu_3.png"],[UIImage imageNamed:@"lcsj_faxian_5.png"],[UIImage imageNamed:@"lcsj_faxian_7.png"],[UIImage imageNamed:@"lcsj_shangwu_7.png"]];
    self.VCArray = @[@"SupplyViewController", @"DemandViewController", @"LCGetHelpViewController", @"ProductViewController", @"ProjectViewController", @"RecruitmentViewController", @"LCMaintainViewController"];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"商务";
    [self hidenLeftButton];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self initArrays];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
