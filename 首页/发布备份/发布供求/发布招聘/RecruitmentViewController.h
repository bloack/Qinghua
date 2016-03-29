//
//  RecruitmentViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RecruitmentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf7;
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;
@property (weak, nonatomic) IBOutlet UITextField *tf6;
@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *chooseIndus;
@property (weak, nonatomic) IBOutlet UIImageView *chosseCompany;
@property (nonatomic, retain)NSString * companyId;
@property (nonatomic, retain)NSString * indusId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain)NSArray * companyList;
@property (weak, nonatomic) IBOutlet UITextField *contract;

@end
