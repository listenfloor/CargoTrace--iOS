//
//  LoginViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CommonUtil.h"
#import "GDataXMLNode.h"
#import "RSA.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize email = _email;
@synthesize password = _password;
@synthesize registerViewController = _registerViewController;
@synthesize userImageView = _userImageView;
@synthesize loginBtn = _loginBtn;
@synthesize registerBtn = _registerBtn;
@synthesize forgetPassword = _forgetPassword;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize findPasswordQueryTraceUtil = _findPasswordQueryTraceUtil;
@synthesize getKeyQueryTraceUtil = _getKeyQueryTraceUtil;
@synthesize registerQueryTraceUtil = _registerQueryTraceUtil;
@synthesize bindingUserUtil = _bindingUserUtil;
@synthesize publicKey = _publicKey;
@synthesize exponent = _exponent;
@synthesize socialityName = _socialityName;
@synthesize userName = _userName;
@synthesize SinaWeiboOAuth = _SinaWeiboOAuth;
@synthesize QzoneOAuth = _QzoneOAuth;
@synthesize permissions = _permissions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"用户登录"];
    [self setNavbar];
    
    self.password.delegate = self;
    [self.password setSecureTextEntry:YES];
    self.email.delegate = self;
    [self.view setBackgroundColor:[CommonUtil colorWithHexString:@"#eeeeec"]];
    [self.loginBtn setBackgroundColor:[CommonUtil colorWithHexString:@"#55a6e0"]];
    
    //[CommonUtil setImageRound:self.userImageView image:[UIImage imageNamed:@"headicon.png"] cornerRadius:48.0 borderWidth:3.0];
    [self getPublicKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  初始化微博
- (void)initWeiboEngine
{
    //注册新浪网页端授权
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://www.efreight.cn"];
    [engine setIsUserExclusive:NO];
    
    _SinaWeiboOAuth = engine;
}

- (void)initQzone
{
    //注册QQ空间授权
    if (_QzoneOAuth == nil)
    {
        _QzoneOAuth = [[TencentOAuth alloc] initWithAppId:@"100462165"
                                              andDelegate:self];
        
        //_QzoneOAuth.redirectURI = @"www.eft.cn";
        _permissions = [NSMutableArray arrayWithObjects:
                        kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        nil];
    }
}

- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//#pragma mark -  single model
//
//+ (LoginViewController*)sharedInstance{
//    @synchronized(self){
//        if (sharedLoginController == nil)
//            sharedLoginController =  [[self alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    }
//    return sharedLoginController;
//    
//}

#pragma mark - login & register  and others button actions
- (void)getPublicKey
{
    if (_getKeyQueryTraceUtil)
    {
        [_getKeyQueryTraceUtil StopFunction];
        _getKeyQueryTraceUtil = nil;
    }
    
    _getKeyQueryTraceUtil = [[QueryTraceUtil alloc] init];
    _getKeyQueryTraceUtil.delegate = self;
    
    //发送异步请求
    [_getKeyQueryTraceUtil GetPublicKey:[NSString stringWithFormat:@"%@?%@", @"http://emall.efreight.cn/eFreightHttpEngine", @"getKey=true"]];
}

- (IBAction)doLogin:(id)sender
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    
    if (!self.email.text || [self.email.text isEqualToString:@""])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"邮箱不可为空!" andConfirmButton:@""];
        alertView.delegate = self;
        [alertView show];
        return;
    }
    
    if (!self.password.text || [self.password.text isEqualToString:@""])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"密码不可为空!" andConfirmButton:@""];
        alertView.delegate = self;
        [alertView show];
        return;
    }
    
    [self loginWithUsername:self.email.text andPassword:self.password.text];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
    //.2f表示精确到小数点后两位
    NSString *postString = [NSString stringWithFormat:
                            @"<eFreightService>"
                            @"<ServiceURL>eFreightUser</ServiceURL>"
                            @"<ServiceAction>login</ServiceAction>"
                            @"<ServiceData>"
                            @"<eFreightUser>"
                            @"<username>%@</username>"
                            @"<password>%@</password>"
                            @"</eFreightUser>"
                            @"</ServiceData>"
                            @"</eFreightService>"
                            , username
                            , password];
    
    NSMutableString *encodeString = (NSMutableString *)[postString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [encodeString replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, encodeString.length)];
    [encodeString replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, encodeString.length)];
    NSLog(@"%@", encodeString);
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RSA *rsa = [[RSA alloc] init];
        if (_exponent && ![_exponent isEqualToString:@""] && _publicKey && ![_publicKey isEqualToString:@""])
        {
            [rsa RSAKeyPair:_exponent and:_exponent and:_publicKey];
        }
        
        NSString *rsaString = [rsa encryptedString:rsa and:encodeString];
        if (rsaString != nil && ![rsaString isEqualToString:@""])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //发送异步请求
                [_queryTraceUtil Login:rsaString withURL:URL_LOGIN];
            });
        }
    });
}

