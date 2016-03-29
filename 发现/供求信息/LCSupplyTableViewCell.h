//
//  LCSupplyTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSupplyTableViewCell : UITableViewCell
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/**
 *  公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *companyName;
/**
 *  赞的个数
 */
@property (weak, nonatomic) IBOutlet UILabel *PraiseNumber;
/**
 *  评论个数
 */
@property (weak, nonatomic) IBOutlet UILabel *recNumber;
/**
 *  创建时间
 */
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *need;
/**
 *  地区,行业
 */
@property (weak, nonatomic) IBOutlet UILabel *province;

/**
 *  评论
 */
@property (weak, nonatomic) IBOutlet UIView *comment;
/**
 *  点赞
 */
@property (weak, nonatomic) IBOutlet UIView *like;

@end
