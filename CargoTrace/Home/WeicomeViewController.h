//
//  WeicomeViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-10-15.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeicomeViewController : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *view;
@property (retain, nonatomic) IBOutlet UIImageView *imageView1;
@property (retain, nonatomic) IBOutlet UIImageView *imageView2;
@property (retain, nonatomic) IBOutlet UIImageView *imageView3;
@property (retain, nonatomic) IBOutlet UIImageView *imageView4;
@property (retain, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@end
