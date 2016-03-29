//
//  LCMessageTalkViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-7-3.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMessageTalkViewController.h"

@interface LCMessageTalkViewController ()

@end

@implementation LCMessageTalkViewController

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
    self.titleString = @"发送私信";
    [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"发送" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCMessageTalkViewController *vc = self;
    if (self.txView.text.length>0) {
        [[NetWork shareNetWork] netWorkWithURL:MessageTalk_Url dic:@{@"sender_id": [MyUserDefult objectForKey:@"UserId"], @"receiver_id":self.user_id, @"content":self.txView.text} setSuccessBlock:^(id dictionary) {
            NSLog(@"%@", dictionary);
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发送成功" forError: YES];
                [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
            }
            else
            {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发送失败" forError: YES];
            }
     
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
        }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请输入私信内容" forError:YES];
    
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
