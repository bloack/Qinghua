//
//  LCClassListViewController.m
//  Qinghua
//
//  Created by 刘俊臣 on 14-8-11.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCClassListViewController.h"
#import "ItemCheck.h"
@interface LCClassListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *items, *array;
@end

@implementation LCClassListViewController

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
    [self.tableView setEditing:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendInterest:) name:@"kSendClass" object:nil];
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"确定" titleColor:nil buttonFram:CGRectZero];
    
    self.titleString = @"选择班级";
    self.tableView.allowsSelectionDuringEditing = YES;
    NSDictionary *dic = @{@"user_id": @"1"};
    [[NetWork shareNetWork] getDataWithURLStr:Class_List aImage:nil aBody:dic   aSuccessBlock:^(id myDictionary) {
        self.array = [NSArray arrayWithArray:[[myDictionary objectForKey:@"data"] objectForKey:@"class_list"]];
        self.items = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i < self.array.count; i++) {
            ItemCheck *item = [[ItemCheck   alloc] init];
            item.isCheck = NO;
            [_items addObject:item];
            
        }
        [self.tableView reloadData];
    } setFailBlock:^(id obj) {
        
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)right1ButtonClick
{
    NSMutableString * intrestStr = [[NSMutableString alloc] init];
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.items.count; i ++) {
        ItemCheck * item = self.items[i];
        if (item.isCheck == YES) {
            NSString * str = [[self.array objectAtIndex:i] objectForKey:@"class_id"];
            NSString * name = [[self.array objectAtIndex:i] objectForKey:@"class_name"];
            nameStr = [nameStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", name]];
            intrestStr = [intrestStr stringByAppendingString:[NSString stringWithFormat:@"%@,", str]];
            NSLog(@"%@", intrestStr);
            NSLog(@"%@", nameStr);
        }
    }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSendClass" object:nil userInfo:@{@"name":nameStr, @"in_id":intrestStr}];
}
- (void)sendInterest:(NSNotification *)noti
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCheck* item = [_items objectAtIndex:indexPath.row];
	
	if (self.tableView.editing)
	{
		LCChosseInterestTableViewCell *cell = (LCChosseInterestTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        item.isCheck = !item.isCheck;
		[cell setChecked:item.isCheck];
	}
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"LCChosseInterestTableViewCell";
    LCChosseInterestTableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] firstObject];
    }
    cell.aLable.text = [self.array[indexPath.row] objectForKey:@"class_name"];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
