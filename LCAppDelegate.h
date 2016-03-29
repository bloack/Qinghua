//
//  LCAppDelegate.h
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ContactsViewController.h"
#import "DiscoveryViewController.h"
#import "BusinessViewController.h"
#import "AboutMyselfViewController.h"
//#import "AKTabBarController.h"
#import "AGViewDelegate.h"
#import <ShareSDK/ShareSDK.h>
@interface LCAppDelegate : UIResponder <UIApplicationDelegate, NetWorkDelegate>{
 
    
    NSMutableArray                          * _friendsArray;
    //是否已经进入程序,用来区分已经进入和首次进入
    BOOL bHasLogin;
}
@property (nonatomic, strong)AGViewDelegate *viewDelegate;
@property (nonatomic, retain)UITabBarController * tabbar;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) id myJid;
@property (nonatomic, retain) NSMutableArray *  friendsArray;

/**
 *  城市
 */
@property (nonatomic, retain) NSMutableDictionary * dict_City;
/**
 *  爱好
 */
@property (nonatomic, retain) NSMutableDictionary * dict_Favorite;
/**
 *  行业
 */
@property (nonatomic, retain) NSMutableDictionary * dict_Industry;
/**
 *  职业
 */
@property (nonatomic, retain) NSMutableDictionary * dict_Profession;



@property (nonatomic, retain) NSMutableArray * array;
+(LCAppDelegate *)shared;
- (void)getMyFriendsWithId:(NSString *)ID;
@end
