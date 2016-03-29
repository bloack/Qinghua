//
//  LCCommentDetailTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-17.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCCommentDetailTableViewCell.h"

@implementation LCCommentDetailTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buildUIWithContentHight:(CGFloat)hight imageStr:(NSString *)str
{

    self.content.frame = CGRectMake(60, 50, 240, hight + 20);
    if (str.length == 0) {
        self.likeView.frame = CGRectMake(240, hight + 65, 60, 40);
        self.time.frame = CGRectMake(20, hight + 65, 120, 40);
    }
    else
    {
        self.likeView.frame = CGRectMake(240, hight + 280, 60, 40);
        self.time.frame = CGRectMake(20, hight + 275, 120, 40);
        [self.aImage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"meIcon.png"]];
        self.aImage.frame = CGRectMake(20, hight + 80, 280, 200);
    }
}
@end
