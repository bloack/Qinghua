//
//  LCintruoduceViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface LCIntruoduceOtherViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * sectionArray;
@property (nonatomic, retain) NSMutableArray * introArray;
@property (nonatomic, assign) BOOL isIntro;
@property (retain, nonatomic) NSMutableArray *items;
@property (nonatomic, strong) NSString * user_id;
@end
