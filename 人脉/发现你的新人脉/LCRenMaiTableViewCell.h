//
//  LCRenMaiTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRenMaiTableViewCell : UITableViewCell
{
	UIImageView*	m_checkImageView;
	BOOL			m_checked;
}
- (void) setChecked:(BOOL)checked;
- (void) buildChild:(NSString *)urlStr parent:(NSString *)pa_str;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UIImageView *levelIcon;
@property (weak, nonatomic) IBOutlet UIImageView *fathImageView;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *addFriendImage;

@end
