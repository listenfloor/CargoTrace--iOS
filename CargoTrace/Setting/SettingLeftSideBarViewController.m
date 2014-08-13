//
//  SettingLeftSideBarViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-9.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "SettingLeftSideBarViewController.h"
#import "CommonUtil.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ShareLinkViewController.h"
#import "MyOrderListViewController.h"
#import "SBJSON.h"

@interface SettingLeftSideBarViewController ()

@end

@implementation SettingLeftSideBarViewController

//@synthesize SettingTableView = _SettingTableView;
@synthesize contentArray = _contentArray;
@synthesize userImage = _userImage;
@synthesize usernameLabel = _usernameLabel;
//@synthesize titleLabel = _titleLabel;
//@synthesize warningLabel = _warningLabel;
@synthesize loginViewController = _loginViewController;
@synthesize isOpenWarning = _isOpenWarning;
@synthesize isLogin = _isLogin;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize weixinUtil = _weixinUtil;
@synthesize updateUtil = _updateUtil;
@synthesize disQueryTraceUtil = _disQueryTraceUtil;
@synthesize unBindingUserUtil = _unBindingUserUtil;
@synthesize userCount = _userCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.view.frame = CGRectMake(0, 20, 320, self.view.frame.size.height);
    }
    [self isUserLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addEventListeners];
    
    self.label0.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    self.label1.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    self.label2.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    self.label3.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    self.label4.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    self.label5.textColor = [CommonUtil colorWithHexString:@"#d9d9d9"];
    
    //[CommonUtil setImageRound:self.userImage image: [UIImage imageNamed:@"headicon.png"] cornerRadius:23.0 borderWidth:3.0];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"e_left_bg.png"]]];
    //[self.titleLabel setBackgroundColor: [UIColor colorWithRed:53/255.0 green:53/255.0  blue:52/255.0  alpha:1]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:LISTFILE(@"setting.plist")])
    {
        self.isOpenWarning = YES;
        NSString *tmpStr = self.isOpenWarning ? @"YES" : @"NO";
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:tmpStr forKey:@"isOpenWarning"];
        [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
    }
    else
    {
        NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
        self.isOpenWarning = [[tmpDic objectForKey:@"isOpenWarning"] boolValue];
    }
    
    _label2.text = self.isOpenWarning ? @"关闭通知" : @"开启通知";
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
    NSString *username = [loginDic objectForKey:@"nikename"];
    if (username && ![username isEqualToString:@""])
    {
        self.usernameLabel.text = username;
    }
}

- (void)isUserLogin
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:LISTFILE(@"login.plist")])
    {
        self.isLogin = NO;
    }
    else
    {
        NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
        NSString *username = [tmpDic objectForKey:@"username"];
        if (username && ![username isEqualToString:@""])
        {
            self.isLogin = YES;
        }
        else
        {
            self.isLogin = NO;
        }
    }
    
    _label5.text = self.isLogin ? @"用户注销" : @"用户登录";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openWarningChanged
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:self.isOpenWarning ? @"是否关闭通知？" : @"是否开启通知？" andConfirmButton:@"确定"];
    alertView.delegate = self;
    alertView.tag = 101;
    [alertView show];
}

