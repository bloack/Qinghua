//
//  LCMessageTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMessageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation LCMessageTableViewCell

- (void)awakeFromNib
{
    self.hintLabel.layer.cornerRadius = 3;
    self.hintLabel.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
