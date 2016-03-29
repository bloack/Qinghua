//
//  LCSelfDataViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSelfDataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NetWorkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
