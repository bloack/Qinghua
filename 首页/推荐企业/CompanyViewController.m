//
//  CompanyViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyDetailViewController.h"
#import "LCCompanyTableViewCell.h"
#import "NSString+MD5.h"
@interface CompanyViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation CompanyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"推荐企业";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"推荐企业";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    __block CompanyViewController * blockSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getMessageList];
    }];
     [self.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)getMessageList
{
    /*
     
     *获取名片交换列表
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"]};
    __weak CompanyViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Company_List_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [vc.tableView.pullToRefreshView stopAnimating];
        vc.array = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"company_list"]];
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
    }
     ];
    
}
- (void)agreeExchange:(UIButton *)button
{
    /*
     
     *统一按钮的方法
     */
    
}
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
    NSDictionary * dic  = self.array[indexPath.row];
    static NSString * messageTBViewCellID = @"LCCompanyTableViewCell";
    LCCompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.icon setImageWithURL:[dic objectForKey:@"logo"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"company_name"]];
    cell.adress.text = [dic objectForKey:@"address"];
    cell.representative.text = [dic objectForKey:@"intro"];
    NSString * indusstr = [NSString getIndusryName:dic];
    cell.industry.text = indusstr;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：企业详情
     */
    CompanyDetailViewController * vc = [[CompanyDetailViewController alloc] init];
    vc.isMyCom = NO;
    vc.com_id = [NSString stringWithFormat:@"%@", [self.array[indexPath.row] objectForKey:@"company_id"]];
    [self.navigationController pushViewController: vc animated:YES];
}
- (void)addFriend:(UIButton *)button
{
    /*
     
     *添加好友
     */

}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"willDis");
    [[NetWork shareNetWork] networkCancle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
