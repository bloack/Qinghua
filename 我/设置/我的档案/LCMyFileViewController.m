//
//  LCMyFileViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyFileViewController.h"
#import "LCDataTableViewCell.h"
#import "LCIconAndBackTableViewCell.h"
#import "ChatViewController.h"
#import "NSString+MD5.h"
#import "LCIntruoduceOtherViewController.h"
#import "LCMyCompanyViewController.h"
#import "MySelfViewController.h"
@interface LCMyFileViewController ()
@property (nonatomic, retain)NSArray * array1, *array2, *array3, *array4, *array5, *array6;
@property (nonatomic, retain)NSDictionary * dic;
@end

@implementation LCMyFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
    self.array3 = @[@"移动电话", @"电子邮件", @"公司地址", @"城市", @"生日", @"性别", @"班级", @"学校"];
    if ([self.user_id isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
            [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"更新" titleColor:nil buttonFram:CGRectZero];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    MySelfViewController * controller = [[MySelfViewController alloc]init];
    
    controller.lastDic = self.dic;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)pop
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)getData
{
    NetWork * net = [NetWork shareNetWork];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":self.user_id};
//    __block LCMyFileViewController * blockSelf = self;
    __weak typeof(self)blockSelf = self;

    [net getDataWithURLStr:UserDetail_URL aImage:nil aBody:dic aSuccessBlock:^(id myDictionary) {
        blockSelf.dic = [myDictionary  objectForKey:@"data"];
        blockSelf.titleString = blockSelf.dic[@"real_name"];
        if ([self.user_id isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
            blockSelf.titleString = @"我的档案";
            blockSelf.isMe = YES;
        }
        else
        {
            blockSelf.titleString = [NSString stringWithFormat:@"%@的档案", blockSelf.dic[@"real_name"]];
        }
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        NSDictionary * dict = @{@"1": @"男", @"2":@"女", @"0":@"保密"};
        NSString * cityStr = [NSString getAllArea:self.dic];
 
        NSDictionary * compa_dic = [blockSelf.dic[@"company_list"] firstObject];
        NSString * indusstr = [NSString getIndusryName:compa_dic];

        NSMutableString * favouriteStr = [NSMutableString string];
        for (NSDictionary * diccc in blockSelf.dic[@"interest_list"]) {
            [favouriteStr appendString:[NSString stringWithFormat:@"%@  ", diccc[@"name"]]];
        }
        blockSelf.array4 = [NSArray arrayWithObjects:[compa_dic objectForKey:@"company_name"]?:@"", indusstr?:@"", [compa_dic objectForKey:@"position"]?:@"",[blockSelf.dic objectForKey:@"intro"]?:@"",[blockSelf.dic objectForKey:@"signature"]?:@"",favouriteStr?:@"", nil];
        
        blockSelf.array5 = [NSArray arrayWithObjects:[blockSelf.dic objectForKey:@"weibo"], [blockSelf.dic objectForKey:@"weixin"], nil];
        NSString * school = [blockSelf.dic objectForKey:@"school"];
        NSMutableString *className = [NSMutableString string];
        for (NSDictionary *classDic in self.dic[@"class_list"]) {
            [className appendString:[NSString stringWithFormat:@"%@  ", classDic[@"class_name"]]];
        }
        
        blockSelf.array6 = [NSArray arrayWithObjects:[blockSelf.dic objectForKey:@"mobile_phone"], [blockSelf.dic objectForKey:@"email"],[blockSelf.dic objectForKey:@"email"],cityStr,[blockSelf.dic objectForKey:@"brithday"],[dict objectForKey:[blockSelf.dic objectForKey:@"gender"]],className,@"清华大学",nil];
        [blockSelf.tableView reloadData];
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.isMe == YES) {
            return 80;
        }
        else
        {
            return 130;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 3) {
            CGFloat flo = [self.dic[@"intro"] getHightWithfontSize:239] + 20;
            return flo;
        }
    
    }
    return 40;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            static NSString * cellID = @"LCIconAndBackTableViewCell";
            LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
            }
    
            [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
            NSArray * aArray = [self.dic objectForKey:@"company_list"];
            NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
            NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
 
        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  [[[LCAppDelegate  shared].dict_City objectForKey:[self.dic objectForKey:@"city"]] objectForKey:@"name"],[[[LCAppDelegate shared].dict_Industry objectForKey:[self.dic objectForKey:@"city"]] objectForKey:@"occupation_id"], Right_Brackets];
            cell.company.text = company;
            cell.position.text = position;
            cell.intro.hidden = YES;
            [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
            cell.name.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"real_name"]];
            cell.level.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"parent_level_name"]];
            [cell buildChild:[self.dic objectForKey:@"child_level_icon"] parent:[self.dic objectForKey:@"parent_level_icon"]];
            
            if (self.isMe == YES) {
                cell.firstButton.hidden = YES;
                cell.secButton.hidden = YES;
            }
            else
            {
                [cell.firstButton setTitle:@"聊天" forState: UIControlStateNormal];
                [cell.secButton setTitle:@"引荐" forState: UIControlStateNormal];
                
                [cell.firstButton addTarget:self action:@selector(goToChat) forControlEvents:UIControlEventTouchUpInside];
                [cell.secButton addTarget:self action:@selector(introduceToOther) forControlEvents:UIControlEventTouchUpInside];
            }
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
                if (indexPath.row == 3) {
                    cell.detail.frame = CGRectMake(81, 11, 239, [self.dic[@"intro"] getHightWithfontSize:239]);
                }
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
        LCMyCompanyViewController  *company = [[LCMyCompanyViewController alloc] init];
        company.user_id = self.user_id;
        [self.navigationController pushViewController:company animated:YES];
    }
}
- (void)introduceToOther
{
    LCIntruoduceOtherViewController * vc =  [[LCIntruoduceOtherViewController alloc] init];
    vc.user_id = self.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToChat
{
    if (self.isChat == YES) {
        [self goBack];
    }
    else
    {
        ChatViewController * userVC = [[ChatViewController alloc] init];
        userVC.friendModel = [[FriendModel alloc]initWithDic:self.dic];
        [FriendDao insertFriendTableWith:userVC.friendModel];
        
        NSString * userName = [self.dic objectForKey:@"username"];
        NSString * realName = [self.dic objectForKey:@"real_name"];
        NSString * avatar = [self.dic  objectForKey:@"avatar"];
        ;
        userVC.unionNickName = [NSString stringWithFormat:@"%@@%@,%@,%@",userName,XMPP_SERVER_URL, realName,avatar];
        
        userVC.user_id = self.user_id;
        userVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userVC animated:YES];

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
@end
