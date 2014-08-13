//
//  AppDelegate.m
//  CargoTrace
//
//  Created by efreight on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "SettingLeftSideBarViewController.h"
#import "CommonUtil.h"
#import "WaybillDetailViewController.h"
#import "SBJSON.h"
#import "CityEntity.h"
#import "DBUtil.h"
#import "WXApi.h"
#import "WeicomeViewController.h"

@implementation AppDelegate

@synthesize token = _token;
@synthesize navController = _navController;
@synthesize rootController = _rootController;
@synthesize leftController = _leftController;
@synthesize loginViewController = _loginViewController;
@synthesize menuController = _menuController;
@synthesize SinaWeiboOAuth = _SinaWeiboOAuth;
@synthesize QzoneOAuth = _QzoneOAuth;
@synthesize TCWeiboOAuth = _TCWeiboOAuth;
@synthesize permissions = _permissions;
@synthesize status = _status;
@synthesize qzoneMessage = _qzoneMessage;
@synthesize qqMessage = _qqMessage;
@synthesize isSendMessage = _isSendMessage;
@synthesize cookieArray = _cookieArray;
@synthesize getDepartQuery = _getDepartQuery;
@synthesize getDestQuery = _getDestQuery;
@synthesize awbCodeString = _awbCodeString;

+(AppDelegate*)ShareAppDelegate
{
    return (AppDelegate*)([UIApplication sharedApplication].delegate);
}

- (void)addHomeView
{
    if(IS_IPHONE_5)
    {
        self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }
    else
    {
        self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewControllerSmall" bundle:nil];
    }
    //self.viewController.title =  @"指尖货运" ;
    self.navController = [[UINavigationController alloc] init];
    [_navController pushViewController:self.viewController animated:YES];
    self.rootController = [[DDMenuController alloc] initWithRootViewController:_navController];
    
    // self.leftController = [[[LeftSideBarSettingViewController alloc] init]autorelease];
    if (IS_IPHONE_5)
    {
        self.leftController = [[SettingLeftSideBarViewController alloc] initWithNibName:@"SettingLeftSideBarViewController" bundle:nil];
    }
    else
    {
        self.leftController = [[SettingLeftSideBarViewController alloc] initWithNibName:@"SettingLeftSideBarViewControllerSmall" bundle:nil];
    }
    
    _rootController.leftViewController = self.leftController;
    self.menuController = _rootController;
    //[self.window addSubview: _navController.view];
    self.window.rootViewController =  self.rootController;
    
    //向微信注册
    [WXApi registerApp:@"wxc14ec9b417175b1a"];
    
    [self initWeiboEngine];
    [self initTCWeiboEngine];
    [self initQzone];
    [self getDepartPorts];
    [self getDestPorts];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedWeibo"])
    {
        [_SinaWeiboOAuth deleteAuthorizeDataInKeychain];
        [_TCWeiboOAuth deleteAuthorizeDataInKeychain];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedWeibo"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 注册推送通知功能, */
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [MobClick startWithAppkey:@"51e4a66d56240b2e620de758"];
    
    //判断程序是不是由推送服务完成的
    [self launchAppFromNotificationWithUserInfo:userInfo];
    
    [self addEventListeners];
    
    /////////
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self addHomeView];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground : %d", application.applicationState);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive : %d", application.applicationState);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - notification of system

- (void)launchAppFromNotificationWithUserInfo:(NSDictionary *)userInfo
{
     //NSLog(@"-----%@", NSStringFromSelector(_cmd));
    if(userInfo != nil)
    {
        NSLog(@"didReceiveRemoteNotification%@", userInfo);
        NSString *awbcode = [userInfo objectForKey:@"AWBCODE"];
        if (awbcode.length >= 12)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [awbcode substringToIndex:3], [[awbcode substringFromIndex:4] substringToIndex:8]];
            
            NSArray *existData = [self.cookieArray filteredArrayUsingPredicate:predicate];
            WaybillDetailViewController * vc = nil;
            if (IS_IPHONE_5)
            {
                vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewController" bundle:nil];
            }
            else
            {
                vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewControllerSmall" bundle:nil];
            }
            if ([existData count] != 0)
            {
                vc.data = [existData objectAtIndex:0];
            }
            vc.isNotification = YES;
            vc.waybillcode = awbcode;
            //        vc.cargocode = @"";
            UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
            [self.rootController presentModalViewController:navLoginController animated:YES];
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/** 接收从苹果服务器返回的唯一的设备token，然后发送给自己的服务端*/
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString *deviceTokens = [[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1, 71)];
    self.token = deviceTokens;
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"%@", error.localizedDescription);
}


- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
	
}

//程序处于启动状态，或者在后台运行时，会接收到推送消息，解析处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  //   NSLog(@"-----%@", NSStringFromSelector(_cmd));
    if (userInfo)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSMutableArray *orderArray = [[NSMutableArray alloc]initWithCapacity:40];
        if([manager fileExistsAtPath:LISTFILE(@"order.plist")])
        {
            orderArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"order.plist")];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ORDERID == %@)", [userInfo objectForKey:@"AWBCODE"]];
        NSArray *existData = [orderArray filteredArrayUsingPredicate:predicate];
        if ([existData count] > 0)
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *tmpDate = [NSDate date];
            NSString *dateStr = [formater stringFromDate:tmpDate];
            [existObject setObject:dateStr forKey:@"PUSHDATE"];
            [orderArray writeToFile:LISTFILE(@"order.plist") atomically:YES];
        }
    }
    
    NSLog(@"%d", application.applicationState);
    if (application.applicationState == 2 || application.applicationState == 1)
    {
        if (userInfo)
        {
            NSString *awbcode = [userInfo objectForKey:@"AWBCODE"];
            if (awbcode.length >= 12)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [awbcode substringToIndex:3], [[awbcode substringFromIndex:4] substringToIndex:8]];
                
                NSArray *existData = [self.cookieArray filteredArrayUsingPredicate:predicate];
                WaybillDetailViewController * vc = nil;
                if (IS_IPHONE_5)
                {
                    vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewController" bundle:nil];
                }
                else
                {
                    vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewControllerSmall" bundle:nil];
                }
                if ([existData count] != 0)
                {
                    vc.data = [existData objectAtIndex:0];
                }
                vc.isNotification = YES;
                vc.waybillcode = awbcode;
                //        vc.cargocode = @"";
                UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:vc];
                [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
                [self.rootController presentModalViewController:navLoginController animated:YES];
            }
        }
    }
    else
    {
        if (userInfo)
        {
            NSString *awbcode = [userInfo objectForKey:@"AWBCODE"];
            if (awbcode.length >= 12)
            {
                _awbCodeString = awbcode;
                [self initDataFromPlist];
                NSString *content = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                 CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:content andConfirmButton:@"确定"];
                alertView.tag = 1001;
                alertView.delegate = self;
                [alertView show];
            }
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark  -  初始化微博
- (void)initWeiboEngine
{
    //注册新浪网页端授权
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self.rootController];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://www.efreight.cn"];
    [engine setIsUserExclusive:NO];
    
    self.SinaWeiboOAuth = engine;
}

- (void)initTCWeiboEngine
{
    //注册腾讯微博授权
    TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:REDIRECTURI];
    [engine setRootViewController:self.rootController];
    self.TCWeiboOAuth = engine;
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
                        kOPEN_PERMISSION_ADD_ALBUM,
                        kOPEN_PERMISSION_ADD_IDOL,
                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                        kOPEN_PERMISSION_ADD_PIC_T,
                        kOPEN_PERMISSION_ADD_SHARE,
                        kOPEN_PERMISSION_ADD_TOPIC,
                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                        kOPEN_PERMISSION_DEL_IDOL,
                        kOPEN_PERMISSION_DEL_T,
                        kOPEN_PERMISSION_GET_FANSLIST,
                        kOPEN_PERMISSION_GET_IDOLLIST,
                        kOPEN_PERMISSION_GET_INFO,
                        kOPEN_PERMISSION_GET_OTHER_INFO,
                        kOPEN_PERMISSION_GET_REPOST_LIST,
                        kOPEN_PERMISSION_LIST_ALBUM,
                        kOPEN_PERMISSION_UPLOAD_PIC,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                        kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                        kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                        nil];
    }
}

#pragma mark  -  从文件中读数据，初始化
- (void)initDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"tracelist.plist")])
    {
        self.cookieArray = [[NSMutableArray alloc] init];
    }
    else
    {
        self.cookieArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
    }
}

