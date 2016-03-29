//
//  MessageViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "MessageViewController.h"
#import "RecieveViewController.h"
#import "ExchangeCardViewController.h"
#import "CommentViewController.h"
#import "SystemMessageViewController.h"
#import "ActivtyAlertViewController.h"
#import "LCMessageTableViewCell.h"
#import "LCGroupMessageAlertViewController.h"
#import "LCIntoreToMeViewController.h"
@interface MessageViewController ()
@property (nonatomic, retain)NSArray * array, *iconArray, *VCArray;
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"消息";
    }
    return self;
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"消息";
    self.messagesTable.delegate = self;
    self.messagesTable.dataSource = self;
    self.iconArray = @[[UIImage imageNamed:@"lcsj_note1.png"],[UIImage imageNamed:@"lcsj_note2.png"],[UIImage imageNamed:@"lcsj_note3.png"],[UIImage imageNamed:@"lcsj_note4.png"],[UIImage imageNamed:@"lcsj_note5.png"],[UIImage imageNamed:@"lcsj_note6.png"],[UIImage imageNamed:@"lcsj_note7.png"]];
    self.array = @[@"收信箱", @"名片交换请求", @"评论通知", @"系统消息", @"活动提醒", @"群组相关消息", @"引荐消息"];

    


    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
    NSArray * resultArray = [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:[MyUserDefult objectForKey:@"userName"]];
    self.hintCount = String(resultArray.count);
    
    [self loadCount];

}
- (void)loadCount
{
    if ([MyUserDefult integerForKey:@"messageCount"]) {
        self.messageCount = [MyUserDefult integerForKey:@"messageCount"];
    }
    else{
        self.messageCount = 0;
    }
    if ([MyUserDefult integerForKey:@"commentCount"]) {
        self.commentCount = [MyUserDefult integerForKey:@"commentCount"];
    }
    else
    {
        self.commentCount = 0;
    }
    if ([MyUserDefult integerForKey:@"systemCount"]) {
        self.systemCount = [MyUserDefult integerForKey:@"systemCount"];
        
    }
    else
    {
        self.systemCount = 0;
    }
    if ([MyUserDefult integerForKey:@"activeCount"]) {
        self.activeCount = [MyUserDefult integerForKey:@"activeCount"];
    }
    else
    {
        self.activeCount = 0;
    }
    if ([MyUserDefult integerForKey:@"groupCount"]) {
        self.groupCount = [MyUserDefult integerForKey:@"groupCount"];
    
    }
    else
    {
        self.groupCount = 0;
    }
    if ([MyUserDefult integerForKey:@"introduceCount"]) {
        self.introduceCount = [MyUserDefult integerForKey:@"introduceCount"];
    }
    else{
        self.introduceCount = 0;
    }
    
}
-(void)setHintCount:(NSString *)hintCount
{
    if (_hintCount != hintCount) {
        _hintCount = hintCount;
        [self.messagesTable reloadData];
    }
}



- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSLog(@"%@", notification.userInfo);
    
    [self loadCount];
    [self.messagesTable reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"LCMessageTableViewCell";
    LCMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.hintLabel.alpha = 0;
    }
    
    if (indexPath.row == 1) {
        if (self.hintCount.intValue > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = self.hintCount;
        }else
        {
            cell.hintLabel.alpha = 0;
        }
    }else if(indexPath.row == 3)
    {
        if (self.systemCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.systemCount];
        }
    }
    else if(indexPath.row == 2)
    {
        if (self.commentCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.commentCount];
        }
    }
    else if(indexPath.row == 4)
    {
        if (self.activeCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.activeCount];
        }
    }
    else if(indexPath.row == 0)
    {
        if (self.messageCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.messageCount];
        }
    }
    else if (indexPath.row == 5)
    {
        if (self.groupCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.groupCount];
        }
    }
    else if (indexPath.row == 6)
    {
        if (self.introduceCount > 0) {
            cell.hintLabel.alpha = 1;
            cell.hintLabel.text = [NSString stringWithFormat:@"%d", self.introduceCount];
        }
    }
    
    cell.messageLable.text = self.array[indexPath.row];
    cell.messageView.image = self.iconArray[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0:
        {
            self.messageCount = 0;
            [MyUserDefult  setInteger:0 forKey:@"messageCount"];
            [self.navigationController pushViewController:[[RecieveViewController alloc] init] animated:YES];

        }
            break;
        case 1:
        {
         [self.navigationController pushViewController:[[ExchangeCardViewController alloc] init] animated:YES];
        }
            break;
            case 2:
        {
            self.commentCount = 0;
            [MyUserDefult setInteger:0 forKey:@"commentCount"];
            [self.navigationController pushViewController:[[CommentViewController alloc]    init] animated:YES];
        }
            break;
            case 3:
        {
            
            SystemMessageViewController * vc = [[SystemMessageViewController alloc] init];
            self.systemCount = 0;
            [MyUserDefult setInteger:0 forKey:@"systemCount"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 4:
        {
           [self.navigationController pushViewController:[[ActivtyAlertViewController alloc] init] animated:YES];
            self.activeCount = 0;
            [MyUserDefult setInteger:0 forKey:@"activeCount"];
        }
            break;
            case 5:
        {
            [MyUserDefult setInteger:0 forKey:@"groupCount"];
            
            self.groupCount = [MyUserDefult integerForKey:@"groupCount"];
            
            
            LCGroupMessageAlertViewController * vc = [[LCGroupMessageAlertViewController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 6:
        {
            self.introduceCount = 0;
            [MyUserDefult setInteger:0 forKey:@"introduceCount"];
            [self.navigationController pushViewController:[[LCIntoreToMeViewController alloc] init] animated:YES];
        }
        default:

            break;
    }
    RootViewController  *vc = [[RootViewController alloc] init];
    [vc  getCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismis:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
@end
