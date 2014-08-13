//
//  HomeViewController.m
//  CargoTrace
//
//  Created by efreight on 13-4-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "HomeViewController.h"
#import "DDMenuController.h"
#import "SettingLeftSideBarViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CTTabbarViewController.h"
#import "SearchViewController.h"
#import "CTGridView.h"
#import "CommonUtil.h"
#import "WaybillCTTabbarContentViewController.h"
#import "ASIFormDataRequest.h"
#import "CTGridButton.h"
#import "TACTQueryViewController.h"
#import "CustomerServiceViewController.h"

#define  BUTTONTYPE  100
@interface HomeViewController ()
  
@end

@implementation HomeViewController

@synthesize rootController = _rootController;
@synthesize leftController = _leftController;
@synthesize searchController = _searchController;
@synthesize ctTabbarViewController = _ctTabbarViewController;
@synthesize headImageView = _headImageView;
@synthesize topView = _topView;
@synthesize bottomView = _bottomView;
@synthesize otherView = _otherView;
@synthesize ctgView = _ctgView;
@synthesize otherBottomView = _otherBottomView;
@synthesize otherTopView = _otherTopView;
@synthesize data = _data;
@synthesize buttonArray = _buttonArray;
@synthesize resultArray = _resultArray;
@synthesize queryTraceUtil= _queryTraceUtil;
@synthesize isSubscribed = _isSubscribed;
@synthesize listViewController = _listViewController;
@synthesize guidBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initDataFromPlist];
    if (self.isSubscribed == 1)
    {
        [self addBottomListView];
        [self analyzeData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Slide:)
                                                 name:@"Slide"
                                               object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self initDataFromPlist];
    [self getCompanyData];
    [self setTitle:@"指尖货运"];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self addEventListeners];
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
    NSString *username = [loginDic objectForKey:@"nikename"];
    if (username && ![username isEqualToString:@""])
    {
        self.usernameLabel.text = username;
    }
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//    {
//        guidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        guidBtn.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//        if(IS_IPHONE_5)
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_home" withType:@"png"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_home_s" withType:@"png"] forState:UIControlStateNormal];
//        }
//        [guidBtn addTarget:self
//                    action:@selector(guidImageViewClicked)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.view addSubview:guidBtn];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)guidImageViewClicked
//{
//    [guidBtn removeFromSuperview];
//    [self SearchEcho:nil];
//}

- (IBAction)TACTBtnClicked:(id)sender
{
    [MobClick event:@"点击TACT查询按钮"];
    TACTQueryViewController *vc = nil;
    if (IS_IPHONE_5)
    {
        vc = [[TACTQueryViewController alloc] initWithNibName:@"TACTQueryViewController" bundle:nil];
    }
    else
    {
        vc = [[TACTQueryViewController alloc] initWithNibName:@"TACTQueryViewControllerSmall" bundle:nil];
    }
    UINavigationController *vcNav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentModalViewController:vcNav animated:YES];
}

-(IBAction)CustomerServiceBtnClicked:(id)sender
{
    [MobClick event:@"点击TACT查询按钮"];
    CustomerServiceViewController *vc = [[CustomerServiceViewController alloc] initWithNibName:@"CustomerServiceViewController" bundle:nil];
    UINavigationController *vcNav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentModalViewController:vcNav animated:YES];
}

