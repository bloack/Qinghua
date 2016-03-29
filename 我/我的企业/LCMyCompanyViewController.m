//
//  LCMyCompanyViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyCompanyViewController.h"
#import "LCAddCompanyViewController.h"
#import "LCCompanyTableViewCell.h"
#import "CompanyDetailViewController.h"
@interface LCMyCompanyViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation LCMyCompanyViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                self.hidesBottomBarWhenPushed = YES;
        self.title = @"我的企业";
    }
    return self;
}
- (IBAction)add:(id)sender {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"我的企业";
    if ([self.user_id isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
            [self.myNavbar setRight1ButtonWithnormalImageName:@"qinghua-huodong+.png" highlightedImageName:@"qinghua-huodong+.png" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectMake(277, 6, 29, 31)];
    }
    else
    {
        self.titleString = @"企业列表";
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.addBtn addTarget:self action:@selector(addCompany) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)right1ButtonClick
{
    [self addCompany];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [self getData];
    });
    self.myNavbar.right1Button.userInteractionEnabled = NO;
}
- (void)getData
{
    __block LCMyCompanyViewController * blockSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":self.user_id?self.user_id:[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        NSLog(@"地产 == %@", dictionary);
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        blockSelf.array = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
        [blockSelf.tableView reloadData];
        blockSelf.myNavbar.right1Button.userInteractionEnabled = YES;
    }];
}
- (void)addCompany
{
    if (self.array.count >=3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的企业已经超过三个, 不能继续添加" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
    [self.navigationController pushViewController:[[LCAddCompanyViewController alloc] init] animated:YES];
    }
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

    if ([self.user_id isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
        vc.isMyCom = YES;
    }
    else
    {
        vc.isMyCom = NO;
    }
    
    vc.com_id = [self.array[indexPath.row] objectForKey:@"company_id"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
