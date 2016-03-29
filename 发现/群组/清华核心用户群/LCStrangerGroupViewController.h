//
//  LCGroupDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCStrangerGroupViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic, retain)NSString * group_id;
@end
