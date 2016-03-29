//
//  LCChosseInterestTableViewCell.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-8.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChosseInterestTableViewCell : UITableViewCell
{
	UIImageView*	m_checkImageView;
	BOOL			m_checked;
}
@property (weak, nonatomic) IBOutlet UILabel *aLable;
- (void) setChecked:(BOOL)checked;
@end
