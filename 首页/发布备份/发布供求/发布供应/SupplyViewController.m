//
//  SupplyViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "SupplyViewController.h"
#import "LCMyNeedViewController.h"
#import "LCMySupplyViewController.h"
#import "LCAddCompanyViewController.h"
#import "LCMyProjectViewController.h"
@interface SupplyViewController ()<UIAlertViewDelegate>
@property (nonatomic, retain)NSArray * companyArray;
@end

@implementation SupplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"发布供应";
    }
    return self;
}
- (IBAction)dismissVCButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ReleaseSel:(id)sender {
    /*
     
     *发布供应方法
     *给服务器发送数据
     *POST
     */
    if (self.txView.text.length >= 1&&self.company_id.length!=0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak SupplyViewController *vc = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary* dic = @{@"user_id":[MyUserDefult objectForKey:@"UserId"], @"company_id": vc.company_id, @"type":@"0", @"content":vc.txView.text};
            [[NetWork shareNetWork] getDataWithURLStr:Business_Create_URL aImage:vc.image1  aBody:dic aSuccessBlock:^(id myDictionary) {
                if ([[myDictionary objectForKey:@"status"]
                     isEqualToString:@"200"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"恭喜您, 发布成功!" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles:@"查看我的供求", nil];
                        alert.tag = 1000;
                        [alert show];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[myDictionary objectForKey:@"message"] delegate:vc cancelButtonTitle:@"好的" otherButtonTitles:@"返回", nil];
                        [alert show];
                    });
                }
            }
            setFailBlock:^(id obj) {
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
                                         }
             ];
            
        });
    }
    else
    {
        [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"请输入内容, 并且确认已经选择完毕企业和发布内容的类型, 重新尝试发布!" forError:YES];
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
    else if (alertView.tag == 1000) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController  popViewControllerAnimated:YES];
                
                break;
            case 1:
            {
   
                [self.navigationController pushViewController:[[LCMySupplyViewController alloc] init] animated:YES];
  
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                break;
            }
    
        }
}

#pragma mark NetWorkDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"发布供应";

    
    self.txView.delegate = self;
    [self.addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicAction)]];
    self.addImage.userInteractionEnabled = YES;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak SupplyViewController *vc = self;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [vc getCompanyData];
    });
    
    if (self.isMain == YES) {
        [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"更新" titleColor:nil buttonFram:CGRectZero];
            self.txView.text = self.content;
        self.companyName.text = self.companyStr;
        [self.view sendSubviewToBack:self.lable];
    }
    else{
            
            [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
    }
}
-(void)right1ButtonClick
{
    [self.view endEditing:YES];

    if (self.isMain == YES) {
        if (self.txView.text.length >= 1) {
            __weak SupplyViewController *vc = self;

            NSString * userId = [NSString stringWithFormat:@"%@", [MyUserDefult objectForKey:@"UserId"]];
            NSDictionary* dic = @{@"user_id":userId, @"company_id": self.company_id, @"type":@"20", @"content":self.txView.text, @"business_id":self.need_id};
            [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    
            [[NetWork shareNetWork] getDataWithURLStr:Business_Update_URL aImage:self.image1  aBody:dic aSuccessBlock:^(id myDictionary) {
                NSLog(@"%@", [myDictionary objectForKey:@"message"]);
      
                [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
                if ([[myDictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[myDictionary objectForKey:@"message"] forError:YES];
                    [vc performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
                }
                else
                {
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[myDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
//                    [alert show];
                    [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[myDictionary objectForKey:@"message"] forError:YES];
                }
            
            }
             setFailBlock:^(id obj) {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误, 请检查网络设置" forError: YES];
             }
             
             ];
            
        }
        else
        {
            [[SystemManager shareSystemManager] showHUDInView:self.view messge:@"内容不能为空, 请重新输入" forError: YES];
        }
        

    }
    else {
    [self ReleaseSel:nil];
    }
}

- (void)addPicAction
{
    NSLog(@"action");
    [self.view endEditing:YES];
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", @"取消", nil];
    [self.standardIBAS setFont:[UIFont systemFontOfSize:13.0]];
    [self.standardIBAS showInView:self.view];
}
- (void)getCompanyData
{
    __weak SupplyViewController *vc = self;

    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        vc.companyArray = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc loadTabView];
        });
    }];
}
- (void)loadTabView
{
    __weak SupplyViewController *vc = self;

    [self.chooseCompany addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCompanyName)]];
    vc.isSecOpened=NO;
    int a = self.companyArray.count;
    [_secTBView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return a;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:vc options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.lb.text = [vc.companyArray[indexPath.row] objectForKey:@"company_name"];
        cell.lb.font = [UIFont systemFontOfSize:13.0];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        vc.companyName.text = cell.lb.text;
        vc.company_id = [NSString stringWithFormat:@"%@", [vc.companyArray[indexPath.row] objectForKey:@"company_id"]];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.secTBView.frame;
            frame.size.height= 0;
            [vc.secTBView setFrame:frame];
            
        } completion:^(BOOL finished){
            
            vc.isSecOpened=NO;
        }];
    }];
    
//    [_secTBView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [_secTBView.layer setBorderWidth:2];
}
- (void)chooseCompanyName
{    __weak SupplyViewController *vc = self;

    if (self.companyArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有企业" delegate: vc cancelButtonTitle:@"知道了" otherButtonTitles:@"创建我的企业", nil];
        alert.tag = 188;
        [alert show];
    }
    else{
    if (vc.isSecOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.secTBView.frame;
            frame.size.height= 0;
            [vc.secTBView setFrame:frame];
            
        } completion:^(BOOL finished){
            
            vc.isSecOpened=NO;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.secTBView.frame;
            frame.size.height=vc.companyArray.count * 42;
            [vc.secTBView setFrame:frame];
        } completion:^(BOOL finished){
            
            vc.isSecOpened=YES;
        }];
        
        
    }
    }
}

- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openImagePickerVC];
    }
    else if(buttonIndex == 1)
    {
        [self openCamera];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.view sendSubviewToBack:self.lable];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"text = %@", textView.text);
    if (self.txView.text.length <= 1) {
        NSLog(@"nil");
        [self.view bringSubviewToFront:self.lable];
        
    }
    else
    {
        NSLog(@"no  nil");
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak SupplyViewController *vc = self;

    self.image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
    [vc.addImage setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
}];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /**
     *  限定 TextView 字数;
     */
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 150) {
        textView.text = [temp substringToIndex:150];
        return NO;
    }
    return YES;
}
/**
 *  收回键盘
 *
 *  @param touches
 *  @param event
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:NO];
    NSLog(@"%@", self.txView.text);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
