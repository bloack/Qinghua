//
//  RegisterViewController.h
//  Qinghua
//
//  Created by FarTeen on 14-8-1.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *classListView;
@property (weak, nonatomic) IBOutlet UITextField *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *nameView;
@property (weak, nonatomic) IBOutlet UILabel *classView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString *class_id, *class_name;
@property (nonatomic, strong)NSString *realName, *sexID, *phoneNumber, *faculty, *className, *startYear, *ower_area, *address, *province, *areaStr;
@end
