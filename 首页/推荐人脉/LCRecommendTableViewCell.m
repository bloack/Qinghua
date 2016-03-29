//
//  LCRecommendTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCRecommendTableViewCell.h"
#import "FSImageLoader.h"
@implementation LCRecommendTableViewCell

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
    __weak LCRecommendTableViewCell *cell = self;
    [[FSImageLoader sharedInstance] loadImageForURL:[NSURL URLWithString:urlStr] image:^(UIImage *image, NSError *error) {
        cell.levelIcon.frame = CGRectMake(235, 10, image.size.width * 2, 16);
        cell.levelIcon.image = image;
        
    }];
    
    
}
@end
