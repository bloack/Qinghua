//
//  LCMyIntegrationViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyIntegrationViewController.h"
#import "LCCredictTableViewCell.h"
#import "LCJifenViewController.h"
@interface LCMyIntegrationViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation LCMyIntegrationViewController
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
    self.titleString = @"我的积分";
    self.page = 1;
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"积分规则" titleColor:nil buttonFram:CGRectZero];
    __weak LCMyIntegrationViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    [self.tableView triggerPullToRefresh];

    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    [self.navigationController pushViewController:[[LCJifenViewController alloc] init] animated:YES];
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
    __weak LCMyIntegrationViewController * blockSelf = self;
    NSDictionary *dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"current_page":[NSString stringWithFormat:@"%d", pag]};
    [[NetWork shareNetWork] netWorkWithURL:Credit_URL dic:dic setSuccessBlock:^(id dictionary){
        
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
        
        for (NSDictionary * dic in blockSelf.array) {
            
            int sum = [dic[@"change_credit"] integerValue];
            int sss = sss + sum;
            printf("%d", sss);
        }
        
        [blockSelf.tableView reloadData];


    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"LCCredictTableViewCell";
    LCCredictTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
    }
    [cell getDataWithDic:self.array[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
