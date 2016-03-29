//
//  LCUserDataViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCUserDataViewController.h"
#import "LCIconAndBackTableViewCell.h"
#import "LCDataTableViewCell.h"
@interface LCUserDataViewController ()
@property (nonatomic, retain)NSArray * array1, *array2, *array3;
@property (nonatomic, retain)NSDictionary * dic;
@end

@implementation LCUserDataViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"人脉详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"详情";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"公司", @"行业", @"职务", @"自我介绍", @"个性签名", @"个人兴趣"];
    self.array2 = @[@"商业人脉", @"新浪微博", @"微信"];
    self.array3 = @[@"移动电话", @"电子邮件", @"网站", @"公司地址", @"城市", @"生日", @"性别", @"学校", @"班级"];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
- (void)getData
{
    NetWork * net = [NetWork shareNetWork];
    net.delegate = self;
    NSDictionary * dic = @{@"user_id": @"1", @"visit_user_id":@"2"};
    [net netWorkWithType:@"POST" url:[NSString stringWithFormat:@"%@%@", URL_BASE, UserDetail_URL] body:dic];
}
- (void)recieveDataSuccessWithNetwork:(NetWork *)net Object:(id)object
{
    self.dic = [object  objectForKey:@"data"];
    NSLog(@"%@", self.dic);
    
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.array1.count;
    }
    else if (section == 2)
    {
        return self.array2.count;
    }
    else if (section == 3)
    {
        return self.array3.count;
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
- (void)exchangeCard:(UIButton *)button
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellID = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
            cell.firstButton.hidden = YES;
            [cell.secButton setTitle:@"交换名片" forState: UIControlStateNormal];
            [cell.secButton addTarget:self action:@selector(exchangeCard:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.iconImage setImageWithURL:[self.dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
        cell.name.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"real_name"]];
        cell.company.text = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"username"]];
        return cell;
    }
    else
    {
        static NSString * cellID = @"LCDataTableViewCell";
        LCDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        if (indexPath.section == 1) {
            cell.nale.text = self.array1[indexPath.row];
        }
        else if (indexPath.section == 2)
        {
            cell.nale.text = self.array2[indexPath.row];
        }
        else if (indexPath.section == 3)
        {
            cell.nale.text = self.array3[indexPath.row];
        }
        
        cell.detail.text = [self.dic objectForKey:@"nickname"];
        return cell;
    }
    return nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
