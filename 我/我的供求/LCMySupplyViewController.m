//
//  LCMySupplyViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMySupplyViewController.h"
#import "LCSupplyTableViewCell.h"
#import "LCNeedDetailViewController.h"
#import "NetWork.h"
#import "NSString+MD5.h"
@interface LCMySupplyViewController ()
@property (nonatomic, retain)NSMutableArray * array, * searchArray;
@end

@implementation LCMySupplyViewController

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

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAreaList:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    
    self.titleString = @"我的供应";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.page = 1;
    __weak LCMySupplyViewController * blockSelf = self;
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

- (void)getAreaList:(NSInteger)pag
{
    __weak LCMySupplyViewController * blockSelf = self;

    NSString * urlStr = [NSString stringWithFormat:@"%@%@", URL_BASE, Business_List_URL];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"type":@"0", @"current_page":[NSString stringWithFormat:@"%d", pag], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]};
    
    [MBProgressHUD showHUDAddedTo:blockSelf.view animated:YES];
    [[NetWork shareNetWork] getDataWithURLStr:Business_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary){
        
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
  //      [blockSelf.tableView reloadData];
        
        
        if (pag == 1) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        
        [blockSelf.tableView reloadData];
        NSLog(@"%@", dictionary);
        
    }
     setFailBlock:^(id obj) {
                [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
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
    static NSString * str = @"LCSupplyTableViewCell";
    LCSupplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = [NSDictionary dictionary];
    if (tableView == _tableView) {
        dic = [self.array objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [self.searchArray objectAtIndex:indexPath.row];
    }
    
    [cell.iconImage setImageWithURL:[dic objectForKey:@"logo"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.creatTime.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"create_time"]];
    cell.companyName.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"company_name"]];
//    [cell.recNumber setTitle: [NSString stringWithFormat:@"%@", [dic objectForKey:@"comment_number"]] forState:UIControlStateNormal];
    cell.recNumber.text = [dic objectForKey:@"comment_number"];
    cell.need.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"content"]];
     cell.PraiseNumber.text = [dic objectForKey:@"like_number"];
    [cell.like addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)]];
    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  [NSString getAllArea:dic],[NSString getIndusryName:dic], Right_Brackets];
    return cell;
    
}
- (void)likeTap:(UIGestureRecognizer *)ges
{
    LCSupplyTableViewCell  * cell = [[(UITableViewCell *)[ges.view superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%d", path.row);
    
    NSInteger  likeNu = [cell.PraiseNumber.text integerValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCSupplyInfoViewController * blockSelf = self;
    [[NetWork shareNetWork] netWorkWithURL:Like_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_id":[self.array[path.row] objectForKey:@"business_id"], @"x_type":@"20"} setSuccessBlock:^(id dictionary) {
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@"", @"type":@"0"} ;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMySupplyViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:Business_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
        blockSelf.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"user_list"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCNeedDetailViewController * commentsVC = [[LCNeedDetailViewController alloc] init];
    commentsVC.type_id = @"20";
    commentsVC.titleStr = @"供应详情";
    commentsVC.isMain = YES;
    if (tableView == _tableView) {
        commentsVC.busis_id = [NSString stringWithFormat:@"%@", [[self.array objectAtIndex:indexPath.row] objectForKey:@"business_id"]];
    }
    else
    {
        commentsVC.busis_id = [NSString stringWithFormat:@"%@", [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"business_id"]];
    }

    [self.navigationController pushViewController:commentsVC animated:YES];
}

@end
