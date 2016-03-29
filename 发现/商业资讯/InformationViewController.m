//
//  InformationViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "InformationViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCInfoListViewController.h"
#import "FeedbackViewController.h"
#import "IndustrySheet.h"
#import "NSString+MD5.h"
@interface InformationViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * allArray, *otherArray, *myArray;
@property (nonatomic, retain)NSArray * myIndusArray;
@end

@implementation InformationViewController
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
    self.titleString = @"商业资讯";

    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"反馈" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Do any additional setup after loading the view from its nib.
}
- (void)favouriteList
{
     __weak InformationViewController * blockSelf = self;
    [[NetWork shareNetWork] netWorkWithURL:favorites_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"2"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        blockSelf.myIndusArray = [[dictionary objectForKey:@"data"] objectForKey:@"list"];
        
        NSMutableArray * ary = [NSMutableArray arrayWithArray:[IndustryDao selectAllDataForDistrict]];
        
        for (int i = 0; i < ary.count; i ++) {
            Industry * indus = ary[i];
            for (int j = 0; j < blockSelf.myIndusArray.count; j ++) {
                NSDictionary * dic = blockSelf.myIndusArray[j];
                
                if ([indus.ID isEqualToString:dic[@"x_id"]]) {
                    [ary removeObject:indus];
                }
            }
        }
        
         
        blockSelf.allArray = [NSMutableArray arrayWithArray:ary];

        [[NetWork  shareNetWork] getDataWithURLStr:Company_me aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult  objectForKey:@"UserId"]} aSuccessBlock:^(id dictionary) {
            NSArray * ary = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
            for (NSDictionary * company_dic in ary) {
                if ([company_dic[@"industry_id"] intValue] >= 101) {
                    [blockSelf.myArray addObject:company_dic];
                }
            }
            [blockSelf.tableView reloadData];
        } setFailBlock:^(id obj) {
            
        }];
        

//        NSLog(@"%@", self.allArray);
    }
        setFailBlock:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络请求错误" forError:YES];
                                  });
                                  
                              }
     
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.myArray = [NSMutableArray arrayWithCapacity:0];

    [self  favouriteList];

}

-(void)right1ButtonClick
{
    [self respect:nil];
}

- (IBAction)respect:(id)sender {
    /*
     
     *反馈
     */
    [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return self.myArray.count;
    }else if(section == 1)
    {
        return self.myIndusArray.count;
    }
    else if (section == 2)
    {
    return self.allArray.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"我的行业";
            break;
        case 1:
            return @"收藏行业";
            break;
        default:
            return @"其他行业";
            break;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
    }
    if (indexPath.section == 1) {
        cell.nameLable.text = [self.myIndusArray[indexPath.row] objectForKey:@"title"];
    }
    else if(indexPath.section == 2)
    {
        cell.nameLable.text = ((Industry *)self.allArray[indexPath.row]).name;
    }
  else if(indexPath.section == 0)
  {

      NSString * indusstr = [NSString getIndusryName:self.myArray[indexPath.row]];


      cell.nameLable.text = indusstr;
  }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCInfoListViewController * vc = [[LCInfoListViewController alloc] init];
    if (indexPath.section == 1) {
        vc.indus_id = [self.myIndusArray[indexPath.row] objectForKey:@"x_id"];
        vc.favourite_id = [self.myIndusArray[indexPath.row] objectForKey:@"favorites_id"];
        vc.isMain = YES;
    }
    else if(indexPath.section == 2)
    {
        vc.indus_id = ((Industry *)self.allArray[indexPath.row]).ID;
        vc.isMain = NO;
    }
    else if(indexPath.section == 0)
    {
        vc.indus_id = [self.myArray[indexPath.row] objectForKey:@"industry_id"];
        vc.isMain = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
