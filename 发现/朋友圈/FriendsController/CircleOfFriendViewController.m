//
//  CircleOfFriendViewController.m
//  Boyage
//
//  Created by song longbiao on 13-8-27.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import "CircleOfFriendViewController.h"
#import "FriendStatusCell.h"
#import "UIImageView+WebCache.h"
#import "NetWork.h"
#import "LCMyMainViewController.h"
//#import "DetailInfoViewController.h"
@interface CircleOfFriendViewController ()

@end

@implementation CircleOfFriendViewController
@synthesize searchDisplayController;
//#pragma mark - ASMediaFocusDelegate
//- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
//{
//    return ((UIImageView *)view).image;
//}
//
//- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
//{
//    return self.view.bounds;
//}
//
//- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
//{
//    return self;
//}
//
//- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaPathForView:(UIView *)view
//{
//    NSString *Url;
//    
//    // Here, images are accessed through their name "1f.jpg", "2f.jpg", …
//    NSInteger index = [MyImagArr indexOfObject:view] ;
//    Url = [AppImagArr objectAtIndex:index];
//    return Url;
//}
//-(void)InitImageView
//{
//    self.mediaFocusManager.delegate = nil;
//    [self.mediaFocusManager   release];
//    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
//    self.mediaFocusManager.delegate = self;
//    
//    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
//    [self.mediaFocusManager installOnViews:MyImagArr];
//    
//}
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
    
    /**
     *  初始化搜索框
     */
    self.searchDisplayController = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    
    // Do any additional setup after loading the view from its nib.
    _StarList = [[NSMutableArray alloc]initWithObjects: nil];
    MyImagArr = [[NSMutableArray alloc]initWithObjects: nil];
    CellArr =  [[NSMutableArray alloc]initWithObjects: nil];
    AppImagArr = [[NSMutableArray alloc]initWithObjects: nil];
    DeleteArr = [[NSMutableArray alloc]initWithObjects: nil];
    MoreDic = [[NSMutableArray alloc]init];
    reloadTab = NO;
    rowReload = NO;
    isNextPage = YES;
    currnetPage = 1;
    MyTableView = [[PullToRefreshTableView alloc]initWithFrame:CGRectMake(0, 43+Ios7Status, 320, HEIGHT-Ios7Status)];
    MyTableView.delegate  = self;
    MyTableView.dataSource = self;
    MyTableView.isAutoLoad = NO;
    DeleteBtn.hidden = YES;
//    MyTableView.footerView.hidden = YES;
    [self.view addSubview:MyTableView];
    currnetPage = 1;
    
    //好友朋友圈
    if ([_OneUserId length] ==0) {
        self.titleString = @"朋友圈";
        NSDictionary * userDic = [MyUserDefult objectForKey:@"userDic"][@"data"];
        [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
        [UserImg  setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] refreshCache:NO placeholderImage:DefaultImage];
//        [UserImg  setImageWithURL:[NSURL URLWithString:[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"head_img"] ] refreshCache:NO placeholderImage:DefaultImage];
//        [UserImg setImageWithURL:[NSURL URLWithString:@"http://www.iyi8.com/2013/mm_1019/1391_10.html"]];
        [UserNameLab setText:userDic[@"real_name"]];
        [self RequestList];
    } //自己的动态
    else{
        
        
        
        
        self.titleString = @"个人主页";
        
        NSDictionary * userDic = [MyUserDefult objectForKey:@"userDic"][@"data"];
        
        
        [UserImg  setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] refreshCache:NO placeholderImage:DefaultImage];
        [UserNameLab setText:userDic[@"real_name"]];
        [EditMyStatus setHidden:YES];
        if ([_OneUserId isEqualToString:[MyUserDefult objectForKey:@"UserId"]])
        {
            DeleteBtn.hidden = NO;
            [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"编辑" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
        }
        [self RequestOneList];
        
    }


}