#pragma mark - common sendtext method
- (void)sendText:(NSDictionary *)dic
{
    if (dic)
    {
        NSString *client = [dic objectForKey:@"client"];
        NSString *content = [dic objectForKey:@"content"];
        self.shortenUrl = [dic objectForKey:@"shortenurl"];
        
        if ([client isEqualToString:@"sinaWeibo"])
        {
            [MobClick event:@"点击新浪微博分享"];
            _isSendMessage = YES;
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享到新浪微博" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 101;
            [input show];
            return;
        }
        else if ([client isEqualToString:@"tencentQQ"])
        {
            [MobClick event:@"点击QQ分享"];
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享给QQ好友" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 102;
            [input show];
            return;
        }
        else if ([client isEqualToString:@"weChat"])
        {
            [MobClick event:@"点击微信分享"];
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享给微信好友" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 103;
            [input show];
            return;
        }
        else if ([client isEqualToString:@"tencentWeibo"])
        {
            [MobClick event:@"点击腾讯微博分享"];
            _isSendMessage = YES;
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享到腾讯微博" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 104;
            [input show];
            return;
        }
        else if ([client isEqualToString:@"Qzone"])
        {
            [MobClick event:@"点击QQ空间分享"];
            _isSendMessage = YES;
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享到QQ空间" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 105;
            [input show];
            return;
        }
        else if ([client isEqualToString:@"weChatCircle"])
        {
            [MobClick event:@"点击微信朋友圈分享"];
            CustomInputAlertView *input = [[CustomInputAlertView alloc] initWithTitle:@"分享到微信朋友圈" andConfirmButton:@"确定" andContent:content];
            input.delegate = self;
            input.tag = 106;
            [input show];
            return;
        }
    }
}

#pragma mark - CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (customAlertView.tag == 1001)
    {
        if (buttonIndex == 1)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [_awbCodeString substringToIndex:3], [[_awbCodeString substringFromIndex:4] substringToIndex:8]];
            
            NSArray *existData = [self.cookieArray filteredArrayUsingPredicate:predicate];
            WaybillDetailViewController * vc = nil;
            if (IS_IPHONE_5)
            {
                vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewController" bundle:nil];
            }
            else
            {
                vc = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewControllerSmall" bundle:nil];
            }
            if ([existData count] != 0)
            {
                vc.data = [existData objectAtIndex:0];
            }
            vc.isNotification = YES;
            vc.waybillcode = _awbCodeString;
            //        vc.cargocode = @"";
            UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
            [self.rootController presentModalViewController:navLoginController animated:YES];
        }
    }
}

#pragma mark - CustomInputAlertViewDelegate
- (void)customInputAlertView:(CustomInputAlertView *)customInputAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (customInputAlertView.tag == 101)
        {
            [self sendWeibo:customInputAlertView.contentTextView.text];
        }
        else if (customInputAlertView.tag == 102)
        {
            [self QQSendMessage:customInputAlertView.contentTextView.text];
        }
        else if (customInputAlertView.tag == 103)
        {
            [self sendTextContent:customInputAlertView.contentTextView.text type:0];
        }
        else if (customInputAlertView.tag == 104)
        {
            [self TCWeiboSendMessage:customInputAlertView.contentTextView.text];
        }
        else if (customInputAlertView.tag == 105)
        {
            [self QzoneSendText:customInputAlertView.contentTextView.text];
        }
        else if (customInputAlertView.tag == 106)
        {
            [self sendTextContent:customInputAlertView.contentTextView.text type:1];
        }
    }
}

#pragma mark - handleOpenURL and openURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.mqq"])
    {
        if ([[[url absoluteString] substringToIndex:2] isEqualToString:@"QQ"])
        {
            return [QQApiInterface handleOpenURL:url delegate:self];
        }
        return  [TencentOAuth HandleOpenURL:url];
    }
    return  [TencentOAuth HandleOpenURL:url];
}

#pragma mark - WXApiDelegate 微信相关函数
- (void)onReq:(id)req
{
    if ([req isKindOfClass:[BaseReq class]])
    {
        
    }
    else if ([req isKindOfClass:[QQBaseReq class]])
    {
        
    }
}

- (void)onResp:(id)resp
{
    if ([resp isKindOfClass:[BaseResp class]])
    {
        
    }
    else if ([resp isKindOfClass:[QQBaseResp class]])
    {
        
    }
}

- (void)sendTextContent:(NSString*)nsText type:(NSInteger)type
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    if (type == 0)
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"指尖货运";
        message.description = nsText;
        [message setThumbImage:[UIImage imageNamed:@"e_dimensional_code.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = self.shortenUrl;
        
        message.mediaObject = ext;
        
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
    }
    else
    {
        req.text = nsText;
        req.bText = YES;
        req.scene = WXSceneTimeline;
    }
    
    [WXApi sendReq:req];
}