//分析数组
- (void)analyzeData
{
    NSMutableArray *allArray = [self.resultArray mutableCopy];
    NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *normalArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *historyArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in self.resultArray)
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSString *tmpStr = [object objectForKey:@"STATUS"];
            NSString *tmpStr1 = [object objectForKey:@"CARGO_CODE"];
            if ([tmpStr1 isEqualToString:@"DLV"])
            {
                [historyArray addObject:object];
                continue;
            }
            
            if ([tmpStr isEqualToString:@"WARNING"])
            {
                [alarmArray addObject:object];
                continue;
            }
            
            [normalArray addObject:object];
        }
    }
    
    if (self.ctTabbarViewController)
    {
        UIFont *cellFont = [UIFont systemFontOfSize:14];
        CGSize constraintSize = CGSizeMake(35, MAXFLOAT);
        self.ctTabbarViewController.messageAll.text = [NSString stringWithFormat:@"%d", [allArray count]];
        CGSize labelSize1 = [self.ctTabbarViewController.messageAll.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageAll.frame = CGRectMake(self.ctTabbarViewController.messageAll.frame.origin.x, self.ctTabbarViewController.messageAll.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageAll.frame.size.height);
        self.ctTabbarViewController.messageNomarl.text = [NSString stringWithFormat:@"%d", [normalArray count]];
        labelSize1 = [self.ctTabbarViewController.messageNomarl.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageNomarl.frame = CGRectMake(self.ctTabbarViewController.messageNomarl.frame.origin.x, self.ctTabbarViewController.messageNomarl.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageNomarl.frame.size.height);
        self.ctTabbarViewController.messageHistory.text = [NSString stringWithFormat:@"%d", [historyArray count]];
        labelSize1 = [self.ctTabbarViewController.messageHistory.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageHistory.frame = CGRectMake(self.ctTabbarViewController.messageHistory.frame.origin.x, self.ctTabbarViewController.messageHistory.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageHistory.frame.size.height);
        if (self.ctTabbarViewController.contentArray && [self.ctTabbarViewController.contentArray count] > 0)
        {
            WaybillCTTabbarContentViewController *tmpWaybillCTTabbarContentViewController = (WaybillCTTabbarContentViewController *)[self.ctTabbarViewController.contentArray objectAtIndex:0];
            if (tmpWaybillCTTabbarContentViewController)
            {
                tmpWaybillCTTabbarContentViewController.allArray = allArray;
                tmpWaybillCTTabbarContentViewController.alarmArray = alarmArray;
                tmpWaybillCTTabbarContentViewController.normalArray = normalArray;
                tmpWaybillCTTabbarContentViewController.historyArray = historyArray;
                
                [tmpWaybillCTTabbarContentViewController dealIndexChange];
                
                switch (tmpWaybillCTTabbarContentViewController.index)
                {
                    case 0:
                        [self.ctTabbarViewController showAll:nil];
                        break;
                    case 2:
                        [self.ctTabbarViewController showNormal:nil];
                        break;
                    case 3:
                        [self.ctTabbarViewController showHistory:nil];
                        break;
                    default:
                        break;
                }
            }
        }
    } 
}

- (void)remove
{
    [self initDataFromPlist];
    [self analyzeData];
}

#pragma mark  -  从文件中读数据，初始化
- (void)initDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"tracelist.plist")])
    {
        self.resultArray = [[NSMutableArray alloc] init];
        self.isSubscribed = 0;
        self.buttonArray = [[NSMutableArray alloc] initWithCapacity:40];
    }
    else
    {
        self.resultArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
        self.isSubscribed = 1;
    }
}

#pragma mark -  初始化 gridview data of companys
- (void)getCompanyData
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
    //.2f表示精确到小数点后两位
    NSString *postString = @"<Service>"
                           @"<ServiceURL>TraceTranslate</ServiceURL>"
                           @"<ServiceAction>querySupportAirCompany</ServiceAction>"
                           @"<ServiceData>"
                           @"</ServiceData>"
                           @"</Service>";
    
    //发送异步请求
    [_queryTraceUtil PostForASync:postString withURL:URL_POST];
}

- (void)saveAirCompanys:(NSArray *)aircompanyList
{
    [self initFileDir];
    if (!aircompanyList || aircompanyList.count == 0)
    {
        self.data = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"companylist.plist")];
    }
    else
    {
        self.data = aircompanyList;
        [self.data writeToFile:LISTFILE(@"companylist.plist") atomically:YES];
    }
    
    if (self.isSubscribed == 0)
    {
        [self addBottomGridView];
    }
    else
    {
        [self addBottomListView];
        [self analyzeData];
    }
}

