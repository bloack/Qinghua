//
//  LCDemmondTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-17.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCDemmondTableViewCell.h"

@implementation LCDemmondTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buildUIWithContentHight:(CGFloat)hight
{
    self.time.frame = CGRectMake(20, hight + 30, 120, 40);
    self.content.frame = CGRectMake(60, 30, 240, hight);
}
@end
