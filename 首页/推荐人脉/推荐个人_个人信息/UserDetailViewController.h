//
//  UserDetailViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface UserDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * userid;
@property (nonatomic, assign)BOOL isFriend;
@property (nonatomic , assign)BOOL isEXchange;
@end
