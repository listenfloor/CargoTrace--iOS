//
//  TCATQueryViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TACTCityListViewController.h"

@interface TACTQueryViewController : UIViewController <TACTCityListViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UITextField *departTextField;
@property (nonatomic, strong) IBOutlet UITextField *destTextField;
@property (nonatomic, strong) IBOutlet UIImageView *departImageView;
@property (nonatomic, strong) IBOutlet UIImageView *destImageView;
@property (nonatomic, strong) NSMutableArray *departArray;
@property (nonatomic, strong) NSMutableArray *destArray;
@property (nonatomic) BOOL isDepartLimit;
@property (nonatomic) BOOL isDestLimit;


- (IBAction)queryBtnClicked:(id)sender;
- (IBAction)expandBtnClicked:(id)sender;

@end
