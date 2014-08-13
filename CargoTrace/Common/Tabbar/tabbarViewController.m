//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarViewController.h"
#import "HomeViewController.h"
#import "TACTQueryViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat orginHeight = self.view.frame.size.height - 50;
    
    if (IS_IPHONE_5)
    {
        orginHeight = self.view.frame.size.height - 50;
    }
    
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0, orginHeight, 320, 50)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    //_arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchBtnAtIndex:(NSInteger)index
{
    UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];

    NSDictionary *data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
}

@end
