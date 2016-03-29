//
//  QHCircleMomentDetailController.h
//  Qinghua
//
//  Created by FarTeen on 14-8-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"
#import "CircleOfFriendModel.h"
#import "FaceToolBarSimple.h"
@interface QHCircleMomentDetailController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView * mbView;
}
@property (strong, nonatomic) FaceToolBarSimple * bar;
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) CircleOfFriendModel * lastModel;
@property (nonatomic, assign) int lastIndex;


@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *functionView;

@property (weak, nonatomic) IBOutlet UITableView *commentListView;

- (IBAction)zanButtonClick:(id)sender;

- (IBAction)commentButtonClick:(id)sender;
@end


@protocol QHCircleMomentDelegate <NSObject>

- (void)QHCircleMoment:(NSString *)str with:(NSString *)tag Id:(NSString *)commonid;

@end