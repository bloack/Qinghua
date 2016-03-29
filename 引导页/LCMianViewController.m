//
//  LCMianViewController.m
//  Qinghua
//
//  Created by 刘俊臣 on 14-9-16.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMianViewController.h"
#import "RegisterViewController.h"
@interface LCMianViewController ()

@end

@implementation LCMianViewController

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
    self.titleString = @"注册隐私声明";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"word.doc" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"同意" titleColor:nil buttonFram:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    RegisterViewController * vc = [[RegisterViewController alloc]init];
    [self presentViewController:vc animated:NO completion:nil];
   
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
