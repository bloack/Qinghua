//
//  LCMessageTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet UIImageView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end