-(void)right1ButtonClick
{
    //朋友圈
    if (_OneUserId.length == 0) {
        [self addMyStatus:nil];
    }else
    {
        [self DeleteImage:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    //[[ViewController MainController] hideBottomButton];
    //[self.navigationController setNavigationBarHidden:YES];

}

//返回
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableView delegate and datasourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 1;
//    }else{
        return [_StarList count]+1;
//    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return TitleCell;
    }else{
        if (indexPath.row-1 < [CellArr count]&&rowReload==NO) {
            return [CellArr objectAtIndex:indexPath.row-1];
        }else{
            int height = 48;
            NSDictionary *dic = [_StarList objectAtIndex:indexPath.row-1];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FriendStatusCell" owner:self options:nil];
            FriendStatusCell *cell = [array objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.UserImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] refreshCache:NO placeholderImage:DefaultImage];
            cell.HomePageBtn.tag = 1000+indexPath.row-1;
//            if ([_OneUserId length]==0) {
            [cell.HomePageBtn addTarget:self action:@selector(OneInfo:) forControlEvents:UIControlEventTouchUpInside];
//            }
            
            [cell.UserName setText:[dic objectForKey:@"real_name"]];
            cell.DeleteBtn.tag = 4000+indexPath.row-1;
            [cell.DeleteBtn addTarget:self action:@selector(DeleteClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.DeleteBtn.hidden =!DeleteBtn.selected;
            [DeleteArr addObject:cell.DeleteBtn];
            
//            float LineNum = [[dic objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:15]].width;
//            float LabWidth = cell.Content.frame.size.width;
//            cell.Content.numberOfLines = ceilf(LineNum/LabWidth);
//            [cell.Content setFrame:CGRectMake(79, 48, 227, 25*ceilf(LineNum/LabWidth))];
//            [cell.Content setText:[dic objectForKey:@"content"]];
            UIView *contentView = [RequestCenter assembleMessageAtIndex:[dic objectForKey:@"content"] from:YES];
            [contentView setFrame:CGRectMake(79, height, 227, contentView.frame.size.height)];
            BOOL more = NO;
            if (contentView.frame.size.height>125) {
                if (![MoreDic containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                    [contentView setFrame:CGRectMake(79, height, 227, 125)];
                }
                more = YES;
            }
            [contentView setClipsToBounds:YES];
            [cell addSubview:contentView];
            [contentView release];


            height = height+contentView.frame.size.height;
            if (more==YES) {
                UIButton *MoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(79, height-12, 60, 44)];
                if ([MoreDic containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                    [MoreBtn setTitle:@"《收起" forState:UIControlStateNormal];
                }else{
                    [MoreBtn setTitle:@"展开》" forState:UIControlStateNormal];
                }
                [MoreBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                [MoreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

                MoreBtn.tag=30000+indexPath.row;
                [MoreBtn addTarget:self action:@selector(More:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:MoreBtn];
                height +=20;
            }
        
        /*
            NSArray *imgArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"app_image"] ];
            for (int i = 0; i < [imgArr count]; i++) {
                UIImageView *img = [[[UIImageView alloc]initWithFrame:CGRectMake(75*(i%3) +79, 75*(i/3) +height, 70, 70)] autorelease];
                [img setContentMode:UIViewContentModeScaleAspectFill];
                [img setClipsToBounds:YES];
                DoubleBtn *btn = [[DoubleBtn alloc]initWithFrame:img.frame];
                btn.tag = indexPath.row-1+40000;
                btn.OtherTag = i;
                [btn addTarget:self action:@selector(LookBigImg:) forControlEvents:UIControlEventTouchUpInside];
                [img setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]] refreshCache:NO placeholderImage:DefaultImage];
                [MyImagArr addObject:img];
                [AppImagArr addObject:[[dic objectForKey:@"image"] objectAtIndex:i]];
                [cell addSubview:img];
                [cell addSubview:btn];
            }
         
         
            height = height + ceilf(((float)[imgArr count])/3.0)*75;
         */
        
        UIImageView *img = [[[UIImageView alloc]initWithFrame:CGRectMake(79, height, 70, 70)] autorelease];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img setClipsToBounds:YES];
        [img setImageWithURL:[NSURL URLWithString:dic[@"image"]] refreshCache:NO placeholderImage:DefaultImage];
        [MyImagArr addObject:img];
        [cell addSubview:img];
        height = height + ceilf(((float)1)/3.0)*75;
        
        
            [cell.Times setFrame:CGRectMake(79, height+5, 132, 21)];
        
        /*
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"create_time"]integerValue]];
            [cell.Times setText:[RequestCenter isoDate2FromDate:confromTimesp]];
        */
        [cell.Times setText:dic[@"create_time"]];
        
            [cell.SaidBtn setFrame:CGRectMake(220, height-10, 40, 40)];
             cell.SaidBtn.tag = 600+indexPath.row-1;
            [cell.SaidBtn addTarget:self action:@selector(AddSaid:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.GoodBtn setFrame:CGRectMake(256, height-10, 40, 40)];
            cell.GoodBtn.tag = 100+indexPath.row-1;
            [cell.GoodBtn addTarget:self action:@selector(AddGood:) forControlEvents:UIControlEventTouchUpInside];
            [cell.SaidNum setFrame:CGRectMake(234, height+5, 30, 20)];
            [cell.GoodNum setFrame:CGRectMake(288, height+8, 30, 20)];
            cell.GoodNum.tag = 800+indexPath.row-1;
            [cell.GoodNum setText:[dic objectForKey:@"like_number"]];
            if ([[dic objectForKey:@"check"]integerValue]==0) {
                [cell.GoodBtn setSelected:YES];
            }
            height = height+30;
            float width =105;
            UIColor *lightColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];

            GoodArr = [[NSArray alloc]initWithArray:[[dic objectForKey:@"zanarr"] retain]];
            if ([GoodArr count]>10) {
                UIImageView *lightBg = [[UIImageView alloc]initWithFrame:CGRectMake(79.0,height,230.0,25)];
                [lightBg setBackgroundColor:lightColor];
                [cell addSubview:lightBg];
                [lightBg release];
                UILabel *goodlistLab = [[UILabel alloc]initWithFrame:lightBg.frame];
                [goodlistLab setText:[NSString stringWithFormat:@"已有%d赞过",[GoodArr count]]];
                [cell addSubview:goodlistLab];
                [goodlistLab release];
                height = height+30;
            }else{
                if ([GoodArr count]>0) {
                    NSString *goodStr = @"        ";
                    for (int i = 0; i <[GoodArr count]; i++) {
                        goodStr = [goodStr stringByAppendingString:[[GoodArr objectAtIndex:i] objectForKey:@"uaername"]];
                        if (i+1!=[GoodArr count]) {
                            goodStr = [goodStr stringByAppendingString:@","];
                        }
                    }


                    float LineNum = [goodStr sizeWithFont:[UIFont systemFontOfSize:15]].width;
                    int lines= ceilf(LineNum/227.0);
                    //背景
                    UIImageView *lightBg = [[UIImageView alloc]initWithFrame:CGRectMake(79.0,height,230.0,25*lines)];
                    [lightBg setBackgroundColor:lightColor];
                    [cell addSubview:lightBg];
                    [lightBg release];
                    //赞图标
                    UIImageView *goodimge = [[UIImageView alloc]initWithFrame:CGRectMake(72.0,height-15,40,40)];
                    [goodimge setImage:[UIImage imageNamed:@"good2.png"]];
                    [cell addSubview:goodimge];
                    [goodimge release];
                    
//                    UILabel *goodlistLab = [[UILabel alloc]initWithFrame:CGRectMake(79, height, 227, 25*lines)];
//                    [goodlistLab setText:goodStr];
//                    goodlistLab.numberOfLines = lines;
//                    [goodlistLab setFont:[UIFont systemFontOfSize:13.0]];
//                    [goodlistLab setBackgroundColor:[UIColor clearColor]];
//                    goodlistLab.tag = 5000+indexPath.row-1;
//                    [cell addSubview:goodlistLab];
//                    [goodlistLab release];
//                    height = height+goodlistLab.frame.size.height;
                    
                    for (int i = 0; i<[GoodArr count];i++) {
                        float btnWitch = [[[GoodArr objectAtIndex:i] objectForKey:@"uaername"] sizeWithFont:[UIFont systemFontOfSize:13]].width;
                        if (width+ btnWitch>300) {
                            width = 85;
                            height+=25;
                        }
                        DoubleBtn *btn = [[DoubleBtn alloc]initWithFrame:CGRectMake(width, height, btnWitch, 25)];
                        btn.tag = i+10000;
                        btn.OtherTag = indexPath.row-1;
                        [btn setTitle:[[GoodArr objectAtIndex:i] objectForKey:@"uaername"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                        [btn addTarget:self action:@selector(UserInfo:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        [btn release];
                        width+=btnWitch+5;
                    }
                    height+=25;
                }
            }
            NSArray *SaidArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"comment_list"]];
        
        /**
         *  评论视图
         */
        UIImageView * commentView = [[UIImageView alloc]initWithFrame:CGRectMake(79, height - 5, 230, 5)];
        commentView.alpha = 0;
        CGRect commentFrame = commentView.frame;
        [cell addSubview:commentView];
        [commentView release];
        
        if (SaidArr.count > 0) {
            commentView.alpha = 1;
            height += 5;
            
            commentView.image = [[UIImage imageNamed:@"pengyouquan_02"] stretchableImageWithLeftCapWidth:50 topCapHeight:20];
        }
        
        
        
            for (int i = 0; i <[SaidArr count]; i++) {
                NSString *midStr;
                if ([[[SaidArr objectAtIndex:i] objectForKey:@"content"] hasPrefix:@"回复"]) {
                    midStr = @" ";
                }else{
                    midStr = @":";
                }
                NSString *content = [NSString stringWithFormat:@"%@%@%@",[[SaidArr objectAtIndex:i] objectForKey:@"real_name"],midStr,[[SaidArr objectAtIndex:i] objectForKey:@"content"]];
//                float LineNum = [content sizeWithFont:[UIFont systemFontOfSize:15]].width;
//                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(79, height, 227, 25*ceilf(LineNum/227.0))];
//                lable.numberOfLines = ceilf(LineNum/227.0);
//                [lable setFont:[UIFont systemFontOfSize:13.0]];
//                [lable setBackgroundColor:[UIColor lightGrayColor]];
//                [cell addSubview:lable];
//                [lable release];
                UIView *saidview = [RequestCenter assembleMessageAtIndex:content from:YES];
                
                [saidview setFrame:CGRectMake(79, height, saidview.frame.size.width, saidview.frame.size.height)];
                UIImageView *lightBg = [[UIImageView alloc]initWithFrame:CGRectMake(79.0,height,230.0,saidview.frame.size.height)];
                
//                [lightBg setBackgroundColor:lightColor];
//                lightBg.backgroundColor = CREAT_COLOR(195, 195, 195, 1);
                [cell addSubview:lightBg];
                [lightBg release];
                height= height+saidview.frame.size.height;
                [cell addSubview:saidview];
                [saidview release];
                DoubleBtn *btn = [[DoubleBtn alloc]initWithFrame:saidview.frame];
                btn.tag = i+20000;
                btn.OtherTag = indexPath.row-1;
                [btn addTarget:self action:@selector(DeleteCommon:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn release];
                
//                NSLog(@"______%@",NSStringFromCGRect(saidview.frame));
                commentFrame.size.height += saidview.frame.size.height;
//                NSLog(@"________%@",NSStringFromCGRect(commentFrame));
            }
        commentView.frame = commentFrame;
        
        
            //定义点击放大
//                [self InitImageView];
//            NSLog(@"%d---%d",[CellArr count],indexPath.row);
            if ([CellArr count]==indexPath.row-1||rowReload==YES) {
                [CellArr insertObject:cell atIndex:indexPath.row-1];
            }
//            rowReload = NO;
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 150;
    }else{
        NSDictionary *dic = [_StarList objectAtIndex:indexPath.row-1];
        int height = 48;
//        float LineNum = [[dic objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:15]].width;
//        height = height+25*ceilf(LineNum/227.0);
        UIView *contentView = [RequestCenter assembleMessageAtIndex:[dic objectForKey:@"content"] from:YES];
        if (contentView.frame.size.height>125) {
            if (![MoreDic containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
                [contentView setFrame:CGRectMake(79, height, 227, 125)];
            }
            height +=44;
        }
        height = height+contentView.frame.size.height;
        [contentView release];
        
        /*
        height = height + ceilf((float)[[dic objectForKey:@"image"] count]/3.0)*75;
        */
        
        height = height + ceilf((float)1/3.0)*75;
        
        height = height +30;
        
        /*
        NSArray *GoodArr1 = [[NSArray alloc]initWithArray:[dic objectForKey:@"zanarr"]];
        if ([GoodArr1 count]>10) {
            height = height+30;
        }else{
            if ([GoodArr1 count]>0) {
                NSString *goodStr = @"        ";
                for (int i = 0; i <[GoodArr1 count]; i++) {
                    goodStr = [goodStr stringByAppendingString:[[GoodArr1 objectAtIndex:i] objectForKey:@"uaername"]];
                    if (i+1!=[GoodArr1 count]) {
                        goodStr = [goodStr stringByAppendingString:@","];
                    }
                }
                float LineNum = [goodStr sizeWithFont:[UIFont systemFontOfSize:15]].width;
                int lines= ceilf(LineNum/227.0);
                height = height+25*lines+10;
            }
        }
         */
        
        NSArray *SaidArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"comment_list"]];
        for (int i = 0; i <[SaidArr count]; i++) {
            NSString *content = [NSString stringWithFormat:@"%@:%@",[[SaidArr objectAtIndex:i] objectForKey:@"real_name"],[[SaidArr objectAtIndex:i] objectForKey:@"content"]];
            UIView *saidview = [RequestCenter assembleMessageAtIndex:content from:YES];
            height = height +saidview.frame.size.height;
        }
        
        height = height +5;
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return;
    
    LCMyMainViewController * controller = [[LCMyMainViewController alloc]init];
    NSDictionary * dic = [_StarList objectAtIndex:indexPath.row-1];
    
    controller.userId = [dic objectForKey:@"user_id"];
    controller.userImageUrl = [dic objectForKey:@"avatar"];
    controller.userNameStr = [dic objectForKey:@"real_name"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
    return;
    
    
    /**
     *  下面代码是跳转到好友的朋友圈  暂时不用该功能
     */
    if (_OneUserId==0) {
        CircleOfFriendViewController  *VC = [[CircleOfFriendViewController alloc]init];
        [VC.TitleName setText:@"个人主页"];
        VC.OneUserId = [[_StarList objectAtIndex:indexPath.row-1]objectForKey:@"uid"];
        VC.OneUserImg = [[_StarList objectAtIndex:indexPath.row-1]objectForKey:@"user_image"];
        VC.OneUserName = [[_StarList objectAtIndex:indexPath.row-1]objectForKey:@"name"];
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }

}
////当 tableview 为 editing 时,左侧按钮的 style
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
////    if ([_OneUserId isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
////        return UITableViewCellEditingStyleDelete;
////    }else{
//        return UITableViewCellEditingStyleNone;
////    }
//}
//
////移动 cell,防止移动 cell到不支持移动的列表下面
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
//    //    if (proposedDestinationIndexPath.row > 3) {
//    return sourceIndexPath;
//    //    return proposedDestinationIndexPath;
//}
////哪几行可以编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
////哪几行可以移动(可移动的行数小于等于可编辑的行数)
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
////继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
////    [GoodArr removeObjectAtIndex:indexPath.row];
////    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
////    [_goodList deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
////    [self CountProduct];
//    
//}
//
#pragma mark 刷新控件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger returnKey = [MyTableView tableViewDidEndDragging];
    
    if (returnKey != k_RETURN_DO_NOTHING) {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
//    [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
        [self updateThread:key];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger returnKey = [MyTableView tableViewDidDragging];
    if (returnKey == k_RETURN_LOADMORE) {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
//        [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
        [self updateThread:key];
    }
}

-(void)getData
{
    [_StarList removeAllObjects];
    [CellArr removeAllObjects];
    currnetPage  = 1;
    isNextPage = YES;
    if ([_OneUserId length]>0) {
        [self RequestOneList];
    }else{
        [self  RequestList];
    }
    if ([_StarList count]==0) {
//        MyTableView.footerView.hidden = YES;
    }
}

#pragma mark - 请求下页数据
- (void)nextPage
{
        currnetPage++;
        if ([_OneUserId length]>0) {
            [self RequestOneList];
        }else{
           [self  RequestList];
        }    
}


- (void)updateTableView
{
    if (isNextPage) {
        // 一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        [MyTableView reloadData:NO];
    } else {
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        [MyTableView reloadData:YES];
    }
}
- (void)updateThread:(NSString *)returnKey{
//    NSAutoreleasePool * pool = [[[NSAutoreleasePool alloc] init]];
    //sleep(2);
    switch ([returnKey intValue]) {
        case k_RETURN_REFRESH:
            [self getData];
            break;
            
        case k_RETURN_LOADMORE:
            [self nextPage];
            break;
            
        default:
            break;
    }
    [self updateTableView];
//    [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    //[pool release];
}
#pragma mark 请求朋友圈数据 为当前用户所有好友的动态
- (void)RequestList
{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hub.minShowTime=1;
    hub.labelText=@"正在刷新，请稍后...";
    NSDictionary * param;
//        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",@"10",@"per_page",[NSString stringWithFormat:@"%d",currnetPage],@"page",@"1",@"headtype",nil];

    param = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],[NSString stringWithFormat:@"%d",currnetPage],@"10"] forKeys:@[@"user_id",@"current_page",@"page_size"]];
    
    

    [[NetWork shareNetWork] netWorkWithURL:@"/api/moment/moment/getListByCircle" dic:param setSuccessBlock:^(id dictionary) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        if ([[dictionary objectForKey:@"status"] integerValue]==200) {
            _StarCount = [[[dictionary objectForKey:@"data"] objectForKey:@"count"] integerValue];
            [_StarList addObjectsFromArray:[[[dictionary objectForKey:@"data"] objectForKey:@"list"] retain]];
            reloadTab = YES;
            [MyTableView reloadData];
            //             MyTableView.footerView.hidden = YES;
            if ([[[dictionary objectForKey:@"data"] objectForKey:@"list"] count]< 10) {
                isNextPage = NO;
                [MyTableView reloadData:YES];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[dictionary objectForKey:@"message"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            //             [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } setFailBlock:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
    /*
    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/friend/get_friend_trends"
     //    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/class_course/get_list"
                                    setSuccessBlock:^(NSDictionary *dict)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         
         if ([[dict objectForKey:@"code"] integerValue]==200) {
             _StarCount = [[[dict objectForKey:@"data"] objectForKey:@"count"] integerValue];
             [_StarList addObjectsFromArray:[[[dict objectForKey:@"data"] objectForKey:@"list"] retain]];
             reloadTab = YES;
             [MyTableView reloadData];
//             MyTableView.footerView.hidden = YES;
             if ([[[dict objectForKey:@"data"] objectForKey:@"list"] count]< 10) {
                 isNextPage = NO;
                 [MyTableView reloadData:YES];
             }
         }else{
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[[dict objectForKey:@"error"] objectForKey:@"msg"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
             //             [MBProgressHUD hideHUDForView:self.view animated:NO];
         }
         
     }
                                       setFailBlock:^(NSDictionary *dict)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];
         [MBProgressHUD hideHUDForView:self.view animated:NO];
     }];
     */
}

#pragma mark - 请求某个人的主页
//请求某人主页
- (void)RequestOneList
{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hub.minShowTime=1;
    hub.labelText=@"正在刷新，请稍后...";
    NSDictionary * param;
    param = [NSDictionary dictionaryWithObjects:@[self.userId,self.OneUserId,[NSString stringWithFormat:@"%d",currnetPage],@"10"] forKeys:@[@"user_id",@"visit_user_id",@"current_page",@"page_size"]];
    
    
    [[NetWork shareNetWork] netWorkWithURL:@"/api/moment/moment/getListByUser" dic:param setSuccessBlock:^(id dictionary) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
        NSLog(@"_____%@",dictionary);
        NSDictionary * dataDic = dictionary[@"data"];
        
        _StarCount = [(dataDic[@"page_info"])[@"total_record"] intValue];
        [_StarList addObjectsFromArray:[dataDic objectForKey:@"list"]];
        reloadTab = YES;
        [MyTableView reloadData];
        if ([_StarList count]==_StarCount) {
            isNextPage = NO;
            [MyTableView reloadData:YES];
        }
//             MyTableView.footerView.hidden = YES;
        
    } setFailBlock:^(id obj) {
        NSLog(@"请求失败了");
    }];
    
    /*
    param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",@"10",@"per_page",[NSString stringWithFormat:@"%d",currnetPage],@"page",_OneUserId,@"fuid",@"4",@"headtype",nil];
    
    
    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/friend/get_trends"
     //    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/class_course/get_list"
                                    setSuccessBlock:^(NSDictionary *dict)
     {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
         
         if ([[dict objectForKey:@"code"] integerValue]==200) {
             _StarCount = [[[dict objectForKey:@"data"] objectForKey:@"count"] integerValue];
             [_StarList addObjectsFromArray:[[[dict objectForKey:@"data"] objectForKey:@"list"] retain]];
             reloadTab = YES;
             [MyTableView reloadData];
             if ([_StarList count]==_StarCount) {
                 isNextPage = NO;
                 [MyTableView reloadData:YES];
             }
//             MyTableView.footerView.hidden = YES;

         }else{
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[[dict objectForKey:@"error"] objectForKey:@"msg"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
             //             [MBProgressHUD hideHUDForView:self.view animated:NO];
         }
         
     }
                                       setFailBlock:^(NSDictionary *dict)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
     }];
     */
}
-(IBAction)UserInfo:(DoubleBtn *)sender
{
//    DetailInfoViewController *detail = [[DetailInfoViewController alloc] init];
//    detail.userPhoneNum = [[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"zanarr"] objectAtIndex: sender.tag-10000]  objectForKey:@"phone"];
//    [self.navigationController pushViewController:detail animated:YES];
//    [detail release];
}
-(IBAction)DeleteClick:(UIButton *)sender
{
    deleteNum = sender.tag-4000;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除此动态？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag =999;
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==999&&buttonIndex==1) {
        MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hub.minShowTime=1;
        hub.labelText=@"正在删除，请稍后...";
        NSDictionary * param;
        
        param = [NSDictionary dictionaryWithObjects:@[[[_StarList objectAtIndex:deleteNum] objectForKey:@"moment_id"],self.userId] forKeys:@[@"moment_id",@"user_id"]];
        
        [[NetWork shareNetWork] netWorkWithURL:@"/api/moment/moment/delete" dic:param setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
            if ([[dictionary objectForKey:@"code"] integerValue]==200) {
                [_StarList removeObjectAtIndex:deleteNum];
                //                 [CellArr removeAllObjects];
                [MyTableView reloadData:YES];
                [RequestCenter showToast:@"删除成功!"];
                [self.delegate DeleteStatus];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[dictionary objectForKey:@"message"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                //             [MBProgressHUD hideHUDForView:self.view animated:NO];
            }

        } setFailBlock:^(id obj) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }];
        
        /*
        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",[[_StarList objectAtIndex:deleteNum] objectForKey:@"mid"],@"mid",nil];
        
        [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/friend/delete_message"
         //    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/class_course/get_list"
                                        setSuccessBlock:^(NSDictionary *dict)
         {
                      [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             if ([[dict objectForKey:@"code"] integerValue]==200) {
                 [_StarList removeObjectAtIndex:deleteNum];
//                 [CellArr removeAllObjects];
                 [MyTableView reloadData:YES];
                 [RequestCenter showToast:@"删除成功!"];
                 [self.delegate DeleteStatus];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[[dict objectForKey:@"error"] objectForKey:@"msg"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 [alert release];
                 //             [MBProgressHUD hideHUDForView:self.view animated:NO];
             }
             
         }
                                           setFailBlock:^(NSDictionary *dict)
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
                     [MBProgressHUD hideHUDForView:self.view animated:NO];
         }];
         */
    }
}
#pragma mark btn事件
-(IBAction)LookBigImg:(DoubleBtn *)sender
{
    NSArray *arr= [[NSArray  alloc]initWithArray:[[_StarList objectAtIndex:sender.tag-40000] objectForKey:@"image"]];
    NSMutableArray *photoArr = [[NSMutableArray alloc]init];
    for (int i = 0; i <[arr count]; i++) {
        FSBasicImage *firstPhoto;
        if ([[[arr objectAtIndex:i] substringToIndex:4] isEqualToString:@"http"]) {
            firstPhoto= [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:[arr objectAtIndex:i]] name:[NSString stringWithFormat:@"%d/%d",i+1,[arr count]]];
        }else{
            firstPhoto= [[FSBasicImage alloc] initWithImageURL:[NSURL fileURLWithPath:[arr objectAtIndex:i]] name:[NSString stringWithFormat:@"%d/%d",i+1,[arr count]]];
        }
        [photoArr addObject:firstPhoto];
        [firstPhoto release];
    }
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:photoArr];
    self.imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex:sender.OtherTag];
    [self.navigationController pushViewController:_imageViewController animated:YES];
    
    //    localImages = [[[_StarList objectAtIndex:sender.tag-40000] objectForKey:@"image"]  retain];
    //    self.title = @"返回";
    //    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //    localGallery.startingIndex = sender.OtherTag;
    //    [self.navigationController pushViewController:localGallery animated:YES];
    //    [localGallery release];
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num = [localImages count];
	return num;
}
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{

        return FGalleryPhotoSourceTypeNetwork;
}
//- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //return [localImages objectAtIndex:index];
//}
- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption = @"";
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index{
    return [localImages objectAtIndex:index];
    
}

-(IBAction)More:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"展开》"]) {
        [MoreDic addObject:[[NSString stringWithFormat:@"%d",sender.tag-30000] retain]];
    }else{
        [MoreDic removeObject:[[NSString stringWithFormat:@"%d",sender.tag-30000] retain]];
    }
//    [CellArr removeObjectAtIndex:sender.tag-30001];
//    rowReload=YES;
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:sender.tag-30000 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [MyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  赞
 *
 */
-(IBAction)AddGood:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    if (btn.selected==YES) {
     
            //    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
            //    hub.minShowTime=1;
            //    hub.labelText=@"正在初始化，请稍后...";
            NSDictionary * param;
            param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"user_id",@"11",@"x_type",[[_StarList objectAtIndex:btn.tag-100] objectForKey:@"moment_id"],@"x_id",nil];
        
        [[NetWork shareNetWork] netWorkWithURL:@"/api/like/like/create" dic:param setSuccessBlock:^(id dictionary) {
            if ([[dictionary objectForKey:@"status"] integerValue]==200) {
                [btn setSelected:NO];
                UILabel *lable = (UILabel *)[self.view viewWithTag:btn.tag+700];
                
                lable.text = String([lable.text intValue] + 1);
                
                [RequestCenter showToast:@"添加赞成功!"];
                
                
                /*
                UILabel *lable2 = (UILabel *)[self.view viewWithTag:btn.tag+4900];
                [lable2 setText:[NSString stringWithFormat:@"        %@,%@",[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"],[lable2.text substringFromIndex:8]]];
                
                
                //                     [[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"zanarr"] objectAtIndex: sender.tag]  objectForKey:@"phone"];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[_StarList objectAtIndex:btn.tag-100]];
                NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"zanarr"]];
                NSDictionary *commondic = [[NSDictionary alloc]initWithObjectsAndKeys:[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"],@"uaername",[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"phone"],@"phone",nil];
                [arr insertObject:commondic atIndex:0];
                [dic removeObjectForKey:@"zanarr"];
                [dic setObject:arr forKey:@"zanarr"];
                [dic setObject:[[[dict objectForKey:@"data"] objectForKey:@"count"] retain] forKey:@"good_count"];
                [dic setObject:@"0" forKey:@"check"];
                [_StarList removeObjectAtIndex:btn.tag-100];
                [_StarList insertObject:dic atIndex:btn.tag-100];
                //                     if ([CellArr count]>btn.tag-100) {
                //                         [CellArr removeObjectAtIndex:btn.tag-100];
                //                     }
                //                     rowReload = YES;
                NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:btn.tag-100+1 inSection:0];
                NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                [MyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                 */
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"%@",[dictionary objectForKey:@"message"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                //             [MBProgressHUD hideHUDForView:self.view animated:NO];
            }
        } setFailBlock:^(id obj) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
        
    }
}

/**
 *  发表评论
 *
 *  @param sender
 */
-(IBAction)AddSaid:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    FriendCommonViewController *VC = [[FriendCommonViewController alloc]init];
    VC.delegate = self;
    VC.MyTag = [NSString stringWithFormat:@"%d",btn.tag-600];
    VC.Myid = [[_StarList objectAtIndex:btn.tag-600] objectForKey:@"moment_id"];
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}
#pragma mark 自定义Delegate
//发布动态delegate
-(void)AddMyStatus
{
    [self getData];
}

//评论delegate
-(void)FriendCommon:(NSString *)data with:(NSString *)tag Id:(NSString *)commonid
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[_StarList objectAtIndex:[tag integerValue]]];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"comment_list"]];
    
    
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString * dateStr = [formatter stringFromDate:date];
    
