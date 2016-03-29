//
//  QHCircleOfFriendCell.m
//  Qinghua
//
//  Created by FarTeen on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "QHCircleOfFriendCell.h"
#import "UIImageView+WTImageCache.h"
//#import <SDWebImage/UIImageView+WebCache.h>
@implementation QHCircleOfFriendCell
-(void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    
    // Initialization code
}


-(void)showImagesWithArray:(NSArray *)imageArray
{
    
//    NSLog(@"______%d",self.imageFunctionView.subviews.count);
    self.imageView1.alpha = 0;
    self.imageView2.alpha = 0;
    self.imageView3.alpha = 0;
    if (imageArray.count > 0) {
        self.imageView1.alpha = 1;
        [self.imageView1 setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:DefaultImage];
        
//        [self.imageView1 setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:DefaultImage];

    }
    
    if (imageArray.count > 1)
    {
        self.imageView2.alpha = 1;
        [self.imageView2 setImageWithURL:[NSURL URLWithString:imageArray[1]] placeholderImage:DefaultImage];
        
    }
    
    
    if (imageArray.count > 2) {
        self.imageView3.alpha = 1;
        [self.imageView3 setImageWithURL:[NSURL URLWithString:imageArray[2]] placeholderImage:DefaultImage];
        
//        [self.imageView3 setImageWithURL:[NSURL URLWithString:@"http://120.131.65.210/president_club/uploads/2014/08/07/53e33fbd24be0101.jpg"] placeholderImage:DefaultImage];
    }
    
}



-(void)setFriendModel:(CircleOfFriendModel *)friendModel
{
    if (_friendModel != friendModel) {
        _friendModel = friendModel;
        [self.UserImg setImageWithURL:[NSURL URLWithString:friendModel.avatar] placeholderImage:DefaultImage];
        self.UserName.text = friendModel.real_name;
        self.Content.text = friendModel.content;
        
        if (!CGRectEqualToRect(friendModel.imagesRect, CGRectZero)) {
//            [self.imageView1 setImageWithURL:[NSURL URLWithString:friendModel.image]];
            [self showImagesWithArray:friendModel.paths];
        }
        
        self.Times.text = friendModel.update_time;
        self.GoodNum.text = friendModel.like_number;
        
        
        self.Content.frame = friendModel.contentRect;
        self.imageFunctionView.frame = friendModel.imagesRect;
        self.otherFunctionView.frame = friendModel.otherRect;
        
        
        
//        self.commentView = friendModel.commentView;
        
        for (UIView * view in self.commentView.subviews) {
            [view removeFromSuperview];
        }
        
        [self.commentView addSubview:friendModel.commentView];
        
        self.commentView.frame = friendModel.commentRect;
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
