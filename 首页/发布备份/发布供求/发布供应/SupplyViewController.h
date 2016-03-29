//
//  SupplyViewController.h
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

@class TableViewWithBlock;
@interface SupplyViewController : BaseViewController<NetWorkDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate, IBActionSheetDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextView *txView;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic, retain)IBActionSheet * standardIBAS;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *secTBView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseCompany;
@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (nonatomic, retain)NSString *company_id;
@property (nonatomic, assign)BOOL   isMain , isSecOpened;;
@property (nonatomic, retain)NSString * need_id;
@property (nonatomic, retain)NSString * content;
@property (nonatomic, retain)NSString * companyStr;
@property (nonatomic, strong)UIImage * image1;
@end
