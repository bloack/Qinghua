//
//  YellowPagesViewController.m
//  Tsinghua
//
//  Created by lcworld-0324 on 14-5-15.
//  Copyright (c) 2014年 JunCen_Liu. All rights reserved.
//

#import "YellowPagesViewController.h"
#import "ProductViewController.h"
#import "LCHaveALookViewController.h"
#import "IndustryDao.h"
#import "NSString+MD5.h"
@interface YellowPagesViewController ()

@end


@implementation YellowPagesViewController

@synthesize searchDisplayController;



- (IBAction)dimiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (IBAction)byALook:(id)sender {
    /*
     
     *随便看看
     */
    [self.navigationController pushViewController:[[LCHaveALookViewController alloc] init] animated:YES];
}
- (IBAction)profuct:(id)sender {
    /*
     
     *发布产品
     */
    [self.navigationController pushViewController:[[ProductViewController alloc] init] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleString = @"产品黄页";
    
    
    
    _arrayOne = [IndustryDao selectAllDataForDistrict];
    self.firstIndex = 0;
    
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    

}
-(void)setFirstIndex:(int)firstIndex
{
    _firstIndex = firstIndex;
    Industry * model = _arrayOne[_firstIndex];
    _arrayTwo = model.kindArray;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (tableView.tag == 100) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"str"];
        Industry * model = _arrayOne[indexPath.row];
        
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }else if (tableView.tag == 200){
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strTwo"];
        Industry * model = _arrayTwo[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }
    
    return nil;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 100) {
        
        return 40;
    }else if (tableView.tag == 200){
        return 40;
        
    }
    
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView.tag == 100) {
        return _arrayOne.count;
    }else if (tableView.tag == 200){
        return _arrayTwo.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        self.firstIndex = indexPath.row;
        [_tableViewTWO reloadData];
    }
    else
    {
        self.secondIndex = indexPath.row;
    }
}



@end