#pragma mark - QueryTraceUtilDelegate
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    if (util == _queryTraceUtil)
    {
        NSError *err = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        
        if(err != nil)
        {
            NSArray *aircompany = [CommonUtil getCompanys];
            [self saveAirCompanys:aircompany];
        }
        else
        {
            NSArray *aircompany = [doc nodesForXPath:@"//aircompany" error:nil];
            if (nil == aircompany || [aircompany count] == 0)
            {
                aircompany = [CommonUtil getCompanys];
            }
            
            NSMutableArray *aircompanyList = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < aircompany.count; i++)
            {
                GDataXMLNode *aircompanyNode = [aircompany objectAtIndex:i];
                
                NSString *aircompanyCode = [QueryTraceUtil getElementString:[aircompanyNode nodesForXPath:@"ac_code3c" error:nil]];
                NSString *aircompanyName = [QueryTraceUtil getElementString:[aircompanyNode nodesForXPath:@"cnname" error:nil]];
                NSLog(@"第%d个公司：%@", i + 1, aircompanyName);
                NSString *url = [NSString stringWithFormat:@"http://efreight.cn/services/tracking/images/airline/%@.logo.png", [QueryTraceUtil getElementString:[aircompanyNode nodesForXPath:@"ac_code2c" error:nil]]];
                NSLog(@"第%d个图标：%@", i + 1, url);
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:aircompanyCode,@"CODE",aircompanyName,@"NAME",url,@"URL", nil];
                
                [aircompanyList addObject:dic];
            }
            
            [self saveAirCompanys:aircompanyList];
        }
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:@"航空公司信息获取失败，请检查网络状态！"];
    NSArray *aircompany = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"companylist.plist")];
    if (nil == aircompany || [aircompany count] == 0)
    {
        aircompany = [CommonUtil getCompanys];
        [self saveAirCompanys:aircompany];
    }
    else
    {
        self.data = aircompany;
    }
}

- (void)downloadImage:(NSNumber *)indexObj
{
    [NSThread sleepForTimeInterval:0.5];
    int index = [indexObj intValue];
    CTGridButton * button =  [self.buttonArray objectAtIndex:index];
    
    NSURL *url = [NSURL URLWithString:[[self.data objectAtIndex:index] objectForKey:@"URL"]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    if (request.error == nil)
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:button,@"BUTTON", nil];
        request.userInfo = dic;
        dic = nil;
        
        [request.responseData writeToFile:GETLOGOFILE(button.companyCode) atomically:YES];
        [self performSelectorOnMainThread:@selector(updateLogo:) withObject:request waitUntilDone:YES];
    }
    
    request = nil;
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
}

- (void)updateLogo:(ASIHTTPRequest *)request
{
    CTGridButton * button = [request.userInfo objectForKey:@"BUTTON"];
    
    CALayer *templayer = [[CALayer alloc]init];
    
    templayer.contents  =(id)[UIImage imageWithData:request.responseData].CGImage;
    [templayer setFrame:CGRectMake(5, 5, 50, 50)];
    [button.layer replaceSublayer:[button.layer.sublayers objectAtIndex:0] with:templayer];
}

#pragma mark -  初始化  file dir
- (void)initFileDir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:GETLOGOFOLDER()]) {
       [manager createDirectoryAtPath:GETLOGOFOLDER() withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark  -  从文件中读数据，初始化
- (void)initCompanyDataFromPlist
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:LISTFILE(@"companylist.plist")]){
        self.data = [[NSMutableArray alloc] init];
    }else{
        self.data = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"companylist.plist")];
    }
}

