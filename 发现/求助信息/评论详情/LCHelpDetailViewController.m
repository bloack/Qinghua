//
//  LCHelpDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCHelpDetailViewController.h"
#import "LCCommentDetailTableViewCell.h"
#import "LCDemmondTableViewCell.h"
#import "YFInputBar.h"
#import "IBActionSheet.h"
#import "LCGetHelpViewController.h"
#import "NSString+MD5.h"
@interface LCHelpDetailViewController ()<YFInputBarDelegate, IBActionSheetDelegate, UIAlertViewDelegate >
@property (nonatomic, retain)NSMutableArray * array;
@property (nonatomic, retain)NSMutableString * message;
@property (nonatomic, retain)NSDictionary * detailDic;
@end

@implementation LCHelpDetailViewController
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    }
    
    [self getdata];
}
- (void)getdata
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCHelpDetailViewController *vc = self;
    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"help_id":self.help_id};
    [[NetWork shareNetWork] getDataWithURLStr:Help_Detail aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        vc.detailDic = [[dictionary objectForKey:@"data"] objectForKey:@"help_info"];
        [vc.tableView reloadData];
        NSDictionary * dicc = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"10", @"x_id":vc.help_id};
        [[NetWork shareNetWork] getDataWithURLStr:Comment_List aImage:nil aBody:dicc aSuccessBlock:^(id dictionary){
            NSLog(@"%@", dictionary);
            vc.array = [NSMutableArray arrayWithCapacity:0];
            [vc.array addObjectsFromArray:[[dictionary objectForKey:@"data"] objectForKey:@"list"]];
            [vc.tableView reloadData];
        } setFailBlock:^(id obj) {
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
- (void)right1ButtonClick
{
    NSLog(@"1111");
    self.sheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"更新" otherButtonTitles:@"删除",@"取消", nil];
    [self.sheet setFont:[UIFont systemFontOfSize:13.0]];
    [_sheet showInView:self.view];
}
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            LCGetHelpViewController * vc = [[LCGetHelpViewController alloc] init];
            vc.isMain = YES;
            vc.str = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"content"]];
            vc.help_id = self.help_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak LCHelpDetailViewController *vc = self;
            [[NetWork shareNetWork] netWorkWithURL:Help_Delete_URL dic:@{@"help_id": self.help_id, @"user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", dictionary);
                if ([[dictionary objectForKey:@"status"]isEqualToString:@"200"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate: vc cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                    [alert show];
                }
            }];
        
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"评论";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self LoadinpuBar];
    // Do any additional setup after loading the view from its nib.
}
/**
 *  加载输入框
 */
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
    [self commentWithMessage:str];
    self.message = str;
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
        return [[self.detailDic objectForKey:@"content"] getHightWithfontSize:260.0] + 95;
    }
    return [[self.array[indexPath.row] objectForKey:@"content"] getHightWithfontSize:260.0] + 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellID = @"LCCommentDetailTableViewCell";
        LCCommentDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        }
        cell.name.text = [self.detailDic objectForKey:@"real_name"];
        [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
        cell.time.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"create_time"]];
        cell.likeNumber.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"like_number"]];
        cell.commentNumber.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"comment_number"]];
        cell.content.text = [NSString stringWithFormat:@"%@", [self.detailDic objectForKey:@"content"]];
        [cell.likeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)]];
        [cell buildUIWithContentHight:[[self.detailDic objectForKey:@"content"] getHightWithfontSize:260.0] imageStr:@""];
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
- (void)likeTap:(UITapGestureRecognizer *)tap
{
    LCCommentDetailTableViewCell  * cell = [[(UITableViewCell *)[tap.view superview] superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%d", path.row);
    
    NSInteger  likeNu = [cell.likeNumber.text integerValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCHelpDetailViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Like_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_id":self.help_id, @"x_type":@"10"} setSuccessBlock:^(id dictionary) {
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
                                  [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"网络错误" forError: YES];
                              }
     ];
    
    
}
/**
 *  评论
 */
- (void)commentWithMessage:(NSString *)message
{
    [self loadArrayWithStr:message];
    //    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(commentNetWithMessage) object:nil];
    [thread start];
}
/**
 *  评论网络请求
 *
 */
- (void)commentNetWithMessage
{
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    NSLog(@"%@====%@=====%@=====10", userId, self.help_id, self.message );
    NSDictionary * dic = @{@"user_id": userId, @"x_id":self.help_id, @"content":self.message, @"x_type":@"10"};
    [[NetWork shareNetWork] netWorkWithURL:Comment_Create dic:dic setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
