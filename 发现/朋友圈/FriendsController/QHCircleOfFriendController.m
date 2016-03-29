//
//  QHCircleOfFriendController.m
//  Qinghua
//
//  Created by FarTeen on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
#import "UIButton+Block.h"
#import "LCMyMainViewController.h"

#import "QHCircleOfFriendController.h"
#import "SVPullToRefresh.h"
#import "QHCircleOfFriendCell.h"
#import "CircleOfFriendModel.h"
#import "NetWork.h"


#import "QHCircleMomentDetailController.h"

@interface QHCircleOfFriendController ()

@end

@implementation QHCircleOfFriendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userBackgroundImageView.clipsToBounds = YES;
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    __weak QHCircleOfFriendController * bolckSelf = self;
    [self.listView addPullToRefreshWithActionHandler:^{
        [bolckSelf getData];
    }];
    
    [self.listView addInfiniteScrollingWithActionHandler:^{
        [bolckSelf getNextPage];
    }];
    

    
    
    
    self.titleString = @"朋友圈";
    NSDictionary * userDic = [MyUserDefult objectForKey:@"userDic"][@"data"];
    [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    [self.userImageView setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] placeholderImage:DefaultImage];
    
    [self.nameLabel setText:userDic[@"real_name"]];
    
    [self.listView.pullToRefreshView triggerRefresh];
    
    // Do any additional setup after loading the view from its nib.
    self.dataMutArray = [NSMutableArray arrayWithCapacity:0];
    [self updateUserImage];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserImage) name:@"updateImage" object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateImage" object:nil];
}

/**
 *  获取用户背景图和用户头像
 */
-(void)updateUserImage
{
    NSDictionary * postDic = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"user_id",@"visit_user_ids"]];
    __weak QHCircleOfFriendController * bolckSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:@"/api/user/user/getBaseInfo" dic:postDic setSuccessBlock:^(id dictionary) {
        
        if ([dictionary[@"status"] intValue] == 200) {
            NSArray * infoArray = dictionary[@"data"][@"user_base_info"];
            if (infoArray.count > 0) {
                NSDictionary * infoDic = [infoArray objectAtIndex:0];
                
                [bolckSelf.userBackgroundImageView setImageWithURL:[NSURL URLWithString:infoDic[@"background"]] placeholderImage:[UIImage imageNamed:@"Starbg.png"]];
                [bolckSelf.userImageView setImageWithURL:[NSURL URLWithString:infoDic[@"avatar"]] placeholderImage:DefaultImage];
            }
            
            
            
        }
        
    } setFailBlock:^(id obj) {
        
    }];
}



-(void)right1ButtonClick
{
    AddMyStatusViewController *VC = [[AddMyStatusViewController alloc]init];
    VC.delegate = self;
    [self.navigationController   pushViewController:VC animated:YES];
}
#pragma AddMyStatusViewControllerDelegate
- (void)AddMyStatus
{
    [self getData];
}


/**
 *  下拉从新获取数据
 */
-(void)getData
{
    if (!self.dataMutArray) {
        self.dataMutArray = [NSMutableArray arrayWithCapacity:0];
    }
    currnetPage = 1;

    
    [self RequestListWithType:1];
}
/**
 *  上拉加载更多
 */
-(void)getNextPage
{
    currnetPage += 1;
    [self RequestListWithType:2];
}
#pragma mark 请求朋友圈数据 为当前用户所有好友的动态
/**
 *  请求朋友圈信息   type为1 下拉   2 为上拉
 *
 *  @param type 
 */
