//
//  WaybillCTTabbarContentViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-11.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "WaybillCTTabbarContentViewController.h"
#import "WaybillDetailViewController.h"
#import "AppDelegate.h"
#import "WaybillTabelViewCell.h"
#import "CommonUtil.h"
#import "SVProgressHUD.h"
#import "GDataXMLNode.h"
#import "SBJSON.h"

@interface WaybillCTTabbarContentViewController ()
{
    WaybillTabelViewCell *_currentlyRevealedCell;
}

@end

@implementation WaybillCTTabbarContentViewController

@synthesize cttableView = _cttableView;
@synthesize navController = _navController;
@synthesize contentArray = _contentArray;
@synthesize allArray = _allArray;
@synthesize alarmArray = _alarmArray;
@synthesize normalArray = _normalArray;
@synthesize historyArray = _historyArray;
@synthesize index = _index;
@synthesize strCode = _strCode;
@dynamic currentlyRevealedCell;
@synthesize resultArray = _resultArray;
@synthesize delegate = _delegate;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize weixinUtil = _weixinUtil;
@synthesize disTraceSubscribeUtil = _disTraceSubscribeUtil;
@synthesize willRefresh = _willRefresh;
@synthesize isButtonAction = _isButtonAction;
@synthesize awbCode = _awbCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.index = 0;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabbarindex" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataFromPlist];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealIndexChange)
                                                 name:@"tabbarindex"
                                               object:nil];
    //[self initDic];
    self.cttableView.dataSource = self;
    
    if (self.willRefresh)
    {
        [self refreshDataFromSever];
    }
}

-(void)dealIndexChange
{
    //NSLog(@"--- %@ -- %d",NSStringFromSelector(_cmd),self.index);
    switch (self.index)
    {
        case 0:
        {
            self.contentArray = self.allArray;
        }
            break;
        case 1:
        {
            self.contentArray = self.alarmArray;
        }
            break;
        case 2:
        {
            self.contentArray = self.normalArray;
        }
            break;
        case 3:
        {
            self.contentArray = self.historyArray;
        }
            break;
        default:
            break;
    }
    
    [self.cttableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors
- (WaybillTabelViewCell *)currentlyRevealedCell
{
	return _currentlyRevealedCell;
}

- (void)setCurrentlyRevealedCell:(WaybillTabelViewCell *)currentlyRevealedCell
{
	if (_currentlyRevealedCell == currentlyRevealedCell)
		return;
	
	[_currentlyRevealedCell setRevealing:NO];
	
	[self willChangeValueForKey:@"currentlyRevealedCell"];
	_currentlyRevealedCell = currentlyRevealedCell ;
	[self didChangeValueForKey:@"currentlyRevealedCell"];
}

#pragma mark - WaybillTabelViewCellDelegate
- (BOOL)cellShouldReveal:(WaybillTabelViewCell *)cell
{
	return YES;
}

- (void)cellDidReveal:(WaybillTabelViewCell *)cell
{
	self.currentlyRevealedCell = cell;
}

- (void)cellDidBeginPan:(WaybillTabelViewCell *)cell
{
	if (cell != self.currentlyRevealedCell)
		self.currentlyRevealedCell = nil;
}

- (void)cellDidPad:(WaybillTabelViewCell *)cell Direction:(NSInteger)direction
{
    [self initDataFromPlist];
    //NSLog(@"%@", cell.detailNumber.text);
    if (cell.detailNumber.text.length >= 12)
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%@%@", [[cell.detailNumber.text substringFromIndex:4] substringToIndex:4], [[cell.detailNumber.text substringFromIndex:9] substringToIndex:4]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [cell.detailNumber.text substringToIndex:3], tmpStr];
        NSString *awbCode = [NSString stringWithFormat:@"%@-%@", [cell.detailNumber.text substringToIndex:3], tmpStr];
        
        NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
        NSArray *existData1 = [self.contentArray filteredArrayUsingPredicate:predicate];
        if ([existData count] != 0 && [existData1 count] != 0)
        {
            NSMutableDictionary *tmpDic = [existData objectAtIndex:0];
            NSMutableDictionary *tmpDic1 = [existData1 objectAtIndex:0];
            
            if (direction == 0)
            {
                [tmpDic setObject:@"NORMAL" forKey:@"STATUS"];
                //NSLog(@"%@", self.resultArray);
                [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
                [self.delegate remove];
            }
            else
            {
                if (self.resultArray && [self.resultArray count] > 0)
                {
                    [self disSubscribe:awbCode];
                    [self.resultArray removeObject:tmpDic];
                    [self.contentArray removeObject:tmpDic1];
                    [self.cttableView deleteSections:[[NSIndexSet alloc] initWithIndex:[self.cttableView indexPathForCell:cell].section] withRowAnimation:UITableViewRowAnimationFade];
                    [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
                    [self performSelector:@selector(deleteCell) withObject:nil afterDelay:0.2];
                }
            }
        }
    }
}

- (void)deleteCell
{
    [self.delegate remove];
}

#pragma mark  -  从文件中读数据，初始化
- (void)initDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"tracelist.plist")])
    {
        self.resultArray = [[NSMutableArray alloc] init];
    }
    else
    {
        self.resultArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
    }
    
    //NSLog(@" -22323   NSMutableArray *resultArray = -- %@",   self.resultArray  );
}

