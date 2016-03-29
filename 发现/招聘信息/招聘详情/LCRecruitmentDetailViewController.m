//
//  LCRecruitmentDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCRecruitmentDetailViewController.h"
#import "LCLablesTableViewCell.h"
#import "NSString+MD5.h"
#import "LCIconAndBackTableViewCell.h"
#import "CompanyDetailViewController.h"
@interface LCRecruitmentDetailViewController ()

@end

@implementation LCRecruitmentDetailViewController

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
    self.titleString = @"招聘详情";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"职位名称", @"行业", @"招聘人数", @"薪资", @"工作地点",@"招聘时间", @"工作内容", @"联系方式"];
    [self getList];
    // Do any additional setup after loading the view from its nib.
}
- (void)getList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCRecruitmentDetailViewController   *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Recuitment_Detail dic:@{@"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"], @"recruitment_id":self.rec_id} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        NSLog(@"%@", dictionary);
        self.rec_dic = [[dictionary objectForKey:@"data"] objectForKey:@"recruitment_info"];
        self.titleString = vc.rec_dic[@"title"];
        [self.tableView reloadData];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 80;
    }
    else
        return 42;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array1.count;
    }
    else
        return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"职位信息";
    }
    else
        return @"公司信息";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

    static NSString * cellID = @"LCLablesTableViewCell";
    LCLablesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
        switch (indexPath.row) {
            case 0:
                cell.contentLable.text = [self.rec_dic objectForKey:@"position"];
                break;
            case 1:
                cell.contentLable.text = [NSString getIndusryName:self.rec_dic];
                break;
            case 2:
                cell.contentLable.text  = [self.rec_dic objectForKey:@"number"];
                break;
            case 3:
                cell.contentLable.text = [NSString stringWithFormat:@"%@ 万元", [self.rec_dic objectForKey:@"annual_salary"]];
                break;
            case 4:
                cell.contentLable.text = [self.rec_dic objectForKey:@"work_address"];
                break;
            case 5:
                cell.contentLable.text = [self.rec_dic objectForKey:@"update_time"];
                break;
            case 6:
                cell.contentLable.text = [self.rec_dic objectForKey:@"content"];
                break;
                case 7:
                cell.contentLable.text = self.rec_dic[@"contact"];
            default:
                break;
        }
        cell.titleLable.text = self.array1[indexPath.row];
        return cell;
        
    }
    else if (indexPath.section == 1) {
        static NSString * cellId = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
            cell.firstButton.hidden = YES;
            cell.secButton.hidden = YES;
        }
        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.rec_dic objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
        cell.name.text = [self.rec_dic objectForKey:@"company_name"];
        cell.intro.hidden = YES;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] init];
        vc.com_id = self.rec_dic[@"company_id"];
        vc.isMyCom = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
