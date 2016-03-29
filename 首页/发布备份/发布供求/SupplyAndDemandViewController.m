//
//  SupplyAndDemandViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-5-21.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "SupplyAndDemandViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "LCMyNeedViewController.h"
#import "LCMySupplyViewController.h"
#import "LCMyProjectViewController.h"
#import "LCAddCompanyViewController.h"
@interface SupplyAndDemandViewController ()<UIAlertViewDelegate>
@property (nonatomic, retain)NSArray * styleArray, *companyArray;
@end

@implementation SupplyAndDemandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)right1ButtonClick
{
    [self.view endEditing:YES];

    [self relData:nil];
}

- (void)viewDidLoad
{
    /**
     *  弹出视图,下拉菜单
     */
    [super viewDidLoad];
    self.titleString = @"发布供求";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"fabu" highlightedImageName:@"fabu" backgroundColor:nil buttonTitle:nil titleColor:nil buttonFram:CGRectZero];
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(getCompanyData) object:nil];
    [thread start];
    
    
    self.textView.delegate = self;
    [self.addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicAction)]];
    self.addImage.userInteractionEnabled = YES;
    _isOpened=NO;
    self.styleArray =  @[@"发布供应", @"发布需求", @"发布项目"];
    __weak SupplyAndDemandViewController *vc = self;
    [_tableView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return 3;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:vc options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.lb.text = vc.styleArray[indexPath.row];
        cell.lb.font = [UIFont systemFontOfSize:13.0];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
       vc .typeLable.text = cell.lb.text;
        vc.typeId = [NSString stringWithFormat:@"%d", indexPath.row];
        [vc.openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
   

    
    
    [vc.typeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseType:)]];
    vc.typeImage.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)getCompanyData
{
    __weak SupplyAndDemandViewController *vc = self;
    [[NetWork shareNetWork] netWorkWithURL:Company_me dic:@{@"user_id": [MyUserDefult objectForKey:@"UserId"], @"visit_user_id":[MyUserDefult objectForKey:@"UserId"]} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
        vc.companyArray = [[dictionary objectForKey:@"data"] objectForKey:@"company_list"];
        
        [vc performSelectorOnMainThread:@selector(loadTabView) withObject:nil waitUntilDone:NO];
    }];
}
- (void)loadTabView
{
    [self.chooseCompany addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCompanyName)]];
    _isSecOpened=NO;
    int a = self.companyArray.count;
    __weak SupplyAndDemandViewController *vc = self;

    [_secTBView initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return a;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:vc options:nil]objectAtIndex:0];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        cell.lb.text = [vc.companyArray[indexPath.row] objectForKey:@"company_name"];
        cell.lb.font = [UIFont systemFontOfSize:13.0];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        vc.companyName.text = cell.lb.text;
        vc.companyId = [NSString stringWithFormat:@"%@", [vc.companyArray[indexPath.row] objectForKey:@"company_id"]];
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
{    __weak SupplyAndDemandViewController *vc = self;

    if (self.companyArray.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还没有企业" delegate: self cancelButtonTitle:@"知道了" otherButtonTitles:@"创建我的企业", nil];
        alert.tag = 188;
        [alert show];
    }
    else{
        if (_isSecOpened) {
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
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (IBAction)chooseType:(id)sender {
    __weak SupplyAndDemandViewController *vc = self;

    if (vc.isOpened) {
       
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.tableView.frame;
            
            frame.size.height=0;
            [vc.tableView setFrame:frame];
            
        } completion:^(BOOL finished){
            
            vc.isOpened=NO;
            vc.downImage.hidden = NO;
        }];
    }else{
        
        vc.downImage.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=vc.tableView.frame;
            frame.size.height = 120;
            [vc.tableView setFrame:frame];
            
            CGRect frame1=vc.secTBView.frame;
            frame1.size.height= 0;
            [vc.secTBView setFrame:frame1];
            
        } completion:^(BOOL finished){
            
            vc.isOpened=YES;
        }];
        
        
    }
    

}

- (void)addPicAction
{
    [self.view endEditing:YES];
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"打开相册" otherButtonTitles:@"打开相机", @"取消", nil];
    [self.standardIBAS setFont:[UIFont systemFontOfSize:13.0]];
    [self.standardIBAS showInView:self.view];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak SupplyAndDemandViewController *vc = self;

    vc.image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
        [vc.addImage setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
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
    if (self.textView.text.length < 1) {
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /**
     *  限定 TextView 字数;
     */
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 300) {
        textView.text = [temp substringToIndex:300];
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
    NSLog(@"%@", self.textView.text);
    
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)relData:(id)sender {
    
    if (self.textView.text.length >= 1&&self.companyId.length!=0&&self.typeId.length!=0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak SupplyAndDemandViewController *vc = self;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary* dic = @{@"user_id":[MyUserDefult objectForKey:@"UserId"], @"company_id": self.companyId, @"type":self.typeId, @"content":self.textView.text};
            [[NetWork shareNetWork] getDataWithURLStr:Business_Create_URL aImage:vc.image1  aBody:dic aSuccessBlock:^(id myDictionary) {
                NSLog(@"%@", [myDictionary objectForKey:@"message"]);
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
                        [[SystemManager shareSystemManager] showHUDInView:vc.view messge:@"网络错误" forError: YES];
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
                if ([self.typeId isEqualToString:@"0"]) {
                    [self.navigationController pushViewController:[[LCMySupplyViewController alloc] init] animated:YES];
                }
                else if ([self.typeId isEqualToString:@"1"]){
                    [self.navigationController pushViewController:[[LCMyNeedViewController alloc] init] animated:YES];
                }
                else if([self.typeId isEqualToString:@"2"]){
                    [self.navigationController pushViewController:[[LCMyProjectViewController alloc] init] animated:YES];
                }
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
}
@end
