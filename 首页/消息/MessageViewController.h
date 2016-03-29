//
//  MessageViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



typedef enum {
    lcRecieveMessage,
    lcComment,
    lcActive
};

@interface MessageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (nonatomic, strong) NSString * hintCount;
- (IBAction)dismis:(UIButton *)sender;
@property (nonatomic,assign)NSInteger  messageCount, commentCount, systemCount, activeCount, groupCount, introduceCount;
@property (nonatomic, strong)NSMutableArray * messageArray, *commentArray, * likeArray, *systemArray, *activeArray, *groupArray, *introduceArray;

@property (nonatomic, retain)NSString * fileName;

@end