-(IBAction)loginBySinaWeibo:(id)sender
{
    if (!_SinaWeiboOAuth)
    {
        [self initWeiboEngine];
    }
    
    if ([_SinaWeiboOAuth isLoggedIn])
    {
        [_SinaWeiboOAuth getUserInfo];
    }
    else
    {
        [_SinaWeiboOAuth logIn];
    }
}

-(IBAction)loginByQQ:(id)sender
{
    if (!_QzoneOAuth)
    {
        [self initQzone];
    }
    
    if ([self isQzoneLogin])
    {
        [_QzoneOAuth getUserInfo];
    }
    else
    {
        [_QzoneOAuth authorize:_permissions inSafari:YES];
    }
}

- (IBAction)doRegister:(id)sender
{
    [MobClick event:@"进入注册页面"];
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    if (IS_IPHONE_5)
    {
        self.registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    }
    else
    {
        self.registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewControllerSmall" bundle:nil];
    }
    [self.navigationController pushViewController:self.registerViewController animated:YES];
}

#pragma mark  -  提交 注册
- (void)registerWithSociality:(NSString *)userid
{
    if (_registerQueryTraceUtil)
    {
        [_registerQueryTraceUtil StopFunction];
        _registerQueryTraceUtil = nil;
    }
    
    _registerQueryTraceUtil = [[QueryTraceUtil alloc] init];
    _registerQueryTraceUtil.delegate = self;
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    _userName = userid;
    
    //.2f表示精确到小数点后两位
    NSString *postString = [NSString stringWithFormat:@"<eFreightService>"
                            @"<ServiceURL>eFreightUser</ServiceURL>"
                            @"<ServiceAction>register</ServiceAction>"
                            @"<ServiceData>"
                            @"<eFreightUser>"
                            @"<username>%@</username>"
                            @"<password>%@</password>"
                            @"<name>%@</name>"
                            @"<companyname></companyname>"
                            @"<telephone></telephone>"
                            @"<mobile></mobile>"
                            @"<email></email>"
                            @"<title></title>"
                            @"<address></address>"
                            @"<org_id>0</org_id>"
                            @"<handler></handler>"
                            @"<createtime></createtime>"
                            @"<modifytime></modifytime>"
                            @"<confirmemailurl>http://emall.efreight.cn/services/account/registration.confirm.html</confirmemailurl>"
                            @"</eFreightUser>"
                            @"</ServiceData>"
                            @"</eFreightService>"
                            , userid
                            , userid
                            , _socialityName];
    
    //发送异步请求
    [_registerQueryTraceUtil PostForASync:postString withURL:URL_LOGIN];
}

- (IBAction)forgetPassword:(id)sender
{
    if (!self.email.text || [self.email.text isEqualToString:@""])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"邮箱不可为空!" andConfirmButton:@""];
        alertView.delegate = self;
        [alertView show];
        return;
    }
    
    if (![self isValidateEmail:self.email.text])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您输入的邮箱格式不正确，请重新输入！" andConfirmButton:@""];
        alertView.delegate = self;
        [alertView show];
        return;
    }
    
    if (_findPasswordQueryTraceUtil)
    {
        [_findPasswordQueryTraceUtil StopFunction];
        _findPasswordQueryTraceUtil = nil;
    }
    
    _findPasswordQueryTraceUtil = [[QueryTraceUtil alloc] init];
    _findPasswordQueryTraceUtil.delegate = self;
    
    //.2f表示精确到小数点后两位
    NSString *postString = [NSString stringWithFormat:
                            @"<eFreightService>"
                            @"<ServiceURL>eFreightUser</ServiceURL>"
                            @"<ServiceAction>FindPassword</ServiceAction>"
                            @"<ServiceData>"
                            @"<eFreightUser>"
                            @"<username>%@</username>"
                            @"<confirmemailurl>http://emall.efreight.cn/services/account/findpasswd.html</confirmemailurl>"
                            @"</eFreightUser>"
                            @"</ServiceData>"
                            @"</eFreightService>"
                            , self.email.text];
    
    //发送异步请求
    [_findPasswordQueryTraceUtil PostForASync:postString withURL:URL_LOGIN];
}

#pragma mark CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark  -  导航栏 设置
- (void)setNavbar
{
    self.navigationController.title = nil;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UIButton *rodoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    //[rodoButton setBackgroundImage:[UIImage imageNamed:@"redobg.png"] forState:UIControlStateSelected];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
}