//    NSLog(@"______%@",[MyUserDefult objectForKey:@"userName"]);
    
    NSDictionary * commondic = [NSDictionary dictionaryWithObjects:@[data,dateStr,([MyUserDefult objectForKey:@"userDic"][@"data"][@"real_name"]),[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"content",@"create_time",@"real_name",@"user_id"]];
    
    [arr addObject:commondic];
    [dic removeObjectForKey:@"comment_list"];
    [dic setObject:arr forKey:@"comment_list"];
    [_StarList removeObjectAtIndex:[tag integerValue]];
    [_StarList insertObject:dic atIndex:[tag integerValue]];
//    [CellArr removeObjectAtIndex:[tag integerValue]];
//    rowReload = YES;
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:[tag integerValue]+1 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [MyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
}
//发布我的动态
-(IBAction)addMyStatus:(id)sender
{
    AddMyStatusViewController *VC = [[AddMyStatusViewController alloc]init];
    VC.delegate = self;
    [self.navigationController   pushViewController:VC animated:YES];
    [VC release];
}
//-(IBAction)OneHomePage:(id)sender
//{
////    UIButton *btn = (UIButton *)sender;
//    if ([_OneUserId length]==0) {
//        CircleOfFriendViewController  *VC = [[CircleOfFriendViewController alloc]init];
//        [VC.TitleName setText:@"个人主页"];
////        if (btn.tag == 9999) {
//            VC.OneUserImg =[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"head_img"];
//            VC.OneUserName =[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"];
//            VC.OneUserId = [MyUserDefult objectForKey:@"UserId"];
////        }else{
////            VC.OneUserId = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"uid"];
////            VC.OneUserImg = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"user_image"];
////            VC.OneUserName = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"name"];
////        }
//        [self.navigationController pushViewController:VC animated:YES];
//        [VC release];
//    }
//}
-(IBAction)OneInfo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    LCMyMainViewController * controller = [[LCMyMainViewController alloc]init];
    if (btn.tag == 9999) {
        controller.userId = [MyUserDefult objectForKey:@"UserId"];
    }else
    {
        NSDictionary * dic = [_StarList objectAtIndex:btn.tag-1000];
        
        controller.userId = [dic objectForKey:@"user_id"];
        controller.userImageUrl = [dic objectForKey:@"avatar"];
        controller.userNameStr = [dic objectForKey:@"real_name"];
    }
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
    return;
    /**
     *  以下代码为朋友圈跳转到好友的朋友圈的逻辑
     *
     *  @param
     *
     *  @return
     */

    if (_OneUserId>0) {
//        DetailInfoViewController *detail = [[DetailInfoViewController alloc] init];
//        if (btn.tag == 9999) {
//            if ([_OneUserId length]==0) {
//                detail.userPhoneNum = [[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"phone"];
//            }else{
//                if ([_OneUserphone length]>0) {
//                    detail.userPhoneNum = self.OneUserphone;
//                }else{
//                    detail.userPhoneNum = [[_StarList objectAtIndex:0] objectForKey:@"phone"];
//                }
//            }
//        }else{
//            detail.userPhoneNum = [[_StarList objectAtIndex:btn.tag-1000] objectForKey:@"phone"];
//        }
//        [self.navigationController pushViewController:detail animated:YES];
//        [detail release];
    }else{
        CircleOfFriendViewController  *VC = [[CircleOfFriendViewController alloc]init];
        VC.delegate =self;
        [VC.TitleName setText:@"个人主页"];
        if (btn.tag == 9999) {
            //VC.OneUserImg =[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"head_img"];
            //VC.OneUserName =[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"];
            XMPPJID * jid = [[LCAppDelegate shared] myJid];
            VC.OneUserName = [jid user];
            //VC.OneUserId = [MyUserDefult objectForKey:@"UserId"];
            VC.OneUserId = @"2";
            VC.OneUserImg = @"http://114.112.94.186/president_club/uploads/2014/06/06/5391aa7c749501.png";
            
            VC.OneUserphone = [[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"phone"];
        }else{
            VC.OneUserId = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"uid"];
            VC.OneUserImg = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"user_image"];
            VC.OneUserName = [[_StarList objectAtIndex:btn.tag-1000]objectForKey:@"name"];
        }
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }

}
#pragma mark - ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hub.minShowTime=1;
        hub.labelText=@"正在删除，请稍后...";
        NSDictionary * param;
        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",[[[[_StarList objectAtIndex:DeleteMyCommon.OtherTag] objectForKey:@"comment"]objectAtIndex:DeleteMyCommon.tag-20000]objectForKey:@"comment_id"],@"cid",nil];
        
        [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/friend/delete_comment"
         //    [[RequestCenter shareRequestCenter] sendRequest:param setOpt:@"/class_course/get_list"
                                        setSuccessBlock:^(NSDictionary *dict)
         {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             if ([[dict objectForKey:@"code"] integerValue]==200) {
                 NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[_StarList objectAtIndex:DeleteMyCommon.OtherTag]];
                 NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"comment"]];
                 [arr removeObjectAtIndex:DeleteMyCommon.tag-20000];
                 [dic removeObjectForKey:@"comment"];
                 [dic setObject:arr forKey:@"comment"];
                 [_StarList removeObjectAtIndex:DeleteMyCommon.OtherTag];
                 [_StarList insertObject:dic atIndex:DeleteMyCommon.OtherTag];
