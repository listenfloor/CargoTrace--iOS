//
//  WeicomeViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-10-15.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "WeicomeViewController.h"

@interface WeicomeViewController ()

@end

@implementation WeicomeViewController
@synthesize pageScroll;
@synthesize pageControl;

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.view.frame = CGRectMake(0, 20, 320, self.view.frame.size.height - 20);
        self.pageScroll.frame = CGRectMake(0, 20, 320, self.view.frame.size.height - 20);
    }
    // Do any additional setup after loading the view from its nib.
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    
    pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMainView
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [self.pageScroll setHidden:YES];
    [self.pageControl setHidden:YES];
    
    [UIView commitAnimations];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double x = scrollView.contentOffset.x;
    if (x > 960)
    {
        [self gotoMainView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"welcome" object:nil userInfo:nil];
    }
    else
    {
        CGFloat pageWidth = self.view.frame.size.width;
        int page = floor((x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
    }
}

@end
