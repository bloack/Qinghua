//
//  ProfessionViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "LCAddFriends.h"
@interface ProfessionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isOpened;
}
- (IBAction)dismiss:(id)sender;
- (IBAction)choose:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableViewBlock;
@property (nonatomic, retain)NSString *indus_id;

@property (nonatomic, assign)NSInteger page;
@end
