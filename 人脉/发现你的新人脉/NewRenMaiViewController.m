//
//  NewRenMaiViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "NewRenMaiViewController.h"
#import "AreaContactsViewController.h"
#import "ProfessionViewController.h"
#import "NearlyContactsViewController.h"
#import "IndustryViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "UserDetailViewController.h"
#import "LCDiscoveryTableViewCell.h"
#import "LCAddFriends.h"

#import "LCMyFileViewController.h"
@interface NewRenMaiViewController ()
@property (nonatomic, retain)NSMutableArray * array, *listArray, *VCArray, *searchArray, *imageArray;
@property (nonatomic, retain)CLLocationManager * manager;

@property (nonatomic, retain)NSMutableString * cityName;
@end

@implementation NewRenMaiViewController




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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"will");
    [self getLocation];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getNearList];
    self.titleString = @"发现你的新人脉";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array = @[@"附近人脉", @"行业人脉", @"地区人脉", @"职业人脉"];
    self.imageArray = @[@"nearly_pic.png", @"indus_pic.png", @"area_pic.png", @"position_pic.png"];
    
    _searchBar.translucent = NO;
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
/**
 *  获取当前地理位置
 */
- (void)getLocation
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 100;
    [_manager startUpdatingLocation];
}
/**
 *  获取地理位置代理
 *
 *  @param manager
 *  @param locations
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
    NSLog(@"%@", _location);
    CLGeocoder * gecoder = [[CLGeocoder alloc] init];
    //逆向地理编码
    __weak NewRenMaiViewController *vc = self;
    [gecoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * marks in placemarks) {
            if ([marks.addressDictionary objectForKey:@"City"]) {
                NSLog(@"%@", [marks.addressDictionary objectForKey:@"City"]);
                vc.cityName = [marks.addressDictionary objectForKey:@"City"];
            }
            else
            {
                vc.cityName = [marks.addressDictionary objectForKey:@"State"];
            }
            [vc.tableView reloadData];
        }
    }];
   
}
/**
 *  获取人脉列表
 */
- (void)getNearList
{
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak NewRenMaiViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:ByRecommend_URL dic:dic setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [vc.listArray addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey:@"user_list"]];

        [vc.tableView reloadData];
    }
     setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
     }
     ];
}

