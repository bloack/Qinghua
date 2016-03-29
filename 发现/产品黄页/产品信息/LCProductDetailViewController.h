//
//  LCProductDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-25.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCProductDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * product_id;
@property (nonatomic, assign)BOOL isMain;
@end
