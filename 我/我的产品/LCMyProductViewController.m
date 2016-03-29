//
//  LCMyProductViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyProductViewController.h"
#import "LCProducTableViewCell.h"
#import "LCProductDetailViewController.h"
#import "NSString+MD5.h"
@interface LCMyProductViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array, * searchArray;
@end

@implementation LCMyProductViewController
@synthesize searchDisplayController;
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    
    self.titleString = @"我的产品";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.page = 1;
    __weak LCMyProductViewController * blockSelf = self;
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
    __weak LCMyProductViewController * blockSelf = self;
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@"", @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} ;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] getDataWithURLStr:Product_List aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
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
    
    //    for (NSDictionary * dic in self.listArray) {
    //          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@", _searchBar.text];
    //          NSString * name = [dic objectForKey:@"real_name"];
    //    }
}

- (void)nextPage
{
    self.page ++;
    [self getListData:self.page];
}
- (void)getData
{
    self.page = 1;
    [self getListData:self.page];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getListData:1];
}
- (void)getListData:(NSInteger)pag
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"], @"current_page":[NSString stringWithFormat:@"%d", pag]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMyProductViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:Product_List aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
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
         
     }
     ];
}
- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    static NSString *cellID = @"LCProducTableViewCell";
    LCProducTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = [NSDictionary dictionary];
    if (tableView == _tableView) {
        dic = [self.array objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [self.searchArray objectAtIndex:indexPath.row];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCProductDetailViewController * vc = [[LCProductDetailViewController alloc] init];
    vc.isMain = YES;
    if (tableView == _tableView) {
        vc.product_id = [NSString stringWithFormat:@"%@", [[self.array objectAtIndex:indexPath.row] objectForKey:@"product_id"]];
    }
    else
    {
        vc.product_id = [NSString stringWithFormat:@"%@", [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"product_id"]];
    }

    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


@end
