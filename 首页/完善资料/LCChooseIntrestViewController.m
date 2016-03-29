//
//  LCChooseIntrestViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-8-8.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCChooseIntrestViewController.h"
#import "ItemCheck.h"
#import "LCChosseInterestTableViewCell.h"
@interface LCChooseIntrestViewController ()
@property (nonatomic, strong)NSMutableArray  * array;
@end

@implementation LCChooseIntrestViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendInterest:) name:@"kSendInterest" object:nil];
    self.titleString = @"选择兴趣";
    _idArray = [NSMutableArray arrayWithArray:[self.indusID componentsSeparatedByString:@","]];

    self.tableView.allowsSelectionDuringEditing = YES;
    self.array = [NSMutableArray arrayWithArray:[[LCAppDelegate shared].dict_Favorite allValues]];
    
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"确定" titleColor: nil buttonFram:CGRectZero];
    
    self.items = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i < self.array.count; i++) {
        ItemCheck *item = [[ItemCheck   alloc] init];
        item.isCheck = NO;
        [_items addObject:item];
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setEditing:YES animated:NO];
    
}
- (void)sendInterest:(NSNotification *)noti
{
    NSLog(@"%@", noti.userInfo);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)right1ButtonClick
{
    NSMutableString * intrestStr = [[NSMutableString alloc] init];
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    NSMutableArray *aray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.items.count; i ++) {
        ItemCheck * item = self.items[i];
        if (item.isCheck == YES) {
            NSString * str = [[self.array objectAtIndex:i] objectForKey:@"id"];
            [aray addObject:str];
            NSString * name = [[self.array objectAtIndex:i] objectForKey:@"name"];
            nameStr = [nameStr stringByAppendingString:[NSString stringWithFormat:@"%@ ", name]];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSendInterest" object:nil userInfo:@{@"name":nameStr, @"in_id":aray}];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     *根据网络请求返回的数据
     */
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * messageTBViewCellID = @"LCChosseInterestTableViewCell";
    LCChosseInterestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:messageTBViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:messageTBViewCellID owner:nil options:nil] firstObject];
    }
    NSDictionary * dic = self.array[indexPath.row];
    cell.aLable.text = dic[@"name"];
    [cell setChecked:[(ItemCheck *)self.items[indexPath.row] isCheck]];
    
    for (int i = 0; i < _idArray.count; i ++) {
        if ([dic[@"id"] isEqualToString:_idArray[i]]) {
            ItemCheck* item = [_items objectAtIndex:indexPath.row];
            item.isCheck = YES;
            [cell setChecked:item.isCheck];
            
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ItemCheck* item = [_items objectAtIndex:indexPath.row];
	
	if (self.tableView.editing)
	{
		LCChosseInterestTableViewCell *cell = (LCChosseInterestTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        item.isCheck = !item.isCheck;
		[cell setChecked:item.isCheck];
        NSString * str = [[self.array objectAtIndex:indexPath.row] objectForKey:@"id"];
        if (![self.idArray containsObject:str]) {
            [self.idArray addObject:str];
            
        }
        else
        {
            [self.idArray removeObject:str];
        }

	}
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
