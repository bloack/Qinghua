//
//  LCChooseIntrestViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-8.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCChooseIntrestViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *items;
@property (nonatomic, retain)NSString * indusID;
@property (nonatomic, retain)NSMutableArray *idArray;
@end
