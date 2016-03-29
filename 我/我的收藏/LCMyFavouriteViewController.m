//
//  LCMyFavouriteViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyFavouriteViewController.h"

#import "LCActivityDetailViewController.h"
#import "LCInfoListTableViewCell.h"
#import "LCInfoDetailViewController.h"
#import "LCGroupActivityTableViewCell.h"
#import "NetWork.h"
@interface LCMyFavouriteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain)NSMutableArray * array1, *array2, *currentArray;
@end

@implementation LCMyFavouriteViewController

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
    self.titleString = @"我的收藏";
    [self.seg addTarget:self action:@selector(changeSegMent:) forControlEvents:UIControlEventValueChanged];
    
    self.page = 1;
    __weak LCMyFavouriteViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
    
//    [self getMyActive:1];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyActive:1];
}
- (void)nextPage
{
    self.page ++;

    if (self.seg.selectedSegmentIndex == 0) {
      
        [self getMyActive:self.page];
    }
    else
    {
        [self getJoinInActivity:self.page];
    }
    
}
- (void)getData
{
    self.page = 1;
    if (self.seg.selectedSegmentIndex == 0) {
        [self getMyActive:1];
    }
    else
    {
        [self getJoinInActivity:1];
    }
}

- (void)changeSegMent:(UISegmentedControl *)segment
{
    self.page = 1;
    if (segment.selectedSegmentIndex == 0) {
        [self getMyActive:1];
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        [self getJoinInActivity:1];
    }
}

- (void)getMyActive:(NSInteger)pag
{
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"],  @"x_type":@"0", @"current_page":[NSString stringWithFormat:@"%d", pag]};
    __weak LCMyFavouriteViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:favorites_List aImage:nil aBody:dic aSuccessBlock:^(id dictionary){
        if ([[[dictionary objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
        
        
        if (pag == 1) {
            blockSelf.array1 =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [blockSelf.array1 addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        blockSelf.currentArray = blockSelf.array1;
        [blockSelf.tableView reloadData];
        
        if (pag == 1) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }

    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"数据请求错误" forError: YES];
    }
     ];
}
- (void)getJoinInActivity:(NSInteger)pag
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"1" , @"current_page":[NSString stringWithFormat:@"%d", pag]};
    __weak LCMyFavouriteViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:favorites_List aImage:nil aBody:dic aSuccessBlock:^(id dictionary){
        if ([[[dictionary objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
        
        
        if (pag == 1) {
            blockSelf.array2 =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [blockSelf.array2 addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        
        blockSelf.currentArray = blockSelf.array2;
        [blockSelf.tableView reloadData];
        
        
        if (pag == 1) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }

    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"数据请求错误" forError: YES];
    }
];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentArray == self.array2) {
        static NSString * str = @"LCGroupActivityTableViewCell";
        LCGroupActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSDictionary * dic = self.currentArray[indexPath.row];
        cell.title.text = [dic objectForKey:@"title"];
        cell.time.text = [dic objectForKey:@"create_time"];
        return cell;
    }
    else
    {
        static NSString * str = @"LCInfoListTableViewCell";
        LCInfoListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSDictionary * dic = self.currentArray[indexPath.row];
        cell.title.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"title"]];
        cell.content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"content"]];
        cell.time.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"create_time"]];
        cell.source.text = [dic objectForKey:@"source"];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.currentArray == self.array1) {
        LCInfoDetailViewController * vc = [[LCInfoDetailViewController alloc] init];
        vc.isMain = YES;
        vc.titleStr = [self.currentArray[indexPath.row] objectForKey:@"title"];
        vc.favourite_id = [self.currentArray[indexPath.row] objectForKey:@"favorites_id"];
        vc.info_id = [self.currentArray[indexPath.row] objectForKey:@"x_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(self.currentArray == self.array2)
    {
        LCActivityDetailViewController * vc = [[LCActivityDetailViewController alloc] init];
        vc.active_id = [self.currentArray[indexPath.row] objectForKey:@"x_id"];
        vc.isFavourite = YES;
        vc.favourite_id = [self.currentArray[indexPath.row] objectForKey:@"favorites_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    self.seg.selectedSegmentIndex = 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)goBack
{
    self.seg.selectedSegmentIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
