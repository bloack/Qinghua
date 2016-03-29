//
//  LCIconAndBackTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCIconAndBackTableViewCell.h"
#import "FSImageLoader.h"
@implementation LCIconAndBackTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) buildChild:(NSString *)urlStr parent:(NSString *)pa_str
{
    [[FSImageLoader sharedInstance] loadImageForURL:[NSURL URLWithString:urlStr] image:^(UIImage *image, NSError *error) {
        self.levelIcon.frame = CGRectMake(235, 10, image.size.width * 2, 16);
        self.levelIcon.image = image;
        
    }];
    
    
//    [self.fathImageView setImageWithURL:[NSURL URLWithString:pa_str]];
}
@end
