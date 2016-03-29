//
//  LCintruoduceViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCIntruoduceOtherViewController.h"
#import "LCRenMaiTableViewCell.h"
#import "ItemCheck.h"
#import "NSString+MD5.h"
@interface LCIntruoduceOtherViewController ()
@property (nonatomic, retain)NSMutableArray * array;
@end

@implementation LCIntruoduceOtherViewController

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
    self.titleString = @"引荐";
    self.tableView.allowsSelectionDuringEditing = YES;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.introArray = [NSMutableArray arrayWithCapacity:0];
    [self.tableView setEditing:YES animated:YES];
    
    [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"引荐" titleColor: nil buttonFram:CGRectZero];
    [self getFriends];
}
- (void)right1ButtonClick
{
    NSMutableString * userStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.items.count; i ++) {
        ItemCheck * item = self.items[i];
        if (item.isCheck) {
            NSString * str = [[self.array objectAtIndex:i] objectForKey:@"user_id"];
            userStr = [userStr stringByAppendingString:[NSString stringWithFormat:@"%@,", str]];
            NSLog(@"%@", userStr);
        }
    }
    
    
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"to_user_ids":userStr?userStr:@"", @"introduce_user_id":self.user_id?self.user_id:@"1"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCIntruoduceOtherViewController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetWork shareNetWork] netWorkWithURL:Introduce_URL dic:dic  setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ([dictionary[@"status"] integerValue] == 200) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"引荐成功" forError: YES];
                [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
            }
            else {
              [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"引荐失败" forError: YES];
            }
            NSLog(@"%@", dictionary);
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
            NSLog(@"%@", obj);
        }
    
         
         ];
    });
    if ([userStr isEqualToString:@","]) {
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请选择引荐人" forError: YES];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (void)getFriends
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCIntruoduceOtherViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Friends_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.array = [NSMutableArray arrayWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"friend_list"]];
        vc.items = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i < vc.array.count; i++) {
            ItemCheck *item = [[ItemCheck   alloc] init];
            item.isCheck = NO;
            [vc.items addObject:item];
    
        }
        [vc.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
}


#pragma mark - action

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCRenMaiTableViewCell";
    LCRenMaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = self.array[indexPath.row];
    
    [cell.iconImage setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    [cell setChecked:[(ItemCheck *)self.items[indexPath.row] isCheck]];
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
    NSString * indusstr = [NSString getIndusryName:dic];
    

    cell.addFriendImage.hidden = YES;
    cell.province.text = [NSString stringWithFormat:@"%@%@,%@%@", Left_Brackets,  cityStr,indusstr, Right_Brackets];
    cell.level.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"child_level_name"]];
    [cell buildChild:[dic objectForKey:@"child_level_icon"] parent:[dic objectForKey:@"parent_level_icon"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCheck* item = [_items objectAtIndex:indexPath.row];
	
	if (self.tableView.editing)
	{
		LCRenMaiTableViewCell *cell = (LCRenMaiTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        item.isCheck = !item.isCheck;
		[cell setChecked:item.isCheck];
	}
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
