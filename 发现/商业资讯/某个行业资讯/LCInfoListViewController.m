//
//  LCInfoListViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCInfoListViewController.h"
#import "LCInfoListTableViewCell.h"
#import "LCInfoDetailViewController.h"
@interface LCInfoListViewController ()
@end

@implementation LCInfoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"行业资讯";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"商业资讯";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.page = 1;
    __weak LCInfoListViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
    
    
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"取消收藏" titleColor: nil buttonFram:CGRectZero];
    }
    else{
        [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"收藏" titleColor: nil buttonFram:CGRectZero];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    __weak LCInfoListViewController * blockSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isMain == YES) {
        [[NetWork shareNetWork] netWorkWithURL: favorites_delete dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"2",@"favorites_id":self.favourite_id} setSuccessBlock:^(id dictionary) {
            blockSelf.isMain = NO;
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            if ([dictionary[@"status"] isEqualToString:@"200"]) {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"取消收藏成功" forError: YES];
                [blockSelf.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"收藏" titleColor: nil buttonFram:CGRectZero];
            }
            else
            {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"取消收藏失败" forError: YES];
            }
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
            
        }];
    }
    else
    {
        [[NetWork shareNetWork] netWorkWithURL:favorites_Create dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"2",@"x_id":self.indus_id} setSuccessBlock:^(id dictionary) {
            blockSelf.isMain = YES;
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            if ([dictionary[@"status"] isEqualToString:@"200"]) {
                [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"收藏成功" forError: YES];
                blockSelf.favourite_id = [[dictionary objectForKey:@"data"] objectForKey:@"favorites_id"];
                [blockSelf.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"取消收藏" titleColor: nil buttonFram:CGRectZero];
            }
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
            
        }];
    }

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
    [self getList:1];
}
- (void)getList:(NSInteger)pag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCInfoListViewController *vc = self;
   [[NetWork shareNetWork] netWorkWithURL:Info_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"category_id":self.indus_id, @"current_page":[NSString stringWithFormat:@"%d", pag]} setSuccessBlock:^(id dictionary) {
       NSLog(@"%@", dictionary);
       [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
       if ([[[dictionary objectForKey:@"data"] objectForKey: @"news_list"] count] == 0) {
           [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"" forError: YES];
       }
       else
       {
           [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"" forError: YES];
       }
       
       
       if (pag == 1) {
           vc.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"news_list"]];
       }
       else
       {
           [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"news_list"]];
       }
       [self.tableView reloadData];
       
       
       if (pag == 1) {
           [vc.tableView.pullToRefreshView stopAnimating];
       }else
       {
           [vc.tableView.infiniteScrollingView stopAnimating];
       }
       
       [vc.tableView reloadData];
   }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"LCInfoListTableViewCell";
    LCInfoListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
    cell.content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"summary"]];
    cell.time.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"release_time"]];
    cell.source.text = [dic objectForKey:@"source"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCInfoDetailViewController * vc = [[LCInfoDetailViewController alloc] init];
    vc.info_id = [self.array[indexPath.row] objectForKey:@"news_id"];
    vc.urlStr = [self.array[indexPath.row] objectForKey:@"html"];
    vc.titleStr = [self.array[indexPath.row] objectForKey:@"title"];
    vc.content = [self.array[indexPath.row] objectForKey:@"summary"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
