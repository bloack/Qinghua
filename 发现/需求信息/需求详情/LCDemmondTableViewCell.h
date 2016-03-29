//
//  LCDemmondTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-17.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCDemmondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
- (void)buildUIWithContentHight:(CGFloat)hight;
@end
