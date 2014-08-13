//
//  WaybillCTTabbarContentViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaybillTabelViewCell.h"
#import <QuartzCore/QuartzCore.h>

@class WaybillCTTabbarContentViewController;
@protocol WaybillCTTabbarContentViewDelegate <NSObject>
- (void)remove;
@end

@interface WaybillCTTabbarContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, QueryTraceUtilDelegate, UIScrollViewDelegate, WaybillTabelViewCellDelegate>
@property(nonatomic,strong) IBOutlet UITableView *cttableView;
@property(nonatomic,strong) UINavigationController *navController;
@property(nonatomic,strong) NSMutableArray *contentArray;
@property (strong,nonatomic) NSMutableArray *allArray;
@property (strong,nonatomic) NSMutableArray *alarmArray;
@property (strong,nonatomic) NSMutableArray *normalArray;
@property (strong,nonatomic) NSMutableArray *historyArray;
@property (nonatomic,assign) int index;
@property (strong,nonatomic) NSString *strCode;
@property (nonatomic,strong) WaybillTabelViewCell *currentlyRevealedCell;
@property (nonatomic,assign) id<WaybillCTTabbarContentViewDelegate> delegate;
@property (nonatomic,strong) QueryTraceUtil *queryTraceUtil;
@property (strong,nonatomic) QueryTraceUtil *weixinUtil;
@property (strong,nonatomic) QueryTraceUtil *disTraceSubscribeUtil;
@property (nonatomic) BOOL willRefresh;
@property (nonatomic) BOOL isButtonAction;
@property (strong,nonatomic) NSString *awbCode;

@property (strong,nonatomic) NSMutableArray *resultArray;

- (void)dealIndexChange;
- (void)initDataFromPlist;
@end
