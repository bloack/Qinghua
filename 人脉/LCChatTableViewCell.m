//
//  LCChatTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCChatTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation LCChatTableViewCell

- (void)awakeFromNib
{
    self.hintCountLabel.layer.cornerRadius = 3;
    self.hintCountLabel.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setHintCount:(int)hintCount
{
    _hintCount = hintCount;
    if (_hintCount == 0) {
        self.hintCountLabel.alpha = 0;
    }else
    {
        self.hintCountLabel.alpha = 1;
        self.hintCountLabel.text = String(_hintCount);
    }
}


@end
