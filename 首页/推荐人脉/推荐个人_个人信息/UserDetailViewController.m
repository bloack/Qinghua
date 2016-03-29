//
//  UserDetailViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "UserDetailViewController.h"
#import "ChatViewController.h"
#import "LCIconAndBackTableViewCell.h"
#import "LCDataTableViewCell.h"
#import "LCMessageTalkViewController.h"
#import "SystemManager.h"
#import "LCMyCompanyViewController.h"
#import "LCAddFriends.h"
#import "NSString+MD5.h"
@interface UserDetailViewController ()
@property (nonatomic, retain)NSArray * array1, *array2, *array3, *array4, *array5, *array6;
@property (nonatomic, retain)NSDictionary * dic;
@property (nonatomic, assign)BOOL isME;
@end

@implementation UserDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"人脉详情";
    }
    return self;
}
- (IBAction)personalMail:(id)sender {
    /*
     *发送私信
     */
    ChatViewController * chatView = [[ChatViewController alloc] init];
    [self presentViewController:chatView animated:NO completion:^{
        
    }];
}
/**
 *  添加好友
 *
 *  @param sender
 */
- (IBAction)exchangeCard:(id)sender {
    /*
     *交换名片
     */
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"公司", @"行业", @"职务", @"自我介绍", @"个性签名", @"个人兴趣"];
    self.array2 = @[ @"新浪微博", @"微信"];
    self.array3 = @[@"移动电话", @"电子邮件", @"地址", @"城市", @"生日", @"性别", @"班级", @"学校"];
    // Do any additional setup after loading the view from its nib.
}
- (void)getData
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":self.userid?self.userid:@"0"};
    NSDictionary * sexDic = @{@"1": @"男", @"2":@"女", @"0":@"保密"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak UserDetailViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:UserDetail_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.dic = [dictionary  objectForKey:@"data"];
        self.titleString = vc.dic[@"real_name"];
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        NSDictionary * dict = @{@"1": @"男", @"2":@"女", @"0":@"保密"};
        NSString * cityStr = [NSString getAllArea:vc.dic];
        NSDictionary * compa_dic = [self.dic[@"company_list"] firstObject];
        NSString * indus_name = [NSString getIndusryName:compa_dic];
        NSMutableString * favouriteStr = [NSMutableString string];
        for (NSDictionary * diccc in self.dic[@"interest_list"]) {
            [favouriteStr appendString:[NSString stringWithFormat:@"%@  ", diccc[@"name"]]];
        }
        self.array4 = [NSArray arrayWithObjects:[compa_dic objectForKey:@"company_name"], indus_name, [compa_dic objectForKey:@"position"],[self.dic objectForKey:@"intro"],[self.dic objectForKey:@"signature"],favouriteStr, nil];
        self.array5 = [NSArray arrayWithObjects: [self.dic objectForKey:@"weibo"], [self.dic objectForKey:@"weixin"], nil];
        NSString * school = [self.dic objectForKey:@"school"];
        NSMutableString *className = [NSMutableString string];
        for (NSDictionary *classDic in self.dic[@"class_list"]) {
          [className appendString:[NSString stringWithFormat:@"%@  ", classDic[@"class_name"]]];
        }
        
        self.array6 = [NSArray arrayWithObjects:
                       @"交换名片成功才能查看该人脉邮件",@"交换名片成功才能查看该人脉移动电话",
                       @"交换名片成功才能查看该人脉地址",
                       cityStr,
                       [self.dic objectForKey:@"brithday"],
                       [sexDic objectForKey:[self.dic objectForKey:@"gender"]], className,
                       @"清华大学",nil];
        
        if ([vc.dic[@"is_friend"] integerValue] == 1) {
            vc.isFriend = YES;
        }
        [self.tableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.array4.count;
    }
    else if (section == 2)
    {
        return self.array5.count;
    }
    else if (section == 3)
    {
        return self.array6.count;
    }
    else if (section == 0)
    {
        return 1;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"职业信息";
    }
    else if (section == 2)
    {
        return @"社交信息";
    }
    else if (section == 3)
    {
        return @"基本资料";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellID = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];

        }
        [cell.secButton setTitle:@"交换名片" forState:UIControlStateNormal];
        
        [cell.firstButton addTarget:self action:@selector(messageTalk:) forControlEvents:UIControlEventTouchUpInside];
        [cell.secButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_isEXchange == YES) {
            cell.firstButton.hidden = YES;
            cell.secButton.hidden = YES;
        }
        
        [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
        cell.intro.hidden = YES;
        NSArray * aArray = [self.dic objectForKey:@"company_list"];
        NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
        NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,[[[LCAppDelegate shared].dict_City objectForKey:[self.dic objectForKey:@"city"]] objectForKey:@"name"],[[[LCAppDelegate shared].dict_City objectForKey:[self.dic objectForKey:@"occupation_id"]] objectForKey:@"name"], Right_Brackets];
        cell.company.text = company;
        cell.position.text = position;
        [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
        cell.name.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"real_name"]];
        cell.level.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"parent_level_name"]];
        [cell buildChild:[self.dic objectForKey:@"child_level_icon"] parent:[self.dic objectForKey:@"parent_level_icon"]];
        return cell;
    }
    else
    {
        static NSString * cellID = @"LCDataTableViewCell";
        LCDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        if (indexPath.section == 1&&indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        if (indexPath.section == 1) {
            cell.nale.text = self.array1[indexPath.row];
            cell.detail.text = self.array4[indexPath.row];
        }
        else if (indexPath.section == 2)
        {
            cell.nale.text = self.array2[indexPath.row];
            cell.detail.text = self.array5[indexPath.row];
        }
        else if (indexPath.section == 3)
        {
            cell.nale.text = self.array3[indexPath.row];
            cell.detail.text = self.array6[indexPath.row];
        }
        return cell;
    }
    
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&indexPath.row == 0) {
        LCMyCompanyViewController *company = [[LCMyCompanyViewController alloc] init];
        company.user_id = self.userid;
        [self.navigationController pushViewController:company animated:YES];
        
    }

}
- (NSString *)bindDomain:(NSString *)jid
{
    NSString *str = [NSString stringWithFormat:@"%@@%@",jid,XMPP_SERVER_URL];
    return str;
}

- (void)addFriend:(UIButton *)btm
{
    [[LCAddFriends shareAddFriend] addFriendWith:self.dic[@"user_name"] vc:self];
}
- (void)messageTalk:(UIButton *)button
{
    LCMessageTalkViewController * vc = [[LCMessageTalkViewController alloc] init];
    vc.user_id = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"user_id"]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)dimiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
