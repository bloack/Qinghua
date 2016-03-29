//
//  LCDirectoryViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-28.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCDirectoryViewController.h"
#import "LCDirectoryTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "NetWork.h"
#import "LCCompany.h"
#import "pinyin.h"
@interface LCDirectoryViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array, * searchArray, * sectionArray, *temArray;
@end

@implementation LCDirectoryViewController
@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchArray.count;
    }
    /*
     *根据网络请求返回的数据
     */
    else
    {
    return [self.array[section] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.sectionArray[section];
    }
    else
    {
        return @"";
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
         return self.array.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LCCompany * company = [[LCCompany  alloc] init];
    if (tableView == _tableView) {
        company = self.array[indexPath.section][indexPath.row];
    }
    else
    {
        company = [self.searchArray objectAtIndex:indexPath.row];
    }
    
    static NSString * messageTBViewCellID = @"LCDirectoryTableViewCell";
    LCDirectoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
   [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", company.icon]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
    cell.content.text = [NSString stringWithFormat:@"%@", company.intro];
    cell.name.text = [NSString stringWithFormat:@"%@", company.name];
    
    
    cell.representative.text = company.indus;
    cell.adress.text = [NSString stringWithFormat:@"%@", company.address];
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCDirectoryViewController *vc = self;
    NSDictionary *dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@""} ;
    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:dic setSuccessBlock:^(id dictionary) {
        
        NSMutableArray * resultArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"company_list"]];
        for (NSDictionary * resultDic in resultArray) {
            LCCompany * company = [[LCCompany alloc] initWithDic:resultDic];
            [vc.searchArray addObject:company];
        }
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
         [vc.searchDisplayController.searchResultsTableView reloadData];
            if (vc.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有搜索到数据" forError: YES];
            }
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  按照标识符跳转
     *  下级页面：用户详情
     */
    CompanyDetailViewController * vc = [[CompanyDetailViewController alloc] init];
//    vc.com_id =
    LCCompany * company = [[LCCompany  alloc] init];
    if (tableView == _tableView) {
        company = self.array[indexPath.section][indexPath.row];
    }
    else
    {
        company = [self.searchArray objectAtIndex:indexPath.row];
    }
    
    
    vc.com_id = company.company_id ;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar.translucent = NO; 
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    
    self.titleString = @"企业名录";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.page = 1;
    __weak LCDirectoryViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    self.sectionArray = [NSMutableArray arrayWithCapacity:0];
    self.temArray = [NSMutableArray arrayWithCapacity:0];
    [self.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getList:1];
    

    
}

- (void)nextPage
{
    self.page ++;
    [self getList:self.page];
}
- (void)getData
{
    self.page = 1;
    [self getList:self.page];
}

- (void)getList:(NSInteger)pag
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     __weak LCDirectoryViewController * blockSelf = self;

    [[NetWork shareNetWork] getDataWithURLStr:Company_me aImage:nil aBody:@{@"user_id": [MyUserDefult   objectForKey:@"UserId"],@"current_page":[NSString stringWithFormat:@"%d", pag]} aSuccessBlock:^(id myDictionary) {
        NSLog(@"%@", myDictionary);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray * resultArray = [NSMutableArray arrayWithArray:[[myDictionary objectForKey:@"data"] objectForKey:@"company_list"]];
            if (pag == 1) {
                [blockSelf.temArray removeAllObjects];
            }
            
            for (NSDictionary * resultDic in resultArray) {
                LCCompany * model = [[LCCompany alloc]initWithDic:resultDic];
                    [blockSelf.temArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (blockSelf.page == 1) {
                    [blockSelf.tableView.pullToRefreshView stopAnimating];
                }else
                {
                    [blockSelf.tableView.infiniteScrollingView stopAnimating];
                }
            
                blockSelf.array = [blockSelf getChineseStringArr:blockSelf.temArray];
                [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
                [blockSelf.tableView reloadData];
            });
        });
        
        
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
    }];
  
    
}
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    [self.sectionArray removeAllObjects];
    
    for(int i = 0; i < [arrToSort count]; i++) {
        LCCompany * model = arrToSort[i];
        NSString * realName = model.name;
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
        
        LCCompany * myModel = chineseStringsArray[index];
        NSMutableString *strchar= [NSMutableString stringWithString:myModel.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        
        
        if ([sr isEqualToString:@","] || [sr isEqualToString:@"1"] ||
            [sr isEqualToString:@"2"] || [sr isEqualToString:@"3"] ||
            [sr isEqualToString:@"4"] || [sr isEqualToString:@"5"] ||
            [sr isEqualToString:@"6"] || [sr isEqualToString:@"7"] ||
            [sr isEqualToString:@"8"] || [sr isEqualToString:@"9"] ||
            [sr isEqualToString:@"0"] || [sr isEqualToString:@" "] || [sr isEqualToString:@""]) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
