//
//  LoginViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "WBEngine.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate, QueryTraceUtilDelegate, CustomAlertViewDelegate, WBEngineDelegate, TencentSessionDelegate, TencentLoginDelegate>
@property(nonatomic,strong) IBOutlet UITextField *email;
@property(nonatomic,strong) IBOutlet UITextField *password;
@property(nonatomic,strong) IBOutlet UIImageView *userImageView;
@property(nonatomic,strong) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong) IBOutlet UIButton *registerBtn;
@property(nonatomic,strong) IBOutlet UIButton *forgetPassword;
@property(nonatomic,strong) RegisterViewController *registerViewController;
@property(nonatomic,strong) QueryTraceUtil *queryTraceUtil;
@property(nonatomic,strong) QueryTraceUtil *findPasswordQueryTraceUtil;
@property(nonatomic,strong) QueryTraceUtil *getKeyQueryTraceUtil;
@property(nonatomic,strong) QueryTraceUtil *registerQueryTraceUtil;
@property(nonatomic,strong) QueryTraceUtil *bindingQueryTraceUtil;
@property(nonatomic, strong) QueryTraceUtil *bindingUserUtil;
@property(nonatomic,strong) NSString *publicKey;
@property(nonatomic,strong) NSString *exponent;
@property(nonatomic,strong) NSString *socialityName;
@property(nonatomic,strong) NSString *userName;
@property (strong, nonatomic) WBEngine *SinaWeiboOAuth;
@property (strong, nonatomic) TencentOAuth *QzoneOAuth;
@property (strong, nonatomic) NSMutableArray *permissions;

-(IBAction)doLogin:(id)sender;
-(IBAction)doRegister:(id)sender;
-(IBAction)forgetPassword:(id)sender;
//-(IBAction)shareWeixin:(id)sender;
-(IBAction)loginBySinaWeibo:(id)sender;
-(IBAction)loginByQQ:(id)sender;
//-(IBAction)doCancel:(id)sender;

//+ (LoginViewController*)sharedInstance;

@end
