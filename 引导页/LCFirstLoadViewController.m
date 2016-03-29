//
//  LCFirstLoadViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCFirstLoadViewController.h"
#import "LCFirstViewController.h"
#import "LogInViewController.h"
#import "LCAppDelegate.h"
#import "IndustryDao.h"
@interface LCFirstLoadViewController ()<UIScrollViewDelegate, UIPageViewControllerDelegate>

@end

@implementation LCFirstLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)comeIn:(id)sender {
//    self.view.window.rootViewController = [[LCFirstViewController alloc] init];
    [self presentViewController:[[LogInViewController alloc] init] animated:NO completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(320 * 3, [[UIScreen mainScreen] bounds].size.height);
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"qinghua-yindao%d.png", i]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        
        if (i == 2) {
   
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setBackgroundImage:[UIImage imageNamed:@"qinghua-comeIn.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(100, [UIScreen mainScreen].bounds.size.height - 80, 120, 40);
            [button addTarget:self action:@selector(comeIn:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/320;
}
- (void)changePage:(UIPageControl *)pag
{
    [self.scrollView setContentOffset:CGPointMake(320 * pag.currentPage, 0) animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
