//
//  ContactsViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ContactsViewController.h"
#import "NewRenMaiViewController.h"
#import "ClassViewController.h"
#import "SpecialtyViewController.h"
#import "MyContactsViewController.h"
#import "LCChatTableViewCell.h"
#import "LCDiscoveryTableViewCell.h"
#import "ChatViewController.h"
#import "FriendDao.h"
#import "SystemManager.h"
#import "LCFirstViewController.h"
@interface ContactsViewController ()
@property (nonatomic, strong)NSArray * array, *iconArray;
@property (nonatomic, strong)UISearchDisplayController * searchDisplayController;
@end

@implementation ContactsViewController
@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tab-2.png"];
        self.title = @"人脉";
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [SystemManager shareSystemManager].historyTalkFriend = [FriendDao selectAllDataFromFriendTable];
    if ([SystemManager shareSystemManager].historyTalkFriend.count != self.historyFriendArray.count) {
        self.historyFriendArray = [SystemManager shareSystemManager].historyTalkFriend;
        if (!self.historyFriendArray) {
            self.historyFriendArray = [NSMutableArray arrayWithCapacity:0];
        }
        
        if (!self.hintCountDic) {
            self.hintCountDic = [NSMutableDictionary dictionaryWithCapacity:0];
        }
        
        
    }
    
    
    [self.tableView reloadData];
    
}


#pragma mark - 接收到openfier推送消息
/**
 *  接收到推送消息
 *
 *  @param noti
 */
-(void)changeNumNoti:(NSNotification *)noti
{
    ChatEntity * entity = (ChatEntity *)[noti object];
    
    NSPredicate * resultPre = [NSPredicate predicateWithFormat:@"self.user_name contains[cd] %@",entity.fromId];
    NSArray * resultArray = [self.historyFriendArray filteredArrayUsingPredicate:resultPre];
    
    
    if (resultArray.count > 0) {
        FriendModel * oldModel = [resultArray objectAtIndex:0];
        [oldModel setLastTalkContentWithEnti:entity];
        
        int index = [self.historyFriendArray indexOfObject:oldModel];
        
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        NSString * countStr = self.hintCountDic[indexPath];
        countStr = String(countStr.intValue + 1);
        if (!self.hintCountDic) {
            self.hintCountDic = [NSMutableDictionary dictionaryWithCapacity:0];
        }
        
        [self.hintCountDic setObject:countStr forKey:indexPath];
        
        
        /**
         *  刷新表逻辑
         */
       
    }else
    {
        NSArray * arr = [entity.nickName componentsSeparatedByString:@","];
        FriendModel * model = [[FriendModel alloc]init];
        model.user_id = [MyUserDefult objectForKey:@"userName"];
        model.user_name = entity.fromId;
        model.real_name = arr[1];
//        if (model.real_name.length == 0) {
//            model.real_name = model.user_name;
//        }
        model.avatar = arr[2];
        
        
        model.updateTime = entity.timeSince1970;
        [model setLastTalkContentWithEnti:entity];
        [FriendDao insertFriendTableWith:model];
        
        if (!self.historyFriendArray) {
            self.historyFriendArray = [NSMutableArray arrayWithCapacity:0];
        }
        [self.historyFriendArray addObject:model];
        
        
        int index = self.historyFriendArray.count - 1;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        NSString * countStr = self.hintCountDic[indexPath];
        countStr = String(countStr.intValue + 1);
        
        [self.hintCountDic setObject:countStr forKey:indexPath];
        
        
        
//        [self.tableView reloadData];
    }
    
    
    dispatch_sync(dispatch_get_main_queue(), ^()
                  {
                      [self.tableView reloadData];
                  });
//    [self.tableView reloadData];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:_READ_MESSAGE object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"人脉";
    [self hidenLeftButton];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    /**
     * 接受到消息 通知
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumNoti:) name:_READ_MESSAGE object:nil];
    
    
    
    
    self.array = @[@"发现你的新人脉", @"班级", @"群组好友", @"我的通讯录"];
    self.iconArray = @[[UIImage imageNamed:@"lcsj_renmai_green.png"],[UIImage imageNamed:@"lcsj_renmai_yellow.png"],[UIImage imageNamed:@"lcsj_renmai_blue.png"],[UIImage imageNamed:@"lcsj_renmai_lignt_blue.png"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initSearchDisplayControler];
    
    
   
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  初始化搜索界面
 */
-(void)initSearchDisplayControler
{
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    
}


#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    if (section == 0) {
        return self.array.count;
    }
    else if(section == 1){
        
        return self.historyFriendArray.count;
        
        NSLog(@"friends = %@", [[LCAppDelegate shared] friendsArray]);
        return [[[LCAppDelegate shared] friendsArray] count];
    }
    return 5;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 84;
    }
    else
        return 40;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       if(indexPath.section == 0){
           NSString * messageTBViewCellID = @"LCDiscoveryTableViewCell";
           LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
           if (cell == nil) {
               cell = [[[NSBundle  mainBundle] loadNibNamed:@"LCDiscoveryTableViewCell" owner:nil options:nil] lastObject];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
           }
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           cell.nameLable.text = self.array[indexPath.row];
           cell.iconImage.image = self.iconArray[indexPath.row];
           return cell;
           
       }else if (indexPath.section == 1) {
           
           NSString * messageTBViewCellID = @"LCChatTableViewCell";
           LCChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
           if (cell == nil) {
               cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
           }
           
           /*
           NSString * strFriends = [[[LCAppDelegate shared] friendsArray] objectAtIndex:indexPath.row];
           NSArray * friendsInfo = [strFriends componentsSeparatedByString:@","];
           NSURL * iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", URL_BASE,[friendsInfo objectAtIndex:2]]];
           [cell.cell_icon setImageWithURL:iconURL];
           cell.cell_name.text = [NSString stringWithFormat:@"%@   %@",[friendsInfo objectAtIndex:1], [[[friendsInfo objectAtIndex:0]  componentsSeparatedByString:@"@"] objectAtIndex:0]];
           cell.cell_desc.text = [friendsInfo objectAtIndex:3];
           */
           
           FriendModel * friend = [self.historyFriendArray objectAtIndex:indexPath.row];
           [cell.cell_icon setImageWithURL:[NSURL URLWithString:friend.avatar] placeholderImage:DefaultImage];
           cell.cell_name.text = friend.real_name;
           cell.cell_desc.text = friend.lastTalkContent;
           cell.lastTimeLabel.text = friend.updateTime;
           
           cell.hintCount = [self.hintCountDic[indexPath] intValue];
           NSLog(@"%@", friend.avatar);
           return cell;
       }
       return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *第一个section：发现你的新人脉
     *第二个section：按照页面
     
     *第三个section
     *按照标识符跳转
     *下级页面：用户相亲
     */
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:[[NewRenMaiViewController alloc] init] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[[ClassViewController alloc] init] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[[SpecialtyViewController alloc] init] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[[MyContactsViewController alloc] init] animated:YES];
                break;
    
            default:
                break;
        }
    }
   else
   {
       
       [self.hintCountDic setObject:String(0) forKey:indexPath];
       
       ChatViewController * chatVC = [[ChatViewController alloc] init];
       chatVC.hidesBottomBarWhenPushed = YES;

       chatVC.friendModel = self.historyFriendArray[indexPath.row];
//       chatVC.unionNickName = [[[LCAppDelegate shared] friendsArray] objectAtIndex:indexPath.row];
       
       
       
       [self.navigationController pushViewController:chatVC animated:YES];
       
//       [self presentViewController:chatVC animated:YES completion:^{
       
//       }];
       
   }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"聊天";
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
