//
//  CTGridView.h
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface CTGridView : UIScrollView<UIGestureRecognizerDelegate>  

@property(strong,nonatomic) NSMutableArray * gridButtonArray;
@property(assign,nonatomic) id<HomeViewControllerDelegete>  delegateHome;
 
-(void)setGridButtonsDeploy;
-(void)setGridButtonsDeploy_NO_IPHONE5;
-(void)setGridButtonsDeploy_IS_IPHON5;

@end
