//
//  MyContactsViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MyContactsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dismiss:(id)sender;

@property (nonatomic, strong) NSMutableArray * sectionArray;
@property (nonatomic, strong) NSMutableArray * openfierArray;


@property (nonatomic, strong) NSMutableArray * searchDataArray;
@property (nonatomic, strong) NSMutableArray * searchResultArray;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController * searchDisplayController;



@end
