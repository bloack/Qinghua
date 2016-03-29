//
//  FriendStatusCell.h
//  Boyage
//
//  Created by song longbiao on 13-8-30.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendStatusCell : UITableViewCell
@property (nonatomic,retain)IBOutlet UIImageView *UserImg;
@property (nonatomic,retain)IBOutlet UILabel *UserName;
@property (nonatomic,retain)IBOutlet UILabel *Content;
@property (nonatomic,retain)IBOutlet UIButton *SaidBtn;
@property (nonatomic,retain)IBOutlet UIButton *GoodBtn;
@property (nonatomic,retain)IBOutlet UIButton *SaidBtnCopy;
@property (nonatomic,retain)IBOutlet UIButton *GoodBtnCopy;
@property (nonatomic,retain)IBOutlet UILabel *Times;
@property (nonatomic,retain)IBOutlet UILabel *GoodNum;
@property (nonatomic,retain)IBOutlet UILabel *SaidNum;
@property (nonatomic,retain)IBOutlet UIButton *HomePageBtn;
@property (nonatomic,retain)IBOutlet UIButton *DeleteBtn;

@end