#pragma mark  -  更新本地数据
//- (void)refreshDataFromSever{
//    
//    int count =  self.contentArray.count;
//    NSString * waybillcode = nil;
//    
//    for (int index = 0; index < count;index++)
//    {
//        waybillcode = [NSString stringWithFormat:@"%@-%@", [[self.contentArray objectAtIndex:index] objectForKey: @"AIRCOMPANYCODE"], [[self.contentArray objectAtIndex:index] objectForKey: @"MAWBCODE"] ];
//        
//        [[self.contentArray objectAtIndex:index] objectForKey: @"AIRCOMPANYCODE"];
//        NSLog(@" -refresh--- %d   --- %@"  , index,waybillcode);
//        
//        if (![waybillcode isEqual: @""])
//        {
//            QueryTraceUtil *util = [[QueryTraceUtil alloc] init];
//            util.delegate = self;
//            [util setDidBookingMawbCode:@selector(refreshRequestFinished:)];
//            
////            BOOL subscribe = NO;
////            
////            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////            
////            NSString *postString = [NSString stringWithFormat:
////                                    @"<eFreightService>"
////                                    @"<ServiceURL>Subscribe</ServiceURL>"
////                                    @"<ServiceAction>TRANSACTION</ServiceAction>"
////                                    @"<ServiceData>"
////                                    @"<Subscribe>"
////                                    @"<type>traceAndAlarm</type><target>%@</target><targettype>MAWB</targettype>"
////                                    @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
////                                    @"<standard_type>2</standard_type>"
////                                    @"</Subscribe>"
////                                    @"</ServiceData>"
////                                    @"</eFreightService>",
////                                    waybillcode,
////                                    subscribe ? @"N" : @"Y",
////                                    appDelegate.token,
////                                    subscribe ? @"IOS" : @"NONE"];
////            
////            [util PostForASync:postString withURL:URL_POST];
//            
//            NSDictionary * dic =[ [NSDictionary alloc] initWithObjectsAndKeys:
//                                 waybillcode,@"mawbCode",
//                                 @"",@"orginData",
//                                 [NSNumber numberWithBool:NO],@"subscribe",
//                                 [NSNumber numberWithBool:NO],@"bookingMode",
//                                 nil];
//            
//            [NSThread detachNewThreadSelector:@selector(bookingWaybillInfo:) toTarget:util withObject:dic];
//        }
//    }
//}
- (void)disSubscribe:(NSString *)waybillcode
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (_disTraceSubscribeUtil)
    {
        [_disTraceSubscribeUtil StopFunction];
        _disTraceSubscribeUtil = nil;
    }
    
    _disTraceSubscribeUtil = [[QueryTraceUtil alloc] init];
    _disTraceSubscribeUtil.delegate = self;
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate = [NSDate date];
    NSString *dateStr = [formater stringFromDate:tmpDate];
    
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
                            waybillcode,
                            @"N",
                            appDelegate.token,
                            @"IOS",
                            @"<offflag>1</offflag>",
                            dateStr];
    
    NSLog(@"%@", postString);
    [_disTraceSubscribeUtil PostForASync:postString withURL:URL_POST];
    
