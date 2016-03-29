//
//  LCMyReviewViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyReviewViewController.h"
#import "LCMyReviewTableViewCell.h"
#import "LCUserDataViewController.h"
#import "UserDetailViewController.h"
#import "LCMyFileViewController.h"
#import "NSString+MD5.h"
@interface LCMyReviewViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSArray * array;
@end

@implementation LCMyReviewViewController
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
    self.titleString = @"最近访客";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getList];
}
- (void)getList
{
    NetWork * net = [NetWork shareNetWork];
    __weak LCMyReviewViewController * blockSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"]};
    [net getDataWithURLStr:Visit_List_URL aImage:nil aBody:dic aSuccessBlock:^(id dictionary){
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        blockSelf.array = [[dictionary objectForKey:@"data"] objectForKey:@"visitor_list"];
        [blockSelf.tableView reloadData];
        NSLog(@"%@", dictionary);
    }setFailBlock:^(id obj) {
        
    } ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"LCMyReviewTableViewCell";
    LCMyReviewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    [cell.icon setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
    NSArray * aArray = [dic objectForKey:@"company_list"];
    NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
    NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
    cell.company.text = company;
    cell.position.text = position;
    /**
     *  城市
     */

    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  [NSString getAllArea:[aArray firstObject]],[NSString getIndusryName:[aArray  firstObject]], Right_Brackets];

    cell.time.text = [dic objectForKey:@"visitor_time"];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"最近15天看过我的人";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：用户详情
     */
    
    NSDictionary * dic = self.array[indexPath.row];
    
    if ([dic[@"is_friend"] integerValue] == 1) {
        LCMyFileViewController * vc = [[LCMyFileViewController   alloc] init];
        vc.isMe = NO;
        vc.isChat = NO;
        vc.user_id = [dic  objectForKey:@"user_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UserDetailViewController * vc = [[UserDetailViewController alloc] init];
        vc.userid = [dic  objectForKey:@"user_id"];
        [self.navigationController pushViewController:vc animated:YES];

        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
