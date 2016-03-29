//
//  LCAddCompanyViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-30.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LCAddCompanyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *rep;
@property (weak, nonatomic) IBOutlet UITextField *fanwei;
@property (weak, nonatomic) IBOutlet UILabel *indus;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *position;
@property (weak, nonatomic) IBOutlet UITextField *intro;
@property (weak, nonatomic) IBOutlet UIScrollView *scrllView;
@property (nonatomic, retain)NSString * cityID, *indusID, *positionText, *province;
@property (nonatomic, retain)UIImageView * addImage, *company_image;
@property (nonatomic, retain)UIImage * image1, *company_image1;
@property (nonatomic, retain)UIActionSheet * sheet;

@property (nonatomic, assign)BOOL isMain;
@property (nonatomic, retain)NSDictionary * formatDic;
@property (nonatomic, retain)NSString * com_id;
@end
