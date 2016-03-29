//
//  LCCredictTableViewCell.h
//  Qinghua
//
//  Created by 刘俊臣 on 14-8-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCredictTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pluss;
@property (weak, nonatomic) IBOutlet UILabel *total;
- (void)getDataWithDic:(NSDictionary *)dic;
@end
