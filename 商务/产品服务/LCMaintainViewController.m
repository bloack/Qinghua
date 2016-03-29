//
//  LCMaintainViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-28.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMaintainViewController.h"
#import "LCAddCompanyViewController.h"
#import "LCCompanyTableViewCell.h"
#import "CompanyDetailViewController.h"
@interface LCMaintainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain)NSArray * array;
@end

@implementation LCMaintainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"企业维护";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"qinghua-huodong+.png" highlightedImageName:@"qinghua-huodong+.png" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectMake(277, 6, 29, 31)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self getData];
}
- (void)getData
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMaintainViewController *vc = self;

        [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult  objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        NSLog(@"地产 == %@", dictionary);
        vc.array = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
        [vc.tableView reloadData];
    }];
}
- (void)right1ButtonClick
{
    [self.navigationController pushViewController:[[LCAddCompanyViewController alloc] init] animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"LCCompanyTableViewCell";
    LCCompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = self.array[indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
    cell.name.text = [dic objectForKey:@"company_name"];
    cell.representative.hidden = YES;
    cell.adress.hidden = YES;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyDetailViewController * vc =  [[CompanyDetailViewController alloc] init];
    vc.isMyCom = YES;
    vc.com_id = [self.array[indexPath.row] objectForKey:@"company_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
