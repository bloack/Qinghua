//
//  LCInfoListViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCInfoListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)BOOL isMain;
@property (nonatomic, retain)NSString * indus_id;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSString * favourite_id;
@property (nonatomic, retain)NSMutableArray * array;

@end
