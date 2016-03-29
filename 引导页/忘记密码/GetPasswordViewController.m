//
//  GetPasswordViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "GetPasswordViewController.h"

@interface GetPasswordViewController ()

@end

@implementation GetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getKey:(id)sender {
}
- (IBAction)getNewK:(id)sender {
    [[NetWork shareNetWork] netWorkWithURL:GetNewKy dic:nil setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
