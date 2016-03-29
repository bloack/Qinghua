//
//  MyContactsViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
#import "pinyin.h"
#import "MyContactsViewController.h"
#import "UserDetailViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "ChatViewController.h"
#import "FriendDao.h"
#import "LCMyFileViewController.h"
#import "LCAppDelegate.h"
#import "NSString+MD5.h"
@interface MyContactsViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation MyContactsViewController
@synthesize searchDisplayController;
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
    self.titleString = @"我的通讯录";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.delegate = self;
    self.searchDisplayController.searchResultsTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self getResultArrayWithText:searchText];
}
/**
 *  获得搜索数组
 *
 *  @param searchText 搜索关键字
 */
-(void)getResultArrayWithText:(NSString *)searchText
{
    NSPredicate * resultPredicate = [NSPredicate predicateWithFormat:@"self.real_name contains [cd] %@ or self.pinYin contains [cd] %@",searchText,searchText];
    NSArray * reslutArray = [self.searchDataArray filteredArrayUsingPredicate:resultPredicate];
    self.searchResultArray = reslutArray;
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFriends];
}
- (void)getFriends
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak MyContactsViewController *vc = self;
    [[NetWork shareNetWork] getDataWithURLStr:Friends_Url aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"page_size":@"100"} aSuccessBlock:^(id myDictionary) {
        NSLog(@"%@", myDictionary);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if (!vc.sectionArray) {
                vc.sectionArray = [NSMutableArray arrayWithCapacity:0];
            }else
            {
                [vc.sectionArray removeAllObjects];
            }
            
            NSMutableArray * baseArray = [NSMutableArray arrayWithCapacity:0];
            
            
            NSMutableArray * resultArray = [NSMutableArray arrayWithArray:[[myDictionary objectForKey:@"data"] objectForKey:@"friend_list"]];
            for (NSDictionary * resultDic in resultArray) {
                FriendModel * model = [[FriendModel alloc]initWithDic:resultDic];
                [baseArray addObject:model];
            }
            
            vc.searchDataArray = baseArray;
            
            vc.array = [vc getChineseStringArr:baseArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                [vc.tableView reloadData];
            });
        });
        
       
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
    }];
    
    
}


#pragma mark - action
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        FriendModel * model = arrToSort[i];
        NSString * realName = model.real_name;
        if([realName length] > 0){
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < realName.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([realName characterAtIndex:j])]uppercaseString];
                
//                NSLog(@"singlePinyinLette = %@", singlePinyinLetter);
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                
            }// end for
//            userInfo.pinYin = pinYinResult;
            model.pinYin = pinYinResult;
            
        } else{
//            userInfo.pinYin = @"";
            model.pinYin = @" ";
        }
        [chineseStringsArray addObject:model];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        
        FriendModel * myModel = chineseStringsArray[index];
        NSMutableString *strchar= [NSMutableString stringWithString:myModel.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        
        
        if ([sr isEqualToString:@","] || [sr isEqualToString:@"1"] ||
            [sr isEqualToString:@"2"] || [sr isEqualToString:@"3"] ||
            [sr isEqualToString:@"4"] || [sr isEqualToString:@"5"] ||
            [sr isEqualToString:@"6"] || [sr isEqualToString:@"7"] ||
            [sr isEqualToString:@"8"] || [sr isEqualToString:@"9"] ||
            [sr isEqualToString:@"0"] || [sr isEqualToString:@" "]) {
            sr = @"#";
        }
        
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionArray containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionArray addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionArray containsObject:[sr uppercaseString]])
        {
            if (TempArrForGrouping == nil) {
                TempArrForGrouping = [[NSMutableArray alloc] init];
            }
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
                
            }
        }
    }
    
    
    return arrayForArrays;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"";
    }
    return self.sectionArray[section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultArray.count;
    }
    /*
     *根据网络请求返回的数据
     */
    return [self.array[section] count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * messageTBViewCellID = @"LCRenMaiTableViewCell";
    LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
    
    FriendModel * model;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        model = self.searchResultArray[indexPath.row];
    }else
    {
        model = self.array[indexPath.section][indexPath.row];
    }
    
    
    [cell.iconImage setImageWithURL:model.avatar placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
     
    cell.name.text = [NSString stringWithFormat:@"%@", model.real_name];
    
    NSArray * aArray = model.companyArray;
    if (aArray.count > 0) {
        
        Company * firstObj = aArray[0];
        NSMutableString * company = firstObj.company_name;
        NSMutableString * position = firstObj.position;
        cell.companyName.text = company;
        cell.position.text = position;
        
        //城市
        
        NSString * cityStr = firstObj.city;
        NSString * indusstr = firstObj.industry;

        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
    }
    
    cell.addFriendImage.hidden = YES;
    cell.level.text = [NSString stringWithFormat:@"%@", model.parent_level_name];
    [cell buildChild:model.child_level_icon parent:model.parent_level_icon];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *下级页面：用户详情
     */
    FriendModel * model;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        model = self.searchResultArray[indexPath.row];
    }else
    {
        model = self.array[indexPath.section][indexPath.row];
    }
    
    if (model.user_id.length == 0) {
        [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"当前人脉不存在" forError:YES];
        return;
    }
    
    LCMyFileViewController * vc = [[LCMyFileViewController   alloc] init];
    vc.isMe = NO;
    vc.isChat = NO;
    vc.user_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
