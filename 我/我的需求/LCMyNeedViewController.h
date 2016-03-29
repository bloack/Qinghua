//
//  LCMyNeedViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-25.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCMyNeedViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@end
