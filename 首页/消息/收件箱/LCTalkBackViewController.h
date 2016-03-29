//
//  LCTalkBackViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface LCTalkBackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic, strong)NSDictionary * dataDic;
@end