#pragma mark -  添加 bottom  list view
- (void)addBottomListView
{
    [self.ctgView removeFromSuperview];
    [self.ctTabbarViewController.view removeFromSuperview];
    self.ctTabbarViewController = nil;
    
    if (!_listViewController)
    {
        _listViewController = [[WaybillCTTabbarContentViewController alloc] initWithNibName:@"WaybillCTTabbarContentViewController" bundle:nil];
        _listViewController.navController = self.navigationController;
        _listViewController.willRefresh = NO;
        _listViewController.delegate = self;
    }
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:_listViewController, nil];
    
    if (!self.ctTabbarViewController)
    {
        self.ctTabbarViewController = [[CTTabbarViewController alloc] initWithNibName:@"CTTabbarViewController" bundle:nil];
    }
    [self.ctTabbarViewController setContentArray:viewControllers];
             
    if(IS_IPHONE_5)
    {
       [self.otherBottomView addSubview:[self.ctTabbarViewController.view.subviews objectAtIndex:0]];
       [self.ctTabbarViewController.ctTabbarView setFrame: CGRectMake(0,0,320,self.otherBottomView.frame.size.height)];
    }
    else
    {
       [self.bottomView addSubview:[self.ctTabbarViewController.view.subviews objectAtIndex:0]];
       [self.ctTabbarViewController.ctTabbarView setFrame:CGRectMake(0,0,320,self.bottomView.frame.size.height)];
    }
    
    [self.ctTabbarViewController addCurrentChildTab:nil];
}

