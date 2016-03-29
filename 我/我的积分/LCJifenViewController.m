//
//  LCJifenViewController.m
//  Qinghua
//
//  Created by 刘俊臣 on 14-8-27.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCJifenViewController.h"

@interface LCJifenViewController ()

@end

@implementation LCJifenViewController

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
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.upforce.cn/score/index.html"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
