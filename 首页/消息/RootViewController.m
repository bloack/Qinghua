//
//  RootViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "MySelfViewController.h"
#import "RootViewController.h"
#import "AlertViewController.h"
#import "RecommendPeopleViewController.h"
#import "CompanyViewController.h"
#import "RecruitmentViewController.h"
#import "FundsViewController.h"
#import "DemandViewController.h"
#import "ProjectViewController.h"
#import "MessageViewController.h"
#import "ProductViewController.h"
#import "SupplyAndDemandViewController.h"
#import "LogInViewController.h"
#import "LCRootTableViewCell.h"
#import "LCGroupData.h"
#import "LCAlertTableViewCell.h"
#import "SystemManager.h"
#import <QuartzCore/QuartzCore.h>

#import "AddMyStatusViewController.h"
#define SECTION_HEIGHT iPhone5?30:20
#define NOT_ROW_HEIGHT  iPhone5?53:40
#define OTHER_ROW_HEIGHT iPhone5?113:90

#define HAS_TABLE_HEADER @"header_is_has"
#import "APService.h"

@interface RootViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSArray * array1;
@property (nonatomic, retain)NSArray * array2;
@property (nonatomic, retain)NSArray * array3;
@property (nonatomic, retain)NSDictionary * dic;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"tab-1.png"];
        self.title = @"首页";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    __weak RootViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:UserDetail_URL aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} aSuccessBlock:^(id myDictionary) {
        blockSelf.user_dic = myDictionary;
    }
                                 setFailBlock:^(id obj) {
                                     
                                 }
     ];

    [self getCount];
}

/**
 *  添加headerView
 */
-(void)addTableHeaderView
{
    self.tableView.tableHeaderView = self.headerView;
    myHeight = 0;
    [[SystemManager shareSystemManager] setPropertyWithKey:HAS_TABLE_HEADER value:@"YES"];
}


