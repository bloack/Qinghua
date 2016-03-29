//
//  LCIntoreToMeViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCIntoreToMeViewController.h"
#import "LCSystmeTableViewCell.h"
#import "UserDetailViewController.h"
@interface LCIntoreToMeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain)NSArray * array;
@end

@implementation LCIntoreToMeViewController

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
    self.titleString = @"引荐信息";
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.array = [MyUserDefult objectForKey:@"introduceArray"];
    if (self.array.count == 0) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"没有数据" forError: YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCSystmeTableViewCell";
    LCSystmeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.content.text = dic[@"content"];
    cell.titleLable.hidden = YES;
    cell.time.hidden = YES;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetailViewController * vc = [[UserDetailViewController alloc] init];
    vc.userid = [[[self.array[indexPath.row] objectForKey:@"extras"] objectForKey:@"data"] objectForKey:@"user_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
