//
//  CompanyDetailViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "ChatViewController.h"
#import "LCAddCompanyViewController.h"
#import "LCIconAndBackTableViewCell.h"
#import "IndustryDao.h"
#import "NSString+MD5.h"
#import "LCLablesTableViewCell.h"
#import "LCMyFileViewController.h"
#import "UserDetailViewController.h"
@interface CompanyDetailViewController ()
@property (nonatomic, retain)NSArray * array1, *array2;
@property (nonatomic, retain)NSArray * array4, * array5;
@property (nonatomic, retain)NSDictionary * dataDic;
@end

@implementation CompanyDetailViewController
- (IBAction)dimiss:(id)sender {
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
- (IBAction)exchangeCard:(id)sender {
    /*
     
     *交换名片
     */
}
- (IBAction)personalMail:(id)sender {
    /*
     
     *发送私信
     */
    ChatViewController * chatView = [[ChatViewController alloc] init];
    [self presentViewController:chatView animated:NO completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"企业介绍";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.array1 = @[@"公司名称", @"行业", @"注册资金", @"经营项目", @"职位"];
    self.array2 = @[@"城市",@"地址"];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

    [self getData];

    
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    if (_isMyCom == YES) {
        self.myNavbar.right1Button.hidden = NO;
    }
    else
    {
        self.myNavbar.right1Button.hidden = YES;
    }
//    [self.bianjiBtn addTarget:self action:@selector(bianji) forControlEvents:UIControlEventTouchUpInside];
}

-(void)right1ButtonClick
{
    [self bianji];
}
- (void)bianji
{
    LCAddCompanyViewController * vc = [[LCAddCompanyViewController alloc] init];
    vc.formatDic = self.dataDic;
    vc.isMain = YES;
    vc.com_id = self.com_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            case 1:
            return self.array4.count;
            break;
            case 2:
            return self.array5.count;
            break;
            case 3:
            return 1;
            break;
        default:
            return 1;
            break;
    }
    return 0;
}
- (void)getData
{
    NSString * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"company_id":self.com_id?self.com_id:self.com_id?self.com_id:@"1"};
    __weak CompanyDetailViewController *vc = self;
    [[NetWork shareNetWork] getDataWithURLStr:Company_detail aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        vc.dataDic = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
        
        if ([[vc.dataDic allKeys] count] != 0) {
            NSArray * array = [[LCAppDelegate shared].dict_Industry allValues];
            NSString * cityStr = [NSString getAllArea:vc.dataDic];
            NSString * indusstr = [NSString getIndusryName:vc.dataDic];
            vc.array4 = [NSArray arrayWithObjects:[vc.dataDic objectForKey:@"company_name"], indusstr, [vc.dataDic objectForKey:@"capital"], [vc.dataDic objectForKey:@"business"], vc.dataDic[@"position"],nil];

            vc.array5 = @[cityStr, [vc.dataDic objectForKey:@"address"]];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有该企业信息" forError: YES];

            });

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [vc.tableView reloadData];
        });
    }
     setFailBlock:^(id obj) {
         [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
     }
     ];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    else if(indexPath.section == 3)
    {
        tableView.separatorColor = [UIColor whiteColor];
        int a = [[self.dataDic objectForKey:@"intro"] getHightWithfontSize:300] + 20;
        return a;
    }
    else if(indexPath.section == 5)
    {
        return 80;
    }
    else
        return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"职业信息";
            break;
            case 2:
            return @"联系信息";
            break;
            case 3:
            return @"企业介绍";
            break;
            case 4:
            return @"企业相册";
            break;
            case 5:
            return @"企业联系人";
        default:
            
            break;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellId = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
        }
        cell.intro.hidden = YES;
        cell.firstButton.hidden = YES;
        cell.secButton.hidden = YES;
        if (indexPath.section == 0) {
            [cell.iconImage setImageWithURL:[NSURL URLWithString: [self.dataDic objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
            cell.name.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"company_name"]];
            cell.province.text = [NSString stringWithFormat:@"法人:%@", self.dataDic[@"representative"]];
        }
        return cell;
    }
    else if(indexPath.section == 3){
        static NSString *cellID = @"LCOnlyLableTableViewCell";
        LCOnlyLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        cell.contentLable.text = self.dataDic[@"intro"];
        return cell;
    }

    else if (indexPath.section == 4){
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
        [aImageView setImageWithURL:[NSURL URLWithString:self.dataDic[@"image"]]];
        [cell addSubview:aImageView];
        return cell;
    }
    else if(indexPath.section == 1||indexPath.section == 2)
    {
        static NSString * cellId = @"LCLablesTableViewCell";
        LCLablesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
          }
        if (indexPath.section == 1) {
            cell.titleLable.text = self.array1[indexPath.row];
             cell.contentLable.text = self.array4[indexPath.row];


        }
        else if(indexPath.section == 2){
            cell.titleLable.text = self.array2[indexPath.row];
          
            cell.contentLable.text = self.array5[indexPath.row];

        }
        return cell;
    }
    else if(indexPath.section ==  5)
    {
        static NSString * cellId = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
        }
            [cell.iconImage setImageWithURL:[NSURL URLWithString: [self.dataDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
            cell.name.text = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"real_name"]];
        cell.firstButton.hidden = YES;
        cell.secButton.hidden = YES;
        return cell;

    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        if ([self.dataDic[@"is_friend"] integerValue] == 0) {
            UserDetailViewController *vc = [[UserDetailViewController alloc] init];
            vc.userid = self.dataDic[@"user_id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([self.dataDic[@"is_friend"] integerValue] == 1){
            LCMyFileViewController  *vc = [[LCMyFileViewController   alloc] init];
            if ([self.dataDic[@"user_id"] isEqualToString:[MyUserDefult objectForKey:@"UserID"]]) {
                vc.isMe = YES;
            }
            vc.user_id = self.dataDic[@"user_id"];
            vc.isChat = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if(indexPath.section == 4)
    {
        NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:0];
        FSBasicImage * basicImage = [[FSBasicImage alloc]initWithImageURL:[NSURL URLWithString:self.dataDic[@"image"]]];
        [imageArray addObject:basicImage];
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
        
        FSImageViewerViewController * imageVC = [[FSImageViewerViewController alloc]initWithImageSource:photoSource imageIndex:0];
        imageVC.navigationController.navigationBarHidden = NO;
        if ([self.dataDic[@"image"] length]) {
            [self.navigationController pushViewController:imageVC animated:YES];
        }
        else
        {
        
        }
    }
}
- (void)messageTalk
{
    NSLog(@"1");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
