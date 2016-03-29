//
//  LCNoteViewController.h
//  Qinghua
//
//  Created by FarTeen on 14-7-7.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "BaseViewController.h"
#import "FaceToolBarSimple.h"
#import "MyMainModel.h"
@interface LCNoteViewController : BaseViewController<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * mbView;
}
@property (strong, nonatomic) FaceToolBarSimple * bar;
/**
 *  数据源对象
 */
@property (nonatomic, strong) MyMainModel * lastMainModel;

/**
 *  当前动态的索引值
 */
@property (nonatomic, assign) int lastIndex;
@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *functionView;

@property (weak, nonatomic) IBOutlet UITableView *commentListView;

- (IBAction)zanButtonClick:(id)sender;

- (IBAction)commentButtonClick:(id)sender;
@end


@protocol LCNoteViewControllerDelegate <NSObject>

-(void)deleteDataWithIndex:(int)index;

-(void)replaceDic:(NSDictionary *)dic index:(int)index;

-(void)reloadData;


@end