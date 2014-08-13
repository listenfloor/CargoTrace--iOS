//
//  SearchViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchOtherView.h"
@class WaybillViewController;

@interface SearchViewController : UIViewController<UITextFieldDelegate, QueryTraceUtilDelegate, CustomAlertViewDelegate>

@property(strong,nonatomic) WaybillViewController *waybillViewController;

@property(strong,nonatomic) IBOutlet UILabel * lastNextOneNumber;
@property(strong,nonatomic) IBOutlet UILabel * middleFourNumber;
@property(strong,nonatomic) IBOutlet UILabel * frontTwoNumber;

@property(strong,nonatomic) IBOutlet UILabel * backMessageLabel;
@property(strong,nonatomic) IBOutlet UILabel * frontMessageLabel;
@property(strong,nonatomic) IBOutlet UIButton * searchButton;
@property(strong,nonatomic) IBOutlet UITextField * searchFirstTextField;
@property(strong,nonatomic) IBOutlet NSString * compayCode;


@property(strong,nonatomic) IBOutlet UIButton * num1;
@property(strong,nonatomic) IBOutlet UIButton * num2;
@property(strong,nonatomic) IBOutlet UIButton * num3;
@property(strong,nonatomic) IBOutlet UIButton * num4;
@property(strong,nonatomic) IBOutlet UIButton * num5;
@property(strong,nonatomic) IBOutlet UIButton * num6;
@property(strong,nonatomic) IBOutlet UIButton * num7;
@property(strong,nonatomic) IBOutlet UIButton * num8;
@property(strong,nonatomic) IBOutlet UIButton * num9;
@property(strong,nonatomic) IBOutlet UIButton * num0;
@property(strong,nonatomic) IBOutlet UIButton * dot;
@property(strong,nonatomic) IBOutlet UIButton * del;

@property (strong,nonatomic) NSMutableString * contentSearch;
@property (strong,nonatomic) NSString * contentBack;
@property (nonatomic,assign) Boolean isFirstText;
@property (nonatomic,assign) Boolean isSecondText;

@property(strong,nonatomic) IBOutlet UILabel *   numLabel1;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel2;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel3;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel4;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel5;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel6;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel7;
@property(strong,nonatomic) IBOutlet UILabel *   numLabel8;

@property(strong,nonatomic) NSMutableArray * numLabelsArray;
@property(strong,nonatomic) NSMutableDictionary * carrierDictionary;
@property(strong,nonatomic) IBOutlet  SearchOtherView *   otherView;
@property(strong,nonatomic) NSMutableArray *resultArray;
@property(strong,nonatomic) NSMutableDictionary *tempData;
@property(strong,nonatomic) NSArray * companyArray;
@property (strong,nonatomic) QueryTraceUtil *queryTraceUtil;
@property (strong,nonatomic) QueryTraceUtil *weixinUtil;
@property (strong,nonatomic) QueryTraceUtil *candyUtil;
@property (strong,nonatomic) NSString *orderCode;
@property (nonatomic) BOOL isTraceSubscribed;
@property (nonatomic) BOOL isAlarmSubscribed;
@property (nonatomic,strong) IBOutlet UILabel *noteLabel;
@property (nonatomic,strong) IBOutlet UIView *separatedView;
@property (nonatomic,strong) IBOutlet UILabel *componyLabel;
@property (nonatomic,strong) UIImageView *guidImageView;
@property (nonatomic,strong) CustomAlertView *candyAlertView;

-(IBAction)doSearch:(id)sender;
-(IBAction)doKeyboardAction:(id)sender;
 

@end
