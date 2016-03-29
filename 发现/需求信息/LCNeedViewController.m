//
//  LCNeedViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCNeedViewController.h"
#import "LCSupplyTableViewCell.h"
#import "LCNeedDetailViewController.h"
#import "IndustrySheet.h"
#import "NSString+MD5.h"
@interface LCNeedViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array, *searchArray;
@property (nonatomic, retain)NetWork * listNet;
@property (nonatomic, retain)NSArray * indusDic;
@end

@implementation LCNeedViewController


@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"需求信息";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAreaList:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar.translucent = NO;
    
    self.array = [NSMutableArray arrayWithCapacity:0];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    
    if ([MyUserDefult objectForKey:@"myIdusId"]) {
        self.indus_id = [MyUserDefult objectForKey:@"myIdusId"];
    }
    else
    {
        self.indus_id = @"";
    }
    self.page = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.titleString = @"需求信息";
    
    [self.myNavbar.chooseTypeBtn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    NSLog(@"%@", self.myNavbar.chooseTypeBtn);
    
    
    __weak LCNeedViewController * blockSelf = self;
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
    [self getAreaList:self.page];
}
- (void)getData
{
    self.page = 1;
    [self getAreaList:self.page];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (void)chooseTypeBtn:(UIButton *)btn
{
    
    IndustrySheet * sheet = [[IndustrySheet alloc]initWithTitle:@"选择行业" delegate:self sheetType:sheetType_picker];
    [sheet showInView:self.view];
}
-(void)industrySheet:(IndustrySheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * industryArray = [IndustryDao selectAllDataForDistrict];
    Industry * firstModel = industryArray[index];
    if (firstModel.kindArray.count > 0) {
        Industry * secondModel = firstModel.kindArray[secondIndex];
        self.indus_id = secondModel.ID;
    }
    [MyUserDefult setObject:self.indus_id forKey:@"myIdusId"];
    [self getAreaList:1];
    
}

- (void)getAreaList:(NSInteger)pag
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", URL_BASE, Business_List_URL];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"type":@"1", @"current_page":[NSString stringWithFormat:@"%d", pag], @"industry_ids":self.indus_id};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       __weak LCNeedViewController * blockSelf = self;
    [[NetWork shareNetWork] getDataWithURLStr:Business_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        if ([[[dictionary objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
        
        
        if (pag == 1) {
            blockSelf.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [blockSelf.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        [blockSelf.tableView reloadData];
        
        
        if (pag == 1) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        
        [blockSelf.tableView reloadData];
    }
     setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
         [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
     }
     
     ];
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
    
    
    static NSString * str = @"LCSupplyTableViewCell";
    LCSupplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.iconImage setImageWithURL:[dic objectForKey:@"logo"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.creatTime.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"create_time"]];
    cell.companyName.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"company_name"]];
    cell.recNumber.text = [dic objectForKey:@"comment_number"];
    cell.need.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"content"]];
    cell.PraiseNumber.text = [dic objectForKey:@"like_number"];
    [cell.like addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)] ];
    NSString * cityStr = [NSString getAllArea:dic];
    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,[NSString getIndusryName:dic], Right_Brackets];
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       __weak LCNeedViewController * blockSelf = self;
    [[NetWork shareNetWork] netWorkWithURL:Business_List_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@"", @"type":@"1"} setSuccessBlock:^(id dictionary) {
        
        blockSelf.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [blockSelf.searchDisplayController.searchResultsTableView reloadData];
            if (blockSelf.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有搜索到数据" forError: YES];
            }
        });
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
    }];
}


- (void)likeTap:(UIGestureRecognizer *)ges
{
    LCSupplyTableViewCell  * cell = [[(UITableViewCell *)[ges.view superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%d", path.row);
       __weak LCNeedViewController * blockSelf = self;
    NSInteger  likeNu = [cell.PraiseNumber.text integerValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] netWorkWithURL:Like_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_id":[self.array[path.row] objectForKey:@"business_id"], @"x_type":@"20"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:[dictionary objectForKey:@"message"] forError:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
            cell.PraiseNumber.text = [NSString stringWithFormat:@"%d", likeNu + 1];
        }
        else
        {
            
        }
        //        [self getAreaList];
    }
                              setFailBlock:^(id obj) {
                                  [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
                              }
     ];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCNeedDetailViewController * detailVC = [[LCNeedDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    
    if (tableView == _tableView) {
        detailVC.busis_id = [NSString stringWithFormat:@"%@", [[self.array objectAtIndex:indexPath.row] objectForKey:@"business_id"]];
    }
    else
    {
        detailVC.busis_id = [NSString stringWithFormat:@"%@", [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"business_id"]];
    }
    
  
    detailVC.type_id = @"20";
    detailVC.titleStr = @"需求详情";
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
