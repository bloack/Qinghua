//
//  LCRecruitmentViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCRecruitmentViewController.h"
#import "LCRecruitmentTableViewCell.h"
#import "LCRecruitmentDetailViewController.h"
#import "LCLablesTableViewCell.h"
@interface LCRecruitmentViewController ()
@property (nonatomic, retain)NSMutableArray * array, * searchArray;
@end

@implementation LCRecruitmentViewController


@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"招聘信息";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getList:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    
    self.user_id?(self.titleString = @"我的招聘"):(self.titleString = @"招聘信息");
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    __weak LCRecruitmentViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)nextPage
{
    self.page ++;
    [self getList:self.page];
}
- (void)getData
{
    self.page = 1;
    [self getList:self.page];
}

- (void)getList:(NSInteger)pag
{
    NetWork * net = [NetWork shareNetWork];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic =@{@"user_id":[MyUserDefult objectForKey:@"UserId"],@"current_page":[NSString stringWithFormat:@"%d", pag], @"visit_user_id":self.user_id?:@""};
    [net netWorkWithType:@"POST" url:[NSString stringWithFormat:@"%@%@", URL_BASE, Recruitment_List_URL] body:dic];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@""} ;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       __weak LCRecruitmentViewController * blockSelf = self;
    [[NetWork shareNetWork] getDataWithURLStr:Recruitment_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
        blockSelf.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [blockSelf.searchDisplayController.searchResultsTableView reloadData];
            if (blockSelf.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有搜索到数据" forError: YES];
            }
        });
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];

        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
    }];
    
}

- (void)recieveDataSuccessWithNetwork:(NetWork *)net Object:(id)object
{
    NSLog(@"%@", object);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([[[object objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"没有数据" forError: YES];
    }
    else
    {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:[object objectForKey:@"message"] forError: YES];
    }
    
    
    if (self.page == 1) {
        self.array =  [NSMutableArray arrayWithArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
    }
    else
    {
        [self.array addObjectsFromArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
    }
    if (self.page == 1) {
        [self.tableView.pullToRefreshView stopAnimating];
    }else
    {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return self.array.count;
    }
    else
    {
        return self.searchArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [NSDictionary dictionary];
    if (tableView == _tableView) {
        dic = [self.array objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [self.searchArray objectAtIndex:indexPath.row];
    }
   static NSString * cellID = @"LCRecruitmentTableViewCell";
    LCRecruitmentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    cell.companyName.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    cell.timeLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"create_time"]];
    cell.slary.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"create_time"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCRecruitmentDetailViewController * vc = [[LCRecruitmentDetailViewController alloc] init];
    vc.rec_id = [self.array[indexPath.row] objectForKey:@"recruitment_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
