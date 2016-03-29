//
//  RecommendPeopleViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RecommendPeopleViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, NetWorkDelegate>
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
