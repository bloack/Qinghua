//
//  LogInViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LogInViewController.h"
#import "LCNewPsdViewController.h"
#import "LCFirstViewController.h"
#import "SystemManager.h"
#import "IndustryDao.h"
#import "DistrictDao.h"
#import "InterestDao.h"
#import "OccupationDao.h"
#import "LCMianViewController.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.yesImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeSure:)]];
    _isYes = YES;  
    self.IDTFView.text = [MyUserDefult objectForKey:@"userName"];
    self.psasswordTFView.text = [MyUserDefult objectForKey:@"passWord"];
    
    if ([MyUserDefult objectForKey:@"indus_verson"]) {
        
    }
    else
    {
        [MyUserDefult setObject:@"0" forKey:@"indus_verson"];
    }
    

    // Do any additional setup after loading the view from its nib.
}
- (void)getDateList
{
    [[NetWork shareNetWork] netWorkWithURL:Area_URL dic:nil setSuccessBlock:^(id dictionary) {
        [MyUserDefult setObject:dictionary forKey:@"cityList"];
        [[NetWork shareNetWork] netWorkWithURL:Favorite_URL dic:nil setSuccessBlock:^(id dictionary) {
            [MyUserDefult setObject:dictionary forKey:@"favouriteList"];
            [[NetWork shareNetWork] netWorkWithURL:Industry_URL dic:nil setSuccessBlock:^(id dictionary) {
                [MyUserDefult setObject:dictionary forKey:@"industryList"];
                [[NetWork shareNetWork] netWorkWithURL:Profession_URL dic:nil setSuccessBlock:^(id dictionary) {
                    [MyUserDefult setObject:dictionary forKey:@"professionList"];
                    [LCAppDelegate shared].dict_City = [NSDictionary dictionaryWithDictionary:[[MyUserDefult objectForKey:@"cityList"] objectForKey:@"data"]];
                    [LCAppDelegate shared].dict_Favorite = [NSDictionary dictionaryWithDictionary:[[MyUserDefult objectForKey:@"favouriteList"] objectForKey:@"data"]];
                    [LCAppDelegate shared].dict_Industry = [NSDictionary dictionaryWithDictionary:[[MyUserDefult objectForKey:@"industryList"] objectForKey:@"data"]];
                    [LCAppDelegate shared].dict_Profession = [NSDictionary dictionaryWithDictionary:[[MyUserDefult objectForKey:@"professionList"] objectForKey:@"data"]];
                    
                    
                    /**
                     *  插入数据库
                     */
                    [DistrictDao insertDicArray:[LCAppDelegate shared].dict_City.allValues];
                    [InterestDao insertDicArray:[LCAppDelegate shared].dict_Favorite.allValues];
                    [IndustryDao insertDicArray:[LCAppDelegate shared].dict_Industry.allValues];
                    [OccupationDao insertDicArray:[LCAppDelegate shared].dict_Profession.allValues];
                }];
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeSure:(id)sender {
    /*
     *切换图片；
     */
    _isYes = !_isYes;
    if (_isYes) {
        [self.yesImage setImage:[UIImage imageNamed:@"rem_psw_checked.png"]];
    }
    else if (!_isYes)
    {
     [self.yesImage setImage:[UIImage imageNamed:@"qinghua-login-no.png"]];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:NO];
}

- (IBAction)getPassword:(id)sender {
    
    /*
     
     *忘记密码
     */
    [self presentViewController:[[LCNewPsdViewController alloc] init] animated:NO completion:^{
        
    }];
}

- (IBAction)registerButtonClick:(id)sender {
    [self presentViewController:[[LCMianViewController alloc] init] animated:YES completion:^{
        
    }];
    
}
- (IBAction)logInPass:(id)sender {
    NSLog(@"login");
    NSString * userName = self.IDTFView.text;
    NSString * passWord = self.psasswordTFView.text;
    
    /*@"password":passWord
     
     *登录
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LogInViewController * blockSelf = self;

    [[NetWork shareNetWork] netWorkWithURL:LOGIN_URL dic:@{@"username": userName, @"password": passWord} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
        if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
            [MyUserDefult setObject:[[dictionary objectForKey:@"data"] objectForKey:@"user_id"] forKey:@"UserId"];
            if (blockSelf.isYes == YES) {
                [MyUserDefult setObject:[[dictionary objectForKey:@"data"] objectForKey:@"username"] forKey:@"userName"];
                [MyUserDefult setObject:passWord forKey:@"passWord"];
                [MyUserDefult setObject:dictionary forKey:@"userDic"];
                if ([MyUserDefult  objectForKey:@"cityList"]&&[MyUserDefult objectForKey:@"favouriteList"]&&[MyUserDefult objectForKey:@"industryList"]&&[MyUserDefult objectForKey:@"professionList"]) {
                    [[NetWork shareNetWork] getDataWithURLStr:@"/api/system/data/check" aImage:nil aBody:@{@"industry_version": [MyUserDefult objectForKey:@"indus_verson"], @"district_version":@"0", @"interest_version":@"0", @"occupation_version":@"0"} aSuccessBlock:^(id myDictionary) {
                        if ([[myDictionary[@"version_info"] objectForKey:@"industry_version"] isEqualToString: [MyUserDefult objectForKey:@"indus_verson"]]) {
                            
                        }
                        else
                        {
                            [MyUserDefult setObject:[myDictionary[@"version_info"] objectForKey:@"industry_version"] forKey:@"indus_verson"];
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [blockSelf getDateList];
                            });
                        }
                    } setFailBlock:^(id obj) {
                        
                    }];
                }
                else
                {                
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [blockSelf getDateList];
                    });
                }
                LCFirstViewController * controller = [[LCFirstViewController alloc] init];
                [SystemManager shareSystemManager].rootController = controller;
                
                [LCAppDelegate shared].window.rootViewController = controller;
                [[LCAppDelegate shared] getMyFriendsWithId:[MyUserDefult objectForKey:@"userName"]];
                
                
            }
            else if(blockSelf.isYes == NO)
            {
                NSLog(@"failue");
                LCFirstViewController * controller = [[LCFirstViewController alloc] init];
                [SystemManager shareSystemManager].rootController = controller;
                blockSelf.view.window.rootViewController = controller;
                
                [[LCAppDelegate shared] getMyFriendsWithId:[[dictionary objectForKey:@"data"] objectForKey:@"username"]];
            }
            

            
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"账户密码不匹配, 请重新输入!" delegate:blockSelf cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
            [alert show];
        }
    }
     setFailBlock:^(id obj) {
         [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
         [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"网络错误" forError: YES];
     }
     
     ];
    
}

@end
