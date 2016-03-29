//
//  BusinessViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
#import "SupplyViewController.h"
#import "DemandViewController.h"
#import "YellowPagesViewController.h"
#import "ProjectViewController.h"
#import "RecruitmentViewController.h"
#import "LCDirectoryViewController.h"
#import "LCMaintainViewController.h"
#import "ProductViewController.h"
#import "BaseViewController.h"
@interface BusinessViewController : BaseViewController<NetWorkDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)CycleScrollView * mainScorllView;
@end
