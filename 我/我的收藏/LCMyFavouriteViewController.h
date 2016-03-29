//
//  LCMyFavouriteViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCMyFavouriteViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)NSInteger page;

@end
