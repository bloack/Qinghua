//
//  LCCompany.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-4.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCompany : NSObject
@property (nonatomic, strong)NSString *name, *company_id;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *intro;
@property (nonatomic, strong)NSString *indus;
@property (nonatomic, strong)NSString *city, *address;
@property (nonatomic, strong)NSString * pinYin;
@property (nonatomic, strong)NSDictionary * dic;
- (id)initWithDic:(NSDictionary *)dic;
@end
