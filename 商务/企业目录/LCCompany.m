//
//  LCCompany.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-4.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCCompany.h"
#import "NSString+MD5.h"
@implementation LCCompany
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.icon = dic[@"logo"];
        self.name = dic[@"company_name"];
        self.intro = dic[@"intro"];
        self.company_id = dic[@"company_id"];
        self.indus = [NSString getIndusryName:dic];
        self.city= [NSString getCity:dic];
        self.address = dic[@"address"];
    }
    return self;
}
@end
