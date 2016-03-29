//
//  LCMyHelpViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyHelpViewController.h"
#import "LCHelpTableViewCell.h"
#import "LCGetHelpViewController.h"
#import "LCHelpDetailViewController.h"
#import "NSString+MD5.h"
@interface LCMyHelpViewController ()<NetWorkDelegate>

@property (nonatomic, retain)NSMutableArray * array, * searchArray;

@end

@implementation LCMyHelpViewController
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
- (IBAction)myEdit:(id)sender {
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    self.tableView.editing = !self.tableView.editing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);
//    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    self.titleString = @"我的求助";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.page = 1;
    __weak LCMyHelpViewController * blockSelf = self;
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
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    [searchBar endEditing:YES];
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@"", @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} ;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMyHelpViewController * blockSelf = self;
    [[NetWork shareNetWork] getDataWithURLStr:Help_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
        blockSelf.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [blockSelf.searchDisplayController.searchResultsTableView reloadData];
            if (blockSelf.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有搜索到数据" forError: YES];
            }
        });
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"网络错误" forError: YES];
    }];
    
    //    for (NSDictionary * dic in self.listArray) {
    //          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@", _searchBar.text];
    //          NSString * name = [dic objectForKey:@"real_name"];
    //    }
}


- (void)nextPage
{
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    self.page ++;
    [self getList:self.page];
}
- (void)getData
{
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    self.page = 1;
    [self getList:self.page];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

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
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    static NSString * cellID = @"LCHelpTableViewCell";
    LCHelpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
    }
    NSDictionary * dic = [NSDictionary dictionary];
    if (tableView == _tableView) {
        dic = [self.array objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [self.searchArray objectAtIndex:indexPath.row];
    }
    
    [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
    cell.content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"content"]];
    NSArray * array = [dic objectForKey:@"company_list"];
    NSDictionary * diccc = [array firstObject];
    
    NSString * cityStr = [NSString getAllArea:diccc];
    NSString * indusstr = [NSString getIndusryName:diccc];
    cell.province.text = [NSString stringWithFormat:@"%@%@, %@%@", Left_Brackets,cityStr, indusstr, Right_Brackets];
    
    [cell.like setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"like_number"]] forState:UIControlStateNormal];
//    [cell.like addTarget:self action:@selector(likeTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.comment setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"comment_number"]] forState:UIControlStateNormal];
    cell.time.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"update_time"]];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}
- (void)getList:(NSInteger)pag
{
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    NetWork * net = [NetWork shareNetWork];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"],@"current_page":[NSString stringWithFormat:@"%d", pag], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]};
    
    __weak LCMyHelpViewController *vc = self;
    [net netWorkWithURL:Help_List_URL dic:dic setSuccessBlock:^(id object) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([[[object objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[object objectForKey:@"message"] forError: YES];
        }
        
        
        if (vc.page == 1) {
            vc.array =  [NSMutableArray arrayWithArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [vc.array addObjectsFromArray:[[object objectForKey:@"data"] objectForKey: @"list"]];
        }
        [vc.tableView reloadData];
        
        
        if (vc.page == 1) {
            [vc.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [vc.tableView.infiniteScrollingView stopAnimating];
        }
        
        
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
}
- (void)recieveDataSuccessWithNetwork:(NetWork *)net Object:(id)object
{
    NSLog(@"%@", object);
    
}
//- (void)fabu
//{
//    [self.navigationController pushViewController:[[LCHelpRelViewController alloc] init] animated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----%s, %d", __FUNCTION__, __LINE__);

    LCHelpDetailViewController * help = [[LCHelpDetailViewController alloc] init];
    if (tableView == _tableView) {
        help.help_id = [NSString stringWithFormat:@"%@", [[self.array objectAtIndex:indexPath.row] objectForKey:@"help_id"]];
    }
    else
    {
        help.help_id = [NSString stringWithFormat:@"%@", [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"help_id"]];
    }

    help.isMain = YES;
    [self.navigationController pushViewController:help animated:YES];
}
- (void)dealloc
{
    
}
@end
