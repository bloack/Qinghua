//
//  LCProducTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-18.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCProducTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *pattern;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
