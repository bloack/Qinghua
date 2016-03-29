//
//  LCRecruitmentDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCRecruitmentDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSArray * array1;
@property (nonatomic, retain)NSDictionary * rec_dic;
@property (nonatomic, retain)NSString * rec_id;
@end
