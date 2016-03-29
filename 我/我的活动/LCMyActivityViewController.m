//
//  LCMyActivityViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCMyActivityViewController.h"
#import "LCGroupActivityTableViewCell.h"
#import "LCActivityDetailViewController.h"
@interface LCMyActivityViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (nonatomic, retain)NSMutableArray * array1, *array2, *currentArray;
@end

@implementation LCMyActivityViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"我的活动";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.seg addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
    self.currentArray = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view from its nib.
}
- (void)segChange:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.currentArray = self.array1;
        [self.tableView reloadData];
    }
    else if(segment.selectedSegmentIndex == 1)
    {
        self.currentArray = self.array2;
        [self.tableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInvocationOperation * operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getMyActive) object:nil];
    NSInvocationOperation * operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getJoinInActivity) object:nil];
    NSOperationQueue * op = [[NSOperationQueue alloc] init];
    [op setMaxConcurrentOperationCount:1];
    [op addOperation:operation1];
    [op addOperation:operation2];

    
}
- (void)current
{
    self.currentArray = self.array1;
    [self.tableView reloadData];
}
- (void)getMyActive
{
    __weak LCMyActivityViewController * blockSelf = self;

    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"],@"type":@"1"};
        [[NetWork shareNetWork] getDataWithURLStr:Activity_My aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
            blockSelf.array1 = [[dictionary objectForKey:@"data"] objectForKey:@"activity_list"];
            [blockSelf current];
        } setFailBlock:^(id obj) {
            [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"数据请求错误" forError: YES];
        }
         ];

    }
- (void)getJoinInActivity
{
    __weak LCMyActivityViewController * blockSelf = self;

    NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"],@"type":@"2"};
    [[NetWork shareNetWork] getDataWithURLStr:Activity_My aImage:nil aBody:dic aSuccessBlock:^(id dictionary) {
        blockSelf.array2 = [[dictionary objectForKey:@"data"] objectForKey:@"activity_list"];
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager] showHUDInView:blockSelf.view messge:@"数据请求错误" forError: YES];
    }
     ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"LCGroupActivityTableViewCell";
    LCGroupActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:str owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = self.currentArray[indexPath.row];
    cell.title.text = [dic objectForKey:@"title"];
    cell.time.text = [dic objectForKey:@"create_time"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCActivityDetailViewController * vc = [[LCActivityDetailViewController alloc] init];
    vc.active_id = [self.currentArray[indexPath.row] objectForKey:@"activity_id"];
    if (self.seg.selectedSegmentIndex == 0) {
        vc.isMian = YES;
    }
    self.seg.selectedSegmentIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
