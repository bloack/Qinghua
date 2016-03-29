//
//  CompanyViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CompanyViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, NetWorkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
