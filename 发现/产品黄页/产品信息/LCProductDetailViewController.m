//
//  LCProductDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-25.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCProductDetailViewController.h"
#import "LCIconAndBackTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "IBActionSheet.h"
#import "ProductViewController.h"
#import "CycleScrollView.h"
#import "LCLablesTableViewCell.h"
#import "NSString+MD5.h"
#import "UIButton+Block.h"
@interface LCProductDetailViewController ()<NetWorkDelegate, UITableViewDataSource, UITableViewDelegate, IBActionSheetDelegate>
@property (nonatomic, retain)NSArray * array1, *array2, *picArray;
@property (nonatomic, retain)NSDictionary * dataDictionay;
@end

@implementation LCProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)pop:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"产品信息";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"产品名称", @"行业", @"经营模式", @"产品描述", @"品牌名称", @"所属区域",@"销售区域", @"发布时间", @"单价", @"供货单位", @"最小供货量", @"最大供货量", @"标签"];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getdata];

    if (self.isMain == YES) {
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    }
}
- (void)right1ButtonClick
{
    NSLog(@"1");
    IBActionSheet * sheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"更新" otherButtonTitles:@"删除", @"取消", nil];
    [sheet setFont:[UIFont systemFontOfSize:13.0]];
    [sheet showInView:self.view];
}
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            ProductViewController * vc = [[ProductViewController alloc] init];
            vc.isMain = YES;
            vc.product_id = self.product_id;
            vc.dataDic = self.dataDictionay;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 1:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak LCProductDetailViewController *vc = self;
            [[NetWork    shareNetWork] netWorkWithURL:Product_Delete dic:@{@"user_id":[MyUserDefult objectForKey:@"UserId"], @"product_id":self.product_id} setSuccessBlock:^(id dictionary) {
                
                if ([[dictionary objectForKey:@"status"]isEqualToString:@"200"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"删除成功" forError: YES];
                        [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError: YES];
                    });
                }
            }
             setFailBlock:^(id obj) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                     [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                 });
             }
             
             
             ];
        
        }
            break;
        default:
            break;
    }
}
- (void)getdata
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"product_id":self.product_id};
    __weak LCProductDetailViewController *vc = self;
    [[NetWork shareNetWork] getDataWithURLStr:Product_Detail aImage:nil aBody:dic aSuccessBlock:^(id dictionary){
        NSLog(@"dic = %@", dictionary);
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.picArray = [dictionary objectForKey:@"paths"];
        NSDictionary * dataDic = [[dictionary objectForKey:@"data"] objectForKey:@"product_info"];
        vc.dataDictionay = dataDic;
        
        NSString * cityStr = [NSString getAllArea:dataDic];
        
        NSString * indusstr = [NSString getIndusryName:dataDic];

        NSDictionary *adic = @{@"0": @"批发", @"1":@"经销", @"2":@"零售"};
        NSString *business_pattern = dataDic[@"business_pattern"];
        NSMutableString *patten = [NSMutableString string];
        NSArray *ary = [business_pattern componentsSeparatedByString:@","];
        for (NSString *str in ary) {
            NSString *sss = [adic objectForKey:str];
            if (sss != nil) {
                [patten appendString:[NSString stringWithFormat:@"%@  ",sss]];

            }
        }
        
        vc.array2 = [NSArray arrayWithObjects:[dataDic objectForKey:@"product_name"],indusstr,patten,[dataDic objectForKey:@"description"], [dataDic objectForKey:@"brand_name"],dataDic[@"product_area"],dataDic[@"sales_area"],[dataDic objectForKey:@"update_time"],[NSString stringWithFormat:@"%@元", dataDic[@"unit_price"]], [dataDic objectForKey:@"support_unit"], dataDic[@"support_min"],dataDic[@"support_max"],dataDic[@"tag"],nil];
            [vc.tableView reloadData];
    }
    setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }
     ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.array2.count;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
            case 1:
            return 40;
            break;
            case 2:
            return 80;
            break;
        default:
            break;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"产品基本信息";
            break;
            case 2:
            return @"企业信息";
        default:
            break;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:cell.frame];
        scrollView.contentSize = CGSizeMake(70 * [self.dataDictionay[@"paths"] count], 70);
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:0];
        __weak LCProductDetailViewController *blockSelf = self;
        for (int i = 0; i < [self.dataDictionay[@"paths"] count]; i ++) {

            UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 70 *i, 5, 60, 60)];
            [button setImageWithURL:[NSURL URLWithString:[self.dataDictionay[@"paths"] objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"120.png"]];
            [scrollView addSubview:button];
            [cell addSubview:scrollView];
        }
        [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTAP)]];
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString * cellId = @"LCIconAndBackTableViewCell";
        LCIconAndBackTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
            cell.firstButton.hidden = YES;
            cell.secButton.hidden = YES;
        }
        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.dataDictionay objectForKey:@"company_logo"]]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
        cell.name.text = [self.dataDictionay objectForKey:@"company_name"];
        cell.intro.hidden = YES;
        return cell;
    }
    else{
    static NSString * cellId = @"LCLablesTableViewCell";
        LCLablesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell =[[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
        }
        cell.titleLable.text = self.array1[indexPath.row];
        cell.contentLable.text = self.array2[indexPath.row];
        return cell;
    }
    return nil;
}
- (void)scrollViewTAP
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:0];
    for (NSString *path in self.dataDictionay[@"paths"]) {
        NSLog(@"%@", path);
        FSBasicImage *aImage = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:path]];
        [ary addObject:aImage];
    }
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:ary];
    
    FSImageViewerViewController * imageVC = [[FSImageViewerViewController alloc]initWithImageSource:photoSource imageIndex:0];
    imageVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:imageVC animated:YES];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        CompanyDetailViewController * vc = [[CompanyDetailViewController alloc] init];
        vc.com_id = self.dataDictionay[@"company_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
   else if (indexPath.section == 0) {

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
