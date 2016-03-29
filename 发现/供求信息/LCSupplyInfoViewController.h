//
//  LCSupplyInfoViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
@interface LCSupplyInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isOpened;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableViewBlock;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain)NSString *indus_id;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
- (void)getAreaList;
- (void)like;
- (void)comment;
@end
