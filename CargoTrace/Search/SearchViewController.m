//
//  SearchViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "SearchViewController.h"
#import "WaybillViewController.h"
#import "SBJSON.h"
#import "CommonUtil.h"
#import "SVProgressHUD.h"
#import "GDataXMLNode.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize waybillViewController = _waybillViewController;
@synthesize lastNextOneNumber = _lastNextOneNumber;
@synthesize middleFourNumber = _middleFourNumber;
@synthesize frontTwoNumber = _frontTwoNumber;

@synthesize backMessageLabel = _backMessageLabel;
@synthesize frontMessageLabel = _frontMessageLabel;
@synthesize searchButton = _searchButton;
@synthesize searchFirstTextField = _searchFirstTextField;
@synthesize compayCode = _compayCode;

@synthesize num0 = _num0;
@synthesize num1 = _num1;
@synthesize num2 = _num2;
@synthesize num3 = _num3;
@synthesize num4 = _num4;
@synthesize num5 = _num5;
@synthesize num6 = _num6;
@synthesize num7 = _num7;
@synthesize num8 = _num8;
@synthesize num9 = _num9;
@synthesize del = _del;
@synthesize dot = _dot;

@synthesize contentSearch = _contentSearch;
@synthesize contentBack = _contentBack;
@synthesize isSecondText = _isSecondText;
@synthesize isFirstText  = _isFirstText;

@synthesize numLabel1 = _numLabel1;
@synthesize numLabel2 = _numLabel2;
@synthesize numLabel3 = _numLabel3;
@synthesize numLabel4 = _numLabel4;
@synthesize numLabel5 = _numLabel5;
@synthesize numLabel6 = _numLabel6;
@synthesize numLabel7 = _numLabel7;
@synthesize numLabel8 = _numLabel8;

@synthesize numLabelsArray = _numLabelsArray;
@synthesize carrierDictionary = _carrierDictionary;
@synthesize otherView  = _otherView;
@synthesize resultArray = _resultArray;
@synthesize tempData = _tempData;
@synthesize companyArray = _companyArray;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize weixinUtil = _weixinUtil;
@synthesize candyUtil = _candyUtil;
@synthesize noteLabel = _noteLabel;
@synthesize separatedView = _separatedView;
@synthesize componyLabel = _componyLabel;
@synthesize guidImageView;
@synthesize candyAlertView = _candyAlertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.compayCode = @"0";
        [self initDataFromPlist];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setKeyboardButtons];
    [self setNavbar];
  
    [self.frontMessageLabel setHidden:YES];
    [self.backMessageLabel setHidden:YES];
    [self.separatedView setHidden:YES];
    [self.noteLabel setHidden:NO];
    [self.componyLabel setHidden:YES];
    self.contentBack =  @"" ;
    
    if ([self.compayCode isEqualToString:@"0"])
    {
        
    }
    else
    {
        [self.searchFirstTextField setText:_compayCode];
        [self.separatedView setHidden:NO];
        [self.noteLabel setHidden:YES];
        if (![self verifyWillbillFrontNumber:_searchFirstTextField.text])
        {
            [self.frontMessageLabel setHidden:NO];
        }
        else
        {
            [self.componyLabel setHidden:NO];
            self.componyLabel.text = [self findCompanyName:_searchFirstTextField.text];
        }
    }
    
    if (!self.companyArray || [self.companyArray count] == 0)
    {
        self.companyArray = [CommonUtil getCompanys];
    }
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//    {
//        if(IS_IPHONE_5)
//        {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//            {
//                guidImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 208)];
//            }
//            else
//            {
//                guidImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 188)];
//            }
//            
//            guidImageView.image = [CommonUtil CreateImage:@"guid_search" withType:@"png"];
//        }
//        else
//        {
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//            {
//                guidImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 163)];
//            }
//            else
//            {
//                guidImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 143)];
//            }
//            guidImageView.image = [CommonUtil CreateImage:@"guid_search_s" withType:@"png"];
//        }
//        
//        [self.navigationController.view addSubview:guidImageView];
//    }
}

- (void)initDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"tracelist.plist")])
    {
        self.resultArray = [[NSMutableArray alloc]initWithCapacity:40];
    }
    else
    {
        self.resultArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
    }
}

#pragma mark -  判断  是否为数字
- (Boolean) verifyPureInt:(NSString *)number
{
    if (![@"" isEqualToString:number])
    {
        NSScanner* scan = [NSScanner scannerWithString:number];
        int val;
        return [scan scanInt:&val] && [scan isAtEnd];
    }
    else
    {
        return NO;
    }
}

