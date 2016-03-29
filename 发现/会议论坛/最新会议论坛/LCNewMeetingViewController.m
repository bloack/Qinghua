//
//  LCNewMeetingViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-23.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCNewMeetingViewController.h"
#import "LCNewMeetingTableViewCell.h"
#import "LCMeetingDetailViewController.h"
@interface LCNewMeetingViewController ()

@end

@implementation LCNewMeetingViewController

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
    self.titleString = @"会议";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"LCNewMeetingTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMeetingDetailViewController * meetDetailVC = [[LCMeetingDetailViewController alloc] init];
    [self presentViewController:meetDetailVC animated:NO completion:^{
        
    }];
}
- (IBAction)dimisss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(void)goBack
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
