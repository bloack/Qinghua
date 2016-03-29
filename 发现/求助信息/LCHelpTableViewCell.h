//
//  LCHelpTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHelpTableViewCell : UITableViewCell
/**
 *  求助内容
 */
@property (weak, nonatomic) IBOutlet UILabel *content;
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 *  地区, 行业
 */
@property (weak, nonatomic) IBOutlet UILabel *province;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 *  赞 个数
 */
@property (weak, nonatomic) IBOutlet UIButton *like;
/**
 *  评论个数
 */
@property (weak, nonatomic) IBOutlet UIButton *comment;

@end
