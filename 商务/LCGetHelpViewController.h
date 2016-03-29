//
//  LCGetHelpViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-30.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCGetHelpViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (nonatomic, retain)NSString * str;
@property (nonatomic, assign)BOOL * isMain;
@property (nonatomic, retain)NSString * help_id;
@end
