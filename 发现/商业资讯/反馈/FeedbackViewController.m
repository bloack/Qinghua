//
//  FeedbackViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UIAlertViewDelegate>

@end

@implementation FeedbackViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)relData:(id)sender {
    if (self.txView.text.length >= 1) {
        NSString * userId = [NSString stringWithFormat:@"%@", [MyUserDefult objectForKey:@"UserId"]];
        NSDictionary * dic = @{@"user_id":@"2", @"company_id": @"1", @"type":@"0", @"content":@"50"};
            __weak FeedbackViewController *vc = self;
            [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
            [[NetWork shareNetWork] netWorkWithURL:Feed_Url dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"content":self.txView.text} setSuccessBlock:^(id dictionary) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            NSLog(@"%@", [dictionary objectForKey:@"message"]);
            if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"反馈成功" message:@"谢谢您的反馈, 我们将做得更好!" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                [alert show];
                self.txView.text = @"";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"反馈";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"" highlightedImageName:@"" backgroundColor:nil buttonTitle:@"上传" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    
    self.txView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)right1ButtonClick
{
    [self relData:nil];
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
