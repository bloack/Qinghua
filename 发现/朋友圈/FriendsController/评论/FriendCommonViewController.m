//
//  FriendCommonViewController.m
//  Boyage
//
//  Created by song longbiao on 13-9-4.
//  Copyright (c) 2013年 songlb. All rights reserved.
//

#import "FriendCommonViewController.h"

@interface FriendCommonViewController ()

@end

@implementation FriendCommonViewController

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
    self.titleString = @"评论";
    [self.myNavbar setRight1ButtonWithnormalImageName:nil highlightedImageName:nil backgroundColor:nil buttonTitle:@"提交" titleColor:[UIColor whiteColor] buttonFram:CGRectZero];
    
    
    // Do any additional setup after loading the view from its nib.
    if ([_ReplyOne length]>0) {
        [MyText setText:[NSString stringWithFormat:@"回复 %@:", _ReplyOne ]];
        PleaseLab.hidden = YES;
    }
    
    /*
    //初始化表情
    //        NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    _faceDictionary = FaceData;
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
//    NSArray *arr = [_faceDictionary allKeys];
    //创建表情键盘
        //            NSLog(@"%f,%f",superView.frame.size.height,[[[UIApplication sharedApplication] keyWindow] frame].size.height);
        
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
                [fview release];
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

-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [MyText becomeFirstResponder];
}
//返回
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)right1ButtonClick
{
    [self Commit:nil];
}

-(IBAction)Commit:(id)sender
{
    //    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //    hub.minShowTime=1;
    //    hub.labelText=@"正在初始化，请稍后...";
    if ([MyText.text length]>0) {
        
        
        __block FriendCommonViewController * blockSelf = self;
        [[SystemManager shareSystemManager]showHUDInView:self.view messge:@"正在评论..." forError:NO];
//    MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
//    hub.minShowTime=1;
//        hub.labelText=@"正在评论，请稍后...";
        NSDictionary * param = [NSDictionary dictionaryWithObjects:@[[MyUserDefult objectForKey:@"UserId"],@"11",_Myid,MyText.text] forKeys:@[@"user_id",@"x_type",@"x_id",@"content"]];
        
        
        [[NetWork shareNetWork] netWorkWithURL:@"/api/comment/comment/create" dic:param setSuccessBlock:^(id dictionary) {
            [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
//            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            if ([[dictionary objectForKey:@"status"] integerValue]==200) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[dictionary objectForKey:@"message"] delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 999;
                [alert show];
                [alert release];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"发生错误,错误为%@",[dictionary objectForKey:@"message"]]delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                //             [MBProgressHUD hideHUDForView:self.view animated:NO];
            }
        } setFailBlock:^(id obj) {
            [[SystemManager shareSystemManager] HUDHidenWithMessage:nil];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString  stringWithFormat:@"网络连接异常" ]delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        
        
    }
    else
    {
        [RequestCenter showAlertMessage:@"评论内容不能为空!"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==999) {
        [self.delegate FriendCommon:MyText.text with:_MyTag Id:nil];
        [self Back:nil];
    }
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
#pragma mark textviewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    PleaseLab.hidden = YES;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    PleaseLab.hidden = YES;
    int wordcount = [self textLength:textView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入字数不能超过140个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
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
        PleaseLab.hidden = YES;
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
//返回长度
- (int)textLength:(NSString *)text
{
	float number = 0.0;
	for (int index = 0; index < [text length]; index++)
	{
		NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
		
		if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
		{
			number++;
		}
		else
		{
			number = number + 0.5;
		}
	}
	return ceil(number);
}
-(void)sendEmotion
{
    
}


@end