#pragma mark -  判断 运单号 前三位 是否正确
-(Boolean)verifyWillbillFrontNumber:(NSString *)number
{
    if ([number isEqualToString:@""])
    {
        return NO;
    }
    else if (number.length != 3)
    {
        return NO;
    }
    else
    {
        return [self findCompanyCode:number];
    }
}

#pragma mark -  判断 运单号 后8位 是否正确
-(Boolean)verifyWillbilBackNumber :(NSString *)number
{
    if ([number isEqualToString:@""])
    {
        return NO;
    }
    else if (number.length == 8)
    {
        int num_8 = [[number substringFromIndex:7]intValue];
        int num_all7 =  [[number substringToIndex:7]intValue];
        int num  = num_all7 % 7;
        
        if (num == num_8)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}


#pragma mark  -  导航栏 设置
-(void) setNavbar
{
    self.navigationController.title = nil;
    [self setTitle:@"订阅运单"];
    
    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
    
    [self.num7 setTintColor:[UIColor clearColor]];
}

-(void) goback
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    [MobClick event:@"从运单订阅页面返回首页"];
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark -  得到运单号
-(void)getWillbillNumber
{
     if ([self verifyPureInt:self.contentBack]
        && [self verifyPureInt:self.searchFirstTextField.text]
        &&[self verifyWillbilBackNumber:self.contentBack ]
        && [self verifyWillbillFrontNumber:self.searchFirstTextField.text])
        {
            self.contentSearch = [NSMutableString stringWithFormat:@"%@",self.searchFirstTextField.text];
            [self.contentSearch appendFormat:@"-%@",self.contentBack];
        }
        else
        {
            self.contentSearch = [NSMutableString stringWithFormat:@"%@",@""];
        }
        //NSLog(@" contentSearch:%@",self.contentSearch);
}
  
#pragma mark - reply the search operation
- (IBAction)doSearch:(id)sender
{
    //[guidImageView removeFromSuperview];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [self initDataFromPlist];
    [self subcribe];
}

- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [customAlertView hideQuickly];
        [self giveCandy];
        [self performSelector:@selector(subcribeRequest) withObject:nil afterDelay:2];
    }
    else if (buttonIndex == 1)
    {
        [customAlertView hideQuickly];
        [_candyAlertView setWebViewImage:@"http://m.eft.cn/meftcn/activity/halloween/images/halloween.gif" andImageName:@"halloween"];
        [_candyAlertView showSlow];
        [self performSelector:@selector(subcribeRequest) withObject:nil afterDelay:2];
    }
}

- (void)subcribe
{
    [self getWillbillNumber];
    if (![self.contentSearch isEqual: @""])
    {
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *tmpDate = [NSDate date];
        NSString *dateStr = [formater stringFromDate:tmpDate];
        
        if ([dateStr isEqualToString:@"2013-10-31"])
        {
            _candyAlertView = [[CustomAlertView alloc] initWithUrlImage:@"http://m.eft.cn/meftcn/activity/halloween/images/candy.gif"];
            _candyAlertView.delegate = self;
            [_candyAlertView show];
        }
        else
        {
            [self subcribeRequest];
        }
    }
}

- (void)subcribeRequest
{
    [_candyAlertView hideSlow];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate = [NSDate date];
    NSString *dateStr = [formater stringFromDate:tmpDate];
    
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
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
                            self.contentSearch,
                            @"Y",
                            !appDelegate.token ? @"" :appDelegate.token,
                            @"IOS",
                            dateStr];
    
    NSLog(@"%@", postString);
    [_queryTraceUtil PostForASync:postString withURL:URL_POST];
    
    [SVProgressHUD showWithStatus:@"正在订阅订单"];
}

- (void)giveCandy
{
    if (_candyUtil)
    {
        [_candyUtil StopFunction];
        _candyUtil = nil;
    }
    
    _candyUtil = [[QueryTraceUtil alloc] init];
    _candyUtil.delegate = self;
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:@"candy" forKey:@"action"];
    [postDic setObject:[AppDelegate ShareAppDelegate].token forKey:@"openid"];
    [postDic setObject:self.contentSearch forKey:@"awbcode"];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSString *postString = [jsonParser stringWithObject:postDic];
    
    [_candyUtil PostWeixin:postString withURL:URL_CANDY];
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
    if (username && ![username isEqualToString:@""])
    {
        [postDic setObject:username forKey:@"userid"];
        [postDic setObject:@"" forKey:@"key"];
        [postDic setObject:@"1" forKey:@"ops"];
        [postDic setObject:self.contentSearch forKey:@"awbnum"];
        [postDic setObject:@"IOS" forKey:@"resource"];
    }
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSString *postString = [jsonParser stringWithObject:postDic];
    
    [_weixinUtil PostWeixin:postString withURL:URL_WEIXIN];
}