- (IBAction)doAction:(id)sender
{
    UIButton * but = (UIButton*)sender;
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    if (but.tag== 0)
    {
        [MobClick event:@"从侧边栏返回首页"];
        [menuController showRootController:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:1] userInfo:nil];
    }
    if (but.tag== 1)
    {
        [SVProgressHUD showErrorWithStatus:@"正在施工"];
    }
    if (but.tag== 2)
    {
        [self openWarningChanged];
    }
    if (but.tag== 3)
    {
        [MobClick event:@"进入社交网络页面"];
        ShareLinkViewController *vc = [[ShareLinkViewController alloc] init];
        UINavigationController *navLoginController = [[UINavigationController alloc] initWithRootViewController:vc];
        [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
        [menuController presentModalViewController:navLoginController animated:YES];
    }
    if (but.tag== 4)
    {
        [SVProgressHUD showErrorWithStatus:@"正在施工"];
    }
    
    if (but.tag== 5)
    {
        if (self.isLogin)
        {
            [MobClick event:@"用户注销"];
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"是否注销" andConfirmButton:@"确定"];
            alertView.delegate = self;
            alertView.tag = 102;
            [alertView show];
        }
        else
        {
            [MobClick event:@"进入用户登录页面"];
            if (IS_IPHONE_5) {
                self.loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            }else{
                self.loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewControllerSmall" bundle:nil];
            }
            UINavigationController *navLoginController = [[UINavigationController alloc]initWithRootViewController:self.loginViewController];
            [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
            [menuController presentModalViewController:navLoginController animated:YES];
        }
   }
    
    if (but.tag == 6)
    {
        MyOrderListViewController *vc = nil;
        if (IS_IPHONE_5)
        {
            vc = [[MyOrderListViewController alloc]initWithNibName:@"MyOrderListViewController" bundle:nil];
        }
        else
        {
            vc = [[MyOrderListViewController alloc]initWithNibName:@"MyOrderListViewControllerSmall" bundle:nil];
        }
        UINavigationController *navLoginController = [[UINavigationController alloc]initWithRootViewController:vc];
        [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
        [menuController presentModalViewController:navLoginController animated:YES];
    }
}

- ( void) popTempViewController
{
}

#pragma mark - CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (customAlertView.tag == 101)
    {
        if (buttonIndex == 1)
        {
            self.isOpenWarning = !self.isOpenWarning;
            [MobClick event:self.isOpenWarning ? @"关闭预警" : @"开启预警"];
            _label2.text = self.isOpenWarning ? @"关闭通知" : @"开启通知";
            [self initDataFromPlist];
            [self surbscribe];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            self.isLogin = !self.isLogin;
            
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
            NSString *username = [tmpDic objectForKey:@"username"];
            [self unBindingUser:username];
            [tmpDic setObject:@"" forKey:@"username"];
            [tmpDic setObject:@"" forKey:@"nikename"];
            [tmpDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
            
            _label5.text = self.isLogin ? @"用户注销" : @"用户登录";
            
            if (!self.isLogin)
            {
                NSMutableDictionary *info= [[NSMutableDictionary alloc] init];
                [info setObject:LOGOUT forKey:@"login"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLogin" object:nil userInfo:info];
                [SVProgressHUD showSuccessWithStatus:@"注销成功"];
            }
        }
    }
}

- (void)surbscribe
{
    if (_disQueryTraceUtil)
    {
        [_disQueryTraceUtil StopFunction];
    }
    
    _disQueryTraceUtil = [[QueryTraceUtil alloc] init];
    _disQueryTraceUtil.delegate = self;
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate = [NSDate date];
    NSString *dateStr = [formater stringFromDate:tmpDate];
    
    for (int i = 0; i < [self.contentArray count]; i++)
    {
        NSMutableDictionary *tmpDic = [self.contentArray objectAtIndex:i];
        [tmpDic setObject:self.isOpenWarning ? @"YES" : @"NO" forKey:@"SUBSCRIBE"];
        
        NSString *code = [NSString stringWithFormat:@"%@-%@", [tmpDic objectForKey:@"AIRCOMPANYCODE"], [tmpDic objectForKey:@"MAWBCODE"]];
        
        NSString *postString = [NSString stringWithFormat:
                                @"<eFreightService>"
                                @"<ServiceURL>Subscribe</ServiceURL>"
                                @"<ServiceAction>TRANSACTION</ServiceAction>"
                                @"<ServiceData>"
                                @"<Subscribe>"
                                @"<type>trace</type><target>%@</target><targettype>MAWB</targettype>"
                                @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
                                @"<standard_type>3</standard_type>"
                                @"<limit_num>-1</limit_num>"
                                @"%@"
                                @"<systime>%@</systime>"
                                @"</Subscribe>"
                                @"</ServiceData>"
                                @"</eFreightService>",
                                code,
                                self.isOpenWarning ? @"Y" : @"N",
                                [AppDelegate ShareAppDelegate].token,
                                @"IOS",
                                self.isOpenWarning ? @"<offflag></offflag>" : @"<offflag>1</offflag>",
                                dateStr];
        
        NSLog(@"%@", postString);
        [_disQueryTraceUtil PostForASync:postString withURL:URL_POST];
    }
    
    [self.contentArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"setting.plist")];
    [tmpDic setObject:self.isOpenWarning ? @"YES" : @"NO" forKey:@"isOpenWarning"];
    [tmpDic writeToFile:LISTFILE(@"setting.plist") atomically:YES];
}

#pragma mark  -  从文件中读数据，初始化
-(void) initDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"tracelist.plist")])
    {
        self.contentArray = [[NSMutableArray alloc] init];
    }
    else
    {
        self.contentArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
    }
}

