//
//  WaybillViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaybillCTTabbarContentViewController.h"
@class CTTabbarViewController;

@interface WaybillViewController : UIViewController <WaybillCTTabbarContentViewDelegate>

@property (nonatomic,strong)  CTTabbarViewController *ctTabbarViewController;

//@property(strong,nonatomic)NSArray  *existData;
@property(strong,nonatomic)NSString *awbCode;
//@property(strong,nonatomic)NSArray  *tabContentArray;
@property(strong,nonatomic)NSMutableArray *resultArray;
@property(strong,nonatomic)WaybillCTTabbarContentViewController *listViewController;
@property (strong,nonatomic) UIButton *guidBtn;

-(IBAction)SearchEcho:(id)sender;
-(void)setAwbCodeStatus:(NSString *)code status:(NSString *)status;
@end
