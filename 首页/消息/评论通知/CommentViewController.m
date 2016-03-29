//
//  CommentViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "CommentViewController.h"
#import "LCCommentTableViewCell.h"
#import "LCNeedDetailViewController.h"
#import "LCHelpDetailViewController.h"
#import "LCActivityDetailViewController.h"
#import "LCGroupDATDetailViewController.h"
@interface CommentViewController ()
@property (nonatomic, strong)NSArray * array;
@end

@implementation CommentViewController

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
    self.titleString = @"评论通知";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    /*
     
     *双层页面
     *第二个tbView和第一个类似
     *重新自定义cell界面
     */
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessageList];
}
- (void)getMessageList
{
    self.array = [MyUserDefult objectForKey:@"commentArray"];
    NSLog(@"%@", self.array);
}
#pragma mark tableViewDatesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCCommentTableViewCell";
    LCCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.array[indexPath.row];
    
    NSString * uu = [dic[@"extras"] objectForKey:@"u"];
    NSArray * ary = [uu componentsSeparatedByString:@","];
    
    [cell.icon setImageWithURL:[ary lastObject] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    cell.name.text = ary[1];
    cell.time.text = dic[@"t"];
    
    
    NSDictionary * dataDic = @{@"10":@"个人求助",@"11":@"个人动态",@"20":@"企业信息(供应、需求、项目)",@"21":@"招聘信息",@"22":@"产品信息",@"30":@"群组信息(动态、通知、话题)",@"31":@"群组活动",@"32":@"群组活动精彩回放",@"40":@"新闻资讯",@"41":@"微访谈"};
    if ([[dic[@"extras"] objectForKey:@"type"] intValue] == 15) {
        cell.contant.text = [NSString stringWithFormat:@"评论了您的%@",dataDic[[[[dic[@"extras"] objectForKey:@"x"]componentsSeparatedByString:@","] firstObject]]];
    }
    else
    {
        cell.contant.text = [NSString stringWithFormat:@"赞了您的%@",dataDic[[[[dic[@"extras"] objectForKey:@"x"]componentsSeparatedByString:@","] firstObject]]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *按照标识符跳转
     *UE没有下级页面
     *下级页面：评论（待定）
     */
    NSDictionary * dic = self.array[indexPath.row];
    NSString * needId = [[[dic[@"extras"] objectForKey:@"x"] componentsSeparatedByString:@","] lastObject] ;
    switch ([[[[dic[@"extras"] objectForKey:@"x"] componentsSeparatedByString:@","] firstObject] intValue]) {
        case 10:
        {
            LCHelpDetailViewController * vc = [[LCHelpDetailViewController alloc] init];
            vc.help_id = needId;
            vc.isMain = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 11:
        {
            
        }
            break;
            case 20:
        {
            LCNeedDetailViewController * vc = [[LCNeedDetailViewController alloc] init];
            vc.isMain = YES;
            vc.busis_id = needId;
            vc.type_id = @"20";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 30:
        {
            LCGroupDATDetailViewController * vc = [[LCGroupDATDetailViewController alloc] init];
            vc.information_id = needId;
            vc.isAdmain = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 31:
        {
            LCActivityDetailViewController * vc = [[LCActivityDetailViewController alloc] init];
            vc.active_id = needId;
            vc.isMian = YES;
            vc.isFavourite = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
