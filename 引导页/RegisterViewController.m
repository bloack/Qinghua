//
//  RegisterViewController.m
//  Qinghua
//
//  Created by FarTeen on 14-8-1.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "RegisterViewController.h"
#import "LCClassListViewController.h"
#import "LCImageAndTFTableViewCell.h"
#import "DistrictSheet.h"
#import "UIPopoverListView.h"

@interface RegisterViewController ()<UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)NSArray *imageArray, *textPlaceAray;
@property (nonatomic, strong)NSMutableArray *yearArray;
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)makeSure:(id)sender {
    [self right1ButtonClick];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleString = @"注册";
    [self.classListView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushClassList)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInterest:) name:@"kSendClass" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.imageArray = @[@"user_icon.png", @"sex_icon.png", @"phone_icon.png", @"school_icon.png", @"book_icon.png", @"class_icon.png", @"calendar_icon.png", @"map_icon.png", @"mail_icon.png"];
    self.textPlaceAray = @[@"请输入真实姓名", @"请选择性别", @"请输入手机号(该号码将作为您的登录用户名)", @"清华大学", @"请输入就读院系、中心(例如:职经中心)", @"请输入班级", @"请选择入学年份", @"请选择所属地区", @"请输入通讯地址(选填)"];
    _yearArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDate  *date = [NSDate date];
    NSLog(@"%@", date);
    for (int i = 1999; i < 2015; i ++) {
        [_yearArray addObject:[NSString stringWithFormat:@"%d年", i]];
    }
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak RegisterViewController *vc = self;
        [[NetWork shareNetWork] netWorkWithURL:Area_URL dic:nil setSuccessBlock:^(id dictionary) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            
            [DistrictDao insertDicArray:[[dictionary objectForKey:@"data"] allValues]];
            
        }];

    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)keyboardWillChange:(NSNotification *)noti
{
    NSDictionary * infoDic = [noti userInfo];
    CGRect beginRect = [[infoDic objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[infoDic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect viewRect = self.view.frame;
    
    if (beginRect.origin.y > endRect.origin.y) {
        
    }
    
    viewRect.size.height = endRect.origin.y;
    
    //    NSLog(@"_______%@______%@",NSStringFromCGRect(beginRect),NSStringFromCGRect(endRect));
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[infoDic[UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationCurve:[infoDic[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    self.view.frame = viewRect;
    [UIView commitAnimations];
    
}

- (void)pushClassList
{
    LCClassListViewController *classVC = [[LCClassListViewController alloc] init];
    [self presentViewController:classVC animated:YES completion:^{
        
    }];
}
- (void)right1ButtonClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"mobile_phone": self.phoneView.text?self.phoneView.text:@"", @"real_name":self.nameView.text?self.nameView.text:@"", @"class_ids":self.class_id?self.class_id:@""};
    [[NetWork shareNetWork] getDataWithURLStr:@"/api/user/user/apply" aImage:nil aBody:dic aSuccessBlock:^(id myDictionary) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:myDictionary[@"message"] forError:YES];
    } setFailBlock:^(id obj) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            [self actionSheetShow];
            break;
         case 6:
            [self popClickAction:nil];
            break;
        case 7:
            [self choosePlace];
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}
- (IBAction)complient:(id)sender {
    [self.view endEditing:YES];
    __weak RegisterViewController *vc = self;
        [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    [[NetWork    shareNetWork] getDataWithURLStr:@"/api/user/user/checkUsername" aImage:nil aBody:@{@"username": self.phoneNumber?:@""} aSuccessBlock:^(id myDictionary) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ([myDictionary[@"data"] objectForKey:@"flag"]) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"该账户尚未注册, 可以使用" forError:YES];
                [[NetWork   shareNetWork] getDataWithURLStr:@"/api/user/user/register" aImage:nil aBody:@{@"mobile_phone": vc.phoneNumber?:@"", @"real_name":vc.realName?:@"", @"gender":vc.sexID?:@"", @"school_id":@"1", @"department":vc.faculty?:@"", @"start_year":[[vc.startYear componentsSeparatedByString:@"年"] firstObject]?:@"", @"class":vc.className?:@"", @"province":vc.province?:@"", @"city":vc.ower_area?:@"", @"address":vc.address?:@""} aSuccessBlock:^(id myDictionary) {
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:myDictionary[@"message"] forError:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } setFailBlock:^(id obj) {
                                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError:YES];
                }];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:nil message:@"您已经是会员, 请直接登录" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            }
        } setFailBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError:YES];
        }];
    

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInde = @"LCImageAndTFTableViewCell";
    LCImageAndTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInde];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellInde owner:nil options:nil] firstObject];
        cell.aTextField.delegate = self;
        cell.aTextField.tag = 100 + indexPath.section;
    }
    cell.aTextField.placeholder = self.textPlaceAray[indexPath.section];
    cell.aImageView.image = [UIImage imageNamed:self.imageArray[indexPath.section]];
    switch (indexPath.section) {
        case 0:
            cell.aTextField.text = self.realName;
            break;
        case 1:
        {
            NSDictionary * dict = @{@"1": @"男", @"2":@"女", @"0":@"保密"};
            cell.aTextField.text = dict[self.sexID];
            cell.aTextField.userInteractionEnabled = NO;

        }

            break;
        case 2:
        {
            cell.aTextField.text = self.phoneNumber;

        }
            break;
        case 3:
        {
            cell.aTextField.text = @"清华大学";
            cell.aTextField.userInteractionEnabled = NO;
        }

            break;
        case 4:
            cell.aTextField.text = self.faculty;

            break;
        case 5:
            cell.aTextField.text = self.className;
            break;
        case 6:
        {            cell.aTextField.userInteractionEnabled = NO;

            cell.aTextField.text = self.startYear;
        }
            break;
        case 7:
        {            cell.aTextField.userInteractionEnabled = NO;

            cell.aTextField.text = self.areaStr;
        }
            break;
        case 8:
            cell.aTextField.text = self.address;
            break;
        default:
            break;
    }
    return cell;
}
- (void)actionSheetShow
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
    [sheet showInView:self.view];
}
- (void)choosePlace
{
    [self.view endEditing:YES];
    DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择地区" delegate:self sheetType:sheetType_picker];
    sheet.myKey = @"belong";
    [sheet showInView:self.view];

}
-(void)districtSheet:(DistrictSheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * resultArray = [DistrictDao selectAllDataForDistrict];
    District * firstModel = resultArray[index];
    NSString * resultStr = firstModel.name;
    self.province = firstModel.ID;
    District * secondModel = firstModel.cityArray[secondIndex];
    if (firstModel.cityArray.count > 0) {
        resultStr = [resultStr stringByAppendingFormat:@"%@",secondModel.name];
        self.ower_area = secondModel.ID;
    }
    self.areaStr = resultStr;
    [self.tableView reloadData];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.sexID = @"1";
            break;
        case 1:
            self.sexID = @"2";
            break;
        case 2:
            self.sexID = @"0";
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    UITableViewCell * cell = [[[textField superview ] superview] superview];
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:textField.tag - 100];
    
    NSString *str = textField.text;
    switch (textField.tag - 100) {
        case 0:
            self.realName = str;
            break;
        case 2:{
            /**
             *  进行网络请求进行手机号验证
             */
            self.phoneNumber = str;
            
        }
            break;
        case 4:
            self.faculty = str;
            break;
        case 5:
            self.className = str;
            break;
        case 8:
            self.address = str;
            break;
        default:
            break;
    }
}
- (void)getInterest:(NSNotification *)noti
{
    self.class_id = noti.userInfo[@"in_id"];

    self.class_name = noti.userInfo[@"name"];
    self.classView.text = self.class_name;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
- (void)popClickAction:(id)sender
{
    [self.view endEditing:YES];
    CGFloat xWidth = self.view.bounds.size.width - 80;
    CGFloat yHeight = 400;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(40, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = YES;
    [poplistview setTitle:@"选择入学年份"];
    [poplistview show];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _yearArray[indexPath.row];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return self.yearArray.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    self.startYear = self.yearArray[indexPath.row];
    [self.tableView reloadData];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
