//
//  NearlyContactsViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserDataViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"
@interface NearlyContactsViewController : BaseViewController<NetWorkDelegate, UITableViewDelegate, UITableViewDataSource>
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)CLLocation * location;

@property (nonatomic, assign) NSInteger page;
@end
