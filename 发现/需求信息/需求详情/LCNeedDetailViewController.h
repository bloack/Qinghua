//
//  LCNeedDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "XHMessageTableViewController.h"
#import "BaseViewController.h"
@interface LCNeedDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, NetWorkDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSMutableDictionary *dataDic;
@property (nonatomic, retain)NSString * busis_id;
@property (nonatomic, retain)NSString * type_id;
@property (nonatomic, retain)NSString * titleStr;
@property (nonatomic, assign)BOOL isMain;
@end
