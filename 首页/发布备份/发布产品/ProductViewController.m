//
//  ProductViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-20.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ProductViewController.h"
#import "LCProductTableViewCell.h"
#import "LCMyProductViewController.h"
#import "DistrictSheet.h"
#import "IndustrySheet.h"
#import "SelectTimeSheet.h"
#import "UIPopoverListView.h"
#import "NSString+MD5.h"
#import "LCAddCompanyViewController.h"
@interface ProductViewController ()<UIImagePickerControllerDelegate, UIAlertViewDelegate, UIPopoverListViewDelegate, UIPopoverListViewDataSource, UIAlertViewDelegate>
@property (nonatomic, retain)NSArray * array, *placederArray;
@property (nonatomic, retain)NSArray * dataArray;
@property (nonatomic, retain)NSArray * companyList;
@end

@implementation ProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (IBAction)relBtn:(id)sender {
    [self.view endEditing:YES];
        __weak ProductViewController *vc = self;
    NSString * str1 = (self.isFirst == YES)?@"0":@"";
    NSString * str2 = (self.isSecond == YES)?@"1":@"";
    NSString * str3 = (self.isLast == YES)?@"2":@"";
    NSString * str = [NSString stringWithFormat:@"%@,%@,%@", str1, str2, str3];
    
    if (self.product.name.length>0&&self.product.indus_id.length>0&&self.product.introduce.length>0&&self.companyId.length>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        });

            NSDictionary * dic = @{
                                   @"user_id":[MyUserDefult objectForKey:@"UserId"],
                                   @"industry_id":self.product.indus_id,
                                   @"product_name":self.product.name,
                                   @"business_pattern":str,
                                   @"description":self.product.introduce,
                                   @"company_id":self.companyId?self.companyId:@"1",
                                   @"brand_name":[self.product.barnd?self.product.barnd:@"" getTureStr],
                                   @"product_area":[self.product.area_ower?self.product.area_ower:@"" getTureStr],
                                   @"sales_area":[self.product.area_to?self.product.area_to:@"" getTureStr],
                                   @"expiry_time":[self.product.endTime?self.product.endTime:@"" getTureStr],
                                   @"support_max":[self.product.maxNumber?self.product.maxNumber:@"" getTureStr],
                                   @"support_min":[self.product.unint?self.product.unint:@"" getTureStr],
                                   @"unit_price":self.product.unint?self.product.unint:@"",
                                   @"support_unit":self.danwei?:@"", @"tag":self.tagg?:@""} ;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NetWork shareNetWork] getDataWithURLStr:Product_Create aImage:ImageArr aBody:dic aSuccessBlock:^(id myDictionary) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                    if ([myDictionary[@"status"] isEqualToString:@"200"]) {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"发布成功" delegate: vc cancelButtonTitle:@"好的" otherButtonTitles:@"查看我的产品", nil];
                        [ImageArr removeAllObjects];
                        alert.tag = 888;
                        [alert show ];
                    }
                    else{
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发布失败, 请输入完整信息" forError: YES];
                    }
                });
            }
                setFailBlock:^(id obj) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];

                                                            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发布失败, 请检查网络" forError: YES];
                    });

            }
             ];

        });
    }
    else
    {
        
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"填写信息不完整" forError: YES];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 188) {
        if (buttonIndex == 0) {
            
        }
        else{
            [self.navigationController pushViewController:[[LCAddCompanyViewController alloc] init] animated:YES];
        }
    }
    else if(alertView.tag == 888)
    {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [self.navigationController pushViewController:[[LCMyProductViewController alloc] init] animated:YES];
        }
    }
    else{
        if (buttonIndex==1) {
            [ImageArr removeObjectAtIndex:alertView.tag-830];
            [self InitImage];
        }
    }
}
- (void)getCompanyData
{
    __weak ProductViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        vc.companyList = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
    }
     setFailBlock:^(id obj) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络请求错误" forError:YES];
         });

     }
     
     ];
}

