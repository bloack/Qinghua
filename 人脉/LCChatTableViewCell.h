//
//  LCChatTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChatTableViewCell : UITableViewCell

@property (nonatomic, assign) int hintCount;

@property (nonatomic, retain) IBOutlet  UIImageView     * cell_icon;
@property (nonatomic, retain) IBOutlet  UILabel         * cell_name;
@property (nonatomic, retain) IBOutlet  UILabel         * cell_desc;

@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintCountLabel;

@end
