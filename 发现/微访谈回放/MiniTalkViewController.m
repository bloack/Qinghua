//
//  MiniTalkViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "MiniTalkViewController.h"
#import "LCInfoListTableViewCell.h"
#import "LCInfoDetailViewController.h"

@interface MiniTalkViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation MiniTalkViewController
- (IBAction)dimiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微访谈回放";
              self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"资讯详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    
    
    self.page = 1;
    __weak MiniTalkViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];
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
    __weak MiniTalkViewController * blockSelf = self;

    [[NetWork   shareNetWork] netWorkWithURL:Info_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"category_id":@"2", @"current_page":[NSString stringWithFormat:@"%d", pag]} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        if ([[[dictionary objectForKey:@"data"] objectForKey: @"news_list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"" forError: YES];
        }
        
        
        if (pag == 1) {
            blockSelf.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"news_list"]];
        }
        else
        {
            [blockSelf.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"news_list"]];
        }
        [blockSelf.tableView reloadData];
        
        
        if (pag == 1) {
            [blockSelf.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        [blockSelf.tableView reloadData];
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
    vc.isMain = NO;
    vc.info_id = [self.array[indexPath.row] objectForKey:@"news_id"];
    vc.urlStr = [self.array[indexPath.row] objectForKey:@"url"];
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
