//
//  LCMyMainViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SVPullToRefresh.h"

@interface LCMyMainViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    int currnetPage;
    
    int ;
}
/**
 *  拍照摄像视图控制器
 */
@property (nonatomic, strong) UIImagePickerController * imageController;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

/**
 *  是否 pop 一层
 */
@property (nonatomic, assign) BOOL isOnlyPop, isNextPage;
/**
 *  数据总条数
 */
@property (assign, nonatomic) int StarCount, chageImageTag;
/**
 *  数据源数组
 */
@property (strong, nonatomic) NSMutableArray * StarList;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  主页用户ID
 */
@property (nonatomic, strong) NSString * userId;
/**
 *  主页用户名
 */
@property (nonatomic, strong) NSString * userNameStr;
/**
 *  主页用户URL
 */
@property (nonatomic, strong) NSString * userImageUrl;


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;

- (IBAction)backgroundButtonClick:(id)sender;

- (IBAction)userImageButtonClick:(id)sender;



@end
