//
//  ProjectViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TableViewWithBlock.h"
@interface ProjectViewController : BaseViewController
{
}
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UIImageView *chooseComapnay;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *secTBView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;
@property (nonatomic, retain)NSString * company_id;
@property (nonatomic, assign)BOOL isSecOpened;
@property (nonatomic, strong)UIImage * image1;
@end
