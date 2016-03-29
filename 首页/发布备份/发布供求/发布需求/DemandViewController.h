//
//  DemandViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "IBActionSheet.h"
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"

@interface DemandViewController : BaseViewController
{
   
}
@property (nonatomic, strong)UIImage * image1;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic, assign)BOOL   isMain, isSecOpened;
@property (nonatomic, retain)NSString *need_id;
@property (nonatomic, retain)NSString * content;
@property (nonatomic, retain)NSString * companyName;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *secTBView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseCompany;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;
@property (nonatomic, retain)NSString * company_id;
@end
