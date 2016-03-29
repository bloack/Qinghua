//
//  LCModificationKeyViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCModificationKeyViewController.h"

@interface LCModificationKeyViewController ()

@end

@implementation LCModificationKeyViewController
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改密码";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"修改密码";
    [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"修改" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    NSLog(@"%@", [MyUserDefult objectForKey:@"UserID"]);

    if (![_psdTfView.text  isEqualToString: _sureNewPsd.text]) {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"请确认您两次输入的新密码是否一致" forError:YES];
    }
    else
    {
        __weak LCModificationKeyViewController *weakSelf = self;
        NSDictionary *dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"old_pwd":_oldTX.text, @"new_pwd":_psdTfView.text};
        [[NetWork shareNetWork] getDataWithURLStr:@"/api/user/user/updatePassword" aImage:nil aBody:dic aSuccessBlock:^(id myDictionary) {
            if ([myDictionary[@"status"] integerValue] == 200) {
                [[SystemManager  shareSystemManager] showHUDInView:weakSelf.view messge:@"密码修改成功" forError:YES];
                [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0];
            }
            else
            {
                [[SystemManager  shareSystemManager] showHUDInView:weakSelf.view messge:@"密码修改失败" forError:YES];
            }
        }
         setFailBlock:^(id obj) {
             [[SystemManager  shareSystemManager] showHUDInView:weakSelf.view messge:@"网络错误" forError:YES];
         }
         ];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
