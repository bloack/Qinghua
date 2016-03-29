//
//  LCMyMainViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
#import "UIButton+Block.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "LCMyMainViewController.h"
#import "LCMyMainTableViewCell.h"
#import "LCNoteViewController.h"
#import "MyMainModel.h"

@interface LCMyMainViewController ()

@end

@implementation LCMyMainViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"我的主页");
        self.hidesBottomBarWhenPushed = YES;
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
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.backgroundImageView.clipsToBounds = YES;
    
    /*
    [self.myNavbar setRight1ButtonWithnormalImageName:@"" highlightedImageName:nil backgroundColor:nil buttonTitle:@"消息列表" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    */
    
//    self.tableView = [[PullToRefreshTableView alloc]initWithFrame:CGRectMake(0, 43+Ios7Status, 320, HEIGHT-Ios7Status)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
    currnetPage = 1;
    _isNextPage = YES;
    self.StarList = [NSMutableArray arrayWithCapacity:0];
    
    
    UIBarButtonItem *moveButton=[[UIBarButtonItem alloc]initWithTitle:@"消息列表" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = moveButton;
    
    NSDictionary * userDic = [MyUserDefult objectForKey:@"userDic"][@"data"];
    if ([self.userId isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
        _userNameStr = @"我";
        self.nameLabel.text = _userNameStr;
        [self.userImageView setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] placeholderImage:DefaultImage];
        
        
//        [self.backgroundButton setImageWithURL:[NSURL URLWithString:userDic[@"backgroud"]] placeholderImage:[UIImage imageNamed:@"Starbg.png"]];
        
        
    }else
    {
        
        self.backgroundButton.userInteractionEnabled = NO;
        self.userImageButton.userInteractionEnabled = NO;
        
        self.nameLabel.text = _userNameStr;
        [self.userImageView setImageWithURL:[NSURL URLWithString:self.userImageUrl] placeholderImage:DefaultImage];
    }
    
    
    self.titleString = [NSString stringWithFormat:@"%@的主页",_userNameStr];
    
    
    __weak LCMyMainViewController * blockSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf nextPage];
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf getData];
    }];
    
    [self.tableView triggerPullToRefresh];
    
    [self updateUserImage];
    
    // Do any additional setup after loading the view from its nib.
    

}
/**
 *  获取用户背景图和用户头像
 */
-(void)updateUserImage
{
    NSDictionary * postDic = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],self.userId] forKeys:@[@"user_id",@"visit_user_ids"]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMyMainViewController * blockSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetWork shareNetWork] netWorkWithURL:@"/api/user/user/getBaseInfo" dic:postDic setSuccessBlock:^(id dictionary) {
            
dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
    if ([dictionary[@"status"] intValue] == 200) {
        NSArray * infoArray = dictionary[@"data"][@"user_base_info"];
        if (infoArray.count > 0) {
            NSDictionary * infoDic = [infoArray objectAtIndex:0];
            
            [blockSelf.backgroundImageView setImageWithURL:[NSURL URLWithString:infoDic[@"background"]] placeholderImage:[UIImage imageNamed:@"Starbg.png"]];
//            [blockSelf.backgroundImageView setImageWithURL:@"http://www.qinghuaceo.cn/president_club/uploads/2014/08/30/5401f2620e924.png"];
            [blockSelf.userImageView setImageWithURL:[NSURL URLWithString:infoDic[@"avatar"]] placeholderImage:DefaultImage];
        }
        
        
        
    }
 
});
        } setFailBlock:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES] ;
            });
        }];
    });
    
}



-(void)right1ButtonClick
{
    [self getData];
    
}


/**
 *  type  1 下拉   2 上拉
 *
 *  @param type 1 下拉   2 上拉
 */
