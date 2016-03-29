//
//  LCMeetingDetailViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMeetingDetailViewController.h"

@interface LCMeetingDetailViewController ()

@end

@implementation LCMeetingDetailViewController

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
    self.titleString = @"会议详情";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"" highlightedImageName:@"" backgroundColor:nil buttonTitle:@"分享" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}

-(void)right1ButtonClick
{
    
}
-(void)goBack
{
    [self dismiss:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
