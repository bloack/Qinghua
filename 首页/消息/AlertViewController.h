//
//  AlertViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-19.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface AlertViewController : BaseViewController<NetWorkDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbaleView;

@end
