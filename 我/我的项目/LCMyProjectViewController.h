//
//  LCMyProductViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-7.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"
#import "LCSupplyInfoViewController.h"
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
@interface LCMyProjectViewController : BaseViewController
{
    BOOL isOpened;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableViewBlock;
@property (nonatomic, retain)NSString *indus_id;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@end
