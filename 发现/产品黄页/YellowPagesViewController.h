//
//  YellowPagesViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface YellowPagesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{

    IBOutlet UITableView        * _tableViewONE;
    IBOutlet UITableView        * _tableViewTWO;

    
    
}
@property (nonatomic, retain) NSArray        * arrayOne, * searchArray;
@property (nonatomic, retain) NSArray        * arrayTwo;
@property (nonatomic, assign) int firstIndex;
@property (nonatomic, assign) int secondIndex;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *  searchDisplayController;
@end