#pragma mark - WBEngineDelegate Methods - 新浪微博相关函数
- (void)sendWeibo:(NSString *)status
{
    [self initWeiboEngine];
    
    _status = status;
    if ([_SinaWeiboOAuth isLoggedIn])
    {
        [_SinaWeiboOAuth sendWeiBoWithText:_status image:[UIImage imageNamed:@"e_dimensional_code.png"]];
        _isSendMessage = NO;
    }
    else
    {
        [_SinaWeiboOAuth logIn];
    }
}

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    if (_isSendMessage)
    {
        [_SinaWeiboOAuth sendWeiBoWithText:_status image:nil];
        _isSendMessage = NO;
    }
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    [engine logIn];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    if (error.userInfo) {
        if ([error.userInfo intForKey:@"error_code"] == 20019)
        {
            
        }
    }
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
	{
        NSString *str = @"新浪微博分享失败，请重试！";
        if (_NULL_JUDGE_([result objectForKey:@"id"])) {
            str = @"新浪微博分享成功！";
        }
        
        [MobClick event:str];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:str andConfirmButton:@""];
        [alertView show];
	}
}

#pragma mark - QzoneDetegate Methods - QQ空间相关方法
- (void)QzoneSendText:(NSString *)text
{
    [self initQzone];
    
    _qzoneMessage = text;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"login.plist")])
    {
        [_QzoneOAuth authorize:_permissions inSafari:YES];
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
            [self QzoneAddShare:text];
            _isSendMessage = NO;
        }
        else
        {
            [_QzoneOAuth authorize:_permissions inSafari:YES];
        }
    }
}

- (void)QzoneAddShare:(NSString *)text
{
    TCAddShareDic *params = [TCAddShareDic dictionary];
    params.paramTitle = @"指尖货运";
    //params.paramComment = text;
    params.paramSummary = text;
    params.paramImages = @"http://img0.ph.126.net/HKZ1Gg7H8k_vL81r_rvcmQ==/1873497445086270291.png";
    params.paramUrl = self.shortenUrl;
	
	if(![_QzoneOAuth addShareWithParams:params])
    {
        [MobClick event:@"QQ空间分享成功"];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"QQ空间分享失败" andConfirmButton:@""];
        [alertView show];
    }
    else
    {
        [MobClick event:@"QQ空间分享失败"];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"QQ空间分享成功" andConfirmButton:@""];
        [alertView show];
    }
}

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin
{
    if (_isSendMessage)
    {
        NSString *tmpStr = @"";
        // 登录成功
        if (_QzoneOAuth.accessToken && 0 != [_QzoneOAuth.accessToken length])
        {
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
                tencentDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_QzoneOAuth.accessToken, _QzoneOAuth.openId, _QzoneOAuth.expirationDate,nil] forKeys:[NSArray arrayWithObjects:@"tencentAccessToken", @"tencentOpenId", @"tencentExpirationDate",nil]];
            }
            [tencentDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
        }
        else
        {
            tmpStr = @"登录不成功 没有获取accesstoken";
        }
        
        [self QzoneAddShare:_qzoneMessage];
    }
    else
    {
        NSString *tmpStr = @"";
        // 登录成功
        if (_QzoneOAuth.accessToken && 0 != [_QzoneOAuth.accessToken length])
        {
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
                tencentDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_QzoneOAuth.accessToken, _QzoneOAuth.openId, _QzoneOAuth.expirationDate,nil] forKeys:[NSArray arrayWithObjects:@"tencentAccessToken", @"tencentOpenId", @"tencentExpirationDate",nil]];
            }
            [tencentDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
        }
        else
        {
            tmpStr = @"登录不成功 没有获取accesstoken";
        }
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

/**
 * Called when the logout.
 */
-(void)tencentDidLogout
{
    
}

#pragma mark - QQApiInterfaceDelegate - QQ相关方法
- (void)QQSendMessage:(NSString *)message
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"e_dimensional_code.png"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
	NSURL* url = [NSURL URLWithString:self.shortenUrl];
	
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:@"指尖货运" description:message previewImageData:data];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [MobClick event:@"QQ分享失败"];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [MobClick event:@"QQ分享失败"];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [MobClick event:@"QQ分享失败"];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [MobClick event:@"QQ分享失败"];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [MobClick event:@"QQ分享失败"];
            break;
        }
        default:
        {
            [MobClick event:@"QQ分享成功"];
            break;
        }
    }
}

