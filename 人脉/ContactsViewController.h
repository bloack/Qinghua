//
//  ContactsViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NetWork.h"

@interface ContactsViewController : BaseViewController<NetWorkDelegate, UITableViewDelegate, UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray * historyFriendArray;
/**
 *  提示数目
 */
@property (nonatomic, strong) NSMutableDictionary * hintCountDic;
@end