- (void)RequestListWithType:(int)type
{
//    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
//    hub.labelText=@"正在刷新，请稍后...";
    NSDictionary * param;
    //        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"uid",@"10",@"per_page",[NSString stringWithFormat:@"%d",currnetPage],@"page",@"1",@"headtype",nil];
    
    param = [NSDictionary dictionaryWithObjects:@[self.userId,[NSString stringWithFormat:@"%d",currnetPage],@"10"] forKeys:@[@"user_id",@"current_page",@"page_size"]];
    
    
    
    __weak LCMyMainViewController * blockSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:@"/api/moment/moment/getListByUser" dic:param setSuccessBlock:^(id dictionary) {
        
        if (type == 1) {
            
            [blockSelf.tableView.pullToRefreshView stopAnimating];
            [blockSelf.StarList removeAllObjects];
        }else
        {
            [blockSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        
        [MBProgressHUD hideHUDForView:blockSelf.view animated:NO];
        
        if ([[dictionary objectForKey:@"status"] integerValue]==200) {
            blockSelf.StarCount = [[[dictionary objectForKey:@"data"] objectForKey:@"page_info"][@"total_record"] integerValue];
            
            
            NSArray * dataList = [[dictionary objectForKey:@"data"] objectForKey:@"list"];
            
            for (NSDictionary * dataDic in dataList) {
                MyMainModel * model = [[MyMainModel alloc]initWithDic:dataDic];
                [blockSelf.StarList addObject:model];
            }
            [blockSelf.tableView reloadData];
            //             MyTableView.footerView.hidden = YES;
            
            if ([[[dictionary objectForKey:@"data"] objectForKey:@"list"] count]< 10) {
                blockSelf.isNextPage = NO;
//                [self.tableView reloadData:YES];
                blockSelf.tableView.showsInfiniteScrolling = NO;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[dictionary objectForKey:@"message"]]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //             [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } setFailBlock:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideHUDForView:blockSelf.view animated:NO];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.StarList.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return _firstCell;
    }
    
    static NSString * str = @"LCMyMainTableViewCell";
    LCMyMainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    
    
    
    MyMainModel * model = self.StarList[indexPath.row - 1];
    NSString * timeStr = model.update_time;
    cell.timeLabel.text = [timeStr substringToIndex:10];
    if (model.paths.count > 0) {
        [cell.normalImageView setImageWithURL:[NSURL URLWithString:model.paths[0]] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
    }else
    {
        cell.normalImageView.image = [UIImage imageNamed:@"meIcon.png"];
    }
    
    cell.noteLabel.text = model.content;
    
    
    __weak LCMyMainViewController * blockSelf = self;
    [cell.headerButton block:^(id sender) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 150;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    LCNoteViewController * noteVC = [[LCNoteViewController alloc]init];
    MyMainModel * model = self.StarList[indexPath.row - 1];
    noteVC.lastMainModel = model;
    noteVC.delegate =self;
    noteVC.lastIndex = indexPath.row - 1;
    [self.navigationController pushViewController:noteVC animated:YES];
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary * dic = self.StarList[indexPath.row - 1];
        
        
        
        NSLog(@"_____%d",indexPath.row);
        
    }
}
*/

#pragma mark - LCNoteViewControllerDelegate
-(void)deleteDataWithIndex:(int)index
{
    [self.StarList removeObjectAtIndex:index];
    [self.tableView reloadData];
}



-(void)reloadData
{
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新控件

-(void)getData
{
    
//    [CellArr removeAllObjects];
    currnetPage  = 1;
     self.isNextPage = YES;
    [self  RequestListWithType:1];
    
    if (_StarCount > 10) {
        self.tableView.showsInfiniteScrolling = YES;
    }
    
    
    if ([_StarList count]==0) {
        
        
        //        MyTableView.footerView.hidden = YES;
    }
}

#pragma mark - 请求下页数据
- (void)nextPage
{
    currnetPage++;
    [self  RequestListWithType:2];
    
}
- (void)goBack
{
    if (self.isOnlyPop) {
        [super goBack];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  tag 1 背景图  2 头像
 *
 *  @param tag
 */
-(void)sheetWithTag:(int)tag
{
    _chageImageTag = tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册",@"拍照",  nil];
    [actionSheet showInView:self.view];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
   
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch (buttonIndex) {
        case 0:
        {
            //相册
            
            self.imageController = [[UIImagePickerController alloc]init];
            self.imageController.delegate = self;
            self.imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imageController.allowsEditing = YES;
            [self presentViewController:self.imageController animated:YES completion:nil];
        }
            break;
            
        case 1:
        {
            
            //拍照
            //判断是否有摄像头
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
            
            
        default:
            break;
    }
    
}


#pragma mark - UIImagePickerController Method
//完成拍照 获取相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak LCMyMainViewController *vc = self;
    UIImage* newImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [picker dismissViewControllerAnimated:YES completion:^{
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"正在更改图片...." forError:NO];
        
        
        NSDictionary * postDic = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"]] forKeys:@[@"user_id"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    /**
                     *  背景图
                     */
                    if (vc.chageImageTag == 1)
                    {
                        
                        [[NetWork shareNetWork] updateImageWithURLStr:@"/api/user/user/updateBackground" aImage:newImage imageKey:@"background_img" aBody:postDic aSuccessBlock:^(id myDictionary) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[SystemManager shareSystemManager] HUDHidenWithMessage:myDictionary[@"message"]];
                                
                                if ([myDictionary[@"status"] intValue] == 200) {
                                    vc.backgroundImageView.image = newImage;
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImage" object:nil];
                                }
                                
                            });
                            
                            
                        } setFailBlock:^(id obj) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[SystemManager shareSystemManager] HUDHidenWithMessage:@"网络不太稳定"];
 
                                });
                        }];
//
//                        [[NetWork shareNetWork] getDataWithURLStr:@"/api/user/user/updateBackground" aImage:newImage aBody:postDic aSuccessBlock:^(id myDictionary) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [[SystemManager shareSystemManager] HUDHidenWithMessage:myDictionary[@"message"]];
//                                
//                                if ([myDictionary[@"status"] intValue] == 200) {
//                                    vc.backgroundImageView.image = newImage;
//                                    
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImage" object:nil];
//                                }
//                                
//                            });
//                            
//                        } setFailBlock:^(id objc) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [[SystemManager shareSystemManager] HUDHidenWithMessage:@"网络不太稳定"];
//                                
//                            });
//
//                        }];
                        
                        
                    }
                    else //头像
                    {
//                        [[NetWork shareNetWork] getDataWithURLStr:@"/api/user/user/updateAvatar" aImage:newImage aBody:postDic aSuccessBlock:^(id myDictionary) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                
//                                [[SystemManager shareSystemManager] HUDHidenWithMessage:myDictionary[@"message"]];
//                                if ([myDictionary[@"status"] intValue] == 200) {
//                                    vc.userImageView.image = newImage;
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImage" object:nil];
//                                }
//                                
//                            });
//                        } setFailBlock:^(id obj) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [[SystemManager shareSystemManager] HUDHidenWithMessage:@"网络不太稳定"];
//                                
//                            });                        }];
                        
                        
                        
                        [[NetWork shareNetWork] updateImageWithURLStr:@"/api/user/user/updateAvatar" aImage:newImage imageKey:@"avatar" aBody:postDic aSuccessBlock:^(id myDictionary) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [[SystemManager shareSystemManager] HUDHidenWithMessage:myDictionary[@"message"]];
                                if ([myDictionary[@"status"] intValue] == 200) {
                                    vc.userImageView.image = newImage;
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImage" object:nil];
                                }
                                [[NetWork   shareNetWork] getDataWithURLStr:@"/api/user/user/getinfo" aImage:nil aBody:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult  objectForKey:@"UserId"]} aSuccessBlock:^(id myDictionary) {
                                    [MyUserDefult setObject:myDictionary forKey:@"userDic"];
                                } setFailBlock:^(id objc) {
                                    
                                }];
                                
                            });
                            
                        } setFailBlock:^(id obj) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[SystemManager shareSystemManager] HUDHidenWithMessage:@"网络不太稳定"];
                                
                            });                        }];
                        
                        
                        
                        
                    }
                });
                
            }
];
    
    
   
    
    
    
    //[self performSelector:@selector(settingAndUploadImage:) withObject:image];
}



- (IBAction)backgroundButtonClick:(id)sender
{
    [self sheetWithTag:1];
}

- (IBAction)userImageButtonClick:(id)sender
{
    NSData *imgData = UIImageJPEGRepresentation(self.userImageView.image, 1);
    
    NSLog(@"_____%f",imgData.length/1024.0);
    
    [self sheetWithTag:2];
}



@end
