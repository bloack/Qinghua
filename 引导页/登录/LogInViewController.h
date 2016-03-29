//
//  LogInViewController.h
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController<NetWorkDelegate>
{
    
    
    NSMutableArray    * _friendsArray;
    
}
/*
 *ID输入框；
 */
@property (weak, nonatomic) IBOutlet UITextField *IDTFView;

/*
 *密码输入框；
 */
@property (weak, nonatomic) IBOutlet UITextField *psasswordTFView;
@property (weak, nonatomic) IBOutlet UIImageView *yesImage;
@property (nonatomic, assign)BOOL isYes;

/*
 *忘记密码？立即找回；
 */
- (IBAction)getPassword:(id)sender;
- (IBAction)registerButtonClick:(id)sender;

@end
