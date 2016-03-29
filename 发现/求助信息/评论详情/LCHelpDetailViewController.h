//
//  LCHelpDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "IBActionSheet.h"
@interface LCHelpDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * help_id;
@property (nonatomic, assign)BOOL isMain;
@property (nonatomic, retain)IBActionSheet * sheet ;
@end
