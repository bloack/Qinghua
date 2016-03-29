//
//  SupplyAndDemandViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DataSourceBlocks.h"
#import "IBActionSheet.h"
@class TableViewWithBlock;
#import "BaseViewController.h"
@interface SupplyAndDemandViewController : BaseViewController<NetWorkDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate, IBActionSheetDelegate>
{

}
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UIImageView *chooseCompany;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *secTBView;
@property (nonatomic, retain)NSString * typeId;
@property (nonatomic, retain)NSString * companyId;
@property (nonatomic, retain)IBActionSheet *standardIBAS;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;
@property (nonatomic, assign)     BOOL isOpened, isSecOpened;
@property (nonatomic, retain)UIImage * image1;
@end
