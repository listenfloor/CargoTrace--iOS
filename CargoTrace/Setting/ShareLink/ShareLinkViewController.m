//
//  ShareLinkViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-5-21.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "ShareLinkViewController.h"

@interface ShareLinkViewController ()

@end

@implementation ShareLinkViewController
@synthesize mSinaWeiboBtn = _mSinaWeiboBtn;
@synthesize mTencentWeiboBtn = _mTencentWeiboBtn;
@synthesize mQzoneBtn = _mQzoneBtn;
@synthesize mSinaWeiboLabel = _mSinaWeiboLabel;
@synthesize mTencentWeiboLabel = _mTencentWeiboLabel;
@synthesize mQzoneLabel = _mQzoneLabel;
@synthesize SinaWeiboOAuth = _SinaWeiboOAuth;
@synthesize QzoneOAuth = _QzoneOAuth;
@synthesize permissions = _permissions;
@synthesize TCWeiboOAuth = _TCWeiboOAuth;

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
    //注册新浪网页端授权
    if (_SinaWeiboOAuth == nil)
    {
        WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://www.efreight.cn"];
        [engine setIsUserExclusive:NO];
        
        self.SinaWeiboOAuth = engine;
    }
    
    //注册QQ空间授权
    if (_QzoneOAuth == nil)
    {
        _QzoneOAuth = [[TencentOAuth alloc] initWithAppId:@"100462165"
                                              andDelegate:self];
        
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
    
    //注册腾讯微博授权
    if (_TCWeiboOAuth == nil)
    {
        TCWBEngine *engine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:REDIRECTURI];
        [engine setRootViewController:self];
        self.TCWeiboOAuth = engine;
    }
    
    [self.view setBackgroundColor:[CommonUtil colorWithHexString:@"#eeeeec"]];
    [self setTitle:@"社交网络"];
    [self setNavbar];
    [self setSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  导航栏 设置
- (void)setNavbar
{
    self.navigationController.title = nil;
    [self.navigationController.navigationBar setBarStyle: UIBarStyleBlack];
    
    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
}

#pragma mark  -  子视图 设置
- (void)setSubViews
{
    UIImageView *sinaWeiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    sinaWeiboImageView.image = [CommonUtil CreateImage:@"e_sina_logo" withType:@"png"];
    [self.view addSubview:sinaWeiboImageView];
    
    self.mSinaWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mSinaWeiboBtn.frame = CGRectMake(50, 60, 220, 30);
    [self.mSinaWeiboBtn setImage:[CommonUtil CreateImage:@"e_sinaweibo_loginbtn" withType:@"png"] forState:UIControlStateNormal];
    [self.mSinaWeiboBtn addTarget:self
                           action:@selector(sinaWeiboBtnClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.mSinaWeiboBtn setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:self.mSinaWeiboBtn];
    
    self.mSinaWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 140, 30)];
    self.mSinaWeiboLabel.backgroundColor = [UIColor clearColor];
    self.mSinaWeiboLabel.textColor = [UIColor whiteColor];
    self.mSinaWeiboLabel.textAlignment = NSTextAlignmentCenter;
    NSString *sinaUsername = @"新浪微博未绑定";
    if ([_SinaWeiboOAuth isLoggedIn])
    {
        sinaUsername = [[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")] objectForKey:@"sinausername"];
        if (!sinaUsername || [sinaUsername isEqualToString:@""])
        {
            [_SinaWeiboOAuth getUserInfo];
        }
        sinaUsername = [NSString stringWithFormat:@"%@ 已绑定", sinaUsername];
    }
    
    self.mSinaWeiboLabel.text = sinaUsername;
    self.mSinaWeiboLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.mSinaWeiboLabel];
    
    sinaWeiboImageView.center = CGPointMake(sinaWeiboImageView.center.x, 60);
    self.mSinaWeiboBtn.center = CGPointMake(self.mSinaWeiboBtn.center.x, 120);
    self.mSinaWeiboLabel.center = CGPointMake(self.mSinaWeiboLabel.center.x, 120);
    
    UIImageView *tencentWeiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, 320, 40)];
    tencentWeiboImageView.image = [CommonUtil CreateImage:@"e_tcweibo_logo" withType:@"png"];
    [self.view addSubview:tencentWeiboImageView];
    
    self.mTencentWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mTencentWeiboBtn.frame = CGRectMake(50, 170, 220, 30);
    [self.mTencentWeiboBtn setImage:[CommonUtil CreateImage:@"e_tcweibo_loginbtn" withType:@"png"] forState:UIControlStateNormal];
    [self.mTencentWeiboBtn addTarget:self
                              action:@selector(tencentWeiboBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mTencentWeiboBtn];
    
    self.mTencentWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 170, 140, 30)];
    self.mTencentWeiboLabel.backgroundColor = [UIColor clearColor];
    self.mTencentWeiboLabel.textColor = [UIColor whiteColor];
    self.mTencentWeiboLabel.textAlignment = NSTextAlignmentCenter;
    NSString *tencentUsername = @"腾讯微博未绑定";
    if ([_TCWeiboOAuth isLoggedIn])
    {
        tencentUsername = [[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")] objectForKey:@"tencentusername"];
        if (!tencentUsername || [tencentUsername isEqualToString:@""])
        {
            [_TCWeiboOAuth getUserInfoWithFormat:@"json"
                                     parReserved:nil
                                        delegate:self
                                       onSuccess:@selector(getUserInfoSuccessed:)
                                       onFailure:@selector(getUserInfoFailed:)];
        }
        tencentUsername = [NSString stringWithFormat:@"%@ 已绑定", tencentUsername];
    }
    
    self.mTencentWeiboLabel.text =  tencentUsername;
    self.mTencentWeiboLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.mTencentWeiboLabel];
    
    self.mTencentWeiboBtn.center = CGPointMake(self.mTencentWeiboBtn.center.x, self.view.center.y - 20);
    self.mTencentWeiboLabel.center = CGPointMake(self.mTencentWeiboLabel.center.x, self.view.center.y - 20);
    tencentWeiboImageView.center = CGPointMake(tencentWeiboImageView.center.x, self.mTencentWeiboBtn.center.y - 60);
    
    UIImageView *qzoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, 320, 40)];
    qzoneImageView.image = [CommonUtil CreateImage:@"e_tencentqq_logo" withType:@"png"];
    [self.view addSubview:qzoneImageView];
    
    self.mQzoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mQzoneBtn.frame = CGRectMake(50, 280, 220, 30);
    [self.mQzoneBtn setImage:[CommonUtil CreateImage:@"e_qzone_loginbtn" withType:@"png"] forState:UIControlStateNormal];
    [self.mQzoneBtn addTarget:self
                       action:@selector(qzoneBtnClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mQzoneBtn];
    
    self.mQzoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 280, 140, 30)];
    self.mQzoneLabel.backgroundColor = [UIColor clearColor];
    self.mQzoneLabel.textColor = [UIColor whiteColor];
    self.mQzoneLabel.textAlignment = NSTextAlignmentCenter;
    NSString *qzoneUsername = @"Qzone未绑定";
    if ([self isQzoneLogin])
    {
        qzoneUsername = [[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")] objectForKey:@"qzoneusername"];
        if (!qzoneUsername || [qzoneUsername isEqualToString:@""])
        {
            [_QzoneOAuth getUserInfo];
        }
        qzoneUsername = [NSString stringWithFormat:@"%@ 已绑定", qzoneUsername];
    }
    
    self.mQzoneLabel.text = qzoneUsername;
    self.mQzoneLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.mQzoneLabel];
    
    self.mQzoneBtn.center = CGPointMake(self.mQzoneBtn.center.x, self.view.frame.size.height - 120);
    self.mQzoneLabel.center = CGPointMake(self.mQzoneLabel.center.x, self.view.frame.size.height - 120);
    qzoneImageView.center = CGPointMake(qzoneImageView.center.x, self.view.frame.size.height - 180);
}

