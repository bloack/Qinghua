//
//  LCNeedDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCNeedDetailViewController.h"
#import "LCCommentDetailTableViewCell.h"
#import "LCDemmondTableViewCell.h"
#import "YFInputBar.h"
#import "IBActionSheet.h"
#import "NSString+MD5.h"
#import "LCMyFileViewController.h"
#import "UserDetailViewController.h"
#import "SupplyViewController.h"
@interface LCNeedDetailViewController ()<YFInputBarDelegate, UIAlertViewDelegate>
@property (nonatomic, retain)NSMutableArray * array;
@property (nonatomic, retain)NSDictionary * detailDic;
@property (nonatomic, retain)NSMutableString * message;
@end

@implementation LCNeedDetailViewController

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
    self.titleString = @"评论";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.titleName.text = self.titleStr;
    NSLog(@"%@", [MyUserDefult objectForKey:@"userDic"]);
    [self LoadinpuBar];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self getListData];
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    }

}
- (void)getListData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCNeedDetailViewController  *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Business_info_URL dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"business_id":vc.busis_id} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        vc.detailDic = [[dictionary objectForKey:@"data"] objectForKey:@"business_info"];
        [vc.tableView reloadData];
        [[NetWork shareNetWork] netWorkWithURL:Comment_List  dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":self.type_id, @"x_id":vc.busis_id} setSuccessBlock:^(id dictionary) {

            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            vc.array = [NSMutableArray arrayWithCapacity:0];
            [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
            [vc.tableView reloadData];
        }
         setFailBlock:^(id obj) {
             [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

         }
         ];
    }         setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

    }];
}
- (void)right1ButtonClick
{
    NSLog(@"1111");
    IBActionSheet *sheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"更新" otherButtonTitles:@"删除",@"取消", nil];
    [sheet setFont:[UIFont systemFontOfSize:13.0]];
    [sheet showInView:self.view];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            SupplyViewController * vc = [[SupplyViewController alloc] init];
            vc.isMain = YES;
            vc.need_id = self.busis_id;
            vc.companyStr = [self.detailDic objectForKey:@"company_name"];
            vc.company_id = [self.detailDic objectForKey:@"company_id"];
            vc.content = [self.detailDic objectForKey:@"content"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                __weak LCNeedDetailViewController  *vc = self;
            [[NetWork shareNetWork] netWorkWithURL:Business_Delete_URL dic:@{@"business_id": self.busis_id, @"user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", [dictionary objectForKey:@"message"]);
                if ([[dictionary objectForKey:@"status"]
                     isEqualToString:@"200"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError:YES];
                        [vc performSelector:@selector(pop:) withObject:nil afterDelay:0.5];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"删除失败" forError: YES];
                    });
                }
            }
                setFailBlock:^(id obj) {
                    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                }
             ];
        }
            break;
        default:
            break;
    }
}
- (void)LoadinpuBar
{
    YFInputBar *inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds)-44, 320, 44)];

    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputBar];
}
-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    NSString * uId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    NSDictionary * dicc = @{@"user_id": uId, @"x_id":self.busis_id, @"content":str, @"x_type":self.type_id};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak LCNeedDetailViewController  *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Comment_Create dic:dicc setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        NSLog(@"%@", dictionary);
        if ([[dictionary objectForKey:@"status"]isEqualToString:@"200"]) {
            [vc  getListData];
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发送失败" forError: YES];
        }
    }
     setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
     }
     ];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UIView*)obj) resignFirstResponder];
    }];
}
- (NSString *)getNowTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
- (void)loadArrayWithStr:(NSString *)str
{
    NSDictionary * dic = @{@"avatar":[[[MyUserDefult objectForKey:@"userDic"] objectForKey:@"data"] objectForKey:@"avatar"], @"real_name":[[[MyUserDefult objectForKey:@"userDic"] objectForKey:@"data"] objectForKey:@"nickname"], @"content":str, @"create_time":[self getNowTime]};
    [self.array addObject:dic];
    [self.tableView reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
        return self.array.count;
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"评论";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.detailDic[@"image"] length] == 0) {
            return [[self.detailDic objectForKey:@"content"] getHightWithfontSize:260.0] + 100;
        }else
        {
                        return [[self.detailDic objectForKey:@"content"] getHightWithfontSize:260.0] + 310;
        }
    }
    return [[self.array[indexPath.row] objectForKey:@"content"] getHightWithfontSize:260.0] + 100;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellID = @"LCCommentDetailTableViewCell";
        LCCommentDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"qiye.png"]];
        cell.likeNumber.text = [self.detailDic objectForKey:@"like_number"];
        cell.commentNumber.text = [self.detailDic objectForKey:@"comment_number"];
        cell.name.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"company_name"]];
        cell.content.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"content"]];
        cell.time.text = [NSString stringWithFormat:@"%@", [self.detailDic  objectForKey:@"create_time"]];
        [cell buildUIWithContentHight:[[self.detailDic objectForKey:@"content"] getHightWithfontSize:260.0] imageStr:[self.detailDic objectForKey:@"image"]];
        cell.releasePerson.hidden = NO;
        [cell.person addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personDetail)]];
        cell.releasePerson.text = [NSString stringWithFormat:@"发布人: %@", self.detailDic[@"real_name"]];
        [cell.likeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)]];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSDictionary * dic = [self.array objectAtIndex:indexPath.row];
        static NSString * cellID = @"LCDemmondTableViewCell";
        LCDemmondTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        [cell.icon setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"meIcon@2x.png"]];
        cell.name.text = [dic objectForKey:@"real_name"];
        cell.content.text = [dic objectForKey:@"content"];
        cell.time.text = [dic objectForKey:@"create_time"];
        [cell buildUIWithContentHight:[[self.array[indexPath.row] objectForKey:@"content"] getHightWithfontSize:260.0]];

        return cell;
    }
  
    return nil;
}
/**
 *  评论
 */

