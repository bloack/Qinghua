//
//  LCAddCompanyViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-30.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCAddCompanyViewController.h"
#import "DistrictSheet.h"
#import "IndustrySheet.h"
#import "SelectTimeSheet.h"
#import "NetWork.h"
#import "FSImageLoader.h"
#import "NSString+MD5.h"
@interface LCAddCompanyViewController ()<UIImagePickerControllerDelegate>

@end

@implementation LCAddCompanyViewController
- (IBAction)popback:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
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
    self.titleString = @"添加企业";

//    self.scrllView.frame = CGRectMake(0, 0, 320, 100);
    self.scrllView.contentSize = CGSizeMake(320, 700);
    [self.indus addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(industryChoose)]];
    [self.area addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaChoose)]];
    UILabel * lable = [[UILabel  alloc] initWithFrame:CGRectMake(10, 490, 60, 40)];
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.text = @"企业 logo:";
    [self.scrllView addSubview:lable];
    _addImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 490, 70, 70)];
    _addImage.image = [UIImage imageNamed:@"addimage.png"];
    [self.scrllView addSubview:_addImage];
    _addImage.userInteractionEnabled = YES;
    [_addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicAction:)]];
    
    UILabel * lable2 = [[UILabel  alloc] initWithFrame:CGRectMake(10, 560, 60, 40)];
    lable2.font = [UIFont systemFontOfSize:13.0];
    lable2.text = @"企业相册:";
    [self.scrllView addSubview:lable2];
    _company_image = [[UIImageView alloc] initWithFrame:CGRectMake(80, 580, 70, 70)];
    _company_image.image = [UIImage imageNamed:@"addimage.png"];
    [self.scrllView addSubview:_company_image];
    _company_image.userInteractionEnabled = YES;
    [_company_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicAction:)]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    if (self.isMain) {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"更新" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
        self.name.text = [self.formatDic objectForKey:@"company_name"];
        self.rep.text = [self.formatDic objectForKey:@"representative"];
        self.fanwei.text = self.formatDic[@"business"];
        //        self.indus.text =
        
        NSString * cityStr = [NSString getAllArea:self.formatDic];
        NSString * indusstr = [NSString getIndusryName:self.formatDic];
        
        
        
        /**
         *  行业
         */
        self.indus.text = indusstr;
        self.area.text = cityStr;
        
        self.indusID = self.formatDic[@"industry_id"];
        self.money.text = self.formatDic[@"capital"];
        self.province = self.formatDic[@"province"];
        self.cityID = self.formatDic[@"city"];
        self.address.text = self.formatDic[@"address"];
        self.position.text = self.formatDic[@"position"];
        self.intro.text = self.formatDic[@"intro"];
        [self.addImage setImageWithURL:[NSURL URLWithString:self.formatDic[@"logo"]]];
        if (self.addImage.image == nil) {
            self.addImage.image = [UIImage imageNamed:@"addimage.png"];
        }
        else
        {
            self.image1 = self.addImage.image;
//            self.addImage.userInteractionEnabled = NO;
        }
        self.position.text = self.formatDic[@"position"];
    }
    else
    {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"添加" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    }
    // Do any additional setup after loading the view from its nib.
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

- (void)addPicAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"action");
    [self.view endEditing:YES];
    _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", nil];
    if (tap.view == self.addImage) {
        _sheet.tag = 388;
    }
    else if (tap.view == self.company_image){
        _sheet.tag = 488;
    }
    [_sheet showInView:self.view];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak LCAddCompanyViewController *vc = self;
    if (self.sheet.tag == 388) {
        self.image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:^{
            [vc.addImage setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        }];
    }else if(self.sheet.tag == 488)
    {
        self.company_image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:^{
            [vc.company_image setImage:self.company_image1];
        }];
    
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openImagePickerVC];
    }
    else if(buttonIndex == 1)
    {
        [self openCamera];
    }
}
- (void)openImagePickerVC
{
    /*
     
     *打开相册
     *如果有特殊需求可以查看
     *技术博客：http://blog.csdn.net/ryantang03/article/details/8468852
     */
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    //imagePicker.allowsImageEditing = YES;    //图片可以编辑
    
    //需要添加委托
    
    [self presentModalViewController:imagePicker animated:YES];
    
}
- (void)openCamera
{
    /*
     
     *打开相机
     *
     */
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        //imagePicker.allowsImageEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
        
    }
    
}


