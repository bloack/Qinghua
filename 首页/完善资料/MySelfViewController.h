//
//  MySelfViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class District;
@interface MySelfViewController : BaseViewController<NetWorkDelegate, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (nonatomic, strong) District * firstDis;
@property (nonatomic, strong) District * secondDis;

@property (nonatomic, strong) NSMutableDictionary * resultDic;
/**
 *  替代文字 
 */
@property (nonatomic, strong) NSArray * placeholedArray, *zhiyeArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;


/**
 *  上层 传过来字典
 */
@property (nonatomic, strong) NSDictionary * lastDic;
@property (nonatomic, strong)UIImage * userImage;
@property (nonatomic, strong)NSString * interestID, *interestName, *province, *deleteIDS, *addIDS;
- (IBAction)userButtonClick:(id)sender;



@end