- (void)personDetail
{
    if ([self.detailDic[@"is_friend"] integerValue] == 1) {
       LCMyFileViewController   *detailVC = [[LCMyFileViewController  alloc] init];
        detailVC.isChat = NO;
        
        detailVC.user_id = self.detailDic[@"user_id"];
        if ([self.detailDic[@"user_id"] isEqualToString:[MyUserDefult objectForKey:@"UserID"]]) {
            detailVC.isMe = YES;
        }
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    else {
       UserDetailViewController * detailVC = [[UserDetailViewController alloc] init];
        detailVC.userid =  self.detailDic[@"user_id"];
        [self.navigationController pushViewController:detailVC animated:YES];

    }

}
- (void)likeTap:(UITapGestureRecognizer *)tap
{
    LCCommentDetailTableViewCell  * cell = [[(UITableViewCell *)[tap.view superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%d", path.row);
    
    NSInteger  likeNu = [cell.likeNumber.text integerValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak LCNeedDetailViewController  *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Like_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_id":self.busis_id, @"x_type":@"20"} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError:YES];
        if ([dictionary[@"status"] integerValue] == 200) {
            cell.likeNumber.text = [NSString stringWithFormat:@"%d", likeNu + 1];
        }
        else
        {
            
        }
        //        [self getAreaList];
    }
                              setFailBlock:^(id obj) {
                                         [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                                  [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                              }
     ];


}
- (void)commentWithMessage:(NSString *)message
{
    [self loadArrayWithStr:message];
//    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(commentNetWithMessage:) object:nil];
    [thread start];
}
/**
 *  评论网络请求
 *
 */
- (void)commentNetWithMessage:(NSString *)messa
{
    NSString * uId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    NSDictionary * dicc = @{@"user_id": uId, @"x_id":self.busis_id, @"content":self.message, @"x_type":self.type_id};
    [[NetWork shareNetWork] netWorkWithURL:Comment_Create dic:dicc setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    }];
}
//- (void)recieveDataSuccessWithNetwork:(NetWork *)net Object:(id)object
//{
//    NSLog(@"%@", object);
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pop:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
