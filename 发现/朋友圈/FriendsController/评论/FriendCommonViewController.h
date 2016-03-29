//
//  FriendCommonViewController.h
//  Boyage
//
//  Created by song longbiao on 13-9-4.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "BaseViewController.h"
@protocol FriendCommon <NSObject>

- (void)FriendCommon:(NSString *)data with:(NSString *)tag Id:(NSString *)commonid;

@end

@interface FriendCommonViewController : BaseViewController<UITextViewDelegate,facialViewDelegate>
{
    UIToolbar *toolBar;//工具栏
    IBOutlet UITextView *MyText;
    IBOutlet UILabel *PleaseLab;
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    IBOutlet UIButton *InputTypeBtn;
}
/**
 *  评论动态ID
 */
@property(nonatomic ,retain)NSString *Myid;
/**
 *  动态在数组中的索引
 */
@property(nonatomic ,retain)NSString *MyTag;
@property(nonatomic ,retain)NSString *ReplyOne;
@property(nonatomic ,assign)id<FriendCommon> delegate;
//表情
@property (nonatomic,retain) NSDictionary *faceDictionary;



@end