#pragma mark -
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    if (util == _queryTraceUtil)
    {
        [SVProgressHUD showSuccessWithStatus:@"运单订阅成功"];
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        NSArray *routesArray = [doc nodesForXPath:@"//route" error:nil];
        NSArray *tracesArray = [doc nodesForXPath:@"//TraceTranslate" error:nil];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSMutableArray *traces = [[NSMutableArray alloc] init];//轨迹信息
        NSMutableArray *alarms = [[NSMutableArray alloc] init];
        NSMutableArray *routes = [[NSMutableArray alloc] init];
        
        //traces信息
        for (NSInteger i = 0; i < tracesArray.count; i ++ )
        {
            [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"AWB_CODE" error:nil]];
            NSMutableDictionary * traceDic = [[NSMutableDictionary alloc] init];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"AWB_CODE" error:nil]]  forKey:@"AWB_CODE"];
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
            [trace_data replaceOccurrencesOfString:@"<BR/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, trace_data.length)];
            [traceDic setObject:trace_data  forKey:@"TRACE_DATA"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OP_TIME" error:nil]] forKey:@"OP_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OCCUR_TIME" error:nil]] forKey:@"OCCUR_TIME"];
            
            [traces addObject:traceDic];
        }
        
        NSArray* sortTrances = [[traces reverseObjectEnumerator] allObjects];
        
        [dic setObject:[self.contentSearch substringFromIndex:4] forKey:@"MAWBCODE"];
        [dic setObject:[self.contentSearch substringWithRange:NSRangeFromString(@"0,3")] forKey:@"AIRCOMPANYCODE"];
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
        
        NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
        
        self.tempData = (NSMutableDictionary *)dic;
        
        //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
        if(existData.count == 0)
        {
            [self.tempData setObject:@"YES" forKey:@"SUBSCRIBE"];
            if (![self.tempData objectForKey:@"AIRCOMPANYCODE"] || [[self.tempData objectForKey:@"AIRCOMPANYCODE"] isEqualToString:@""]
                || ![self.tempData objectForKey:@"MAWBCODE"] || [[self.tempData objectForKey:@"MAWBCODE"] isEqualToString:@""]
                || ![[self.tempData objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")]
                || ![[self.tempData objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")])
            {
                return;
            }
            [self.resultArray insertObject:self.tempData atIndex:0];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        else
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            [self.tempData setObject:@"YES" forKey:@"SUBSCRIBE"];
            [self.tempData setObject:[existObject objectForKey:@"STATUS"] forKey:@"STATUS"];
            [self.resultArray removeObject:existObject];
            [self.resultArray insertObject:self.tempData atIndex:0];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        
        [self subcribeToWeixin];
        
        self.orderCode = [NSString stringWithFormat:@"%@-%@",[self.tempData objectForKey:@"AIRCOMPANYCODE"],[self.tempData objectForKey:@"MAWBCODE"]];
        
        //记录订阅运单的时间
//        NSFileManager *manager = [NSFileManager defaultManager];
//        NSMutableArray *orderArray = [[NSMutableArray alloc]initWithCapacity:40];
//        if([manager fileExistsAtPath:LISTFILE(@"order.plist")])
//        {
//            orderArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"order.plist")];
//        }
//        NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
//        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
//        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *tmpDate = [NSDate date];
//        NSString *dateStr = [formater stringFromDate:tmpDate];
//        [orderDic setObject:self.orderCode forKey:@"ORDERID"];
//        [orderDic setObject:dateStr forKey:@"ORDERDATE"];
//        [orderArray addObject:orderDic];
//        [orderArray writeToFile:LISTFILE(@"order.plist") atomically:YES];
        //记录订阅运单的时间
        
        [MobClick event:@"运单订阅成功"];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:[[NSArray alloc] initWithObjects:existData,self.orderCode, nil] waitUntilDone:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:3] userInfo:nil];
    }
    else if (util == _weixinUtil)
    {
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *parseError = nil;
        NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
        if (tmpDic)
        {
            NSString *returnStr = [tmpDic objectForKey:@"description"];
            NSLog(@"%@", returnStr);
        }
    }
    else if (util == _candyUtil)
    {
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *parseError = nil;
        NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
        if (tmpDic)
        {
            NSString *returnStr = [tmpDic objectForKey:@"success"];
            NSLog(@"%@", returnStr);
            [_candyAlertView setWebViewImage:@"http://m.eft.cn/meftcn/activity/halloween/images/givecandy.gif" andImageName:@"giveCandy"];
            [_candyAlertView showSlow];
        }
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        [SVProgressHUD showErrorWithStatus:@"暂无轨迹，请求已发出，请稍候！"];
    }
    else if (util == _candyUtil)
    {
        [SVProgressHUD showErrorWithStatus:@"给糖失败！"];
    }
}

- (void)updateUI:(NSArray *)args
{
    if (![self.contentSearch isEqualToString:@""])
    {
        if (IS_IPHONE_5)
        {
            self.waybillViewController = [[WaybillViewController alloc] initWithNibName:@"WaybillViewController" bundle:nil];
        }
        else
        {
            self.waybillViewController = [[WaybillViewController alloc] initWithNibName:@"WaybillViewControllerSmall" bundle:nil];
        }
        
        self.waybillViewController.awbCode = self.contentSearch;
        [self clearContent];
        [self.navigationController pushViewController:_waybillViewController animated:YES];
    }
}

- (void)clearContent
{
    self.searchFirstTextField.text  = @"";
    for (int i = 0; i < [self.numLabelsArray count]; i++)
    {
        UILabel *tmpLabel = (UILabel *)[self.numLabelsArray objectAtIndex:i];
        tmpLabel.text = @"";
    }
    self.contentBack = @"";
    [self.separatedView setHidden:YES];
    [self.noteLabel setHidden:NO];
    [self.componyLabel setHidden:YES];
}

#pragma  mark - set the keyboard's aph color
-(void)setButtonAlphaF:(UIButton *)button
{
    [button setAlpha:0.9];
}
-(void)setButtonAlphaB:(UIButton *)button
{
    [button setAlpha:0.015];
}
#pragma  mark - init the keyboard   
-(void) setKeyboardButtons
{
    self.num0.tag = 0;
    self.num1.tag = 1;
    self.num2.tag = 2;
    self.num3.tag = 3;
    self.num4.tag = 4;
    self.num5.tag = 5;
    self.num6.tag = 6;
    self.num7.tag = 7;
    self.num8.tag = 8;
    self.num9.tag = 9;
    self.del.tag = 10;
    self.dot.tag = 11;
      
    self.numLabel1.tag = 1;
    self.numLabel2.tag = 2;
    self.numLabel3.tag = 3;
    self.numLabel4.tag = 4;
    self.numLabel5.tag = 5;
    self.numLabel6.tag = 6;
    self.numLabel7.tag = 7;
    self.numLabel8.tag = 8;
    
    self.numLabel1.hidden = YES;
    self.numLabel2.hidden = YES;
    self.numLabel3.hidden = YES;
    self.numLabel4.hidden = YES;
    self.numLabel5.hidden = YES;
    self.numLabel6.hidden = YES;
    self.numLabel7.hidden = YES;
    self.numLabel8.hidden = YES;
    
    self.numLabelsArray  = [[NSMutableArray alloc]initWithObjects:self.numLabel1,self.numLabel2,self.numLabel3,self.numLabel4,self.numLabel5,self.numLabel6,self.numLabel7,self.numLabel8, nil];
  
    [self.searchFirstTextField setTag:0];
    //[self.searchTextField setTag:1];
  
    self.isFirstText = NO;
    self.isSecondText = NO;
  
}

#pragma  mark -  action of  keyboard button
- (IBAction)doKeyboardAction:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    [CommonUtil setSystemAlarm];
    
    NSString *tempStr = @"";
    if (tempButton.tag <= 9 )
    {
        tempStr = [NSString stringWithFormat:@"%d",tempButton.tag];
        
        if(self.searchFirstTextField.text.length < 3)
        {
            NSMutableString *myText = [[NSMutableString alloc] init];
            if (self.searchFirstTextField.text.length > 0)
            {
                [myText appendString:self.searchFirstTextField.text];
            }
            [myText appendFormat:@"%@",tempStr];
            self.searchFirstTextField.text = myText;
            [self.separatedView setHidden:NO];
            [self.noteLabel setHidden:YES];
            [self.componyLabel setHidden:YES];
          
            [self.frontMessageLabel setHidden:YES];
            if (myText.length == 3)
            {
                if (![self verifyWillbillFrontNumber:myText])
                {
                    [self.frontMessageLabel setHidden:NO];
                }
                else
                {
                    [self.componyLabel setHidden:NO];
                    self.componyLabel.text = [self findCompanyName:myText];
                }
            }
        }
        else
        {
            if (self.contentBack.length < 8)
            {
              
                NSMutableString *myText2 = [NSMutableString stringWithFormat:@"%@", self.contentBack];
                [myText2 appendFormat:@"%@",tempStr];
                
                self.contentBack = myText2;
               
                UILabel * label = [self.numLabelsArray objectAtIndex:(myText2.length - 1)];
                label.text = tempStr;
                label.hidden = NO;
            }
            
            if (self.contentBack.length == 8)
            {
                NSMutableString *myText2 = [NSMutableString stringWithFormat:@"%@", self.contentBack];
                [myText2 deleteCharactersInRange:NSMakeRange(7, 1)];
                [myText2 appendFormat:@"%@", tempStr];
                self.contentBack = myText2;
                
                UILabel * label = [self.numLabelsArray objectAtIndex:(self.contentBack.length - 1)];
                label.text = tempStr;
                label.hidden = NO;
                
                BOOL isRight = [self verifyWillbilBackNumber:myText2]; // 校验位是否正确
                self.numLabel8.textColor = [UIColor whiteColor];
                self.backMessageLabel.hidden = YES;
                
                if (isRight == NO)
                {
                    self.numLabel8.textColor = [UIColor redColor];
                    self.backMessageLabel.hidden = NO;
                }
            }
        }
    }
    
    // delete the content
    if (tempButton.tag == 10)
    {
        self.backMessageLabel.hidden = YES;
        
        if ([@"" isEqualToString:self.searchFirstTextField.text] && [@"" isEqualToString: self.contentBack])
        {
            return;
        }
      
        if([@"" isEqualToString:self.contentBack] && self.searchFirstTextField.text.length != 0)
        {
            [self.frontMessageLabel setHidden:YES];
            NSMutableString *myText = [NSMutableString stringWithFormat:@"%@",self.searchFirstTextField.text];
            NSRange range = {([myText length]-1),1};
            [myText deleteCharactersInRange:range];
            self.searchFirstTextField.text = myText;
            if ([self.searchFirstTextField.text isEqualToString:@""])
            {
                [self.separatedView setHidden:YES];
                [self.noteLabel setHidden:NO];
            }
            
            if (myText.length < 3)
            {
                [self.componyLabel setHidden:YES];
            }
        }
        else if(self.searchFirstTextField.text.length != 0)
        {
            int tag = self.contentBack.length ;
                  
            for (UILabel *label in self.numLabelsArray)
            {
                if(label.tag == tag)
                {
                    [label setHidden:YES];
                }
            }
                  
            NSMutableString *myText = [NSMutableString stringWithFormat:@"%@",self.contentBack];
            NSRange range = {([myText length]-1),1};
            [myText deleteCharactersInRange:range];
            self.contentBack = myText;
        }
        return;
    }
    
    if (tempButton.tag == 11 )
    {
        self.isFirstText = NO;
    }
}

#pragma mark -  初始化 航空公司三字码
- (BOOL)findCompanyCode:(NSString *) code
{
    BOOL temp = NO;
    if (code.length == 3)
    {
        for (NSDictionary *dic in  self.companyArray)
        {
            NSString * temp_companyCode = [dic objectForKey:@"CODE"];
            // NSLog(@"temp_companyCode ---%@ ",temp_companyCode);
            if ([code isEqualToString:temp_companyCode])
            {
                temp = YES;
            } 
        }
    }
    else
    {
        return  NO;
    }
    return temp;
}

- (NSString *)findCompanyName:(NSString *) code
{
    NSString *temp = @"";
    if (code.length == 3)
    {
        for (NSDictionary *dic in  self.companyArray)
        {
            NSString * temp_companyCode = [dic objectForKey:@"CODE"];
            // NSLog(@"temp_companyCode ---%@ ",temp_companyCode);
            if ([code isEqualToString:temp_companyCode])
            {
                temp = [dic objectForKey:@"NAME"];
            }
        }
    }
    else
    {
        return  @"";
    }
    return temp;
}

#pragma mark - 系统键盘 事件
- (void)keyboardWillShowOnDelay:(NSNotification *)notification
{
    [self performSelector:@selector(keyboardWillShow:) withObject:nil afterDelay:0];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //NSLog(@"    ----  %@ ",  NSStringFromSelector(_cmd));
}

- (void)keyboardWillHide:(NSNotification *)note{
    //NSLog(@"    ----  %@ ",  NSStringFromSelector(_cmd));
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *)textField
{
   //NSLog(@"    ----  %@ ",  NSStringFromSelector(_cmd));
   return NO;
}
 
@end
 