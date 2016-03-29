//
//  LCClassFriendsViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-4.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface LCClassFriendsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * class_id;
@property (nonatomic, retain)NSString * titleStr;
@property (nonatomic, retain)NSString * type;
@end
