//
//  DiscoveryViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
#import "MeettingsViewController.h"
#import "YellowPagesViewController.h"
#import "InformationViewController.h"
#import "MiniTalkViewController.h"
#import "LCSupplyInfoViewController.h"
#import "AskForHelpViewController.h"
#import "GroupsViewController.h"
#import "CircleOfFriendViewController.h"
#import "BaseViewController.h"
@interface DiscoveryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain)CycleScrollView * mainScorllView;

@end