- (void)RequestListWithType:(int)type
{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hub.minShowTime=1;
    hub.labelText=@"正在刷新，请稍后...";
    NSDictionary * param;
    //        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",@"10",@"per_page",[NSString stringWithFormat:@"%d",currnetPage],@"page",@"1",@"headtype",nil];
    
    param = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],[NSString stringWithFormat:@"%d",currnetPage],@"10"] forKeys:@[@"user_id",@"current_page",@"page_size"]];
    
    
    __weak QHCircleOfFriendController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:@"/api/moment/moment/getListByCircle" dic:param setSuccessBlock:^(id dictionary) {
        
        [MBProgressHUD hideHUDForView:vc.view animated:NO];
        
        if ([[dictionary objectForKey:@"status"] integerValue]==200) {
//            _StarCount = [[[dictionary objectForKey:@"data"] objectForKey:@"count"] integerValue];
            
            
            if (type == 1) {
                [vc.dataMutArray removeAllObjects];
            }
            
            NSArray * resultArray = dictionary[@"data"][@"list"];
            for (NSDictionary * dataDic in resultArray) {
                CircleOfFriendModel * model = [[CircleOfFriendModel alloc]initWithDic:dataDic];
                [vc.dataMutArray addObject:model];
            }
            
            [vc.listView reloadData];
            
            //第一次请求数据
            if (type == 1) {
                [vc.listView.pullToRefreshView stopAnimating];
            }else
            {
                [vc.listView.infiniteScrollingView stopAnimating];
            }
            
            if ([[[dictionary objectForKey:@"data"] objectForKey:@"list"] count]< 10) {
                vc.listView.showsInfiniteScrolling = NO;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[dictionary objectForKey:@"message"]]delegate:vc cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //             [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } setFailBlock:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:vc cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideHUDForView:vc.view animated:NO];
    }];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.firstCell;
    }else
    {
        static NSString * identifier = @"Cell";
        QHCircleOfFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
           cell = [[NSBundle mainBundle] loadNibNamed:@"QHCircleOfFriendCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.HomePageBtn addTarget:self action:@selector(OneInfo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentBtn addTarget:self action:@selector(AddSaid:) forControlEvents:UIControlEventTouchUpInside];
            [cell.GoodBtn addTarget:self action:@selector(AddGood:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.HomePageBtn.tag = indexPath.row - 1;
        cell.commentBtn.tag = indexPath.row - 1;
        cell.GoodBtn.tag = indexPath.row - 1;
        cell.GoodNum.tag = cell.GoodBtn.tag + 700;
        
        CircleOfFriendModel * model = self.dataMutArray[indexPath.row - 1];
        
        cell.friendModel = model;
        
        
        __weak QHCircleOfFriendController * blockSelf = self;
        [cell.functionButton block:^(id sender) {
            NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:0];
            if (model.paths.count > 0) {
                for (NSString * path in model.paths) {
                    FSBasicImage * basicImage = [[FSBasicImage alloc]initWithImageURL:[NSURL URLWithString:path]];
                    [imageArray addObject:basicImage];
                }
                
                FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
                
                FSImageViewerViewController * imageVC = [[FSImageViewerViewController alloc]initWithImageSource:photoSource imageIndex:0];
                imageVC.navigationController.navigationBarHidden = NO;
                [blockSelf.navigationController pushViewController:imageVC animated:YES];
            }
            
        }];
        
        
        return cell;
    }
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    }else
    {
        CircleOfFriendModel * friendModel = self.dataMutArray[indexPath.row - 1];
        return friendModel.cell_height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row != 0) {
        CircleOfFriendModel * friendModel = self.dataMutArray[indexPath.row - 1];
        
        /*
        FriendCommonViewController *VC = [[FriendCommonViewController alloc]init];
        VC.delegate = self;
        VC.MyTag = [NSString stringWithFormat:@"%d",indexPath.row -1];
        VC.Myid = friendModel.moment_id;
        [self.navigationController pushViewController:VC animated:YES];
         */
        
        QHCircleMomentDetailController * vc = [[QHCircleMomentDetailController alloc]init];
        vc.delegate = self;
        vc.lastIndex = indexPath.row -1;
        vc.lastModel = friendModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

- (void)QHCircleMoment:(NSString *)str with:(NSString *)tag Id:(NSString *)commonid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"整理数据中...." forError:NO];
    });
    __weak QHCircleOfFriendController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CircleOfFriendModel * friendModel = vc.dataMutArray[tag.intValue];
        /*
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString * dateStr = [formatter stringFromDate:date];
        
        //    NSLog(@"______%@",[MyUserDefult objectForKey:@"userName"]);
        
        
        NSDictionary * commondic = [NSDictionary dictionaryWithObjects:@[str,dateStr,([MyUserDefult objectForKey:@"userDic"][@"data"][@"real_name"]),[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"content",@"create_time",@"real_name",@"user_id"]];
        
        Comment * comment = [[Comment alloc] initWithDic:commondic];
        [friendModel.comment_list insertObject:comment atIndex:0];
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            [friendModel reloadComment];
        });
        
        
        //    [CellArr removeObjectAtIndex:[tag integerValue]];
        //    rowReload = YES;
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:[tag integerValue]+1 inSection:0];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [vc.listView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
        });
        
    });
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
    CircleOfFriendModel * friendModel = self.dataMutArray[btn.tag];
    VC.delegate = self;
    VC.MyTag = [NSString stringWithFormat:@"%d",btn.tag];
    VC.Myid = friendModel.moment_id;
    [self.navigationController pushViewController:VC animated:YES];

}

/**
 *  赞
 *
 */