#pragma mark - ButtonClicked
- (void)sinaWeiboBtnClicked:(id)sender
{
    if ([_SinaWeiboOAuth isLoggedIn])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"是否确认解除新浪微博绑定？" andConfirmButton:@"确定"];
        alertView.delegate = self;
        alertView.tag = 101;
        [alertView show];
    }
    else
    {
        [_SinaWeiboOAuth logIn];
    }
}

- (void)tencentWeiboBtnClicked:(id)sender
{
    if ([_TCWeiboOAuth isLoggedIn])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"是否确认解除腾讯微博绑定？" andConfirmButton:@"确定"];
        alertView.delegate = self;
        alertView.tag = 102;
        [alertView show];
    }
    else
    {
        [_TCWeiboOAuth logInWithDelegate:self
                               onSuccess:@selector(onSuccessLogin)
                               onFailure:@selector(onFailureLogin:)];
    }
}

- (void)qzoneBtnClicked:(id)sender
{
    if ([self isQzoneLogin])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"是否确认解除QQ空间绑定？" andConfirmButton:@"确定"];
        alertView.delegate = self;
        alertView.tag = 103;
        [alertView show];
    }
    else
    {
        [_QzoneOAuth authorize:_permissions inSafari:YES];
    }
}

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

//#pragma mark - UIAlertViewDelegate Methods
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}

