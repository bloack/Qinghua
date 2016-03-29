//
//  MySelfViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "MySelfViewController.h"
#import "AddMyInfoCell.h"
#import "DistrictSheet.h"
#import "UIButton+Addition.h"
#import "SystemManager.h"
#import "NetWork.h"
#import "NSString+MD5.h"
#import "NSString+Addition.h"
#import "LCChooseIntrestViewController.h"
#import "UIPopoverListView.h"
@interface MySelfViewController ()<UIPopoverListViewDataSource, UIPopoverListViewDelegate>
@property (nonatomic, retain)NSArray * array1, *array2, *array3;
@end

@implementation MySelfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (IBAction)dimiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (IBAction)Editor:(id)sender {
    
    /*
     
     *编辑
     */
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInterest:) name:@"kSendInterest" object:nil];
    self.titleString = @"个人资料";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"保存" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
//    self.tableView.tableHeaderView = self.headerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.array1 = @[@"自我介绍", @"个性签名"];
    self.array2 = @[@"新浪微博", @"微信"];
    self.array3 = @[@"姓名",@"移动电话", @"电子邮件", @"所在城市",@"通讯地址", @"生日", @"性别", @"学校", @"兴趣"];
    
    self.placeholedArray = [NSArray arrayWithObjects:@[@"添加自我介绍",@"添加个性签名"],@[@"添加新浪微博账号",@"添加微信账号"],@[@"添加姓名",@"添加手机号码",@"添加电子邮件",@"选择所在城市",@"添加通讯地址",@"添加生日",@"添加性别",@"添加学校", @"添加兴趣"], nil];
    
    
    
