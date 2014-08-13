//
//  tabbarViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tabbarView.h"

#define addHeight 88

@class tabbarView;

@interface tabbarViewController : UIViewController <tabbarDelegate>

@property(nonatomic,strong) IBOutlet UIView *view;
@property(nonatomic,strong) tabbarView *tabbar;
@property(nonatomic,strong) NSArray *arrayViewcontrollers;
@end



