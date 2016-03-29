//
//  LCIconAndBackTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCIconAndBackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secButton;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UIImageView *levelIcon;
@property (weak, nonatomic) IBOutlet UIButton *intro;

@property (weak, nonatomic) IBOutlet UIImageView *fathImageView;
- (void) buildChild:(NSString *)urlStr parent:(NSString *)pa_str;
@end
