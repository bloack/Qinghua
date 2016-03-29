//
//  LCNewPsdViewController.m
//  Qinghua
//
//  Created by lcworld-0324 on 14-6-26.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "LCNewPsdViewController.h"

@interface LCNewPsdViewController ()

@end

@implementation LCNewPsdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleString = @"忘记密码";
    // Do any additional setup after loading the view from its nib.
}

-(void)goBack
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:NO];
}

- (IBAction)getCodeBtn:(id)sender {
    if (self.phoneTFView.text.length != 11) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入完整的手机号" delegate: self cancelButtonTitle:@"好的" otherButtonTitles: nil, nil];
        [alert show];
    }
    NSString * phone = self.phoneTFView.text;
    NSLog(@"phone = %@", phone);
    [[NetWork shareNetWork] netWorkWithURL:GetCode dic:@{@"mobile_phone": phone} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    }];

}
- (IBAction)getNewKeyBtn:(id)sender {
    NSLog(@"%@", self.phoneTFView.text);

    [[NetWork shareNetWork] netWorkWithURL:GetNewKy dic:@{@"mobile_phone": self.phoneTFView.text, @"code":self.codeTFView.text,@"new_password":self.myNewKey.text} setSuccessBlock:^(id dictionary) {
        NSLog(@"%@", dictionary);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
