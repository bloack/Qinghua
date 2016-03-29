//
//  AreaContactsViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LCAddFriends.h"
@interface AreaContactsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, NetWorkDelegate>
{
    BOOL isOpened;
}
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dismiss:(id)sender;
@property (nonatomic, retain)NSString *city_id;

@property (nonatomic, assign)NSInteger page;
@end