- (void)popClickAction:(id)sender
{
    [self.view endEditing:YES];
    CGFloat xWidth = self.view.bounds.size.width - 80;
    CGFloat yHeight = self.companyList.count * 40 + 40;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(40, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"选择企业"];
    
    if (self.companyList.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有企业" delegate: self cancelButtonTitle:@"知道了" otherButtonTitles:@"创建我的企业", nil];
        alert.tag = 188;
        [alert show];
    }
    else{
    [poplistview show];
    }
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.text = [self.companyList[indexPath.row] objectForKey:@"company_name"];
    self.companyId = [self.companyList[indexPath.row] objectForKey:@"company_id"];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return self.companyList.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    
    self.companyName = [self.companyList[indexPath.row] objectForKey:@"company_name"];
    self.companyId = [self.companyList[indexPath.row] objectForKey:@"company_id"];
    LCProductTableViewCell * cell = (LCProductTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.textField.text = self.companyName;
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


- (void)addPicAction
{
    NSLog(@"action");
    [self.view endEditing:YES];
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", @"取消", nil];
    [self.standardIBAS setFont:[UIFont systemFontOfSize:13.0]];
    [self.standardIBAS showInView:self.view];
}
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndexd
{
    if (buttonIndexd == 0){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = self;
            
            //imagePicker.allowsImageEditing = YES;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
            
        }
        
        
    }else if (buttonIndexd == 1){
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 8-[ImageArr count];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        
        if(imagePickerController.allowsMultipleSelection) {
            //            NSArray *mediaInfoArray = (NSArray *)info;
            
            NSLog(@"Selected %d photos", assets.count);
            //        [Image setImage:[[mediaInfoArray objectAtIndex:0] objectForKey:@"UIImagePickerControllerOriginalImage"]];
            for (int i = 0; i < [assets count]; i++) {
                [ImageArr addObject:[UIImage imageWithCGImage:((ALAsset *)[assets objectAtIndex:i]).thumbnail]];
            }
        } else {
            //            NSDictionary *mediaInfo = [UIImage imageWithCGImage:((ALAsset *)[assets objectAtIndex:0]).thumbnail];
            //            NSLog(@"Selected: %@", mediaInfo);
        }
    }else{
        [ImageArr addObject: [UIImage imageWithCGImage:((ALAsset *)[assets objectAtIndex:0]).thumbnail]];
    }
    [self InitImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        
        if(imagePickerController.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            NSLog(@"Selected %d photos", mediaInfoArray.count);
            //        [Image setImage:[[mediaInfoArray objectAtIndex:0] objectForKey:@"UIImagePickerControllerOriginalImage"]];
            for (int i = 0; i < [mediaInfoArray count]; i++) {
                [ImageArr addObject:[[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"]];
            }
        } else {
            NSDictionary *mediaInfo = (NSDictionary *)info;
            NSLog(@"Selected: %@", mediaInfo);
        }
    }else{
        [ImageArr addObject: [info objectForKey:UIImagePickerControllerOriginalImage]];
    }
    [self InitImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"全部照片";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"取消全部照片";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"照片%d个", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%d个", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"照片%d个、图像%d个", numberOfPhotos, numberOfVideos];
}


- (IBAction)po:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:nil backgroundColor:nil buttonTitle:@"更新" titleColor:nil buttonFram:CGRectZero];
        self.product = [[LCProduct alloc] init];
        
        _product.name = [self.dataDic objectForKey:@"product_name"];
        _product.indus_id = [self.dataDic objectForKey:@"industry_id"];
        _product.industry = [NSString getIndusryName:self.dataDic];
        _product.endTime = [self.dataDic objectForKey:@"expiry_time"];
        _product.minNumber = [self.dataDic objectForKey:@"support_min"];
        _product.maxNumber = [self.dataDic objectForKey:@"support_max"];
        _product.introduce = [self.dataDic objectForKey:@"description"];
        _product.barnd = [self.dataDic objectForKey:@"brand_name"];
        _product.area_ower = [self.dataDic objectForKey:@"product_area"];
        _product.area_to =  [self.dataDic objectForKey:@"sales_area"];
        _product.unint = [self.dataDic objectForKey:@"unit_price"];
        _product.type = [self.dataDic objectForKey:@"business_pattern"];
        self.danwei = self.dataDic[@"support_unit"];
        self.companyId = self.dataDic[@"company_id"];
        self.companyName = self.dataDic[@"company_name"];
    }
    else
    {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
        self.product = [[LCProduct alloc] init];
    }
    
    
    self.titleString = @"发布产品";

    
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIBarButtonItem * rightBT = [[UIBarButtonItem alloc] initWithTitle:@"发布" style: UIBarButtonItemStyleDone target:self action:@selector(fabu:)];
    self.navigationItem.rightBarButtonItem = rightBT;
    self.array = @[@"产品名称", @"行业",@"企业",@"产品描述",@"品牌名称",@"所属区域",@"销售区域",@"有效日期",@"最小起订量",@"最大供货量",@"产品单价", @"供货单位", @"经营模式", @"标签"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    BtnArr = [[NSMutableArray alloc]init];
    ImgViewArr = [[NSMutableArray alloc]init];
    ImageArr = [[NSMutableArray alloc]init];
       
    self.scrollView.contentSize = CGSizeMake(60 * 8, 60);
    for (int i = 0; i < 9;  i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60 * i+ 10, 5, 50, 50)];
        imageView.tag = 20 + i;
        [imageView setClipsToBounds:YES];
        imageView.backgroundColor = [UIColor whiteColor];
        [ImgViewArr addObject:imageView];
        [self.scrollView addSubview:imageView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = imageView.frame;
        button.tag = 30 +i;
        button.tintColor = [UIColor whiteColor];
        [button setBackgroundImage:[UIImage imageNamed:@"addimage.png"] forState:UIControlStateSelected];
        [BtnArr addObject:button];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
    }
    [((UIButton *)[BtnArr objectAtIndex:[ImageArr count]]) setSelected:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)InitImage
{
    for (int i = 0; i<8; i++) {
        UIImageView *img = (UIImageView *)[ImgViewArr objectAtIndex:i];
        UIButton *btn = (UIButton *)[BtnArr objectAtIndex:i];
        [img setImage:nil];
        [btn setSelected:NO];
    }
    for (int i = 0; i<[ImageArr count]; i++) {
        UIImageView *img = (UIImageView *)[ImgViewArr objectAtIndex:i];
        [img setImage:[ImageArr objectAtIndex:i]];
    }
    if ([ImageArr count]<8) {
        [((UIButton *)[BtnArr objectAtIndex:[ImageArr count]]) setSelected:YES];
    }
    
}
- (IBAction)buttonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO && btn.tag-30<[ImageArr count]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = ((UIButton*)sender).tag+800;
        [alert show];
    }else if (btn.selected == YES ){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"相册", nil];
        [actionSheet showInView:self.view];
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

            __weak ProductViewController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [vc getCompanyData];
    });
}
-(void)right1ButtonClick
{
    [self.view endEditing:YES];
    if (self.isMain == YES) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if (self.product.name.length>0&&self.product.indus_id.length>0&&self.product.introduce.length>0&&self.companyId.length>0) {
            NSString * str1 = (self.isFirst == YES)?@"0":@"";
            NSString * str2 = (self.isSecond == YES)?@"1":@"";
            NSString * str3 = (self.isLast == YES)?@"2":@"";
            NSString * str = [NSString stringWithFormat:@"%@,%@,%@", str1, str2, str3];
            NSDictionary * dic = @{
                                   @"user_id":[MyUserDefult objectForKey:@"UserId"],
                                   @"industry_id":self.product.indus_id,
                                   @"product_name":self.product.name,
                                   @"business_pattern":str,
                                   @"description":self.product.introduce,
                                   @"company_id":self.companyId,
                                   @"brand_name":[self.product.barnd?self.product.barnd:@"" getTureStr],
                                   @"product_area":[self.product.area_ower?self.product.area_ower:@"" getTureStr],
                                   @"sales_area":[self.product.area_to?self.product.area_to:@"" getTureStr],
                                   @"expiry_time":[self.product.endTime?self.product.endTime:@"" getTureStr],
                                   @"support_max":[self.product.maxNumber?self.product.maxNumber:@"" getTureStr],
                                   @"support_min":[self.product.minNumber?self.product.minNumber:@"" getTureStr],
                                   @"product_id":self.product_id,@"unit_price":self.product.unint?self.product.unint:@"",
                                   @"support_unit":self.danwei?:@""
                                   ,@"tag":self.tagg?:@""} ;
            __weak ProductViewController *vc = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NetWork shareNetWork] getDataWithURLStr:Product_Update aImage:self.imageArray aBody:dic aSuccessBlock:^(id myDictionary) {
                    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([myDictionary[@"status"] isEqualToString:@"200"]) {
                            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"更新成功" forError: YES];
                            [ImageArr removeAllObjects];
                            [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
                        }
                        else{
                            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"更新失败" forError: YES];
                        }
                    });
                }
                                             setFailBlock:^(id obj) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发布失败, 请检查网络" forError: YES];
                                                 });
                                             }
                 
                 ];
            });
            
 
        }
        else
        {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"填写信息不完整" forError: YES];
        }

    }
    else{
        
    [self relBtn:nil];
    }
    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 12) {
        static NSString* cellID = @"LCProductFormatTableViewCell";
        LCProductFormatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
            NSLog(@"22");
        }
        if (self.isFirst) {
            cell.image1.image = [UIImage imageNamed:@"rem_psw_checked.png"];
        }
        else
        {
            cell.image1.image = [UIImage imageNamed:@"qinghua-login-no.png"];
            
        }
        if (self.isSecond) {
            cell.image3.image = [UIImage imageNamed:@"rem_psw_checked.png"];
        }
        else
        {
            cell.image3.image = [UIImage imageNamed:@"qinghua-login-no.png"];
            
        }
        if (self.isLast) {
            cell.image2.image = [UIImage imageNamed:@"rem_psw_checked.png"];
        }
        else
        {
            cell.image2.image = [UIImage imageNamed:@"qinghua-login-no.png"];
            
        }
        [cell.view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button1:)]];
                [cell.view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button2:)]];
                [cell.view3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button3:)]];
        return cell;
    }
    else {
        NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",indexPath.section,indexPath.row];
        static NSString* cellID = @"LCProductTableViewCell";
        LCProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
            cell.textField.delegate = self;
        }
        
        if (indexPath.row == 1|| indexPath.row == 2||indexPath.row == 5 ||indexPath.row == 7) {
            cell.textField.userInteractionEnabled = NO;
        }
        cell.nameLable.text = self.array[indexPath.row];
        cell.textField.placeholder = self.array[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.textField.text = self.product.name;
                break;
            case 1:
                cell.textField.text = self.product.industry;
                break;
            case 2:
                cell.textField.text = self.companyName;
                break;
            case 3:
                cell.textField.text = self.product.introduce;
                break;
            case 4:
                cell.textField.text = self.product.barnd;
                break;
            case 5:
                cell.textField.text = self.product.area_ower;
                break;
            case 6:
                cell.textField.text = self.product.area_to;
                break;
            case 7:
                cell.textField.text = self.product.endTime;
                break;
            case 8:
                cell.textField.text = self.product.minNumber;
                break;
            case 9:
                cell.textField.text = self.product.maxNumber;
                break;
            case 10:
                cell.textField.text = self.product.unint;
                break;
            case 11:
                cell.textField.text = self.danwei;
                break;
            case 12:{
                cell.textField.placeholder = @"单价(元)";
                cell.textField.text = self.product.unint;
            }
                break;
                case 13:
            {
                cell.textField.text = self.tagg;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    return nil;
}
- (IBAction)button1:(id)sender {
    
    LCProductFormatTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    self.isFirst = !self.isFirst;
    if (self.isFirst == YES) {
        cell.image1.image = [UIImage imageNamed:@"rem_psw_checked.png"];
    }
    else
    {
        cell.image1.image = [UIImage imageNamed:@"qinghua-login-no.png"];
        
    }
}
- (IBAction)button2:(id)sender {
        LCProductFormatTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    self.isSecond = !self.isSecond;
    if (self.isSecond == YES) {
        cell.image3.image = [UIImage imageNamed:@"rem_psw_checked.png"];
    }
    else
    {
        cell.image3.image = [UIImage imageNamed:@"qinghua-login-no.png"];
        
    }
}
- (IBAction)button3:(id)sender {
    LCProductFormatTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    self.isLast = !self.isLast;
    if (self.isLast == YES) {
        cell.image2.image = [UIImage imageNamed:@"rem_psw_checked.png"];
    }
    else
    {
        cell.image2.image = [UIImage imageNamed:@"qinghua-login-no.png"];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"基本信息";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self popClickAction:nil];
    }
    
    //所属区域
    else if (indexPath.row == 5) {
        [self.view endEditing:YES];
        DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择地区" delegate:self sheetType:sheetType_picker];
        sheet.myKey = @"belong";
        [sheet showInView:self.view];
    }//销售区域
//    else if(indexPath.row == 6)
//    {
//        [self.view endEditing:YES];
//        DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择地区" delegate:self sheetType:sheetType_picker];
//        sheet.myKey = @"market";
//        [sheet showInView:self.view];
//    }//行业
    else if (indexPath.row == 1)
    {
         [self.view endEditing:YES];
        IndustrySheet * sheet = [[IndustrySheet alloc]initWithTitle:@"选择行业" delegate:self sheetType:sheetType_picker];
        [sheet showInView:self.view];
    }//有效日期
    else if (indexPath.row == 7)
    {
         [self.view endEditing:YES];
        SelectTimeSheet * sheet = [[SelectTimeSheet alloc]initWithTitle:@"有效日期" delegate:self sheetType:sheetType_date];
        [sheet showInView:self.view];
    }
    else {
        LCProductTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
}



#pragma mark - MyPickerViewDelegate
-(void)industrySheet:(IndustrySheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * industryArray = [IndustryDao selectAllDataForDistrict];
    Industry * firstModel = industryArray[index];
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    LCProductTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
    NSString * resultStr = firstModel.name;
    if (firstModel.kindArray.count > 0) {
        Industry * secondModel = firstModel.kindArray[secondIndex];

        self.product.indus_id = [NSString stringWithFormat:@"%@", secondModel.ID];
        self.product.industry = [NSString stringWithFormat:@"%@", secondModel.name];
 //       resultStr = [resultStr stringByAppendingFormat:@"-%@",secondModel.name];
        cell.textField.text = self.product.industry;
    }
    self.product.indus_id = [NSString stringWithFormat:@"%@", firstModel.ID];
    self.product.industry = [NSString stringWithFormat:@"%@", firstModel.name];
    cell.textField.text = self.product.industry;
    NSLog(@"选择的行业是:%@",self.product.indus_id);
    
    
}
-(void)districtSheet:(DistrictSheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * resultArray = [DistrictDao selectAllDataForDistrict];
    District * firstModel = resultArray[index];
    NSString * resultStr = firstModel.name;
    District * secondModel = firstModel.cityArray[secondIndex];
    if (firstModel.cityArray.count > 0) {
        resultStr = [resultStr stringByAppendingFormat:@"%@",secondModel.name];
    }
    
    //所属区域
    if ([sheet.myKey isEqualToString:@"belong"])
    {
        NSLog(@"所属区域是:%@",resultStr);
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
        LCProductTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
        self.product.area_ower = resultStr;
        self.product.area_ower_id = secondModel.ID;
        cell.textField.text = self.product.area_ower;

    }
//    //销售区域
//    else if ([sheet.myKey isEqualToString:@"market"])
//    {
//        NSLog(@"销售区域是:%@",resultStr);
//        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:6 inSection:0];
//        LCProductTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
//        self.product.area_to = resultStr;
//        self.product.area_to_id = secondModel.ID;
//        cell.textField.text = self.product.area_to;
//    }
}

-(void)selectTimeSheet:(SelectTimeSheet *)sheet
{
    NSDate * date = sheet.datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * resultStr = [formatter stringFromDate:date];
    self.product.endTime = resultStr;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:7 inSection:0];
    LCProductTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexpath];
    cell.textField.text = self.product.endTime;
    NSLog(@"有效日期是:%@",resultStr);
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell * cell = [[[textField superview ] superview] superview];
    NSIndexPath * path  = [self.tableView indexPathForCell:cell];
    NSString * string = textField.text;
    switch (path.row) {
            case 0:
            self.product.name = string;
            break;
            case 3:
            self.product.introduce = string;
            break;
            case 4:
            self.product.barnd = string;
            break;
            case 6:
            self.product.area_to = string;
            break;
            case 8:
            self.product.minNumber = string;
            break;
            case 9:
            self.product.maxNumber = string;
            break;
            case 10:
            self.product.unint = string;
            break;
            case 11:
            self.danwei = string;
            break;
            case 12:
            self.product.tag = string;
            break;
            case 13:
            self.tagg = string;
            break;
            default:
            break;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:NO];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:NO];
}

@end
