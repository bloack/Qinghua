//
//  LCMessageTalkViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-3.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface LCMessageTalkViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic, retain)NSString * user_id;
@end
