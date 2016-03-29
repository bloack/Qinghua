//
//  QHCircleMomentDetailController.m
//  Qinghua
//
//  Created by FarTeen on 14-8-12.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "QHCircleMomentDetailController.h"

@interface QHCircleMomentDetailController ()

@end

@implementation QHCircleMomentDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
    
}

-(void)initFaceToolBar
{    //输入工具
    _bar=[[FaceToolBarSimple alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view];
    _bar.textView.placeholder = @"回复动态";
    _bar.delegate1=self;
    
    _bar.voiceButton.hidden = YES;
    _bar.recordButton.hidden = YES;
    _bar.faceButton.hidden =YES;
    [_bar.textView setFrame:CGRectMake(10, 4, 240, 36)];
    [_bar.sendButton setFrame:CGRectMake(260, 7, 50, 30)];
    [_bar.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_bar.sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_bar.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bar.sendButton setImage:nil forState:UIControlStateNormal];
    [_bar.sendButton setImage:nil forState:UIControlStateHighlighted];
    [_bar.sendButton  setBackgroundImage:[UIImage imageNamed:@"titlebtn1.png"] forState:UIControlStateNormal];
    [_bar.sendButton  setBackgroundImage:[UIImage imageNamed:@"titlebtn2.png"] forState:UIControlStateHighlighted];
    
    [self.view bringSubviewToFront:self.functionView];
}

#pragma mark - 键盘
- (void)keyboardWillShow:(NSNotification *)noti
{
    mbView.alpha = .2;
    //    CGRect changeFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //
    //    CGRect bgRect = self.bgScrollView.frame;
    //
    //    bgRect.size.height = MY_SCREEN_HEIGHT - 44 - changeFrame.size.height + ADJUST_HEIGHT;
    //
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.25];
    //    [UIView setAnimationCurve:7];
    //    self.bgScrollView.frame = bgRect;
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    mbView.alpha = 0;
    //    CGRect changeFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //
    //    CGRect bgRect = self.bgScrollView.frame;
    //    bgRect.size.height += changeFrame.size.height;
    //
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.25];
    //    [UIView setAnimationCurve:7];
    //    self.bgScrollView.frame = bgRect;
    //    [UIView setAnimationBeginsFromCurrentState:YES];
    //    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleString = @"动态详情";
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setAllUI];
    
    
    /**
     *  添加蒙板,当输入框弹起的时候用来屏蔽底部点击事件
     */
    mbView = [[UIView alloc]initWithFrame:self.view.bounds];
    mbView.alpha = 0;
    mbView.backgroundColor  = [UIColor blackColor];
    mbView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mbView];
    
    [self initFaceToolBar];
    
    //添加手势(键盘响应)
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_bar action:@selector(dismissKeyBoard)];
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_bar action:@selector(dismissKeyBoard)];
    [mbView addGestureRecognizer:tapRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_bar addObserver];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_bar removeObserver];
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


/**
 *  设置所有UI
 */
-(void)setAllUI
{
    CGRect  rect = self.contentLabel.frame;
    self.titleString = @"动态详情";
    /*
    if ([self.lastModel.user_id isEqualToString:[MyUserDefult objectForKey:@"UserId"]]) {
        [self.myNavbar setRight1ButtonWithnormalImageName:@"" highlightedImageName:nil backgroundColor:nil buttonTitle:@"更多" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    }
    */
    
    
    if (self.lastModel.paths.count > 0) {
        static int distance = 10;
        static float width = (320 - 10 * 4) / 3;
        static float height = (320 - 10 * 4) / 3;
        for (int i = 0; i < self.lastModel.paths.count; i++) {
            float x = (i % 3 + 1) * distance + (i % 3) * width;
            float y = (i / 3) * (distance + height);
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
            [self.imageBgView addSubview:imageView];
            
            [imageView setImageWithURL:[NSURL URLWithString:self.lastModel.paths[i]] placeholderImage:DefaultImage];
            
        }
        
        int rowCount = ceilf(self.lastModel.paths.count / 3.0);
        CGRect bgRect = self.imageBgView.frame;
        bgRect.size.height = rowCount * (distance + height);
        self.imageBgView.frame = bgRect;
        
        rect.origin.y = bgRect.origin.y + bgRect.size.height;
        
    }else
    {
        rect.origin.y = 10;
    }
    
    
    NSString * content = self.lastModel.content;
    CGSize size = [SystemManager getRectWithWidth:300 content:content font:14];
    rect.size.height = size.height;
    self.contentLabel.frame = rect;
    self.contentLabel.text = content;
    self.zanCountLabel.text = self.lastModel.like_number;
    
    
    CGRect listRect = self.commentListView.frame;
    listRect.origin.y = rect.origin.y + rect.size.height + 10;
    self.commentListView.frame = listRect;
    [self setListViewFrame];
}

/**
 *  重新设置列表坐标
 */
-(void)setListViewFrame
{
    CGFloat height = 0;
    for (int i = 0; i < [self.lastModel.comment_list count]; i++) {
        Comment * comment = self.lastModel.comment_list[i];
        
        CGSize size = [SystemManager getRectWithWidth:280 content:[NSString stringWithFormat:@"%@: %@",comment.real_name,comment.content] font:13];
        height += size.height + 10;
    }
    
    CGRect listRect = self.commentListView.frame;
    listRect.size.height = height;
    self.commentListView.frame = listRect;
    
    self.bgScrollView.contentSize = CGSizeMake(0, listRect.origin.y + listRect.size.height + 5);
    
    [self.commentListView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lastModel.comment_list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 5)];
        [cell addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        label.tag = 10;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel * label = (UILabel *)[cell viewWithTag:10];
    
    
    Comment * comment = self.lastModel.comment_list[indexPath.row];
    
    NSString * content = [NSString stringWithFormat:@"%@: %@",comment.real_name,comment.content];
    
    CGSize size = [SystemManager getRectWithWidth:280 content:content font:13];
    label.text = content;
    label.frame = CGRectMake(10, 5, 280, size.height);
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Comment * comment = self.lastModel.comment_list[indexPath.row];
    
    CGSize size = [SystemManager getRectWithWidth:300 content:[NSString stringWithFormat:@"%@: %@",comment.real_name,comment.content] font:13];
    return size.height + 10;
}

