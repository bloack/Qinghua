//
//  RootViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RootViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    
    
    /**
     *  用于适配顶部的表头
     */
    float myHeight;
    /**
     *  左上角提示信息数字
     */
    UILabel * hintLabel;
}


@property (nonatomic, retain)NSMutableArray * array;
@property (nonatomic, assign)BOOL isData;
- (IBAction)message:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

/**
 *  区头点击事件
 *
 *  @param sender 
 */
- (IBAction)headerButtonClick:(id)sender;
- (IBAction)clearHeaderClick:(id)sender;

- (IBAction)dongtai:(id)sender;
- (IBAction)supply:(id)sender;
- (IBAction)project:(id)sender;
- (void)getListData;

@property (nonatomic,assign)NSInteger  messageCount, commentCount, systemCount, activeCount, groupCount, introduceCount;
@property (nonatomic, strong)NSMutableArray * messageArray, *commentArray, * likeArray, *systemArray, *activeArray, *groupArray, *introduceArray;
- (void)getCount;
@property (nonatomic, assign)BOOL isNew;
@property (nonatomic, strong)NSDictionary * user_dic;
@end
