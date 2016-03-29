//
//  LCHaveALookViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCHaveALookViewController.h"
#import "LCProducTableViewCell.h"
#import "LCProductViewController.h"
#import "LCProductDetailViewController.h"
#import "NSString+MD5.h"
@interface LCHaveALookViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array, * searchArray;
@end

@implementation LCHaveALookViewController

@synthesize searchDisplayController;
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
        [self getList:1];
    self.searchBar.translucent = NO;
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;

    
    
    self.titleString = @"随便看看";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    __weak LCHaveALookViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@""} ;
    __weak LCHaveALookViewController *vc = self;
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    [[NetWork shareNetWork] getDataWithURLStr:Product_List aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
        vc.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [vc.searchDisplayController.searchResultsTableView reloadData];
            if (vc.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有搜索到数据" forError: YES];
            }
        });
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)getList:(NSInteger)pag
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCHaveALookViewController *vc = self;
    NSDictionary *dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"current_page":[NSString stringWithFormat:@"%d", pag]};
    [[NetWork shareNetWork] getDataWithURLStr:Product_List aImage:nil aBody:dic aSuccessBlock:^(id object) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([[[object objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[object objectForKey:@"message"] forError: YES];
        }
        
        
        if (vc.page == 1) {
            [vc.tableView.pullToRefreshView stopAnimating];
            vc.array =  [NSMutableArray arrayWithArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [vc.tableView.infiniteScrollingView stopAnimating];
            [vc.array addObjectsFromArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
        }

        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_tableView) {
        return self.array.count;
    }
    else
    {
        return self.searchArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LCProducTableViewCell";
    LCProducTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    
    NSDictionary * dic = nil;
    if (tableView == _tableView) {
            dic = self.array[indexPath.row];
    }
    else
    {
        dic = self.searchArray[indexPath.row];
    }
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"product_name"]];
    [cell.icon setImageWithURL:[NSURL URLWithString:[dic[@"paths"] firstObject]] placeholderImage:[UIImage imageNamed:@"120.png"]];
    cell.price.text = [NSString stringWithFormat:@"%@元", dic[@"unit_price"]];
    NSDictionary *adic = @{@"0": @"批发", @"1":@"经销", @"2":@"零售"};
    NSString *business_pattern = dic[@"business_pattern"];
    NSMutableString *patten = [NSMutableString string];
    NSArray *ary = [business_pattern componentsSeparatedByString:@","];
    for (NSString *str in ary) {
        NSString *sss = [adic objectForKey:str];
        if (sss != nil) {
            [patten appendString:[NSString stringWithFormat:@"%@  ",sss]];
            
        }
    }
    cell.pattern.text = patten;
    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets, dic[@"sales_area"], [NSString getIndusryName:dic], Right_Brackets];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCProductDetailViewController * vc = [[LCProductDetailViewController alloc] init];
    if (tableView == _tableView) {
            vc.product_id = [self.array[indexPath.row] objectForKey:@"product_id"];
    }
    else
    {
            vc.product_id = [self.searchArray[indexPath.row] objectForKey:@"product_id"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
