//
//  RecieveViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "RecieveViewController.h"
#import "ChatViewController.h"
#import "LCRecieveTableViewCell.h"
#import "LCTalkBackViewController.h"
@interface RecieveViewController ()
@property (nonatomic, retain)NSArray * array;
@end

@implementation RecieveViewController

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
    self.titleString = @"收件箱";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.array = [MyUserDefult objectForKey:@"messageArray"];
    if(self.array.count == 0)
    {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"没有私信" forError: YES];
    }
}
- (void)getMessageList
{
/*
 
 *获取信件列表
 */

    NetWork * net = [NetWork shareNetWork];
    net.delegate = self;
    /*
     
     *URL按需求更换
     */
    [net netWorkWithType:@"GET" url:URL_BASE body:nil];
}

#pragma mark NetWorkDelegate
- (void)recieveDataSuccessWithObject:(id)object
{
    /*
     
     *发布成功
     *
     
     
     *发布失败
     *
     */
}
- (void)recieveDataFailure
{
    /*
     
     *网络请求失败
     */
}
#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return [self.array count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCRecieveTableViewCell";
    LCRecieveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
        
        
        /*
         
         *按UI更换
         *不行就贴图！
         */
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.name.text = [[dic[@"extras"] objectForKey:@"data"] objectForKey:@"user_name"];
//    cell.time.text = dic[@""];
    cell.content.text = dic[@"content"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        /*
         
         *按照标识符跳转
         *下级页面：聊天
         */
    
    LCTalkBackViewController * vc = [[LCTalkBackViewController alloc] init];
    vc.dataDic = self.array[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
