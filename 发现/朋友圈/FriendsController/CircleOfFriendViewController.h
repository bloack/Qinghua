//
//  CircleOfFriendViewController.h
//  Boyage
//
//  Created by song longbiao on 13-8-27.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableView.h"
//#import "ASMediaFocusManager.h"
#import "FGalleryViewController.h"
#import "FriendCommonViewController.h"
#import "AddMyStatusViewController.h"
#import "DoubleBtn.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "BaseViewController.h"
@protocol DeleteStatus <NSObject>

- (void)DeleteStatus;

@end

@interface CircleOfFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,FriendCommon,AddStatus,DeleteStatus,UIActionSheetDelegate,FGalleryViewControllerDelegate>
{
    PullToRefreshTableView  *MyTableView;
    IBOutlet UITableViewCell *TitleCell;
    IBOutlet UIButton *EditMyStatus;
    int currnetPage;
    BOOL isNextPage;
    NSInteger Mycount;
    IBOutlet UIImageView *UserImg;
    IBOutlet UILabel *UserNameLab;
    IBOutlet UIImageView *HeaderBg;
    NSMutableArray *MyImagArr;
    //appImag
    NSMutableArray *AppImagArr;
    BOOL reloadTab;
    NSMutableArray *CellArr;
    BOOL rowReload;
    IBOutlet UIButton *DeleteBtn;
    NSMutableArray *DeleteArr;
    int deleteNum;
    NSArray *GoodArr;
    DoubleBtn *DeleteMyCommon;
    NSMutableArray *MoreDic;
    NSArray *localImages;
    FGalleryViewController *localGallery;
}
@property (nonatomic ,retain) NSMutableArray *StarList;
@property (nonatomic ,assign) NSInteger StarCount;
//@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;
/**
 *  被访问用户ID
 */
@property (nonatomic, retain) NSString *OneUserId;
/**
 *  用户ID
 */
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString *OneUserName;
@property (nonatomic, retain) NSString *OneUserImg;
@property (nonatomic, retain) NSString *OneUserphone;

/**
 *  搜索框
 */
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;

@property (nonatomic,retain) IBOutlet UILabel *TitleName;
@property(nonatomic ,assign)id<DeleteStatus> delegate;
@property(strong, nonatomic) FSImageViewerViewController *imageViewController;

@end