- (void)goback
{
    if (_getKeyQueryTraceUtil)
    {
        [_getKeyQueryTraceUtil StopFunction];
        _getKeyQueryTraceUtil = nil;
    }
    
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    [MobClick event:@"从登录页面返回侧边栏"];
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    [self dismissModalViewControllerAnimated:YES];
}

//- (IBAction)shareWeixin:(id)sender
//{
//    NSLog(@" ---- %@",NSStringFromSelector(_cmd));
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (IBAction)shareSinaWeibo:(id)sender
//{
//    NSLog(@" ---- %@",NSStringFromSelector(_cmd));
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (IBAction)shareQQ:(id)sender
//{
//    NSLog(@" ---- %@",NSStringFromSelector(_cmd));
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (IBAction)doCancel:(id)sender
//{
//    NSLog(@" ---- %@",NSStringFromSelector(_cmd));
//    [self dismissModalViewControllerAnimated:YES];
//    
//}

#pragma mark  - 点击 屏幕 关闭 键盘
- (IBAction)backgroundTap:(id)sender
{
    //NSLog(@"backgroundTap");
    
    UIView *tempview  = self.view;
    
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, tempview.frame.size.width, tempview.frame.size.height);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        rect = CGRectMake(0.0f, 64.0f, tempview.frame.size.width, tempview.frame.size.height);
    }
    tempview.frame = rect;
    
    [UIView commitAnimations];
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView *tempview  = self.view;
    
    //NSLog(@"textFieldDidBeginEditing");
    CGRect frame = self.password.frame;
    int offset = frame.origin.y + 32 - (tempview.frame.size.height - 230.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = tempview.frame.size.width;
    float height = tempview.frame.size.height;
    
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset, width, height);
        tempview.frame = rect;
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.email)
    {
        [self.password becomeFirstResponder];
    }
    else if (textField == self.password)
    {
        [self backgroundTap:nil];
        [self doLogin:self];
    }
    
    return YES;
}

#pragma mark - QueryTraceUtilDelegate Methods
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    if (util == _getKeyQueryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        _publicKey = [QueryTraceUtil getElementString:[doc nodesForXPath:@"//module" error:nil]];
        _exponent = [QueryTraceUtil getElementString:[doc nodesForXPath:@"//exponent" error:nil]];
    }
    else if (util == _queryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        if (err)
        {
            
        }
        else
        {
            NSInteger resultCode = [[QueryTraceUtil getElementString:[doc nodesForXPath:@"//ResultCode" error:nil]] intValue];
            NSString *username = [QueryTraceUtil getElementString:[doc nodesForXPath:@"//username" error:nil]];
            if (resultCode == 1)
            {
                [MobClick event:@"用户登录成功"];
                [SVProgressHUD dismissWithSuccess:@"登录成功"];
                [self bindingUser:username];
                NSFileManager *manager = [NSFileManager defaultManager];
                NSMutableDictionary *loginDic = nil;
                if([manager fileExistsAtPath:LISTFILE(@"login.plist")])
                {
                    loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
                    if (!loginDic)
                    {
                        loginDic = [[NSMutableDictionary alloc] init];
                    }
                    
                    [loginDic setObject:username forKey:@"username"];
                    [loginDic setObject:username forKey:@"nikename"];
                }
                else
                {
                    loginDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:username, @"username", username, @"nikename", nil];
                }
                [loginDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
                
                NSMutableDictionary *info= [[NSMutableDictionary alloc] init];
                [info setObject:LOGIN_SUCESS forKey:@"login"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLogin" object:nil userInfo:info];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                [MobClick event:@"用户登录失败"];
                [SVProgressHUD dismissWithError:@"登录失败"];
            }
        }
    }
    else if (util == _findPasswordQueryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        NSInteger resultCode = [[QueryTraceUtil getElementString:[doc nodesForXPath:@"//ResultCode" error:nil]] intValue];
        if (resultCode == 1)
        {
            [MobClick event:@"找回密码"];
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"找回密码的链接已经发送到您的邮箱，请您注意查收!" andConfirmButton:@""];
            alertView.delegate = self;
            [alertView show];
        }
        else
        {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"找回密码失败" andConfirmButton:@""];
            alertView.delegate = self;
            [alertView show];
        }
    }
    else if (util == _registerQueryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        NSInteger resultCode = [[QueryTraceUtil getElementString:[doc nodesForXPath:@"//ResultCode" error:nil]] intValue];
        if (resultCode == 1 || resultCode == -301)
        {
            [SVProgressHUD dismissWithSuccess:@"登录成功"];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSMutableDictionary *loginDic = nil;
            if([manager fileExistsAtPath:LISTFILE(@"login.plist")])
            {
                loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
                if (!loginDic)
                {
                    loginDic = [[NSMutableDictionary alloc] init];
                }
                
                [loginDic setObject:_userName forKey:@"username"];
                [loginDic setObject:_socialityName forKey:@"nikename"];
            }
            else
            {
                loginDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_socialityName, @"nikename", _userName, @"username", nil];
            }
            [loginDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
            
            NSMutableDictionary *info= [[NSMutableDictionary alloc] init];
            [info setObject:LOGIN_SUCESS forKey:@"login"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLogin" object:nil userInfo:info];
            [self dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD dismissWithError:@"登录失败"];
        }
    }
    else if (util == _bindingUserUtil)
    {
        
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        [SVProgressHUD dismissWithError:@"登录失败"];
    }
}

