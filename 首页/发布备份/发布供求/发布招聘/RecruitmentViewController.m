//
//  RecruitmentViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "RecruitmentViewController.h"
#import "IndustryDao.h"
#import "UIPopoverListView.h"
#import "IndustrySheet.h"
#import "LCAddCompanyViewController.h"
@interface RecruitmentViewController ()<UIAlertViewDelegate, UIPopoverListViewDataSource, UIPopoverListViewDelegate>

@end

@implementation RecruitmentViewController
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)ReleaseSel:(id)sender {
    /*
     
     *发布供应方法
     *给服务器发送数据
     *POST
     */
    __weak RecruitmentViewController *vc = self;

    if (_tf1.text.length >0&&_tf2.text.length >0&&_tf3.text.length >0&&_tf4.text.length >0&&_tf5.text.length >0&&_tf6.text.length>0&&_tf7.text.length>0&&_contract.text.length>0) {
        NSDictionary * dic = @{@"user_id": [NSString stringWithFormat:@"%@", [MyUserDefult  objectForKey:@"UserId"]], @"company_id":self.companyId?self.companyId:@"", @"industry_id":self.indusId, @"title":_tf1.text, @"number":_tf3.text, @"work_address":_tf4.text, @"content":_tf7.text, @"annual_salary":_tf5.text, @"position":_tf6.text, @"contact":_contract.text};
        [MBProgressHUD showHUDAddedTo:vc.view animated:YES];

        [[NetWork shareNetWork] netWorkWithURL:Recruitment_Create_URL dic:dic setSuccessBlock:^(id dictionary) {
            
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            if ([[dictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"发布成功" forError: YES];
                vc.tf1.text= @"";
                vc.tf2.text= @"";
                vc.tf3.text= @"";
                vc.tf4.text= @"";
                vc.tf5.text= @"";
                vc.tf6.text= @"";
                vc.tf7.text= @"";
                [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[dictionary objectForKey:@"message"] delegate:vc cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
                [alert show];
            }

        }
         setFailBlock:^(id obj) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
         }
         
         ];
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
    else
    if (alertView.tag == 999) {
        _tf1.text= @"";
        _tf2.text= @"";
        _tf3.text= @"";
        _tf4.text= @"";
        _tf5.text= @"";
        _tf6.text= @"";
        _tf7.text= @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark NetWorkDelegate
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.chosseCompany addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popClickAction:)]];
    [self.chooseIndus addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseIndusAction)]];
    self.titleString = @"发布招聘";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    __weak RecruitmentViewController * blockSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [blockSelf getCompanyData];
    });
    
    self.scrollView.contentSize = CGSizeMake(320, 600);
    
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


- (void)chooseIndusAction
{
    IndustrySheet * sheet = [[IndustrySheet alloc]initWithTitle:@"选择行业" delegate:self sheetType:sheetType_picker];
    [sheet showInView:self.view];
}
-(void)industrySheet:(IndustrySheet *)sheet firstIndex:(int)index secondIndex:(int)secondIndex{
    NSArray * industryArray = [IndustryDao selectAllDataForDistrict];
    Industry * firstModel = industryArray[index];
    if (firstModel.kindArray.count > 0) {
        Industry * secondModel = firstModel.kindArray[secondIndex];
        self.indusId = secondModel.ID;
        self.tf2.text = secondModel.name;
    }
    else
    {
        self.indusId = firstModel.ID;
         self.tf2.text = firstModel.name;
    }
}
- (void)getCompanyData
{
    __weak RecruitmentViewController *vc = self;

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
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
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
    
    self.companyId = [self.companyList[indexPath.row] objectForKey:@"company_id"];
    self.companyName.text = [self.companyList[indexPath.row] objectForKey:@"company_name"];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)right1ButtonClick
{
    [self.view endEditing:YES];

    [self ReleaseSel:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
