//
//  LCSelfDataViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCSelfDataViewController.h"

@interface LCSelfDataViewController ()
@property (nonatomic, retain)NSArray * array1, *array2, *array3;
@end

@implementation LCSelfDataViewController
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (IBAction)Complete:(id)sender {
    /*
     
     *完成
     */
}

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
    self.array1 = @[@"公司", @"行业", @"职务", @"自我介绍", @"个性签名", @"个人兴趣"];
    self.array2 = @[@"商业人脉", @"新浪微博", @"微信"];
    self.array3 = @[@"移动电话", @"电子邮件", @"网站", @"公司地址", @"城市", @"生日", @"性别", @"学校", @"班级"];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
          return self.array1.count;
            break;
        case 1:
           return self.array2.count;
            break;
        case 2:
           return self.array3.count;
            break;
    
        default:
            break;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
           return @"职业信息";
            break;
        case 1:
            return @"社交信息";
            break;
        case 2:
            return @"基本信息";
            break;
            
        default:
            break;
    }
    return nil;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [self.array1 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [self.array2 objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [self.array3 objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *进入对应的修改页面;
     */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
