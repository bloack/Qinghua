//
//  ProjectViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "ProjectViewController.h"
#import "LCMyProjectViewController.h"
@interface ProjectViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, retain)NSArray * companyArray;
@end

@implementation ProjectViewController
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
    __weak ProjectViewController *vc = self;

    if (self.txView.text.length >= 1 && self.company_id.length >= 1) {
        NSString * userId = [NSString stringWithFormat:@"%@", [MyUserDefult objectForKey:@"UserId"]];
        NSDictionary* dic = @{@"user_id":userId, @"company_id":self.company_id, @"type":@"2", @"content":self.txView.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetWork shareNetWork] getDataWithURLStr:Business_Create_URL aImage:self.image1  aBody:dic aSuccessBlock:^(id myDictionary) {
            [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
            NSLog(@"%@", [myDictionary objectForKey:@"message"]);
            if ([[myDictionary objectForKey:@"status"] isEqualToString:@"200"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"恭喜您, 发布成功!" delegate:vc cancelButtonTitle:@"好的" otherButtonTitles:@"查看我的项目", nil];
                alert.tag = 1000;
                [alert show];
                vc.txView.text = @"";
            }
            else
            {
                [[SystemManager shareSystemManager] showHUDInView:vc.view messge:[myDictionary objectForKey:@"message"] forError:YES];
            }
        }
         setFailBlock:^(id obj) {
             [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
             [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError:YES];
         }
         ];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"请输入内容, 并且确认已经选择完毕企业和发布内容的类型, 重新尝试发布!" forError:YES];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController  popViewControllerAnimated:YES];
                break;
            case 1:
            {
                
                [self.navigationController pushViewController:[[LCMyProjectViewController alloc] init] animated:YES];
                
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
    self.titleString = @"发布项目";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
    self.txView.delegate = self;
    [self.addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicAction)]];
    self.addImage.userInteractionEnabled = YES;
    
    [self.chooseComapnay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCompanyName)]];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCompanyData];
    });
}
- (void)getCompanyData
{
    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        self.companyArray = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTabView];
        });
    }];
}
- (void)loadTabView
{
    __weak ProjectViewController *vc = self;

    [self.chooseComapnay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCompanyName)]];
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
        vc.companyNameLable.text = cell.lb.text;
        vc.company_id = [NSString stringWithFormat:@"%@", [vc.companyArray[indexPath.row] objectForKey:@"company_id"]];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.secTBView.frame;
            frame.size.height= 0;
            [vc.secTBView setFrame:frame];
            
        } completion:^(BOOL finished){
            
            vc.isSecOpened=NO;
        }];
    }];

}
- (void)chooseCompanyName
{    __weak ProjectViewController *vc = self;

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


-(void)right1ButtonClick
{
    [self.view endEditing:YES];

    [self ReleaseSel:nil];
}

- (void)addPicAction
{
    NSLog(@"action");
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", nil];
    [sheet showInView:self.view];
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

- (void)fabu:(UIButton *)button
{
    
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
    __weak ProjectViewController *vc = self;

    vc.image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
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
