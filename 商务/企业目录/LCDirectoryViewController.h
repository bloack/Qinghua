//
//  LCDirectoryViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-28.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface LCDirectoryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@property (nonatomic, assign)NSInteger page;

@end