//                 [CellArr removeObjectAtIndex:DeleteMyCommon.OtherTag];
//                 rowReload = YES;
                 NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:DeleteMyCommon.OtherTag+1 inSection:0];
                 NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                 [MyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                 [RequestCenter showToast:@"删除成功!"];
                 
             }else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[[dict objectForKey:@"error"] objectForKey:@"msg"]]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 [alert release];
                 //             [MBProgressHUD hideHUDForView:self.view animated:NO];
             }
             
         }
                                           setFailBlock:^(NSDictionary *dict)
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
             [MBProgressHUD hideHUDForView:self.view animated:NO];
         }];
        
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
#pragma mark 删除操作
-(IBAction)DeleteCommon:(DoubleBtn *)sender
{
    NSLog(@"%@====%@",[[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"comment"] objectAtIndex:sender.tag-20000] objectForKey:@"user_name"],[MyUserDefult objectForKey:@"UserId"]);
    
    if ([[[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"comment"] objectAtIndex:sender.tag-20000] objectForKey:@"user_id"] integerValue] ==[[MyUserDefult objectForKey:@"UserId"]integerValue])
    {
        DeleteMyCommon = [sender retain];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"删除"
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    }else{
        FriendCommonViewController *VC = [[FriendCommonViewController alloc]init];
        VC.delegate = self;
        VC.ReplyOne = [[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"comment"] objectAtIndex:sender.tag-20000] objectForKey:@"user_name"];
        VC.MyTag = [NSString stringWithFormat:@"%d",sender.OtherTag];
        VC.Myid = [[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"mid"];
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }
 
}

-(void)DeleteStatus
{
    [_StarList removeAllObjects];
//    [CellArr removeAllObjects];
    currnetPage  = 1;
    isNextPage = YES;
    if ([_OneUserId length]>0) {
        [self RequestOneList];
    }else{
        [self  RequestList];
    }
}
-(IBAction)DeleteImage:(id)sender
{
        for (int i =0; i<[DeleteArr count]; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:4000+i];
            btn.hidden = DeleteBtn.selected;
        }
        DeleteBtn.selected = !DeleteBtn.selected;
}

@end