- (IBAction)zanButtonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.selected==NO) {
        
        //    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
        //    hub.minShowTime=1;
        //    hub.labelText=@"正在初始化，请稍后...";
        NSDictionary * param;
        param= [NSDictionary dictionaryWithObjectsAndKeys:[MyUserDefult objectForKey:@"UserId"] ,@"user_id",@"11",@"x_type",self.lastModel.moment_id,@"x_id",nil];
        __weak QHCircleMomentDetailController * blockSelf = self;
        
        [[NetWork shareNetWork] netWorkWithURL:@"/api/like/like/create" dic:param setSuccessBlock:^(id dictionary) {
            if ([[dictionary objectForKey:@"status"] integerValue]==200) {
                [btn setSelected:YES];
                
                blockSelf.lastModel.like_number = String(blockSelf.lastModel.like_number.intValue + 1);
                blockSelf.zanCountLabel.text = String([_zanCountLabel.text intValue] + 1);
                
                [RequestCenter showToast:@"添加赞成功!"];
                
                
                /*
                 UILabel *lable2 = (UILabel *)[self.view viewWithTag:btn.tag+4900];
                 [lable2 setText:[NSString stringWithFormat:@"        %@,%@",[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"],[lable2.text substringFromIndex:8]]];
                 
                 
                 //                     [[[[_StarList objectAtIndex:sender.OtherTag] objectForKey:@"zanarr"] objectAtIndex: sender.tag]  objectForKey:@"phone"];
                 
                 NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[_StarList objectAtIndex:btn.tag-100]];
                 NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"zanarr"]];
                 NSDictionary *commondic = [[NSDictionary alloc]initWithObjectsAndKeys:[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"user_name"],@"uaername",[[MyUserDefult objectForKey:@"UserInfo"] objectForKey:@"phone"],@"phone",nil];
                 [arr insertObject:commondic atIndex:0];
                 [dic removeObjectForKey:@"zanarr"];
                 [dic setObject:arr forKey:@"zanarr"];
                 [dic setObject:[[[dict objectForKey:@"data"] objectForKey:@"count"] retain] forKey:@"good_count"];
                 [dic setObject:@"0" forKey:@"check"];
                 [_StarList removeObjectAtIndex:btn.tag-100];
                 [_StarList insertObject:dic atIndex:btn.tag-100];
                 //                     if ([CellArr count]>btn.tag-100) {
                 //                         [CellArr removeObjectAtIndex:btn.tag-100];
                 //                     }
                 //                     rowReload = YES;
                 NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:btn.tag-100+1 inSection:0];
                 NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
                 [MyTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                 */
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"%@",[dictionary objectForKey:@"message"]]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                //             [MBProgressHUD hideHUDForView:self.view animated:NO];
            }
        } setFailBlock:^(id obj) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
        
    }
}

- (IBAction)commentButtonClick:(id)sender {
    [_bar.textView becomeFirstResponder];
}


#pragma mark - 发送消息<好友或群组>
- (void)sendTakePictureAction:(NSString *)inputText
{
    if (inputText.length > 0) {
        [self commentWithText:inputText];
    }
}

- (void)sendTextAction:(NSString *)inputText
{
    if (inputText.length > 0) {
        [self commentWithText:inputText];
    }
}

-(void)commentWithText:(NSString *)inputText
{
    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //        hub.minShowTime=1;
    hub.labelText=@"正在评论，请稍后...";
    
    __block QHCircleMomentDetailController * blockSelf = self;
    
    NSDictionary * param = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],@"11",_lastModel.moment_id,inputText] forKeys:@[@"user_id",@"x_type",@"x_id",@"content"]];
    
    
    
    [[NetWork shareNetWork] netWorkWithURL:@"/api/comment/comment/create" dic:param setSuccessBlock:^(id dictionary) {
        
        [MBProgressHUD hideHUDForView:blockSelf.view animated:NO];
        
        if ([[dictionary objectForKey:@"status"] integerValue]==200) {
            
            
            
            
            NSDate * date = [NSDate date];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            NSString * dateStr = [formatter stringFromDate:date];
            
            //    NSLog(@"______%@",[MyUserDefult objectForKey:@"userName"]);
            NSDictionary * commondic = [NSDictionary dictionaryWithObjects:@[inputText,dateStr,([MyUserDefult objectForKey:@"userDic"][@"data"][@"real_name"]),[MyUserDefult objectForKey:@"UserId"],([MyUserDefult objectForKey:@"userDic"][@"data"][@"avatar"])] forKeys:@[@"content",@"create_time",@"real_name",@"user_id",@"avatar"]];
            
            Comment * comment = [[Comment alloc]initWithDic:commondic];
            
            
            [blockSelf.lastModel.comment_list addObject:comment];
            [blockSelf setListViewFrame];
            
            if ([self.delegate respondsToSelector:@selector(QHCircleMoment:with:Id:)]) {
                [self.delegate QHCircleMoment:inputText with:String(blockSelf.lastIndex) Id:blockSelf.lastModel.moment_id];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"%@",[dictionary objectForKey:@"message"]]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //             [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } setFailBlock:^(id obj) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideHUDForView:blockSelf.view animated:NO];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
