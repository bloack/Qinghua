//
//  LCAlertDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NSString+MD5.h"
@interface LCAlertDetailViewController : BaseViewController
@property (nonatomic, strong)NSString * sys_id;
@property (weak, nonatomic) IBOutlet UILabel *titleV;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UILabel *content;
@end
