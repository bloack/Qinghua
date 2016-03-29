//
//  LCEditNoteViewController.m
//  Qinghua
//
//  Created by FarTeen on 14-7-10.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCEditNoteViewController.h"
#import "SystemManager.h"
#import "NetWork.h"
#import "UIButton+WebCache.h"
#import "LCMyMainViewController.h"
@interface LCEditNoteViewController ()

@end

@implementation LCEditNoteViewController

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
    // Do any additional setup after loading the view from its nib.
    self.titleString = @"编辑动态";
    [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"保存" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    [self setAllUI];
}


/**
 *  设置所有UI
 */
-(void)setAllUI
{
    CGRect rect = self.textBgView.frame;
    NSString * urlStr = @"";
    if (urlStr.length > 5) {
        [self.normalImageButton setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DefaultImage];
    }else
    {
        rect.origin.y = 44 + ADJUST_HEIGHT +10;
    }
    
    NSString * content = self.lastMainModel.content;
    self.textBgView.frame = rect;
    self.textView.text = content;
    
}

-(void)right1ButtonClick
{
    [self.view endEditing:YES];
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"正在保存.." forError:NO];
    if (self.textView.text.length == 0) {
        [[SystemManager shareSystemManager]HUDHidenWithMessage:@"动态信息不能为空"];
        return;
    }
    
    NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:self.lastMainModel.moment_id,@"moment_id",[MyUserDefult objectForKey:@"UserId"],@"user_id",_textView.text,@"content",nil];
    
    NSArray * imagesArray = nil;
    if (self.userImage) {
        imagesArray = @[self.userImage];
    }
    
    
    [[NetWork shareNetWork]getDataWithURLStr:@"/api/moment/moment/update" aImage:imagesArray aBody:param aSuccessBlock:^(id myDictionary) {
        [[SystemManager shareSystemManager]HUDHidenWithMessage:nil];
        
        if ([[myDictionary objectForKey:@"status"] integerValue]==200) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[myDictionary objectForKey:@"message"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 999;
            [alert show];
            
            self.lastMainModel.content = _textView.text;
            
            
            if ([self.delegate respondsToSelector:@selector(updateSuccess:)]) {
                [_delegate updateSuccess:self.userImage];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"%@",[myDictionary objectForKey:@"message"]]delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } setFailBlock:^(id error) {
        [[SystemManager shareSystemManager]HUDHidenWithMessage:@"您当前的网络有问题"];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==999) {
        LCMyMainViewController * controller  = nil;
        for (id  obj in self.navigationController.viewControllers) {
            if ([obj isKindOfClass:[LCMyMainViewController class]]) {
                controller = (LCMyMainViewController *)obj;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }else
        {
            [self goBack];
        }
        
        
    }
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageButtonClick:(id)sender
{
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
    if (_userImage != userImage) {
        _userImage = userImage;
        [self.normalImageButton setImage:nil forState:UIControlStateNormal];
        [self.normalImageButton setImage:nil forState:UIControlStateHighlighted];
        [self.normalImageButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.normalImageButton setBackgroundImage:_userImage forState:UIControlStateNormal];
    }
}

@end
