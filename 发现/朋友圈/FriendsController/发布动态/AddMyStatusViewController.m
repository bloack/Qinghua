//
//  AddMyStatusViewController.m
//  Boyage
//
//  Created by song longbiao on 13-9-3.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import "SystemManager.h"
#import "AddMyStatusViewController.h"
#import "NetWork.h"
#import "LCMyMainViewController.h"

@interface AddMyStatusViewController ()

@end

@implementation AddMyStatusViewController

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
    self.titleString = @"我的动态";
    [self.myNavbar setRight1ButtonWithnormalImageName:@"5-12-back" highlightedImageName:@"5-12-back" backgroundColor:nil buttonTitle:@"发表" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    
    
    
    // Do any additional setup after loading the view from its nib.
    BtnArr = [[NSMutableArray alloc]init];
    ImgViewArr = [[NSMutableArray alloc]init];
    ImageArr = [[NSMutableArray alloc]init];

    for (int i = 0; i<8; i++) {
        UIImageView *img = (UIImageView *)[self.view viewWithTag:20+i];
        [img setClipsToBounds:YES];
        [ImgViewArr addObject:img];
        UIButton *btn = (UIButton *)[self.view viewWithTag:30+i];
        [btn setImage:[UIImage imageNamed:@"addimage.png"] forState:UIControlStateSelected];
        [BtnArr addObject:btn];
    }
    [((UIButton *)[BtnArr objectAtIndex:[ImageArr count]]) setSelected:YES];
    
    //初始化表情
    //        NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    _faceDictionary = FaceData;
//    NSArray *arr = [_faceDictionary allKeys];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [_faceDictionary enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *b)
     {
         [newDict setObject:key forKey:obj];
     }];
    NSArray *arr = [[newDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2)
                    {
                        int i_obj1 = [[[obj1 componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
                        int i_obj2 = [[[obj2 componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
                        if(i_obj1 < i_obj2)
                        {
                            return NSOrderedAscending;
                        }
                        else if(i_obj1 > i_obj2)
                        {
                            return NSOrderedDescending;
                        }
                        else
                        {
                            return NSOrderedSame;
                        }
                    }];
    //创建表情键盘
    //            NSLog(@"%f,%f",superView.frame.size.height,[[[UIApplication sharedApplication] keyWindow] frame].size.height);
    
    
    /*
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT - 20-216, 320, 216)];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    for (int i=0; i<6; i++) {
        @autoreleasepool {
            
            
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, 300, 170)];
            NSMutableArray *arr_temp = [[[NSMutableArray alloc] init] autorelease];
            for (int j = 0; j < 20; j ++) {
                int c = i * 20 + j;
                if(c >= [arr count]) break;
                [arr_temp addObject:[arr objectAtIndex:c]];
            }
            fview.dict = newDict;
            fview.arr = arr_temp;
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33, 33)];
            fview.delegate=self;
            [scrollView addSubview:fview];
            //[fview release];
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*6, 216);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [scrollView release];
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(85, HEIGHT-20-80, 150, 30)];
    [pageControl setCurrentPage:0];
    if([MyVersion floatValue] > 6.0)
    {
        pageControl.pageIndicatorTintColor=[UIColor colorWithRed:195/255.0 green:179/255.0 blue:163/255.0 alpha:1];
        pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:132/255.0 green:104/255.0 blue:77/255.0 alpha:1];
    }
    pageControl.numberOfPages = 6;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    //    pageControl.hidden=YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [pageControl release];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
//    [MyText becomeFirstResponder];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.hintLabel.alpha = 0;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.hintLabel.alpha = 1;
    }
    return YES;
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
//返回
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
//选取图片
- (IBAction)buttonClicked:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO && btn.tag-30<[ImageArr count]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = ((UIButton*)sender).tag+800;
        [alert show];
        [alert release];
    }else if (btn.selected == YES ){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"相册", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==999) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController  popViewControllerAnimated:YES];
                break;
            case 1:
            {
                LCMyMainViewController * vc = [[[LCMyMainViewController alloc] init] autorelease];
                vc.userId = [MyUserDefult objectForKey:@"UserId"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            default:
                break;
        }
    }else{
        if (buttonIndex==1) {
            [ImageArr removeObjectAtIndex:alertView.tag-830];
            [self InitImage];
        }
    }
}

-(void)right1ButtonClick
{
    [self Commit:nil];
}

//提交
-(IBAction)Commit:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (MyText.text.length == 0) {
        [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"输入内容不能为空" forError:YES];
        return;
    }
    
    [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"正在发送，请稍后..." forError:NO];
    __block AddMyStatusViewController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /*
        NSMutableArray *imageArray = [[NSMutableArray alloc]initWithObjects: nil];
        for (int i =0; i<[ImageArr count]; i++) {
            UIImage *img = [ImageArr objectAtIndex:i];
            NSData *dataObj = UIImageJPEGRepresentation(img, 1);
            if ([dataObj length]>1*1024*1024) {
                dataObj = UIImageJPEGRepresentation(img, 0.05);
            }
            [imageArray  addObject:dataObj];
        }
        
        UIImage * image = nil;
        if ([ImageArr count]>0) {
            image = ImageArr[0];
        }
        */
       __block NSDictionary * param = [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"],@"user_id",MyText.text,@"content",nil];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NetWork shareNetWork]getDataWithURLStr:@"/api/moment/moment/create" aImage:ImageArr aBody:param aSuccessBlock:^(id myDictionary) {
                [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
                if ([[myDictionary objectForKey:@"status"] integerValue]==200) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"恭喜您, 发布成功!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"查看我的主页", nil];
                    alert.tag = 999;
                    [alert show];
                    
                    [ImageArr removeAllObjects];
                    [vc.delegate AddMyStatus];
                    
                }else{
                    [[SystemManager shareSystemManager] showHUDInView:self.view messge:[NSString  stringWithFormat:@"发生错误,错误为%@",[myDictionary objectForKey:@"message"]] forError:YES];
                }
            } setFailBlock:^(id error) {
                [[SystemManager shareSystemManager] HUDHidenWithMessage:@"您当前的网络有问题"];
            }];
        });
        
        
    });
    
    
    
    
   
    
    
    
}

