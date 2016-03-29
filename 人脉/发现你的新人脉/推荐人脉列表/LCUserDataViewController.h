//
//  LCUserDataViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCUserDataViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)BOOL isFriend;
@end