- (void)areaChoose
{
    NSLog(@"111111");
    DistrictSheet * sheet = [[DistrictSheet alloc]initWithTitle:@"选择地区" delegate:self sheetType:sheetType_picker];
    sheet.myKey = @"belong";
    [sheet showInView:self.view];
}
- (void)industryChoose
{
    IndustrySheet * sheet = [[IndustrySheet alloc]initWithTitle:@"选择行业" delegate:self sheetType:sheetType_picker];
    [sheet showInView:self.view];
}
-(void)industrySheet:(IndustrySheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * industryArray = [IndustryDao selectAllDataForDistrict];
    Industry * firstModel = industryArray[index];
    NSString * resultStr = firstModel.name;
    if (firstModel.kindArray.count > 0) {
        Industry * secondModel = firstModel.kindArray[secondIndex];
        self.indusID = secondModel.ID;
        self.indus.text = secondModel.name;
    }
   
    
}
-(void)districtSheet:(DistrictSheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex
{
    NSArray * resultArray = [DistrictDao selectAllDataForDistrict];
    District * firstModel = resultArray[index];
    NSString * resultStr = firstModel.name;
    District * secondModel = firstModel.cityArray[secondIndex];
    if (firstModel.cityArray.count > 0) {
        resultStr = [resultStr stringByAppendingFormat:@"-%@",secondModel.name];
        self.area.text = resultStr;
        self.cityID = [NSString stringWithFormat:@"%@", secondModel.ID];
    }
    self.province = firstModel.ID;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)right1ButtonClick
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isMain) {
        [self update];
    }
    else
    {
    
        [self create];
    }
}
- (void)update
{
    __weak LCAddCompanyViewController *vc =self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.name.text.length>0&&self.address.text.length>0) {
        NSDictionary * dic = @{
                               @"user_id": [MyUserDefult objectForKey:@"UserId"],
                               @"position":self.position.text?self.position.text:@"",
                               @"company_name":self.name.text?self.name.text:@"",
                               @"industry_id":self.indusID?self.indusID:@"",
                               @"capital":self.money.text?self.money.text:@"",
                               @"city":self.cityID?self.cityID:@"",
                               @"address":self.address.text,
                               @"business":self.fanwei.text?self.fanwei.text:@"",
                               @"intro":self.intro.text?self.intro.text:@"",
                               @"company_id":self.com_id,
                               @"representative":self.rep.text?self.rep.text:@"",
                               @"admin_username": self.formatDic[@"username"]?self.formatDic[@"username"]:@"", @"province":self.province?self.province:@""};
        [[NetWork shareNetWork] getCompanyDataWithURLStr:Company_update company_logo:self.image1 company_Image:self.company_image1 aBody:dic aSuccessBlock:^(id myDictionary)  {
            if ([myDictionary[@"status"] isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"更新成功" forError: YES];
                    [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
                });
            }
            
            else
            {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", myDictionary);
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"更新失败" forError:YES];
            }
            
        }
                                     setFailBlock:^(id obj) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                                             [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                                         });
                                     }
         
         ];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请填写完整信息" forError: YES];
            
        });
    }

}
- (void)create
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak LCAddCompanyViewController *vc = self;
    if (self.name.text.length>0&&self.address.text.length>0) {
        NSDictionary * dic = @{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"position":self.position.text?self.position.text:@"", @"company_name":self.name.text?self.name.text:@"", @"industry_id":self.indusID?self.indusID:@"", @"capital":self.money.text?self.money.text:@"", @"city":self.cityID?self.cityID:@"", @"address":self.address.text, @"business":self.fanwei.text?self.fanwei.text:@"", @"intro":self.intro.text?self.intro.text:@"",@"representative":self.rep.text?self.rep.text:@"",@"province":self.province?self.province:@""};
        [[NetWork shareNetWork] getCompanyDataWithURLStr:Company_Create company_logo:self.image1 company_Image:self.company_image1 aBody:dic aSuccessBlock:^(id myDictionary)
        {
            if ([myDictionary[@"status"] isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"创建成功" forError: YES];
                    [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
                });
            }
            
            else
            {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                NSLog(@"%@", myDictionary);
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"更新失败" forError:YES];
            }

        }
         setFailBlock:^(id obj) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                 [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
             });
         }
         
         ];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请填写完整信息" forError: YES];

        });
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
