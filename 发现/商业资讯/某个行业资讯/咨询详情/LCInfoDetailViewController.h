//
//  LCInfoDetailViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TableViewWithBlock.h"
@interface LCInfoDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (nonatomic, retain)NSString * urlStr;
@property (nonatomic, retain)NSString * titleStr;
@property (nonatomic, assign)BOOL isMain;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *blockTable;
@property (nonatomic, retain)NSString * info_id, *favourite_id;
@property (weak, nonatomic) IBOutlet UILabel *sourceLable;
@property (nonatomic, assign)BOOL isOpened;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (nonatomic, retain)NSString * content;
@end