#pragma mark  imagePickerController
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndexd
{
    if (buttonIndexd == 0){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];       
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;//no
        imagePickerController.sourceType = sourceType;
        imagePickerController.showsCameraControls  = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];

    }else if (buttonIndexd == 1){
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 8-[ImageArr count];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        [imagePickerController release];
        [navigationController release];
    }
}
#pragma mark - QBImagePickerControllerDelegate
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
        
        
        UIImage * newImage = [UIImage imageWithCGImage:((ALAsset *)[assets objectAtIndex:0]).thumbnail];
//        NSData * data = UIImagePNGRepresentation(newImage);
        
        
        
        [ImageArr addObject: newImage];
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
        
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0.2);
        NSData * newData = imgData;
        if (imgData.length > 1024 * 100) {
            UIImage * myImage = [UIImage imageWithData:imgData];
            newData = UIImageJPEGRepresentation(myImage, (1024 * 100.0) / (imgData.length * 2));
            
        }
        
//        NSLog(@"____%d",newData.length);
        
        UIImage * newImage = [UIImage imageWithData:newData];
        
        [ImageArr addObject: newImage];
    }
    [self InitImage];

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
}
- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%d个", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"照片%d个、图像%d个", numberOfPhotos, numberOfVideos];
}
-(IBAction)SelecteInput:(id)sender
{
    if (InputTypeBtn.selected==YES) {
        [MyText becomeFirstResponder];
        [InputTypeBtn setSelected:NO];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [InputTypeBtn setSelected:YES];
    }
    
}
#pragma mark facialviewDelegate
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (MyText.text.length>0) {
            //说明存在[]
            if([MyText.text hasSuffix:@"]"] && [MyText.text rangeOfString:@"["].location != NSNotFound)
            {
                //包含这个表情
                if([[_faceDictionary allKeys] containsObject:[MyText.text substringFromIndex:[MyText.text rangeOfString:@"[" options:NSBackwardsSearch].location]])
                {
                    newStr = [MyText.text substringToIndex:[MyText.text rangeOfString:@"[" options:NSBackwardsSearch].location];
                    MyText.text=newStr;
                }
            }
        }
    }
    else{
        NSMutableString *str_temp = [(NSMutableString *)MyText.text mutableCopy];
        [str_temp appendString:str];
        [MyText setText:str_temp];
    }
    if (MyText.contentSize.height>MyText.frame.size.height) {
        MyText.contentOffset = CGPointMake(0, MyText.contentSize.height - MyText.frame.size.height);
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