#pragma mark - TCWeiboDelegate - 腾讯微博相关方法
//腾讯微博发送消息
- (void)TCWeiboSendMessage:(NSString *)message
{
    [self initTCWeiboEngine];
    
    _qqMessage = message;
    if ([_TCWeiboOAuth isLoggedIn] && ![_TCWeiboOAuth isAuthorizeExpired])
    {
        NSMutableDictionary *dicAppFrom = [NSMutableDictionary dictionaryWithObject:@"ios-sdk-2.0-publish" forKey:@"appfrom"];
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"e_dimensional_code.png"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        
        [self.TCWeiboOAuth postPictureTweetWithFormat:@"json"
                                              content:message
                                             clientIP:nil
                                                  pic:data
                                       compatibleFlag:nil
                                            longitude:@""
                                          andLatitude:@""
                                          parReserved:dicAppFrom
                                             delegate:self
                                            onSuccess:@selector(successCallback)
                                            onFailure:@selector(failureCallback)];
        _isSendMessage = NO;
    }
    else
    {
        [self onLogin];
    }
}

//点击登录按钮
- (void)onLogin
{
    [_TCWeiboOAuth logInWithDelegate:self
                           onSuccess:@selector(onSuccessLogin)
                           onFailure:@selector(onFailureLogin:)];
}

- (void)onLogout
{
    // 注销授权
    [_TCWeiboOAuth logOut];
}

//登录成功回调
- (void)onSuccessLogin
{
    if (_isSendMessage)
    {
        [self TCWeiboSendMessage:_qqMessage];
        _isSendMessage = NO;
    }
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{

}

//分享成功回调
- (void)successCallback
{
    [MobClick event:@"腾讯微博分享成功"];
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"腾讯微博分享成功" andConfirmButton:@""];
    [alertView show];
}

- (void)failureCallback
{
    [MobClick event:@"腾讯微博分享失败"];
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"腾讯微博分享失败" andConfirmButton:@""];
    [alertView show];
}

-(void)onLoginFailed:(WBErrCode)errCode msg:(NSString*)msg
{
    
}

-(void)onLoginSuccessed:(NSString*)name token:(WBToken*)token
{
    
}

//获取TACT始发港
- (void)getDepartPorts
{
    if (_getDepartQuery)
    {
        [_getDepartQuery StopFunction];
        _getDepartQuery = nil;
    }
    
    _getDepartQuery = [[QueryTraceUtil alloc] init];
    _getDepartQuery.delegate = self;
    
    //发送异步请求
    [_getDepartQuery GetPublicKey:@"http://m.eft.cn/data/dep.json"];
}
//获取TACT目的港
- (void)getDestPorts
{
    if (_getDestQuery)
    {
        [_getDestQuery StopFunction];
        _getDestQuery = nil;
    }
    
    _getDestQuery = [[QueryTraceUtil alloc] init];
    _getDestQuery.delegate = self;
    
    //发送异步请求
    [_getDestQuery GetPublicKey:@"http://m.eft.cn/data/ap.json"];
}

#pragma mark - QueryTraceUtilDelegate Methods
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    
    if (util == _getDepartQuery)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            //要执行的比较耗时的操作
            SBJSON *jsonParser = [[SBJSON alloc] init];
            NSError *parseError = nil;
            NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
            for (id key in tmpDic)
            {
                CityEntity *city = [[CityEntity alloc] init];
                city.threeCode = key;
                city.ch_name = [tmpDic objectForKey:key];
                [[DBUtil SharedDBEngine].departCityArray addObject:city];
            }
            [[DBUtil SharedDBEngine] insertDepartData];
            if (data != nil) {
                //返回主线程刷新界
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            
        });
    }
    else if (util == _getDestQuery)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            //要执行的比较耗时的操作
            SBJSON *jsonParser = [[SBJSON alloc] init];
            NSError *parseError = nil;
            NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
            for (id key in tmpDic)
            {
                CityEntity *city = [[CityEntity alloc] init];
                city.threeCode = key;
                city.ch_name = [tmpDic objectForKey:key];
                [[DBUtil SharedDBEngine].destCityArray addObject:city];
            }
            [[DBUtil SharedDBEngine] insertDestData];
            if (data != nil) {
                //返回主线程刷新界
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            
        });
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    
}

#pragma mark - NSNotificationCenter

- (void)addEventListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealReceiveEvent)
                                                 name:@"welcome"
                                               object:nil];
}

- (void)removeEventListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"welcome" object:nil];
}

- (void)dealReceiveEvent
{
    [self addHomeView];
}

@end
