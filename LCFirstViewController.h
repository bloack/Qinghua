//
//  LCFirstViewController.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-14.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//
#define _READ_MESSAGE @"read_message"

//#import "AKTabBarController.h"

@interface LCFirstViewController : UITabBarController<XmppServiceDelegate>
{
    NSArray *userArr;
    NSString *blackStr;
    NSArray *groupUser;
}
@end
