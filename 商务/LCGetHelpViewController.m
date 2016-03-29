//
//  LCGetHelpViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-30.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCGetHelpViewController.h"
#import "LCMyHelpViewController.h"
@interface LCGetHelpViewController ()<UIAlertViewDelegate>

@end

@implementation LCGetHelpViewController

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
    self.titleString = @"求助发布";

    self.txView.delegate = self;
 
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.txView.text = self.str;
    if (self.txView.text.length > 0) {
        [self.view sendSubviewToBack:self.lable];
    }
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"更新" titleColor:nil buttonFram:CGRectZero];
    }
    else
        [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
}
-(void)right1ButtonClick
{
    __weak LCGetHelpViewController  *vc = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (vc.isMain == YES) {
        if (vc.txView.text.length >= 1) {
            NSString * userId = [NSString stringWithFormat:@"%@", [MyUserDefult objectForKey:@"UserId"]];
            NSDictionary* dic = @{@"user_id":userId, @"content":vc.txView.text, @"help_id":vc.help_id};
            [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
            [[NetWork shareNetWork] netWorkWithURL:Help_Update_URL dic:dic setSuccessBlock:^(id dictionary) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", [dictionary objectForKey:@"message"]);
                if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"恭喜您, 更新成功!" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                    [alert show];
                    vc.txView.text = @"";
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[dictionary objectForKey:@"message"] delegate:vc cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                    [alert show];
                }
            }];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
            [alert show];
        }
      
    }
    else
    {
 [vc rel:nil];

    }
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rel:(id)sender {
    __weak LCGetHelpViewController  *vc = self;
    if (self.txView.text.length >= 1) {
        NSString * userId = [NSString stringWithFormat:@"%@", [MyUserDefult objectForKey:@"UserId"]];
        NSDictionary* dic = @{@"user_id":userId, @"content":vc.txView.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NetWork shareNetWork] netWorkWithURL:Help_Create_URL dic:dic setSuccessBlock:^(id dictionary) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", [dictionary objectForKey:@"message"]);
                if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"恭喜您, 发布成功!" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles: @"查看我的求助", nil];
                        [alert show];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[dictionary objectForKey:@"message"] forError:YES];
                    });
                }
            }];

        });
        
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请输入内容" forError:YES];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            case 1:
            [self.navigationController pushViewController:[[LCMyHelpViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.view sendSubviewToBack:self.lable];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"text = %@", textView.text);
    if (self.txView.text.length <= 1) {
        NSLog(@"nil");
        [self.view bringSubviewToFront:self.lable];
        
    }
    else
    {
        NSLog(@"no  nil");
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /**
     *  限定 TextView 字数;
     */
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 150) {
        textView.text = [temp substringToIndex:150];
        return NO;
    }
    return YES;
}
/**
 *  收回键盘
 *
 *  @param touches
 *  @param event
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:NO];
    NSLog(@"%@", self.txView.text);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