#pragma mark tableViewDatesource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"推荐人脉";
    }
    return Nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    if (tableView == _tableView) {
        if (section == 0) {
            return self.array.count;
        }
        else
            return self.listArray.count;
    }
    else
    {
        return self.searchArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            return 40;
        }
        else
            return 100;
    }
    else
    {
        return 100;
    }
    return 0.0;

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
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if(indexPath.section == 0){
            NSString * messageTBViewCellID = @"LCDiscoveryTableViewCell";
            LCDiscoveryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
            if (cell == nil) {
                cell = [[[NSBundle  mainBundle] loadNibNamed:@"LCDiscoveryTableViewCell" owner:nil options:nil] lastObject];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.nameLable.text = self.array[indexPath.row];
            if (indexPath.row == 0) {
                UILabel * lable = [[UILabel   alloc] initWithFrame:CGRectMake(250, 5, 50, 30)];
                lable.text = self.cityName;
                lable.font = [UIFont systemFontOfSize:11.0];
                [cell addSubview:lable];
            }
            cell.iconImage.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
            return cell;
            
        }else if (indexPath.section == 1) {
            static NSString * messageTBViewCellID = @"LCRenMaiTableViewCell";
            LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
            }
            NSDictionary * dic = [self.listArray objectAtIndex:indexPath.row];
            
            [cell.iconImage setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
            cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
            NSArray * aArray = [dic objectForKey:@"company_list"];
            NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
            NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
            cell.companyName.text = company;
            cell.position.text = position;
            /**
             *  城市
             */
            NSString * cityStr = [NSString getAllArea:[aArray firstObject]];
            NSString * indusstr = [NSString getIndusryName:[aArray firstObject]];

            if ([dic[@"is_friend"] integerValue] == 1) {
                cell.addFriendImage.image = [UIImage imageNamed:@"gotoChat.png"];
                [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoChat:)]];
            }
            else{
                [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriend:)]];
            }
            cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
            cell.province.textColor = [UIColor blueColor];
            [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];
            cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parent_level_name"]];
            NSInteger str =  [[NSString stringWithFormat:@"%@", [dic objectForKey:@"distance"]] integerValue];
            cell.distance.text = [NSString stringWithFormat:@"%d 米", str];
            
            
            return cell;
            
        }
    }
    else
    {
        static NSString * messageTBViewCellID = @"LCRenMaiTableViewCell";
        LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
        }
        NSDictionary * dic = [self.searchArray objectAtIndex:indexPath.row];
        [cell.iconImage setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
        cell.name.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"real_name"]];
        NSArray * aArray = [dic objectForKey:@"company_list"];
        NSMutableString * company = [[aArray firstObject] objectForKey:@"company_name"];
        NSMutableString * position = [[aArray firstObject] objectForKey:@"position"];
        cell.companyName.text = company;
        cell.position.text = position;
        /**
         *  城市
         */
        NSString * cityStr = [NSString getAllArea:dic];
        NSString * indusstr = [NSString getIndusryName:[aArray firstObject]];

        
        cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
        cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parent_level_name"]];
        [cell.levelIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"child_level_icon"]]]];
        [cell.addFriendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriendSearch:)]];
        NSInteger str =  [[NSString stringWithFormat:@"%@", [dic objectForKey:@"distance"]] integerValue];
        cell.distance.text = [NSString stringWithFormat:@"%d 米", str * 1000];
        [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];

        
        return cell;
        
    }
    
    return nil;
}
- (void)addFriend:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * userName = nil;
    userName = [self.listArray[path.row] objectForKey:@"user_name"];
    [[LCAddFriends shareAddFriend] addFriendWith:userName vc:self];
}
- (void)gotoChat:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    ChatViewController * userVC = [[ChatViewController alloc] init];
    NSDictionary *dic = self.listArray[path.row];
    userVC.friendModel = [[FriendModel alloc]initWithDic:dic];
    [FriendDao insertFriendTableWith:userVC.friendModel];
    
    NSString * userName = [dic objectForKey:@"username"];
    NSString * realName = [dic objectForKey:@"real_name"];
    NSString * avatar = [dic  objectForKey:@"avatar"];
    ;
    userVC.unionNickName = [NSString stringWithFormat:@"%@@%@,%@,%@",userName,XMPP_SERVER_URL, realName,avatar];
    
    userVC.user_id = dic[@"user_id"];
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];

}
- (void)addFriendSearch:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)[[tap.view superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSString * userName = nil;
    userName = [self.searchArray[path.row] objectForKey:@"user_name"];
    [[LCAddFriends shareAddFriend] addFriendWith:userName vc:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *第一个section：按照页面
     *第二个section
     *按照标识符跳转
     *下级页面：用户详情
     */
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    NearlyContactsViewController * vc =[[NearlyContactsViewController alloc] init];
                    vc.location = self.location;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1:
                    [self.navigationController pushViewController:[[IndustryViewController alloc] init] animated:YES];
                    break;
                case 2:
                    [self.navigationController pushViewController:[[AreaContactsViewController alloc] init] animated:YES];
                    break;
                case 3:
                    [self.navigationController pushViewController:[[ProfessionViewController alloc] init] animated:YES];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            if ([[self.listArray[indexPath.row] objectForKey:@"is_friend"] integerValue] == 1) {
                LCMyFileViewController *vc = [[LCMyFileViewController alloc] init];
                vc.isChat = NO;
                vc.isMe = NO;
                vc.user_id =[self.listArray[indexPath.row] objectForKey:@"user_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                UserDetailViewController * userVC = [[UserDetailViewController alloc] init];
                userVC.userid = [[self.listArray objectAtIndex:indexPath.row] objectForKey:@"user_id"];
                [self.navigationController pushViewController:userVC animated:YES];
            }
        }
    }
    else{
        UserDetailViewController * userVC = [[UserDetailViewController alloc] init];
        userVC.userid = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"user_id"];
        [self.navigationController pushViewController:userVC animated:YES];
     
    }
}
- (void)addNewFriends:(UIButton *)button
{
    /*
     
     *添加好友
     */
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak NewRenMaiViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:ByKeywords_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"keywords":searchBar.text?searchBar.text:@""} setSuccessBlock:^(id dictionary) {
        
        vc.searchArray = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"user_list"]];
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
    
//    for (NSDictionary * dic in self.listArray) {
//          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self contains[cd]%@", _searchBar.text];
//          NSString * name = [dic objectForKey:@"real_name"];
//    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetWork shareNetWork] networkCancle];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
