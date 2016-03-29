//
//  LCGroupDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCStrangerGroupViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "QCListViewController.h"
#import "NSString+MD5.h"
@interface LCStrangerGroupViewController ()

@end

@implementation LCStrangerGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)joinIn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCStrangerGroupViewController *vc = self;
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"group_id":self.group_id};
    [[NetWork shareNetWork] getDataWithURLStr:Group_Apply aImage:nil aBody:dic aSuccessBlock:^(id myDictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([myDictionary[@"status"] intValue] == 200) {
            [[SystemManager  shareSystemManager] showHUDInView:vc.view messge:@"申请已经发送, 请等待审核" forError: YES];
        }
        else
        {
                [[SystemManager  shareSystemManager] showHUDInView:vc.view messge:myDictionary[@"message"] forError: YES];
        }
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager  shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"其他群组";
    [self getdata];
}
- (void)getdata
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCStrangerGroupViewController *vc = self;

        [[NetWork shareNetWork] netWorkWithURL:Group_Info dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"group_id":self.group_id} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", dictionary);
        [vc.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[[dictionary objectForKey:@"data"] objectForKey:@"group_info"] objectForKey:@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"qinghua-qunzu.png"]];
        vc.name.text = [NSString stringWithFormat:@"%@", [[[dictionary objectForKey:@"data"] objectForKey:@"group_info"] objectForKey:@"group_name"]];
        
        vc.intro.text = [NSString stringWithFormat:@"%@", [[[dictionary objectForKey:@"data"] objectForKey:@"group_info"] objectForKey:@"group_intro"]];
        float hight = [[[[dictionary objectForKey:@"data"] objectForKey:@"group_info"] objectForKey:@"group_intro"] getHightWithfontSize:300];
            vc.intro.frame = CGRectMake(10, 165, 300, hight);
            vc.agreeBtn.frame = CGRectMake(20, 190 +hight, 280, 30);
    }];
}
- (void)buildUI
{
    __weak LCStrangerGroupViewController *vc = self;

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
