//
//  LCMyFileViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCMyFileViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, NetWorkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * user_id;

@property (nonatomic, assign)BOOL isMe;
@property (nonatomic, assign)BOOL isChat;
@end
