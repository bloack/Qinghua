//
//  AddMyStatusViewController.h
//  Boyage
//
//  Created by song longbiao on 13-9-3.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "FacialView.h"
#import "BaseViewController.h"
@protocol AddStatus <NSObject>

- (void)AddMyStatus;

@end

@interface AddMyStatusViewController : BaseViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,facialViewDelegate,UITextViewDelegate>
{
    IBOutlet UITextView *MyText;
    IBOutlet UIButton *MyImag;
    NSMutableArray *BtnArr;
    NSMutableArray *ImgViewArr;
    NSMutableArray *ImageArr;
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    IBOutlet UIButton *InputTypeBtn;
}

@property (retain, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, retain) UIImagePickerController *imagePC;
@property(nonatomic ,assign)id<AddStatus> delegate;
//表情
@property (nonatomic,retain) NSDictionary *faceDictionary;
@end