#pragma mark -  添加 bottom  grid view 
- (void)addBottomGridView
{
    [self.ctTabbarViewController.view removeFromSuperview];
    [self.ctgView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    
    //定义PageControll
    UIPageControl *pageControl = [[UIPageControl alloc] init] ; 
    self.pageControl = pageControl;
    
    if (IS_IPHONE_5)
    {
        self.pageControl.frame = CGRectMake(135, 215, 50, 20);
    }
    else
    {
        self.pageControl.frame = CGRectMake(135, 145, 50, 20);
    }
 //    
    if(IS_IPHONE_5)
    {
        CTGridView *tmp = [[CTGridView alloc] initWithFrame: CGRectMake(0, 0, self.otherBottomView.frame.size.width, _otherBottomView.frame.size.height)];
        self.ctgView = tmp;
        
        self.ctgView.delegateHome = self;
        self.ctgView.delegate = self;
        [self.otherBottomView addSubview:self.ctgView];
        [self.otherBottomView addSubview:self.pageControl];
    }
    else
    {
        CTGridView *tmp = [[CTGridView alloc]initWithFrame: CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height)];
        self.ctgView = tmp;
        self.ctgView.delegateHome = self;
        self.ctgView.delegate = self;
        [self.bottomView addSubview:self.ctgView];
        [self.bottomView addSubview:self.pageControl];
    }
     
    int num = self.data.count;
    if (num != 0)
    {
    
        for (int index_num = 0 ; index_num < num; index_num ++)
        {
            //这里创建一个圆角矩形的按钮
            CTGridButton *but = [[CTGridButton alloc]init];
            but.tag = index_num;
            but.companyCode =  [[self.data objectAtIndex:index_num] objectForKey:@"CODE"];
            but.companyName = [[self.data objectAtIndex:index_num] objectForKey:@"NAME"];
            but.companyIntTag = index_num;
            CALayer *templayer = [[CALayer alloc]init];
        
            templayer.contents  = (id)[UIImage imageNamed:@"airplane"].CGImage;
            [templayer setFrame:CGRectMake(5, 5, 50, 50)];
            [but.layer addSublayer:templayer];
        
            NSFileManager *manager = [NSFileManager defaultManager];
            if (![manager fileExistsAtPath:GETLOGOFILE(but.companyCode)])
            {
                [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject: [NSNumber numberWithInt:index_num]];
            }
            else
            {
                templayer.contents = (id)[UIImage imageWithData:[NSData dataWithContentsOfFile:GETLOGOFILE(but.companyCode)]].CGImage;
                [but.layer addSublayer:templayer];
            }
       
            [self.buttonArray addObject:but];

        
            but = nil;
        }
        self.ctgView.gridButtonArray = nil;
        self.ctgView.gridButtonArray = self.buttonArray;
        [self.ctgView setGridButtonsDeploy];
    
        int pages = 1;
        if (IS_IPHONE_5)
        {
            ((num/12.0 - num/12) > 0) ? (pages = num/12 + 1) : (pages = num/12);
        }
        else
        {
            ((num/8.0 - num/8) > 0) ? (pages = num/8 + 1) : (pages = num/8);
        }
        
        self.pageControl.numberOfPages = pages;  
        self.pageControl.currentPage = 0; 
        [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - pagecontroll的委托方法
- (IBAction)changePage:(id)sender
{
    int page = self.pageControl.currentPage;
    [self.ctgView setContentOffset:CGPointMake(308 * page, 0)];
}

#pragma mark -scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
     int page = self.ctgView.contentOffset.x/290;
     self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sender
{
    
}

#pragma mark - navController left & right button

- (void)showLeftSideBarSettingPage
{
    
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
        [self addBottomListView];
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
        self.usernameLabel.text = [loginDic objectForKey:@"nikename"];
    }
    else if ([tmpStr isEqualToString:LOGOUT])
    {
        self.usernameLabel.text = @"未登录";
    }
    else
    {
        [self addBottomGridView];
    }
}

#pragma mark - reply the search button
- (IBAction)SearchEcho:(id)sender
{
    [MobClick event:@"点击运单订阅按钮"];
    if (IS_IPHONE_5) {
          self.searchController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    }else{
          self.searchController = [[SearchViewController alloc]initWithNibName:@"SearchViewControllerSmall" bundle:nil];
    }
    self.searchController.companyArray = self.data;
    [self.navigationController pushViewController:_searchController animated:YES];
}

#pragma mark - 响应 delegate的方法 gridbutton 的点击事件。
- (void)delgateAction:(NSString *)code
{
    if (IS_IPHONE_5) {
        self.searchController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    }else{
        self.searchController = [[SearchViewController alloc]initWithNibName:@"SearchViewControllerSmall" bundle:nil];
    }
    
    self.searchController.companyArray = self.data;
    self.searchController.compayCode = code;
    [self.navigationController pushViewController:_searchController animated:YES];
}

#pragma mark - CustomTouchViewDelegate
- (void)Slide:(NSNotification *)notification
{
    int flag = [notification.object intValue];
    if (flag == 0)
    {
        self.otherTopView.hidden = YES;
        self.topView.hidden = YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if (IS_IPHONE_5)
        {
            [self.otherBottomView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 53)];
            [self.ctTabbarViewController.ctTabbarView setFrame:self.otherBottomView.frame];
        }
        else
        {
            [self.bottomView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 53)];
            [self.ctTabbarViewController.ctTabbarView setFrame:self.bottomView.frame];
        }
        
        [UIView commitAnimations];
    }
    else if (flag == 1)
    {
        self.otherTopView.hidden = NO;
        self.topView.hidden = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if (IS_IPHONE_5)
        {
            [self.otherBottomView setFrame:CGRectMake(0, 215, 320, 236)];
            [self.ctTabbarViewController.ctTabbarView setFrame:CGRectMake(0, 0, 320, 236)];
        }
        else
        {
            [self.bottomView setFrame:CGRectMake(0, 195, 320, 168)];
            [self.ctTabbarViewController.ctTabbarView setFrame:CGRectMake(0, 0, 320, 168)];
        }
        
        [UIView commitAnimations];
    }
    else if (flag == 2)
    {
        [self initDataFromPlist];
        [self analyzeData];
    }
    else if (flag == 3)
    {
        [self initDataFromPlist];
        if (self.isSubscribed == 1)
        {
            [self addBottomListView];
            [self analyzeData];
        }
    }
}

- (void)dealloc {
    [self removeEventListeners];
}

@end
