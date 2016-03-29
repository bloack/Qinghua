//
//  LCHaveALookViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCHaveALookViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)NSString * product_id;
@property (nonatomic, retain)NSString * titleStr;

@property (nonatomic, assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@end