- (void)getListData
{
    __weak RootViewController * blockSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:blockSelf.view animated:YES];
    });

    [[NetWork shareNetWork] netWorkWithURL:SystemAlert_url  dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        
        blockSelf.array3 = [[dictionary objectForKey:@"data"] objectForKey:@"list"];
        [[NetWork shareNetWork] netWorkWithURL:Company_List_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"page_size":@"4"} setSuccessBlock:^(id dictionary) {
            
            [blockSelf.array addObject:dictionary];
            blockSelf.array2 = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
            [[NetWork shareNetWork] netWorkWithURL:ByRecommend_URL dic:@{@"user_id":[MyUserDefult objectForKey:@"UserId"], @"page_size":@"4"} setSuccessBlock:^(id dictionary) {
                blockSelf.array1 = [[dictionary objectForKey:@"data"] objectForKey:@"user_list"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
                    [blockSelf.tableView.pullToRefreshView stopAnimating];
                    [blockSelf.tableView reloadData];
                });
                [[NetWork shareNetWork] getDataWithURLStr:UserDetail_URL aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} aSuccessBlock:^(id myDictionary) {
                    blockSelf.user_dic = myDictionary;
                }
                 setFailBlock:^(id obj) {
                     
                 }
];
            }
             setFailBlock:^(id obj) {
                 
             }
             ];
        }
         setFailBlock:^(id obj) {
             
         }
         ];
    }
                              setFailBlock:^(id obj) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
                                      [blockSelf.tableView.pullToRefreshView stopAnimating];
                                      [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
                                  });
                              }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak RootViewController * blockSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [blockSelf getListData];
    });
    

    [APService setTags:[NSSet setWithObjects:@"qinghuao",@"qinghuac",@"qinghuae",nil] alias:[MyUserDefult objectForKey:@"UserId"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
    self.titleString = @"首页";
    [self.myNavbar setLeftButtonWithImageName:@"5-12-back" name:@"消息"];
    CGRect leftRect = self.myNavbar.leftButtonImageView.frame;
    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftRect.size.width - 10, -5, 16, 14)];
    [self.myNavbar.leftButtonImageView addSubview:hintLabel];
    hintLabel.backgroundColor = [UIColor redColor];
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.layer.cornerRadius = 4;
    hintLabel.clipsToBounds = YES;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFriend:) name:@"newFriendApply" object:nil];
    
    [self addTableHeaderView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array = [NSMutableArray arrayWithCapacity:0];

    
    [[NSNotificationCenter defaultCenter] addObserver:blockSelf selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.systemArray = [NSMutableArray arrayWithCapacity:0];
    self.commentArray  = [NSMutableArray arrayWithCapacity:0];
    self.activeArray = [NSMutableArray arrayWithCapacity:0];
    self.messageArray = [NSMutableArray arrayWithCapacity:0];
    self.likeArray = [NSMutableArray arrayWithCapacity:0];
    self.groupArray = [NSMutableArray arrayWithCapacity:0];
    self.introduceArray = [NSMutableArray arrayWithCapacity:0];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getListData];
    }];
    
    self.isNew = NO;
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    if ([MyUserDefult objectForKey:@"messageArray"]) {
        self.messageArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"messageArray"]];
    }
    if ([MyUserDefult objectForKey:@"commentArray"]) {
        self.commentArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"commentArray"]];
    }
    if ([MyUserDefult objectForKey:@"activeArray"]) {
        self.activeArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"activeArray"]];
    }
    if ([MyUserDefult objectForKey:@"likeArray"]) {
        self.likeArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"likeArray"]];
    }
    if ([MyUserDefult objectForKey:@"groupArray"]) {
        self.groupArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"groupArray"]];
    }
    if ([MyUserDefult objectForKey:@"introduceArray"]) {
        self.introduceArray = [NSMutableArray arrayWithArray:[MyUserDefult objectForKey:@"introduceArray"]];
    }
    
    
    NSDictionary * dic = notification.userInfo;
    switch ([[dic[@"extras"] objectForKey:@"type"] integerValue]) {
        case 9:
        {
            AudioServicesPlaySystemSound(1007);

            self.systemCount ++;
            self.dic = dic;
            [MyUserDefult setInteger:self.systemCount forKey:@"systemCount"];
            self.isNew = YES;
            [self.tableView reloadData];

            
        }
            break;
        case 13:
        {
            AudioServicesPlaySystemSound(1007);

            
            self.messageCount ++;
            [self.messageArray addObject:dic];
            
            [MyUserDefult setInteger:self.messageCount forKey:@"messageCount"];
            [MyUserDefult setObject:self.messageArray forKey:@"messageArray"];
            
            
        }
            break;
            
        case 14:
        {
            AudioServicesPlaySystemSound(1007);

            self.introduceCount ++;
            [self.introduceArray addObject:dic];
            
            [MyUserDefult setInteger:self.introduceCount forKey:@"introduceCount"];
            [MyUserDefult setObject:self.introduceArray forKey:@"introduceArray"];
            
            
        }
            break;
        case 15:
        {
            
            if (![[[[dic[@"extras"] objectForKey:@"u"] componentsSeparatedByString:@","] firstObject] isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
                AudioServicesPlaySystemSound(1007);

                self.commentCount ++;
                [self.commentArray addObject:dic];
                [MyUserDefult setObject:self.commentArray forKey:@"commentArray"];
                [MyUserDefult setInteger:self.commentCount forKey:@"commentCount"];
            }
            

        }
            break;
        case 16:
        {
            if (![[[[dic[@"extras"] objectForKey:@"u"] componentsSeparatedByString:@","] firstObject] isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
                AudioServicesPlaySystemSound(1007);

            self.commentCount ++;
            
            [self.likeArray addObject:dic];
            
            [MyUserDefult setObject:self.likeArray forKey:@"commentArray"];
            [MyUserDefult setInteger:self.commentCount forKey:@"commentCount"];
                        }
            
        }
            break;
        default:
            break;
    }
    if ([dic[@"type"] intValue] == 10|| [dic[@"type"] intValue] == 11||[dic[@"type"] intValue] == 12) {
        
        AudioServicesPlaySystemSound(1007);

        self.groupCount ++;
        [self.groupArray addObject:dic];
        [MyUserDefult setInteger:self.groupCount forKey:@"groupCount"];
        [MyUserDefult setObject:self.groupArray forKey:@"groupArray"];
        
        NSLog(@"%@", [dic[@"aps"] objectForKey:@"alert"]);
    }
    if ([dic[@"type"] intValue] == 17) {
        
        AudioServicesPlaySystemSound(1007);

        self.activeCount ++;
        [self.activeArray addObject:dic];
        
        [MyUserDefult setObject:self.activeArray forKey:@"activeArray"];
        [MyUserDefult setInteger:self.activeCount forKey:@"activeCount"];
    }
    [self getHintLable];
}
- (void)getHintLable
{
    NSArray * resultArray = [[OperationalDatabase sharedDataBase] getNoPassFriendApplyWithTo:[MyUserDefult objectForKey:@"userName"]];
    int count = resultArray.count + self.systemCount +self.messageCount + self.activeCount + self.introduceCount + self.groupCount + self.commentCount;
    if (count == 0) {
        hintLabel.alpha = 0;
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];

    }else
    {
        hintLabel.alpha = 1;
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:count];


    }
    hintLabel.text = [NSString stringWithFormat:@"%d",count];
    
}
-(void)AddFriend:(NSNotification *)noti
{
    NSString * countStr = [noti object];
    hintLabel.text = countStr;
    hintLabel.alpha = 1;
}