//    NSDictionary * userDic = [MyUserDefult objectForKey:@"userDic"][@"data"];
    
    
    
    
    
    self.resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * testArray = [NSMutableArray arrayWithCapacity:0];
    [testArray addObjectsFromArray:self.array1];
    [testArray addObjectsFromArray:self.array2];
    [testArray addObjectsFromArray:self.array3];
    for (NSString * keyStr in testArray) {
        [self.resultDic setObject:@"" forKey:keyStr];
    }
    
    [self.resultDic setObject:self.lastDic[@"real_name"]?:@"" forKey:@"姓名"];
    [self.resultDic setObject:self.lastDic[@"brithday"]?:@"" forKey:@"生日"];
    [self.resultDic setObject:self.lastDic[@"mobile_phone"]?:@"" forKey:@"移动电话"];
    [self.resultDic setObject:self.lastDic[@"email"]?:@"" forKey:@"电子邮件"];
    [self.resultDic setObject:self.lastDic[@"intro"]?:@"" forKey:@"自我介绍"];
    [self.resultDic setObject:self.lastDic[@"address"]?:@"" forKey:@"通讯地址"];
    [self.resultDic setObject:self.lastDic[@"gender"]?:@"" forKey:@"性别"];
    [self.resultDic setObject:self.lastDic[@"city"]?:@"" forKey:@"所在城市"];
    [self.resultDic setObject:self.lastDic[@"weibo"]?:@"" forKey:@"新浪微博"];
    [self.resultDic setObject:self.lastDic[@"weixin"]?:@"" forKey:@"微信"];
    [self.resultDic setObject:self.lastDic[@"signature"]?:@"" forKey:@"个性签名"];
    self.province = self.lastDic[@"province"];
    
    NSMutableString * inteStr = [NSMutableString string];
    NSMutableString * IDStr = [NSMutableString string];
    for (NSDictionary * dic in self.lastDic[@"interest_list"]) {
        
        [inteStr appendString:[NSString stringWithFormat:@"%@ ",dic[@"name"]]];
        [IDStr appendString:[NSString stringWithFormat:@"%@,",dic[@"id"]]];
    }
    self.interestName = inteStr;
    self.interestID = IDStr;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];


    
    // Do any additional setup after loading the view from its nib.
}
- (void)getInterest:(NSNotification *)noti
{
    self.interestName = noti.userInfo[@"name"];
    NSMutableArray *newIDs = [NSMutableArray arrayWithArray:noti.userInfo[@"in_id"]];
    NSMutableArray *oldIDs = [self.interestID componentsSeparatedByString:@","];
    NSMutableSet *oldSet = [NSMutableSet setWithArray:oldIDs];
    NSMutableSet *newSet = [NSMutableSet setWithArray:newIDs];
    NSMutableSet *oldSet2 = [NSMutableSet setWithArray:oldIDs];
    NSMutableSet *newSet2 = [NSMutableSet setWithArray:newIDs];
    [newSet intersectSet:oldSet];
    [newSet2 minusSet:newSet];
    [oldSet2 minusSet:newSet];
    
    NSMutableArray *addAry = [NSMutableArray arrayWithArray:[newSet2 allObjects]];
    NSMutableArray *deleteAry = [NSMutableArray arrayWithArray:[oldSet2 allObjects]];
    for (NSString *str in addAry) {
        if (str == nil) {
            [addAry removeObject:str];
        }
    }
    for (NSString *str2 in deleteAry) {
        if (str2 == nil) {
            [deleteAry removeObject:str2];
        }
    }
//    [deleteAry removeObjectAtIndex:0];
    self.addIDS = [addAry componentsJoinedByString:@","];
    self.deleteIDS = [deleteAry componentsJoinedByString:@","];
    self.interestID = [NSString stringWithFormat:@"%d,%d", self.addIDS, self.deleteIDS];
    [self.tableView reloadData];
}
-(void)right1ButtonClick
{
    
    
    [self.view endEditing:YES];
    
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"正在保存" forError:NO];
    

    
    
    NSArray * objectArray = @[
                              [MyUserDefult objectForKey:@"UserId"],
                              [self.resultDic[@"姓名"] getTureStr],
                              [self.resultDic[@"电子邮件"] getTureStr],
                              [self.resultDic[@"移动电话"] getTureStr],
                              [self.resultDic[@"性别"] getTureStr],
                              [self.resultDic[@"生日"] getTureStr],
                              (self.province?self.province:@""),
                              (self.resultDic[@"所在城市"]?self.resultDic[@"所在城市"]:@""),
                              
                              [self.resultDic[@"通讯地址"] getTureStr],
                              [self.resultDic[@"自我介绍"] getTureStr],
                              [self.resultDic[@"个性签名"] getTureStr],
                              [self.resultDic[@"学校"] getTureStr],
                              [self.resultDic[@"新浪微博"] getTureStr],
                              [self.resultDic[@"微信"] getTureStr],self.addIDS?:@"", self.deleteIDS?:@""
                              ];
    NSArray * keyArray = @[@"user_id",@"real_name",@"email",@"mobile_phone",@"gender",@"brithday",@"province",@"city",@"address",@"intro",@"signature",@"school",@"weibo",@"weixin", @"interests", @"delete_interests"];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString * obj in objectArray) {
        if (obj.length > 0) {
            int index = [objectArray indexOfObject:obj];
            [dic setObject:obj forKey:keyArray[index]];
        }
    }
//    [dic addEntriesFromDictionary:@{@"province": self.province?self.province:@""}];
    __weak MySelfViewController  *vc = self;

    
    [[NetWork shareNetWork]netWorkWithURL:@"/api/user/user/updateProfile" dic:dic setSuccessBlock:^(id dictionary) {
        
        if ([dictionary[@"status"] intValue] == 200) {
            [[SystemManager shareSystemManager]HUDHidenWithMessage:dictionary[@"message"]];
            [vc performSelector:@selector(goBack) withObject:nil afterDelay:1];
        }else
        {
            [[SystemManager shareSystemManager]HUDHidenWithMessage:@"保存失败"];
        }
        
    } setFailBlock:^(id obj) {
        [[SystemManager shareSystemManager]HUDHidenWithMessage:@"网络错误"];
    }];
}

