//
//  SettingLeftSideBarViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-9.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface SettingLeftSideBarViewController : UIViewController<UIAlertViewDelegate, QueryTraceUtilDelegate, CustomAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *contentArray;
@property (strong,nonatomic) IBOutlet UIImageView * userImage;
@property (strong,nonatomic) IBOutlet UILabel * usernameLabel;
//@property (strong,nonatomic) IBOutlet UILabel * titleLabel;
//@property (strong,nonatomic) IBOutlet UILabel * warningLabel;
@property (strong,nonatomic) IBOutlet UILabel * label0;
@property (strong,nonatomic) IBOutlet UILabel * label1;
@property (strong,nonatomic) IBOutlet UILabel * label2;
@property (strong,nonatomic) IBOutlet UILabel * label3;
@property (strong,nonatomic) IBOutlet UILabel * label4;
@property (strong,nonatomic) IBOutlet UILabel * label5;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (nonatomic) BOOL isOpenWarning;
@property (nonatomic) BOOL isLogin;
@property (strong,nonatomic) QueryTraceUtil *queryTraceUtil;
@property (strong,nonatomic) QueryTraceUtil *weixinUtil;
@property (strong,nonatomic) QueryTraceUtil *updateUtil;
@property (strong,nonatomic) QueryTraceUtil *disQueryTraceUtil;
@property(nonatomic, strong) QueryTraceUtil *unBindingUserUtil;
@property (nonatomic) NSInteger userCount;
 
-(IBAction)doAction:(id)sender;
@end