- (void)getCount
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
    [self getHintLable];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"newFriendApply" object:nil];
}

-(void)goBack
{
    [self messages:nil];
}

- (void)button:(UIButton *)button
{
#warning cell 上面确定 indexpath 的解决方案
    
    UITableViewCell * cell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%d", path.row);
    
}
- (IBAction)messages:(id)sender {
    
    [self.navigationController pushViewController:[[MessageViewController alloc] init] animated:YES];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString * cellID = @"LCAlertTableViewCell";
        LCAlertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == Nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.time.hidden = YES;
        if (self.dic) {
            cell.time.text = [self.dic[@"data"] objectForKey:@"create_time"];
            cell.titleLable.text = [self.dic[@"aps"] objectForKey:@"alert"];
            cell.content.text = [self.dic[@"data"] objectForKey:@"content"];
        
        }
        else
        {
            NSDictionary * dicc = [self.array3 firstObject];
            cell.time.text = dicc[@"create_time"];
            cell.titleLable.text = dicc[@"title"];
            cell.content.text = dicc[@"content"];
        }
        if (self.isNew == YES) {
            cell.myNewL.hidden = NO;
        }
        else
        {
            cell.myNewL.hidden = YES;
        }
        
        return cell;
    }
    else  if (indexPath.section == 1) {
        static NSString * cellID = @"LCRootTableViewCell";
        LCRootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == Nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CGRect bgRect = cell.bgView.frame;
        bgRect.origin.y = ((OTHER_ROW_HEIGHT + myHeight) - bgRect.size.height)/2;
        cell.bgView.frame = bgRect;
        
        
      

        for (int i = 0; i < self.array2.count; i ++) {
            UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 80 * i, 20, 40, 40)];
            [aImageView setImageWithURL:[NSURL URLWithString:[self.array2[i] objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
            [cell addSubview:aImageView];
            
            UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(80 * i + 10, 70, 70, 20)];
            lable.font = [UIFont systemFontOfSize:13.0];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.text = self.array2[i][@"company_name"];
            [cell addSubview:lable];
        }
        return cell;
    }
     else  if (indexPath.section == 2) {
        static NSString * cellID = @"LCRootTableViewCell";
        LCRootTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == Nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
         CGRect bgRect = cell.bgView.frame;
         bgRect.origin.y = ((OTHER_ROW_HEIGHT + myHeight) - bgRect.size.height)/2;
         cell.bgView.frame = bgRect;
         for (int i = 0; i < self.array1.count; i ++) {
             UIImageView * aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 80 * i, 20, 40, 40)];
             [aImageView setImageWithURL:[NSURL URLWithString:[self.array1[i] objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
             [cell addSubview:aImageView];
             
             UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(80 * i + 10, 70, 70, 20)];
             lable.font = [UIFont systemFontOfSize:13.0];
             lable.textAlignment = NSTextAlignmentCenter;
             lable.text = self.array1[i][@"real_name"];
             [cell addSubview:lable];
         }
        return cell;
    }
   
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"通知";
            break;
        case 1:
            return @"推荐企业";
            break;
        case 2:
            return @"推荐人脉";
            break;
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            
            LCAlertTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.myNewL.hidden = YES;
            self.isNew = NO;
            [self.navigationController pushViewController:[[AlertViewController alloc] init] animated:YES];
        }
            break;
        case 1:
            [self.navigationController pushViewController:[[CompanyViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[RecommendPeopleViewController alloc]init] animated:YES];
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0)
    {
        rowHeight = NOT_ROW_HEIGHT;
    }
    else if(indexPath.section == 1)
    {
        rowHeight =  OTHER_ROW_HEIGHT;
    }
    else if (indexPath.section == 2)
    {
        rowHeight =  OTHER_ROW_HEIGHT;
    }

    return  rowHeight + myHeight;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)message:(UIButton *)sender
{

}
- (IBAction)headerButtonClick:(id)sender
{
    MySelfViewController * controller = [[MySelfViewController alloc]init];
    
    controller.lastDic = self.user_dic[@"data"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)clearHeaderClick:(id)sender {
    self.tableView.tableHeaderView = nil;
    [[SystemManager shareSystemManager] setPropertyWithKey:HAS_TABLE_HEADER value:@"NO"];
    myHeight = 10;
    [self.tableView reloadData];
}

- (IBAction)dongtai:(id)sender {
    AddMyStatusViewController * vc = [[AddMyStatusViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)supply:(id)sender {
    [self.navigationController pushViewController:[[SupplyAndDemandViewController alloc] init] animated:YES];
}

- (IBAction)project:(id)sender {
    [self.navigationController pushViewController:[[ProductViewController alloc] init] animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}





@end