//    postString = [NSString stringWithFormat:
//                  @"<eFreightService>"
//                  @"<ServiceURL>Subscribe</ServiceURL>"
//                  @"<ServiceAction>TRANSACTION</ServiceAction>"
//                  @"<ServiceData>"
//                  @"<Subscribe>"
//                  @"<type>alarm</type><target>%@</target><targettype>MAWB</targettype>"
//                  @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
//                  @"<standard_type>3</standard_type>"
//                  @"<limit_num>-1</limit_num>"
//                  @"%@"
//                  @"<systime>%@</systime>"
//                  @"</Subscribe>"
//                  @"</ServiceData>"
//                  @"</eFreightService>",
//                  waybillcode,
//                  @"N",
//                  appDelegate.token,
//                  @"NONE",
//                  @"<offflag>1</offflag>",
//                  dateStr];
//    
//    [_disTraceSubscribeUtil PostForASync:postString withURL:URL_POST];
    
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
        [postDic setObject:@"0" forKey:@"ops"];
        [postDic setObject:waybillcode forKey:@"awbnum"];
        [postDic setObject:@"IOS" forKey:@"resource"];
    }
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    postString = [jsonParser stringWithObject:postDic];
    NSLog(@"%@", postString);
    [_weixinUtil PostWeixin:postString withURL:URL_WEIXIN];
}

#pragma mark  -  更新本地数据
- (void)refreshDataFromSever
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    [_queryTraceUtil setDelegate:self];
    
    NSString * waybillcode = nil;
    
    for (int i = 0; i < [self.resultArray count]; i++)
    {
        NSMutableDictionary *tmpDic = [self.resultArray objectAtIndex:i];
        
        waybillcode = [NSString stringWithFormat:@"%@-%@", [tmpDic objectForKey:@"AIRCOMPANYCODE"], [tmpDic objectForKey:@"MAWBCODE"]];
        if ([waybillcode isEqualToString:_awbCode])
        {
            continue;
        }
        NSString *postString = [NSString stringWithFormat:
                                @"<eFreightService>"
                                @"<ServiceURL>Subscribe</ServiceURL>"
                                @"<ServiceAction>TRANSACTION</ServiceAction>"
                                @"<ServiceData>"
                                @"<Subscribe>"
                                @"<type>%@</type><target>%@</target><targettype>MAWB</targettype>"
                                @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
                                @"<standard_type>3</standard_type>"
                                @"<limit_num>0</limit_num>"
                                @"</Subscribe>"
                                @"</ServiceData>"
                                @"</eFreightService>",
                                @"traceAndAlarm",
                                waybillcode,
                                @"N",
                                [AppDelegate ShareAppDelegate].token,
                                @"NONE"];
        
        NSLog(@"%@", postString);
        [_queryTraceUtil PostForASync:postString withURL:URL_POST];
    }
}

- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    if (util == _queryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        NSArray *routesArray = [doc nodesForXPath:@"//route" error:nil];
        NSArray *tracesArray = [doc nodesForXPath:@"//TraceTranslate" error:nil];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        NSMutableArray *traces = [[NSMutableArray alloc] init];//轨迹信息
        NSMutableArray *alarms = [[NSMutableArray alloc] init];
        NSMutableArray *routes = [[NSMutableArray alloc] init];
        
        //NSString *mawbCode = @"";
        
        //traces信息
        for (NSInteger i = 0; i < tracesArray.count; i ++ )
        {
            //mawbCode = [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"AWB_CODE" error:nil]];
            NSMutableDictionary * traceDic = [[NSMutableDictionary alloc] init];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"AWB_CODE" error:nil]] forKey:@"AWB_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"FLIGHT_NO" error:nil]] forKey:@"FLIGHT_NO"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"FLIGHT_DATE" error:nil]] forKey:@"FLIGHT_DATE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"SHIMPENT_PIECE" error:nil]] forKey:@"SHIMPENT_PIECE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"SHIMPENT_WEIGHT" error:nil]]  forKey:@"SHIMPENT_WEIGHT"] ;
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"CARGO_CODE" error:nil]] forKey:@"CARGO_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"CARGO_NAME" error:nil]] forKey:@"CARGO_NAME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"CARGO_ENNAME" error:nil]] forKey:@"CARGO_ENNAME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"TRACE_CODE" error:nil]] forKey:@"TRACE_CODE"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"TRACE_TIME" error:nil]] forKey:@"TRACE_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"TRACE_LOCATION" error:nil]]  forKey:@"TRACE_LOCATION"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"AIRPORT_DEP" error:nil]] forKey:@"AIRPORT_DEP"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"AIRPORT_LAND" error:nil]] forKey:@"AIRPORT_LAND"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"ORIGIN_AIRPORT" error:nil]] forKey:@"ORIGIN_AIRPORT"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"DESTINATION_AIRPORT" error:nil]]  forKey:@"DESTINATION_AIRPORT"];
            NSMutableString *trace_data = [NSMutableString stringWithFormat:@"%@", [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"TRACE_DATA" error:nil]]];
            [trace_data replaceOccurrencesOfString:@"<BR/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, trace_data.length)];
            [traceDic setObject:trace_data  forKey:@"TRACE_DATA"];
            //[traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"STARDARD_DATA" error:nil]] forKey:@"STARDARD_DATA"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"OP_TIME" error:nil]]
                         forKey:@"OP_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i]nodesForXPath:@"OCCUR_TIME" error:nil]] forKey:@"OCCUR_TIME"];
            
            [traces addObject:traceDic];
        }
        
        // NSLog(@"--traces--%@",traces);
        // NSLog(@"--traces count--%d",traces.count);
        
        [dic setObject:[doc nodesForXPath:@"//MAWBCODE" error:nil] forKey:@"MAWBCODE"];
        [dic setObject:[doc nodesForXPath:@"//AIRCOMPANYCODE" error:nil] forKey:@"AIRCOMPANYCODE"];
        [dic setObject:@"NORMAL" forKey:@"STATUS"];
        [dic setObject:alarms forKey:@"ALARMS"];
        [dic setObject:traces forKey:@"TRACES"];
        [dic setObject:routes forKey: @"ROUTES"];
        [dic setObject: [QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_CODE" error:nil]] forKey:@"CARGO_CODE"];
        [dic setObject: [QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_NAME" error:nil]]forKey: @"CARGO_NAME"];
        
        //始发港 目的港 日期 信息
        for (NSInteger i = 0; i < routesArray.count; i ++ )
        {
            if (i == 0)
            {
                [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] ;
                [dic setObject:  [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] forKey:@"DEP_PORT"];
                [dic setObject:  [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"flight_date" error:nil]]forKey: @"FLIGHT_DATE"];
                [dic setObject: [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]]forKey:@"ARR_PORT"];
            }
            else
            {
                [dic setObject: [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]]forKey:@"ARR_PORT"];
            }
        }
        
        // 判断 plist 中是否有重复的历史数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [dic objectForKey:@"AIRCOMPANYCODE"], [dic objectForKey:@"MAWBCODE"]];
        
        NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
        
        NSMutableDictionary *tempData = (NSMutableDictionary *)dic;
        
        //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
        if(existData.count != 0)
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            [tempData setObject:[existObject objectForKey:@"SUBSCRIBE"] forKey:@"SUBSCRIBE"];
            [tempData setObject:[existObject objectForKey:@"STATUS"] forKey:@"STATUS"];
            [self.resultArray removeObject:existObject];
            [self.resultArray insertObject:tempData atIndex:0];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        else
        {
            [tempData setObject:@"YES" forKey:@"SUBSCRIBE"];
            if (![[tempData objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")]
                || ![[tempData objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")]
                || ![tempData objectForKey:@"AIRCOMPANYCODE"] || [[tempData objectForKey:@"AIRCOMPANYCODE"] isEqualToString:@""]
                || ![tempData objectForKey:@"MAWBCODE"] || [[tempData objectForKey:@"MAWBCODE"] isEqualToString:@""])
            {
                return;
            }
            [self.resultArray insertObject:tempData atIndex:0];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:[[NSArray alloc] initWithObjects:existData, nil] waitUntilDone:NO];
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    [[ActiveMaskView SharedIndicator] HideInWindow];
}

- (void)updateUI:(NSArray *)args
{
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    [self dealIndexChange];
}

- (void)gotoDetailTrace:(NSString *)airCompanyCode  mawbCode:(NSString *)mawbCode
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)",airCompanyCode ,mawbCode];
    
    NSArray *existData = [self.contentArray filteredArrayUsingPredicate:predicate];
    
    //NSLog(@"existData   %@",existData);
    
    if (existData.count > 0)
    {
        [MobClick event:@"进入运单轨迹页面"];
        WaybillDetailViewController * waybillDetailController = nil;
        if (IS_IPHONE_5)
        {
            waybillDetailController = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewController" bundle:nil];
        }
        else
        {
            waybillDetailController = [[WaybillDetailViewController alloc]initWithNibName:@"WaybillDetailViewControllerSmall" bundle:nil];
        }
        waybillDetailController.data = [existData objectAtIndex:0];
        waybillDetailController.waybillcode = _strCode;
        waybillDetailController.cargocode = @"";
        [self.navController pushViewController:waybillDetailController animated:YES];
    }
}

#pragma mark - tabelView fuctions
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.contentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaybillTabelViewCell";
    
    WaybillTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WaybillTabelViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell laySubviews];
    }
    
    NSDictionary *tempDic = [self.contentArray objectAtIndex:indexPath.section];
    cell.tag = indexPath.section;
    NSString *waybillcode = [NSString stringWithFormat:@"%@-%@", [tempDic objectForKey:@"AIRCOMPANYCODE"],[tempDic objectForKey:@"MAWBCODE"]];
    cell.detailNumber.text = [NSString stringWithFormat:@"%@ %@", [waybillcode substringToIndex:8], [[waybillcode substringFromIndex:8] substringToIndex:4]];
    if ([tempDic objectForKey:@"DEP_PORT"] == NULL || [tempDic objectForKey:@"ARR_PORT"] == NULL) {
        cell.detailAirpostInfo.text = @"";
    }else{
        cell.detailAirpostInfo.text = [NSString stringWithFormat:@"%@>%@", [tempDic objectForKey:@"DEP_PORT"],[tempDic objectForKey:@"ARR_PORT"]];
    }

    if ([[tempDic objectForKey:@"STATUS"] isEqualToString:@"WARNING"])
    {
        cell.detailState.text = @"状态异常";
        cell.bigLetter.textColor = [CommonUtil colorWithHexString:@"#c75134"];
        cell.simpleState.textColor = [CommonUtil colorWithHexString:@"#c75134"];
        cell.detailNumber.textColor = [CommonUtil colorWithHexString:@"#c75134"];
        cell.detailState.textColor = [CommonUtil colorWithHexString:@"#c75134"];
        cell.leftView.backgroundColor = [CommonUtil colorWithHexString:@"#f5d2ba"];
        cell.arrowImageView.image = [UIImage imageNamed:@"e_home_cellarrow_h.png"];//[CommonUtil CreateImage:@"e_home_cellarrow_h" withType:@"png"];
        cell.direction = WaybillTabelViewCellDirectionBoth;
    }
    else
    {
        cell.detailState.text = @"状态正常";
        cell.bigLetter.textColor = [CommonUtil colorWithHexString:@"#348ac7"];
        cell.simpleState.textColor = [CommonUtil colorWithHexString:@"#007EA7"];
        cell.detailNumber.textColor = [CommonUtil colorWithHexString:@"#55a6e0"];
        cell.detailAirpostInfo.textColor = [CommonUtil colorWithHexString:@"#444444"];
        cell.detailState.textColor = [CommonUtil colorWithHexString:@"#7d7d7d"];
        cell.leftView.backgroundColor = [CommonUtil colorWithHexString:@"#bae0f6"];
        cell.arrowImageView.image = [UIImage imageNamed:@"e_home_cellarrow.png"];//[CommonUtil CreateImage:@"e_home_cellarrow" withType:@"png"];
        cell.direction = WaybillTabelViewCellDirectionRight;
    }
    
    if((![[tempDic objectForKey:@"STATUS"] isEqualToString:@"WARNING"] ) && (![[tempDic objectForKey:@"STATUS"] isEqualToString:@"NORMAL"]))
    {
        cell.detailState.text = @"暂无信息";
        cell.time.hidden = YES;
    }
    
    if ([[tempDic objectForKey:@"TRACES"] count] == 0)
    {
        cell.detailState.text = @"暂无信息";
        cell.time.hidden = YES;
    }
    else
    {
        NSArray *tmpArray = [tempDic objectForKey:@"TRACES"];
        for (NSDictionary *tmpDic in tmpArray)
        {
            NSString *tmpStr = [tmpDic objectForKey:@"OP_TIME"];
            
            if (![tmpStr isEqualToString:@""])
            {
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateTime = [formater dateFromString:[tmpStr substringToIndex:10]];
                NSTimeInterval timeInterval = [dateTime timeIntervalSinceNow];
                timeInterval = - timeInterval;
                long days = ((long)timeInterval)/(3600*24);
                NSString *time = @"";
                if (days == 0)
                {
                    time = [NSString stringWithFormat:@"最新：今天 %@", [tmpStr substringFromIndex:10]];
                }
                else if (days == 1)
                {
                    time = [NSString stringWithFormat:@"最新：昨天 %@", [tmpStr substringFromIndex:10]];
                }
                else
                {
                    time = [NSString stringWithFormat:@"最新：%d月%d日 %@", [[[tmpStr substringFromIndex:5] substringToIndex:2] intValue], [[[tmpStr substringFromIndex:8] substringToIndex:2] intValue], [tmpStr substringFromIndex:10]];
                }
                cell.time.text = time;
                cell.time.hidden = NO;
                cell.time.textColor = [CommonUtil colorWithHexString:@"#bbbbbb"];
            }
        }
    }
    
    if (([tempDic objectForKey:@"CARGO_CODE"] == NULL)||([[tempDic objectForKey:@"CARGO_CODE"] isEqualToString:@""] ) ) {
        cell.bigLetter.text = @"";
        cell.nanImage.hidden = NO;
    }else{
        cell.bigLetter.text = [tempDic objectForKey:@"CARGO_CODE"];
        cell.nanImage.hidden = YES;
      }
    
    cell.simpleState.text = [tempDic objectForKey:@"CARGO_NAME"];
    
    for (id view in [cell subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"UIImageView")])
        {
            [view removeFromSuperview];
        }
    }
	cell.delegate = self;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDic = [self.contentArray objectAtIndex:indexPath.section];
    _strCode = [NSString stringWithFormat:@"%@-%@", [tempDic objectForKey:@"AIRCOMPANYCODE"],[tempDic objectForKey:@"MAWBCODE"]];
    [self gotoDetailTrace:[tempDic objectForKey:@"AIRCOMPANYCODE"] mawbCode:[tempDic objectForKey:@"MAWBCODE"]];
    //[self willShowDetailTrace];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    return tmpView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isButtonAction)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval animationDuration = 0.4;
            // The block-based equivalent doesn't play well with iOS 4
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            cell.layer.opacity = 0;
            cell.layer.opacity = 1.0f;
            [UIView commitAnimations];
        });
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [MobClick event:@"运单列表向上滑动"];
    self.currentlyRevealedCell = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:[NSNumber numberWithInt:0] userInfo:nil];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //NSLog(@"velocity = (%f, %f)", velocity.x, velocity.y);
    //NSLog(@"targetContentOffset = (%f, %f)", targetContentOffset->x, targetContentOffset->y);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Slide" object:nil userInfo:nil];
}

@end
