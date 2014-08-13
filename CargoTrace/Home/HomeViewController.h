//
//  HomeViewController.h
//  CargoTrace
//
//  Created by efreight on 13-4-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveMaskView.h"
#import "GDataXMLNode.h"
#import "WaybillCTTabbarContentViewController.h"

@class DDMenuController;
@class  LeftSideBarSettingViewController;
@class SearchViewController ;
@class CTTabbarViewController;
@class CTGridView;


@protocol HomeViewControllerDelegete <NSObject>

-(void)delgateAction:(NSString *)code;

@end



@interface HomeViewController : UIViewController<HomeViewControllerDelegete,UIScrollViewDelegate, QueryTraceUtilDelegate, WaybillCTTabbarContentViewDelegate>

@property (strong, nonatomic)DDMenuController *rootController;
@property (strong, nonatomic)LeftSideBarSettingViewController  *leftController;
@property (strong, nonatomic)NSMutableArray * buttonArray;

@property (nonatomic,strong) IBOutlet UIView *otherView;
@property (nonatomic,strong) IBOutlet UIView *bottomView;
@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) IBOutlet UIView *otherBottomView;
@property (nonatomic,strong) IBOutlet UIView *otherTopView;
@property (nonatomic,strong) IBOutlet UIImageView *headImageView;
 
@property (nonatomic,strong) SearchViewController  * searchController;
@property (nonatomic,strong) CTTabbarViewController *ctTabbarViewController;
@property (nonatomic,strong) CTGridView *ctgView;
@property (strong,nonatomic) NSArray *data;
@property (strong,nonatomic) IBOutlet UIPageControl * pageControl;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) QueryTraceUtil *queryTraceUtil;
@property (nonatomic,assign) NSInteger isSubscribed;
@property (strong,nonatomic) WaybillCTTabbarContentViewController *listViewController;
@property (strong,nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong,nonatomic) UIButton *guidBtn;

-(IBAction)SearchEcho:(id)sender;
-(void)delgateAction:(NSString*)code;
-(void)getCompanyData;
-(IBAction)TACTBtnClicked:(id)sender;
-(IBAction)CustomerServiceBtnClicked:(id)sender;

@end
