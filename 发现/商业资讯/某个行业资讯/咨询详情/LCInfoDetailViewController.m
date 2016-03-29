//
//  LCInfoDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCInfoDetailViewController.h"
#import "SelectionCell.h"
#import "LCShare.h"
@interface LCInfoDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, retain)NSMutableArray * managerArray;
@end

@implementation LCInfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"资讯详情";
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavbar setRight1ButtonWithnormalImageName:@"qinghua-huodong+.png" highlightedImageName:@"qinghua-huodong+.png" backgroundColor:nil buttonTitle:nil titleColor: nil buttonFram:CGRectMake(280, 5, 30, 30)];
    [self getdata];
}
- (void)getdata
{
    __weak LCInfoDetailViewController *vc = self;
    [[NetWork shareNetWork] getDataWithURLStr:News_detail aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"news_id":self.info_id} aSuccessBlock:^(id myDictionary) {
        NSLog(@"%@", myDictionary);
        vc.urlStr = [[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"url"];
        vc.titleLable.text = [[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"title"];
        vc.timeLable.text = [[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"release_time"];
        vc.sourceLable.text = [NSString stringWithFormat:@"来源:%@", [[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"source"]];
        [vc.webView loadHTMLString:[[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"content"] baseURL:nil];
        if ([[[myDictionary[@"data"] objectForKey:@"news_info"] objectForKey:@"favorites_id"] integerValue] == 0) {
        vc.isMain = NO;
        }
        else
        {
            vc.isMain = YES;
        }
        [vc loadTable];
    } setFailBlock:^(id obh) {
        
    }];

}
- (void)loadTable
{
    __weak LCInfoDetailViewController *blockVC = self;
    [blockVC.view bringSubviewToFront:self.blockTable];
    _isOpened=NO;
    if (blockVC.isMain == YES) {
        blockVC.managerArray = [NSMutableArray arrayWithArray:@[@"取消收藏", @"分享到新浪微博", @"分享到微信朋友圈", @"分享到微信好友",@"分享到 QQ 空间"]];
    }
    else if(blockVC.isMain == NO)
    {
        blockVC.managerArray =  [NSMutableArray arrayWithArray:@[@"收藏", @"分享到新浪微博", @"分享到朋友圈",@"分享到微信好友", @"分享到 QQ 空间"]];
    }
    
    int a = blockVC.managerArray.count;
    [blockVC.blockTable initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return a;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:blockVC options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.lb.text = blockVC.managerArray[indexPath.row];
        cell.lb.font = [UIFont systemFontOfSize:13.0];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        UIImage * image = [UIImage imageNamed:@"120.png"];
        NSString * text = blockVC.content;
        switch (indexPath.row) {
            case 0:
            { [blockVC shoucang];}
                break;
            case 1:
            { [[LCShare shareLCShare] shareToSinaWithImage:image text:text Url:blockVC.urlStr title:blockVC.titleLable.text];}
                break;
            case 2:
            {  [[LCShare shareLCShare] shareToWechatFriendsCycleWithImage:image text:text Url:blockVC.urlStr title:blockVC.titleLable.text];}
                break;
            case 3:
            {   [[LCShare shareLCShare] shareToWechatFriendsWithImage:image text:text Url:blockVC.urlStr title:blockVC.titleLable.text];}
                break;
            case 4:
            {   [[LCShare shareLCShare] shareToQQZoneWithImage:image text:text Url:blockVC.urlStr title:blockVC.titleLable.text];}
                break;
            default:
                break;
        }
        [blockVC.myNavbar.right1Button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];

}
-(void)right1ButtonClick
{    __weak LCInfoDetailViewController *blockVC = self;

    if (_isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=blockVC.blockTable.frame;
            frame.size.height= 0;
            [blockVC.blockTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            blockVC.isOpened=NO;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=blockVC.blockTable.frame;
            frame.size.height= 42* blockVC.managerArray.count;
            [blockVC.blockTable  setFrame:frame];
        } completion:^(BOOL finished){
            
            blockVC.isOpened=YES;
        }];
        
        
    }
    
}

- (void)shoucang
{
        __weak LCInfoDetailViewController *weakVC = self;
    [MBProgressHUD showHUDAddedTo:weakVC.view animated:YES];
    if (weakVC.isMain == YES) {
        [[NetWork shareNetWork] netWorkWithURL: favorites_delete dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"0",@"favorites_id":weakVC.favourite_id?weakVC.favourite_id:@""} setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideAllHUDsForView:weakVC.view animated:YES];
            if ([dictionary[@"status"] isEqualToString:@"200"]) {
                weakVC.isMain = NO;
                [[SystemManager shareSystemManager] showHUDInView:weakVC.view messge:@"取消收藏成功" forError: YES];
                [weakVC loadTable];
                [weakVC.blockTable reloadData];
            }
            else
            {
                [[SystemManager shareSystemManager] showHUDInView:weakVC.view messge:@"取消收藏失败" forError: YES];
            }
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:weakVC.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:weakVC.view messge:@"网络错误" forError: YES];
            
        }];
    }
    else
    {
        [[NetWork shareNetWork] netWorkWithURL:favorites_Create dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"x_type":@"0",@"x_id":weakVC.info_id} setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideAllHUDsForView:weakVC.view animated:YES];
            if ([dictionary[@"status"] isEqualToString:@"200"]) {
                weakVC.isMain = YES;
                [[SystemManager shareSystemManager] showHUDInView:  weakVC.view messge:@"收藏成功" forError: YES];
                weakVC.favourite_id = [[dictionary objectForKey:@"data"] objectForKey:@"favorites_id"];
                [weakVC loadTable];
                [weakVC.blockTable reloadData];
            }
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:weakVC.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:weakVC.view messge:@"网络错误" forError: YES];
            
        }];
    }

}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"无法加载页面" delegate: self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
