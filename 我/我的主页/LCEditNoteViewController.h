//
//  LCEditNoteViewController.h
//  Qinghua
//
//  Created by FarTeen on 14-7-10.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"
#import "MyMainModel.h"
@interface LCEditNoteViewController : BaseViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *normalImageButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *textBgView;

@property (assign,nonatomic)id delegate;
/**
 *  数据源对象
 */
@property (nonatomic, strong) MyMainModel * lastMainModel;
@property (nonatomic, strong) UIImage * userImage;
- (IBAction)imageButtonClick:(id)sender;

@end


@protocol LCEditNoteViewControllerDelegate <NSObject>

-(void)updateSuccess:(UIImage *)image;

@end