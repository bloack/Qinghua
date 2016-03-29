//
//  GroupsViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "GroupsViewController.h"
#import "LCGroupsTableViewCell.h"
#import "QCSlideViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCStrangerGroupViewController.h"
@interface GroupsViewController ()<NetWorkDelegate>
@property (nonatomic, retain)NSMutableArray * array, *searchArray;
@property (nonatomic, retain)NSArray * myArray;
@property (nonatomic, retain)NSMutableArray * notArray;
@end
#warning 重做!!!
@implementation GroupsViewController

@synthesize searchDisplayController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"群组";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (IBAction)dimiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    
    
    self.titleString = @"群组";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getMyGroupList];
    // Do any additional setup after loading the view from its nib.
}

- (void)getMyGroupList
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak GroupsViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Group_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        
       vc.myArray = [NSArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"group_list"]];
        [[NetWork shareNetWork] netWorkWithURL:Group_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            vc.notArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"group_list"]];
            for (NSDictionary *dic in vc.myArray) {
                [vc.notArray removeObject:dic];

            }
            [vc.tableView reloadData];
        }
         setFailBlock:^(id obj) {
             [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
             [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
         }
         ];
    }
     setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
         [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
     }
     ];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _tableView) {
        if (section == 0) {
            return self.myArray.count;
        }
        else
            return self.notArray.count;
    }
    else
    {
        return self.searchArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"LCDiscoveryTableViewCell";
    LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle   mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
    }
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            NSDictionary * dic = self.myArray[indexPath.row];
            cell.nameLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"group_name"]];
             [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"qinghua-qunzu.png"]];
        }
        else if(indexPath.section == 1)
        {
            NSDictionary * dic = self.notArray[indexPath.row];
            cell.nameLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"group_name"]];
            [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"qinghua-qunzu.png"]];
        }
    }
    else
    {
        NSDictionary * dic = self.searchArray[indexPath.row];
        cell.nameLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"group_name"]];
        cell.nameLable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"group_name"]];
        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dic objectForKey:@"group_icon"]]] placeholderImage:[UIImage imageNamed:@"qinghua-qunzu.png"]];
    }
    return cell;

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            return @"我的群组";
        }
        else
            return @"更多群组";
    }
    else
    {
        return nil; 
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return 2;
    }
    else
    {
        return 1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            QCSlideViewController * groupVC = [[QCSlideViewController alloc] init];
            NSString * group;
            if (tableView == _tableView) {
                group = [self.myArray[indexPath.row] objectForKey:@"group_id"];
            }
            else
            {
                group = [self.searchArray[indexPath.row] objectForKey:@"group_id"];
            }
            groupVC.group_id = group?group:@"10002";
            if ([[self.myArray[indexPath.row] objectForKey:@"group_admin"] integerValue] == 1) {
                
                groupVC.isAdmain = YES;
            }
            else
            {
                groupVC.isAdmain = NO;
            }
            [self.navigationController pushViewController:groupVC animated:YES];
            
        }
            break;
            case 1:
        {
            LCStrangerGroupViewController * vc = [[LCStrangerGroupViewController alloc] init];
            NSString * group = [self.notArray[indexPath.row] objectForKey:@"group_id"];
            vc.group_id = group?group:@"10002";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak GroupsViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Group_List dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@""} setSuccessBlock:^(id dictionary) {
        
        vc.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"group_list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [vc.searchDisplayController.searchResultsTableView reloadData];
            if (vc.searchArray.count == 0) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"没有搜索到数据" forError: YES];
            }
        });
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
    }];
}
- (void)dealloc
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
