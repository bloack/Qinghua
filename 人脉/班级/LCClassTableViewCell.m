//
//  LCClassTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCClassTableViewCell.h"

@implementation LCClassTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buildChild:(NSString *)urlStr parent:(NSString *)pa_str
{
    //    NSData * dataV = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    //    UIImage * imageV = [UIImage sd_imageWithData:dataV];
    //
    [[FSImageLoader sharedInstance] loadImageForURL:[NSURL URLWithString:urlStr] image:^(UIImage *image, NSError *error) {
        self.levelIcon.frame = CGRectMake(235, 10, image.size.width * 2, 16);
        self.levelIcon.image = image;
        
    }];
    self.lev.text = pa_str;
    self.lev.frame = CGRectMake(210, 10, 30, 16);
    
    //    [self.fathImageView setImageWithURL:[NSURL URLWithString:pa_str]];
    
}

@end
