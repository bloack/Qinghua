//
//  LCCommentDetailTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-17.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCommentDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *aImage;
- (void)buildUIWithContentHight:(CGFloat)hight imageStr:(NSString *)str;
@property (weak, nonatomic) IBOutlet UILabel *releasePerson;
@property (weak, nonatomic) IBOutlet UIView *person;
@end