- (void)subcribeToWeixin
{
    if (_weixinUtil)
    {
        [_weixinUtil StopFunction];
        _weixinUtil = nil;
    }
    
    _weixinUtil = [[QueryTraceUtil alloc] init];
    _weixinUtil.delegate = self;
    
    NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
    NSString *username = [tmpDic objectForKey:@"username"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [self initDataFromPlist];
    if (username && ![username isEqualToString:@""])
    {
        for (int i = 0; i < [self.contentArray count]; i++)
        {
            NSMutableDictionary *tmpDic = [self.contentArray objectAtIndex:i];
            NSString *code = [NSString stringWithFormat:@"%@-%@", [tmpDic objectForKey:@"AIRCOMPANYCODE"], [tmpDic objectForKey:@"MAWBCODE"]];
            [postDic setObject:username forKey:@"userid"];
            [postDic setObject:@"" forKey:@"key"];
            [postDic setObject:@"1" forKey:@"ops"];
            [postDic setObject:code forKey:@"awbnum"];
            [postDic setObject:@"IOS" forKey:@"resource"];
            
            SBJSON *jsonParser = [[SBJSON alloc] init];
            NSString *postString = [jsonParser stringWithObject:postDic];
            
            [_weixinUtil PostWeixin:postString withURL:URL_WEIXIN];
        }
    }
}

- (void)updateFromWeixin
{
    if (_updateUtil)
    {
        [_updateUtil StopFunction];
        _updateUtil = nil;
    }
    
    _updateUtil = [[QueryTraceUtil alloc] init];
    _updateUtil.delegate = self;
    
    NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
    NSString *username = [tmpDic objectForKey:@"username"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    if (username && ![username isEqualToString:@""])
    {
        [postDic setObject:username forKey:@"userid"];
        [postDic setObject:@"" forKey:@"key"];
        [postDic setObject:@"" forKey:@"awbnum"];
        
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSString *postString = [jsonParser stringWithObject:postDic];
        
        [_updateUtil PostWeixin:postString withURL:URL_WEIXIN];
    }
}

- (void)getUserSubcribed:(NSArray *)array
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate = [NSDate date];
    NSString *dateStr = [formater stringFromDate:tmpDate];
    _userCount = [array count];
    if (_userCount == 0)
    {
        [SVProgressHUD showSuccessWithStatus:@"同步成功"];
        return;
    }
    
    for (int i = 0; i < [array count]; i++)
    {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *codeStr = [dic objectForKey:@"awbnum"];
        NSString *postString = [NSString stringWithFormat:
                                @"<eFreightService>"
                                @"<ServiceURL>Subscribe</ServiceURL>"
                                @"<ServiceAction>TRANSACTION</ServiceAction>"
                                @"<ServiceData>"
                                @"<Subscribe>"
                                @"<type>trace</type><target>%@</target><targettype>MAWB</targettype>"
                                @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
                                @"<standard_type>3</standard_type>"
                                @"<limit_num>-1</limit_num>"
                                @"<offflag></offflag>"
                                @"<systime>%@</systime>"
                                @"</Subscribe>"
                                @"</ServiceData>"
                                @"</eFreightService>",
                                codeStr,
                                @"Y",
                                [AppDelegate ShareAppDelegate].token,
                                @"IOS",
                                dateStr];
        
        NSLog(@"%@", postString);
        [_queryTraceUtil PostForASync:postString withURL:URL_POST];
    }
}

- (void)parseTrace:(GDataXMLDocument *)doc
{
    
}

#pragma mark - QueryTraceUtilDelegate fuctions
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    if (util == _updateUtil)
    {
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *parseError = nil;
        NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
        if (tmpDic)
        {
            NSArray *codeArray = [tmpDic objectForKey:@"data"];
            [self getUserSubcribed:codeArray];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"同步成功"];
        }
    }
    else if (util == _queryTraceUtil)
    {
        _userCount--;
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        //[NSThread detachNewThreadSelector:@selector(parseTrace:) toTarget:self withObject:doc];
        NSArray *routesArray = [doc nodesForXPath:@"//route" error:nil];
        NSArray *tracesArray = [doc nodesForXPath:@"//TraceTranslate" error:nil];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSMutableArray *traces = [[NSMutableArray alloc] init];//轨迹信息
        NSMutableArray *alarms = [[NSMutableArray alloc] init];
        NSMutableArray *routes = [[NSMutableArray alloc] init];
        
        NSString *awbCode = @"";
        
        //traces信息
        for (NSInteger i = 0; i < tracesArray.count; i ++ )
        {
            awbCode = [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"AWB_CODE" error:nil]];
            NSMutableDictionary * traceDic = [[NSMutableDictionary alloc] init];
            [traceDic setObject:awbCode  forKey:@"AWB_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"FLIGHT_NO" error:nil]] forKey:@"FLIGHT_NO"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"FLIGHT_DATE" error:nil]] forKey:@"FLIGHT_DATE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"SHIMPENT_PIECE" error:nil]] forKey:@"SHIMPENT_PIECE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"SHIMPENT_WEIGHT" error:nil]] forKey:@"SHIMPENT_WEIGHT"] ;
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"CARGO_CODE" error:nil]] forKey:@"CARGO_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"CARGO_NAME" error:nil]] forKey:@"CARGO_NAME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"CARGO_ENNAME" error:nil]] forKey:@"CARGO_ENNAME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"TRACE_CODE" error:nil]] forKey:@"TRACE_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"TRACE_TIME" error:nil]] forKey:@"TRACE_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"TRACE_LOCATION" error:nil]] forKey:@"TRACE_LOCATION"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"AIRPORT_DEP" error:nil]] forKey:@"AIRPORT_DEP"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"AIRPORT_LAND" error:nil]] forKey:@"AIRPORT_LAND"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"ORIGIN_AIRPORT" error:nil]] forKey:@"ORIGIN_AIRPORT"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"DESTINATION_AIRPORT" error:nil]] forKey:@"DESTINATION_AIRPORT"];
            NSMutableString *trace_data = [NSMutableString stringWithFormat:@"%@", [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"TRACE_DATA" error:nil]]];
            [trace_data replaceOccurrencesOfString:@"  " withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, trace_data.length)];
            [traceDic setObject:trace_data  forKey:@"TRACE_DATA"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OP_TIME" error:nil]] forKey:@"OP_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OCCUR_TIME" error:nil]] forKey:@"OCCUR_TIME"];
            
            [traces addObject:traceDic];
        }
        
        NSArray* sortTrances = [[traces reverseObjectEnumerator] allObjects];
        
        if (awbCode.length < 12)
        {
            if (_userCount == 0)
            {
                [SVProgressHUD showSuccessWithStatus:@"同步成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:2] userInfo:nil];
            }
            return;
        }
        [dic setObject:[awbCode substringFromIndex:4] forKey:@"MAWBCODE"];
        [dic setObject:[awbCode substringWithRange:NSRangeFromString(@"0,3")] forKey:@"AIRCOMPANYCODE"];
        [dic setObject:@"NORMAL" forKey:@"STATUS"];
        [dic setObject:alarms forKey:@"ALARMS"];
        [dic setObject:sortTrances forKey:@"TRACES"];
        [dic setObject:routes forKey: @"ROUTES"];
        
        [dic setObject:[QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_CODE" error:nil]] forKey:@"CARGO_CODE"];
        [dic setObject:[QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_NAME" error:nil]] forKey: @"CARGO_NAME"];
        
        //始发港 目的港 日期 信息
        for (NSInteger i = 0; i < routesArray.count; i++)
        {
            if (i == 0)
            {
                [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] ;
                [dic setObject:[QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] forKey:@"DEP_PORT"];
                [dic setObject:[QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"flight_date" error:nil]] forKey: @"FLIGHT_DATE"];
                [dic setObject: [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]]forKey:@"ARR_PORT"];
            }
            else
            {
                [dic setObject:[QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]] forKey:@"ARR_PORT"] ;
            }
        }
        
        // 判断 plist 中是否有重复的历史数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [dic objectForKey:@"AIRCOMPANYCODE"], [dic objectForKey:@"MAWBCODE"]];
        
        if (!self.contentArray)
        {
            [self initDataFromPlist];
        }
        
        NSArray *existData = [self.contentArray filteredArrayUsingPredicate:predicate];
        
        //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
        if(existData.count == 0)
        {
            [dic setObject:@"YES" forKey:@"SUBSCRIBE"];
            if (![dic objectForKey:@"AIRCOMPANYCODE"] || [[dic objectForKey:@"AIRCOMPANYCODE"] isEqualToString:@""]
                || ![dic objectForKey:@"MAWBCODE"] || [[dic objectForKey:@"MAWBCODE"] isEqualToString:@""]
                || ![[dic objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")]
                || ![[dic objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")])
            {
                return;
            }
            [self.contentArray insertObject:dic atIndex:0];
            [self.contentArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        else
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            [dic setObject:@"YES" forKey:@"SUBSCRIBE"];
            [dic setObject:[existObject objectForKey:@"STATUS"] forKey:@"STATUS"];
            [self.contentArray removeObject:existObject];
            [self.contentArray insertObject:dic atIndex:0];
            [self.contentArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        
        if (_userCount == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"同步成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:2] userInfo:nil];
        }
    }
    else if (util == _unBindingUserUtil)
    {
        
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        _userCount--;
        if (_userCount == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"同步成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:2] userInfo:nil];
        }
    }
}

#pragma mark - NSNotificationCenter

- (void)addEventListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealReceiveEvent:)
                                                 name:@"actionLogin"
                                               object:nil];
}

- (void)removeEventListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"actionLogin" object:nil];
}

- (void)dealReceiveEvent :(NSNotification*) notification
{
    NSString *tmpStr = [[notification userInfo] objectForKey:@"login"];
    
    if ([tmpStr isEqualToString:LOGIN_SUCESS])
    {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [SVProgressHUD showWithStatus:@"正在同步用户信息"];
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
        self.usernameLabel.text = [loginDic objectForKey:@"nikename"];
        
        [self subcribeToWeixin];
        [self updateFromWeixin];
    }
    else if ([tmpStr isEqualToString:LOGOUT])
    {
        self.usernameLabel.text = @"未登录";
    }
}

- (void)unBindingUser:(NSString *)username
{
    if (_unBindingUserUtil)
    {
        [_unBindingUserUtil StopFunction];
        _unBindingUserUtil = nil;
    }
    
    _unBindingUserUtil = [[QueryTraceUtil alloc] init];
    _unBindingUserUtil.delegate = self;
    NSString *postString = [NSString stringWithFormat:@"{\"eFreightService\":{\"ServiceURL\":\"LinkedAccount\",\"ExportType\":\"JSON\",\"ServiceData\":{\"LinkedAccount\":{\"linkedaccounttype\":\"IOS\",\"username\":\"%@\",\"linkedaccountid\":\"%@\",\"operatetime\":\"sysdate\"}},\"ServiceAction\":\"unbind\"}}", username, [AppDelegate ShareAppDelegate].token];
    
    [_unBindingUserUtil binding:postString withURL:URL_LOGIN];
}

@end