#pragma mark keyboardNoti
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
    AddMyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == Nil) {
        NSArray * array =[[NSBundle mainBundle] loadNibNamed:@"AddMyInfoCell" owner:nil options:nil];
        cell = array[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
        
        [cell.functionButton addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.functionButton.alpha = 0;
    NSString * keyStr = @"";
    switch (indexPath.section) {
        case 0:
            keyStr = [self.array1 objectAtIndex:indexPath.row];
            break;
        case 1:
            keyStr = [self.array2 objectAtIndex:indexPath.row];
            
            break;
        case 2:
        {
            if (indexPath.row == 3) {
                cell.functionButton.alpha = 1;
            }
            keyStr = [self.array3 objectAtIndex:indexPath.row];
            if (indexPath.row == 0 && [self.array2[0] length] > 0) {
                cell.textField.userInteractionEnabled = NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    cell.titleLabel.text = keyStr;
    cell.textField.keyStr = keyStr;
    if ([keyStr isEqualToString:@"性别"]) {
        int sex =  [self.resultDic[keyStr] intValue];
        if (sex == 1) {
            cell.textField.text = @"男";
        }else if(sex == 2)
        {
            cell.textField.text = @"女";
        }
        else
        {
            cell.textField.text = @"保密";

        }
        cell.functionButton.userInteractionEnabled = NO;
        cell.textField.userInteractionEnabled = NO;
    }
    else if ([keyStr isEqualToString:@"所在城市"])
    {
        NSString *city;
        NSString *province;
        int cityN = [[self.resultDic objectForKey:@"所在城市"] integerValue] - 1;
        
        if (cityN >= 0) {
            city = [[[LCAppDelegate shared].dict_City objectForKey:[NSString stringWithFormat:@"%d", cityN]] objectForKey:@"name"];
        }
        else
        {
            city = @"未知";
        }
        int intPro = [self.province integerValue] - 1;
        
        if (intPro >= 0) {
            province  = [[[LCAppDelegate shared].dict_City objectForKey:[NSString stringWithFormat:@"%d", intPro]] objectForKey:@"name"];
        }
        else if(intPro == -1)
        {
            province = @"北京";
        }
        else
        {
            province = @"未知";
        }
        
            cell.textField.text = [NSString stringWithFormat:@"%@%@", province, city];
    }
    else
    {
        cell.textField.text = self.resultDic[keyStr];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 8) {
            cell.textField.userInteractionEnabled = NO;
            cell.textField.text = self.interestName;
        }
    }
    if (indexPath.section == 2 &&indexPath.row == 7) {
        cell.textField.text = @"清华大学";
        cell.textField.userInteractionEnabled = NO;
    }
    return cell;
}

-(void)functionButtonClick:(UIButton *)button
{
    DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择所在城市" delegate:self sheetType:sheetType_picker];
    [sheet showInView:self.view];
}


-(void)districtSheet:(DistrictSheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * dataArray = [DistrictDao selectAllDataForDistrict];
    District * firstDis = dataArray[index];
    self.province = firstDis.ID;
    self.firstDis = firstDis;
    NSString *city;
    if (firstDis.cityArray.count > 0) {
        District * secondDis = firstDis.cityArray[secondIndex];
        self.secondDis = secondDis;
//        value = [value stringByAppendingString:secondDis.ID];
        city = secondDis.ID;
    }
    
    [self.resultDic setObject:city forKey:@"所在城市"];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     *进入对应的修改页面;
     */
    if (indexPath.section == 2) {
        if (indexPath.row == 8) {
            LCChooseIntrestViewController * vc = [[LCChooseIntrestViewController alloc] init];
            vc.indusID = self.interestID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self.resultDic setObject:textField.text forKey:textField.keyStr];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userButtonClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}


#pragma mark  imagePickerController
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }else if (buttonIndex == 1){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.userImage = image;
    
}

-(void)setUserImage:(UIImage *)userImage
{
    if (userImage != _userImage) {
        _userImage = userImage;
        [self.userButton setImage:_userImage forState:UIControlStateNormal];
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)popClickAction:(id)sender
{
    [self.view endEditing:YES];
    CGFloat xWidth = self.view.bounds.size.width - 80;
    CGFloat yHeight = 200;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(40, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"选择职业"];
    
    [poplistview show];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
//    cell.textLabel.text = [self.companyList[indexPath.row] objectForKey:@"company_name"];
//    self.companyId = [self.companyList[indexPath.row] objectForKey:@"company_id"];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return self.zhiyeArray.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    
//    self.companyName = [self.companyList[indexPath.row] objectForKey:@"company_name"];
//    self.companyId = [self.companyList[indexPath.row] objectForKey:@"company_id"];
//    LCProductTableViewCell * cell = (LCProductTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    cell.textField.text = self.companyName;
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


@end
