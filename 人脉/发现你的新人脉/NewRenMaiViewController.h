//
//  NewRenMaiViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
@interface NewRenMaiViewController : BaseViewController<NetWorkDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)dismiss:(id)sender;
@property (nonatomic, retain)CLLocation * location;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@end
