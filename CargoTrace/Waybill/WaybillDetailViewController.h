//
//  WaybillDetailViewController.h
//  CargoTrace
//
//  Created by efreight on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"
#import <MessageUI/MessageUI.h>
#import "WBEngine.h"

@class CTProgressbarView;

@interface WaybillDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate, CustomActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, QueryTraceUtilDelegate, WBEngineDelegate, CustomAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UIView *bottombarView;
@property (nonatomic,strong) IBOutlet UIButton *leftButton;
@property (nonatomic,strong) IBOutlet UIButton *middButton;
@property (nonatomic,strong) IBOutlet UIButton *rightButton;

@property (nonatomic,strong) IBOutlet UIView *topView;
@property (nonatomic,strong) IBOutlet UITableView * expandTableView;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic,assign) NSUInteger indentation;
@property (nonatomic,strong) NSMutableArray *nodes;
@property (nonatomic,strong) CTProgressbarView *progressbar;

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) bool isWarning;
@property (nonatomic,assign) NSInteger alarmCount;
@property (nonatomic,assign) NSInteger traceCount;
@property (nonatomic,strong) NSMutableDictionary *data;
@property (nonatomic, strong) id waybillcode;
@property (nonatomic, copy) NSString *cargocode;
@property (nonatomic) BOOL isSubribe;
@property (strong,nonatomic) QueryTraceUtil *queryTraceUtil;
@property (strong,nonatomic) QueryTraceUtil *disTraceSubscribeUtil;
@property (strong,nonatomic) QueryTraceUtil *weixinUtil;
@property (strong,nonatomic) QueryTraceUtil *candyUtil;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (nonatomic,strong) IBOutlet UIView *lineView1;
@property (nonatomic,strong) IBOutlet UIView *lineView2;
@property (nonatomic,strong) IBOutlet UIView *lineView3;
@property (nonatomic,strong) IBOutlet UILabel *label1;
@property (nonatomic,strong) IBOutlet UILabel *label2;
@property (nonatomic,strong) IBOutlet UILabel *label3;
@property (nonatomic,strong) IBOutlet UILabel *noInfo;
@property (nonatomic) BOOL isNotification;
@property (strong,nonatomic) UIButton *guidBtn;

- (void)expandCollapseNode:(NSNotification *)notification;
- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray  section:(int)sectionIndex;
//- (void)fillNodesArray;
//- (NSArray *)fillChildrenForNode;
- (IBAction)expandAll:(id)sender;
- (IBAction)collapseAll:(id)sender;

- (IBAction)leftButAction:(id)sender;
- (IBAction)middButAction:(id)sender;
- (IBAction)rightButAction:(id)sender;
@end
