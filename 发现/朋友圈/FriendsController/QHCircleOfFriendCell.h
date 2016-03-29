//
//  QHCircleOfFriendCell.h
//  Qinghua
//
//  Created by FarTeen on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleOfFriendModel.h"
@interface QHCircleOfFriendCell : UITableViewCell


@property (nonatomic,retain)IBOutlet UIImageView *UserImg;
@property (nonatomic,retain)IBOutlet UILabel *UserName;
@property (nonatomic,retain)IBOutlet UILabel *Content;
@property (nonatomic,retain)IBOutlet UIButton *commentBtn;
@property (nonatomic,retain)IBOutlet UIButton *GoodBtn;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;




/**
 *  图片功能视图
 */
@property (weak, nonatomic) IBOutlet UIView *imageFunctionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

/**
 * 其他功能视图
 */
@property (weak, nonatomic) IBOutlet UIView *otherFunctionView;

@property (nonatomic,retain)IBOutlet UILabel *Times;
@property (nonatomic,retain)IBOutlet UILabel *GoodNum;
@property (nonatomic,retain)IBOutlet UILabel *SaidNum;
@property (nonatomic,retain)IBOutlet UIButton *HomePageBtn;

@property (weak, nonatomic) IBOutlet UIView *commentView;


@property (nonatomic, strong) CircleOfFriendModel * friendModel;
@end



