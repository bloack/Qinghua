//
//  LCAlertDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCAlertDetailViewController.h"
#define System_Detail @"/api/system/message/getInfo"
@interface LCAlertDetailViewController ()
@property (nonatomic, strong)NSDictionary * dic;
@end

@implementation LCAlertDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"系统消息";
        [self getdata];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)getdata
{
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"system_message_id":self.sys_id?self.sys_id:@"1"} ;
    __weak LCAlertDetailViewController *vc = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWork shareNetWork] getDataWithURLStr:System_Detail aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        
        vc.dic = [[dictionary objectForKey:@"data"] objectForKey:@"message_info"];
        vc.time.text = vc.dic[@"create_time"];
        vc.titleV.text = vc.dic[@"title"];
        CGFloat hight = [vc.dic[@"content"] getHightWithfontSize:280];
        vc.content.frame = CGRectMake(20, 110, 280, hight);
        vc.content.text = vc.dic[@"content"];
        vc.backView.frame = CGRectMake(10, 110, 290, hight + 10);
    } setFailBlock:^(id obj) {
        
    }];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
