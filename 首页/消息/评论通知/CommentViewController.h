//
//  CommentViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CommentViewController : BaseViewController<NetWorkDelegate, UITableViewDelegate, UITableViewDataSource>
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic)UITableView * secondTBView;
@end