#pragma mark - CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (customAlertView.tag == 101)
        {
            [MobClick event:@"解除新浪微博绑定"];
            [_SinaWeiboOAuth logOut];
        }
        else if (customAlertView.tag == 102)
        {
            [MobClick event:@"解除腾讯微博绑定"];
            BOOL isLogOut = [_TCWeiboOAuth logOut];
            if (isLogOut)
            {
                self.mTencentWeiboLabel.text = @"腾讯微博未绑定";
            }
            else
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"登出失败！" andConfirmButton:@""];
                alertView.delegate = self;
                [alertView show];
            }
        }
        else if (customAlertView.tag == 103)
        {
            [MobClick event:@"解除QQ空间绑定"];
            [_QzoneOAuth logout:self];
        }
    }
}

#pragma mark - WBEngineDelegate Methods
- (void)engineDidLogIn:(WBEngine *)engine
{
    //[_mSinaWeiboBtn setTitle:@"新浪微博解除绑定" forState:UIControlStateNormal];
    [_SinaWeiboOAuth getUserInfo];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"新浪微博绑定失败！" andConfirmButton:@""];
    alertView.delegate = self;
    [alertView show];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    //[_mSinaWeiboBtn setTitle:@"新浪微博绑定" forState:UIControlStateNormal];
    self.mSinaWeiboLabel.text = @"新浪微博未绑定";
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [MobClick event:@"绑定新浪微博"];
    NSDictionary *tmpDic = (NSDictionary *)result;
    
    if ([engine.request.url rangeOfString:@"users/show.json"].location != NSNotFound)
    {
        NSString *username = [tmpDic stringForKey:@"screen_name"];
        self.mSinaWeiboLabel.text = [NSString stringWithFormat:@"%@ 已绑定", username];
        NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
        [tmpDic setObject:username forKey:@"sinausername"];
        [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
    }
}

#pragma mark - 腾讯微博login callback
//登录成功回调
- (void)onSuccessLogin
{
    [MobClick event:@"绑定腾讯微博"];
    //[_mTencentWeiboBtn setTitle:@"腾讯微博解除绑定" forState:UIControlStateNormal];
    self.mTencentWeiboLabel.text = [NSString stringWithFormat:@"%@ 已绑定", _TCWeiboOAuth.name];
    NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
    [tmpDic setObject:_TCWeiboOAuth.name forKey:@"tencentusername"];
    [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
}

-(void)onLoginFailed:(WBErrCode)errCode msg:(NSString*)msg
{
    
}

-(void)onLoginSuccessed:(NSString*)name token:(WBToken*)token
{
    self.mTencentWeiboLabel.text = [NSString stringWithFormat:@"%@ 已绑定", name];
    NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
    [tmpDic setObject:name forKey:@"tencentusername"];
    [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
}

- (void)getUserInfoSuccessed:(id)result
{
    NSDictionary *tmpResultDic = [(NSDictionary *)result objectForKey:@"data"];
    self.mTencentWeiboLabel.text = [NSString stringWithFormat:@"%@ 已绑定", [tmpResultDic objectForKey:@"name"]];
    NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
    [tmpDic setObject:[tmpResultDic objectForKey:@"name"] forKey:@"tencentusername"];
    [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
}

- (void)getUserInfoFailed:(NSError *)error
{
    NSLog(@"error: %@", error);
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin
{
    NSString *tmpStr = @"";
    // 登录成功
    if (_QzoneOAuth.accessToken && 0 != [_QzoneOAuth.accessToken length])
    {
        [MobClick event:@"绑定QQ空间"];
        //[_mQzoneBtn setTitle:@"Qzone解除绑定" forState:UIControlStateNormal];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSMutableDictionary *tencentDic = nil;
        if([manager fileExistsAtPath:LISTFILE(@"login.plist")])
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

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"QQ空间绑定失败！" andConfirmButton:@""];
    alertView.delegate = self;
    [alertView show];
}

- (void)tencentDidLogout
{
    //[_mQzoneBtn setTitle:@"Qzone绑定" forState:UIControlStateNormal];
    self.mQzoneLabel.text = @"Qzone未绑定";
    NSMutableDictionary *tencentDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"", @"", @"",nil]
                                                                  forKeys:[NSArray arrayWithObjects:@"tencentAccessToken", @"tencentOpenId", @"tencentExpirationDate",nil]];
    [tencentDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
}

- (void)tencentDidNotNetWork
{
	
}

- (void)getUserInfoResponse:(APIResponse*) response
{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
        self.mQzoneLabel.text = [NSString stringWithFormat:@"%@ 已绑定", [response.jsonResponse objectForKey:@"nickname"]];
        NSMutableDictionary *tmpDic = (NSMutableDictionary *)[NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
        [tmpDic setObject:[response.jsonResponse objectForKey:@"nickname"] forKey:@"qzoneusername"];
        [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
	}
}

- (void)goback
{
    [MobClick event:@"从社交网络页面返回侧边栏"];
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    [self dismissModalViewControllerAnimated:YES];
}

@end