#pragma mark - WBEngineDelegate Methods - 新浪微博相关函数
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    [_SinaWeiboOAuth getUserInfo];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSDictionary *tmpDic = (NSDictionary *)result;
    
    if ([engine.request.url rangeOfString:@"users/show.json"].location != NSNotFound)
    {
        [MobClick event:@"新浪微博登录成功"];
        NSString *username = [tmpDic stringForKey:@"screen_name"];
        NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
        [tmpDic setObject:username forKey:@"sinausername"];
        [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
        
        _socialityName = username;
        
        [self registerWithSociality:[NSString stringWithFormat:@"sina_%@", engine.userID]];
    }
}

#pragma mark - QzoneDetegate Methods - QQ空间相关方法
- (BOOL)isQzoneLogin
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"login.plist")])
    {
        return NO;
    }
    else
    {
        NSDictionary *tencentDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
        NSString *accessToken = [tencentDic objectForKey:@"tencentAccessToken"];
        NSString *openId = [tencentDic objectForKey:@"tencentOpenId"];
        NSDate *expirationDate = [tencentDic objectForKey:@"tencentExpirationDate"];
        if (accessToken && ![accessToken isEqualToString:@""])
        {
            [_QzoneOAuth setAccessToken:accessToken];
            [_QzoneOAuth setOpenId:openId];
            [_QzoneOAuth setExpirationDate:expirationDate];
            return YES;
        }
    }
    return NO;
}
/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin
{
    NSString *tmpStr = @"";
    // 登录成功
    if (_QzoneOAuth.accessToken && 0 != [_QzoneOAuth.accessToken length])
    {
        [MobClick event:@"QQ登录成功"];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSMutableDictionary *tencentDic = nil;
        if(![manager fileExistsAtPath:LISTFILE(@"login.plist")])
        {
            tencentDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
            if (!tencentDic)
            {
                tencentDic = [[NSMutableDictionary alloc] init];
            }
            
            [tencentDic setObject:_QzoneOAuth.accessToken forKey:@"tencentAccessToken"];
            [tencentDic setObject:_QzoneOAuth.openId forKey:@"tencentOpenId"];
            [tencentDic setObject:_QzoneOAuth.expirationDate forKey:@"tencentExpirationDate"];
        }
        else
        {
            tencentDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_QzoneOAuth.accessToken, _QzoneOAuth.openId, _QzoneOAuth.expirationDate,nil]
                                                     forKeys:[NSArray arrayWithObjects:@"tencentAccessToken", @"tencentOpenId", @"tencentExpirationDate",nil]];
        }
        [tencentDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
        
        [_QzoneOAuth getUserInfo];
    }
    else
    {
        tmpStr = @"登录不成功 没有获取accesstoken";
    }
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
	
}

- (void)getUserInfoResponse:(APIResponse *)response
{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
        NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
        [tmpDic setObject:[response.jsonResponse objectForKey:@"nickname"] forKey:@"qzoneusername"];
        [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
        
        _socialityName = [response.jsonResponse objectForKey:@"nickname"];
        
        [self registerWithSociality:[NSString stringWithFormat:@"qq_%@", _QzoneOAuth.openId]];
	}
}

#pragma mark ------绑定------------
- (void)bindingUser:(NSString *)username
{
    if (_bindingUserUtil)
    {
        [_bindingUserUtil StopFunction];
        _bindingUserUtil = nil;
    }
    
    _bindingUserUtil = [[QueryTraceUtil alloc] init];
    _bindingUserUtil.delegate = self;
    NSString *postString = [NSString stringWithFormat:@"{\"eFreightService\":{\"ServiceURL\":\"LinkedAccount\",\"ExportType\":\"JSON\",\"ServiceData\":{\"LinkedAccount\":{\"linkedaccounttype\":\"IOS\",\"username\":\"%@\",\"linkedaccountid\":\"%@\",\"operatetime\":\"sysdate\"}},\"ServiceAction\":\"TRANSACTION\"}}", username, [AppDelegate ShareAppDelegate].token];
    
    [_bindingUserUtil binding:postString withURL:URL_LOGIN];
}

@end
