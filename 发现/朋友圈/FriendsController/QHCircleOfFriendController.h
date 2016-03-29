//
//  QHCircleOfFriendController.h
//  Qinghua
//
//  Created by FarTeen on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface QHCircleOfFriendController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    int currnetPage;
}
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UITableView *listView;
/**
 *  数据源数组
 */
@property (nonatomic, strong) NSMutableArray * dataMutArray;

@property (weak, nonatomic) IBOutlet UIImageView *userBackgroundImageView;

/**
 *  朋友圈用户头像点击事件
 *
 *  @param sender 
 */
- (IBAction)userImageButtonClick:(id)sender;

@end
