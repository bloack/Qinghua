//
//  LCRenMaiTableViewCell.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCRenMaiTableViewCell.h"
#import "FSImageLoader.h"
@implementation LCRenMaiTableViewCell

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	if (self.editing == editting)
	{
		return;
	}
	
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[UIView alloc] init];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected.png"]];
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}



- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
		self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	m_checked = checked;
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
    

//    [self.fathImageView setImageWithURL:[NSURL URLWithString:pa_str]];

}
@end
