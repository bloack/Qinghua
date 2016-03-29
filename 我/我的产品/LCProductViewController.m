//
//  LCProductViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-18.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCProductViewController.h"
#import "LCProducTableViewCell.h"
@interface LCProductViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain)NSArray * array, *detailArray;
@end

@implementation LCProductViewController

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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array = @[@"产品名称", @"行业", @"经营方式", @"产品描述", @"品牌名称", @"所属区域", @"销售区域", @"有效日期", @"最小起订量", @"最大供货量", @"供货单位"];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }
//    else
    return self.array.count;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"LCProducTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