-(void)AddGood:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //    hub.minShowTime=1;
    //    hub.labelText=@"正在初始化，请稍后...";
    
    
    CircleOfFriendModel * friendModel = self.dataMutArray[btn.tag];
    
    NSDictionary * param;
    param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"user_id",@"11",@"x_type",friendModel.moment_id,@"x_id",nil];
    __weak QHCircleOfFriendController * bolckSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:@"/api/like/like/create" dic:param setSuccessBlock:^(id dictionary) {
        if ([[dictionary objectForKey:@"status"] integerValue]==200) {
            [btn setSelected:NO];
            UILabel *lable = (UILabel *)[bolckSelf.view viewWithTag:btn.tag+700];
            
            lable.text = String([lable.text intValue] + 1);
            
            [[SystemManager shareSystemManager]showHUDInView:bolckSelf.view messge:@"赞成功" forError:YES];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"%@",[dictionary objectForKey:@"message"]]delegate:bolckSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //             [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } setFailBlock:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:bolckSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
        

}

//评论delegate
-(void)FriendCommon:(NSString *)data with:(NSString *)tag Id:(NSString *)commonid
{
    __weak QHCircleOfFriendController *vc = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       [[SystemManager shareSystemManager]showHUDInView:vc.view messge:@"整理数据中...." forError:NO];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CircleOfFriendModel * friendModel = vc.dataMutArray[tag.intValue];
        
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString * dateStr = [formatter stringFromDate:date];
        
        //    NSLog(@"______%@",[MyUserDefult objectForKey:@"userName"]);
        
        NSDictionary * commondic = [NSDictionary dictionaryWithObjects:@[data,dateStr,([MyUserDefult objectForKey:@"userDic"][@"data"][@"real_name"]),[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"content",@"create_time",@"real_name",@"user_id"]];
        
        Comment * comment = [[Comment alloc] initWithDic:commondic];
        [friendModel.comment_list insertObject:comment atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [friendModel reloadComment];
        });
        
        
        //    [CellArr removeObjectAtIndex:[tag integerValue]];
        //    rowReload = YES;
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:[tag integerValue]+1 inSection:0];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [vc.listView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
        });
        
    });
    
    /*
    CircleOfFriendModel * friendModel = self.dataMutArray[tag.intValue];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString * dateStr = [formatter stringFromDate:date];
    
    //    NSLog(@"______%@",[MyUserDefult objectForKey:@"userName"]);
    
    NSDictionary * commondic = [NSDictionary dictionaryWithObjects:@[data,dateStr,([MyUserDefult objectForKey:@"userDic"][@"data"][@"real_name"]),[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"content",@"create_time",@"real_name",@"user_id"]];
    
    Comment * comment = [[Comment alloc] initWithDic:commondic];
    [friendModel.comment_list insertObject:comment atIndex:0];
    
    [friendModel reloadComment];
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:[tag integerValue]+1 inSection:0];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [self.listView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
     */
}


/**
 * 跳转个人主页
 */
-(void)OneInfo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    LCMyMainViewController * controller = [[LCMyMainViewController alloc]init];
    controller.isOnlyPop = YES;
    CircleOfFriendModel * model = [self.dataMutArray objectAtIndex:btn.tag];
        
    controller.userId = model.user_id;
    controller.userImageUrl = model.avatar;
    controller.userNameStr = model.real_name;

    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)userImageButtonClick:(id)sender
{
    LCMyMainViewController * controller = [[LCMyMainViewController alloc]init];
    controller.isOnlyPop = YES;
    controller.userId = [MyUserDefult objectForKey:@"UserId"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
