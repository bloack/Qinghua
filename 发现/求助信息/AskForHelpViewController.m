//
//  AskForHelpViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "AskForHelpViewController.h"
#import "LCHelpTableViewCell.h"
#import "NSString+MD5.h"
#import "LCHelpDetailViewController.h"
@interface AskForHelpViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation AskForHelpViewController
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
    self.titleString = @"求助信息";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    __weak AskForHelpViewController * blockSelf = self;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getList:1];
}
- (void)getList:(NSInteger)pag
{
    __weak AskForHelpViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Help_List_URL dic:@{@"user_id":[MyUserDefult objectForKey:@"UserId"], @"current_page":[NSString stringWithFormat:@"%d", pag]} setSuccessBlock:^(id dictionary) {
        if ([[[dictionary objectForKey:@"data"] objectForKey: @"list"] count] == 0) {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有数据" forError: YES];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError: YES];
        }
        
        
        if (pag == 1) {
            vc.array =  [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        else
        {
            [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey: @"list"]];
        }
        if (pag == 1) {
            [vc.tableView.pullToRefreshView stopAnimating];
        }else
        {
            [vc.tableView.infiniteScrollingView stopAnimating];
        }
        [vc.tableView reloadData];

    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"LCHelpTableViewCell";
    LCHelpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
    }
    NSDictionary * dic = self.array[indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
    cell.content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"content"]];
    NSArray * array = [dic objectForKey:@"company_list"];
    NSDictionary * diccc = [array firstObject];
    NSString * cityStr = [NSString getAllArea:diccc];
    NSString * indusstr = [NSString getIndusryName:diccc];
    cell.province.text = [NSString stringWithFormat:@"%@%@, %@%@", Left_Brackets,cityStr, indusstr, Right_Brackets];
    
    [cell.like setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"like_number"]] forState:UIControlStateNormal];
    [cell.like addTarget:self action:@selector(likeTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.comment setTitle:[NSString stringWithFormat:@"%@", [dic objectForKey:@"comment_number"]] forState:UIControlStateNormal];
    cell.time.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"update_time"]];
    return cell;

}
- (void)likeTap:(UIButton *)btn
{
    LCHelpTableViewCell * cell = (UITableViewCell *)[[[btn superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    int num = [cell.like.titleLabel.text integerValue];
    NSLog(@"%d", path.row);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak AskForHelpViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Like_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_id":[self.array[path.row] objectForKey:@"help_id"], @"x_type":@"10"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:dictionary[@"message"] forError:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
            [cell.like setTitle:[NSString stringWithFormat:@"%d", num +1] forState:UIControlStateNormal];
        }
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCHelpDetailViewController * helpDetailVC = [[LCHelpDetailViewController alloc] init];
    helpDetailVC.help_id = [self.array[indexPath.row] objectForKey:@"help_id"];
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
