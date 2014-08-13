//
//  AppDelegate.h
//  CargoTrace
//
//  Created by efreight on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WBEngine.h"
#import "TCWBEngine.h"
#import "WBApi.h"
#import "CustomInputAlertView.h"
#import "QueryTraceUtil.h"
#import "CustomAlertView.h"

@class ViewController;
@class LoginViewController;
@class HomeViewController;
@class DDMenuController;
@class SettingLeftSideBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, WXApiDelegate, WBEngineDelegate, TencentSessionDelegate, TencentLoginDelegate, QQApiInterfaceDelegate, CustomInputAlertViewDelegate, CustomAlertViewDelegate, QueryTraceUtilDelegate>
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UINavigationController  *navController;
@property (strong, nonatomic) DDMenuController *rootController;
@property (strong, nonatomic) SettingLeftSideBarViewController *leftController;

@property (strong, nonatomic) LoginViewController  *loginViewController;
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) WBEngine *SinaWeiboOAuth;
@property (strong, nonatomic) TencentOAuth *QzoneOAuth;
@property (strong, nonatomic) TCWBEngine *TCWeiboOAuth;
@property (strong, nonatomic) NSMutableArray *permissions;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *qzoneMessage;
@property (strong, nonatomic) NSString *qqMessage;
@property (nonatomic) BOOL isSendMessage;
@property (nonatomic, strong) NSMutableArray *cookieArray;
@property (nonatomic, strong) NSString *shortenUrl;
@property (nonatomic, strong) QueryTraceUtil *getDepartQuery;
@property (nonatomic, strong) QueryTraceUtil *getDestQuery;
@property (nonatomic, copy) NSString *awbCodeString;

+(AppDelegate*)ShareAppDelegate;
- (void)sendText:(NSDictionary *)dic;
- (void)sendWeibo:(NSString *)status;
@end
