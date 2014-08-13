//
//  MyOrderListViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-10-16.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "MyOrderListViewController.h"

@interface MyOrderListViewController ()

@end

@implementation MyOrderListViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[CommonUtil colorWithHexString:@"#eeeeec"]];
    [self setTitle:@"我的运单"];
    [self setNavbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  导航栏 设置
- (void)setNavbar
{
    self.navigationController.title = nil;
    [self.navigationController.navigationBar setBarStyle: UIBarStyleBlack];
    
    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
}

- (void)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
