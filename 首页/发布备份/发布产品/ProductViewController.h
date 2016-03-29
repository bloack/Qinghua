//
//  ProductViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCProduct.h"
#import "BaseViewController.h"
#import "IBActionSheet.h"
#import "LCProductFormatTableViewCell.h"
@interface ProductViewController : BaseViewController
{
    NSMutableArray *BtnArr;
    NSMutableArray *ImgViewArr;
    NSMutableArray *ImageArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain)LCProduct * product;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (nonatomic, retain)IBActionSheet * standardIBAS;
@property (nonatomic, assign)BOOL   isMain;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain)NSString * product_id;
@property (nonatomic, retain)NSDictionary * dataDic;
@property (nonatomic, retain)NSString * companyName;
@property (nonatomic, retain)NSString * companyId;
@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic, strong)NSString * tagg, *danwei;

@property (nonatomic, assign)BOOL isFirst, isSecond, isLast;
@end
