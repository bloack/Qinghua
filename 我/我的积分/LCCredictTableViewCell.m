//
//  LCCredictTableViewCell.m
//  Qinghua
//
//  Created by 刘俊臣 on 14-8-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCCredictTableViewCell.h"

@implementation LCCredictTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)getDataWithDic:(NSDictionary *)dic
{
    self.time.text = dic[@"create_time"];
    self.titleLable.text = dic[@"change_desc"];
    self.pluss.text = dic[@"change_credit"];
    self.total.text = dic[@"credit"];

}
@end
