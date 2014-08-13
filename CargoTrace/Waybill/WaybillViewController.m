//
//  WaybillViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "WaybillViewController.h"
#import "CTTabbarViewController.h"
#import "CommonUtil.h"
#import "WaybillCTTabbarContentViewController.h"

@interface WaybillViewController ()

@end

@implementation WaybillViewController
@synthesize ctTabbarViewController = _ctTabbarViewController;
//@synthesize existData = _existData;
@synthesize awbCode = _awbCode;
//@synthesize tabContentArray = _tabContentArray;
@synthesize resultArray = _resultArray;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setTabbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self setTitle:@"指尖货运"];
    [self setNavbar];
    [self.view setBackgroundColor:[UIColor colorWithRed:223/255.f green:223/255.f blue:223/255.f alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //NSLog(@"%@", object);
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSString *tmpStr = [object objectForKey:@"STATUS"];
            NSString *tmpStr1 = [object objectForKey:@"CARGO_CODE"];
            if ([tmpStr1 isEqualToString:@"DLV"])
            {
                [historyArray addObject:object];
                //[allArray removeObject:object];
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
        CGSize constraintSize = CGSizeMake(30, MAXFLOAT);
        self.ctTabbarViewController.messageAll.text = [NSString stringWithFormat:@"%d", [allArray count]];
        CGSize labelSize1 = [self.ctTabbarViewController.messageAll.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageAll.frame = CGRectMake(self.ctTabbarViewController.messageAll.frame.origin.x, self.ctTabbarViewController.messageAll.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageAll.frame.size.height);
        self.ctTabbarViewController.messageNomarl.text = [NSString stringWithFormat:@"%d", [normalArray count]];
        labelSize1 = [self.ctTabbarViewController.messageNomarl.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageNomarl.frame = CGRectMake(self.ctTabbarViewController.messageNomarl.frame.origin.x, self.ctTabbarViewController.messageNomarl.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageNomarl.frame.size.height);
        self.ctTabbarViewController.messageHistory.text = [NSString stringWithFormat:@"%d", [historyArray count]];
        labelSize1 = [self.ctTabbarViewController.messageHistory.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        self.ctTabbarViewController.messageHistory.frame = CGRectMake(self.ctTabbarViewController.messageHistory.frame.origin.x, self.ctTabbarViewController.messageHistory.frame.origin.y, labelSize1.width+5, self.ctTabbarViewController.messageHistory.frame.size.height);
        
        if (_listViewController)
        {
            _listViewController.allArray = allArray;
            _listViewController.alarmArray = alarmArray;
            _listViewController.normalArray = normalArray;
            _listViewController.historyArray = historyArray;
            
            [_listViewController dealIndexChange];
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
    }
    else
    {
        self.resultArray = [NSMutableArray arrayWithContentsOfFile:LISTFILE(@"tracelist.plist")];
    }
    //NSLog(@" -self.resultArray.count -- %d",self.resultArray.count);
    //NSLog(@" -22323 LISTFILE -- %@",LISTFILE(@"tracelist.plist"));
}

//- (void)guidImageViewClicked
//{
//    [guidBtn removeFromSuperview];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guidWaybill"];
//}

#pragma mark  -  tab 设置
- (void)setTabbar
{
    [self initDataFromPlist];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guidWaybill"] && [self.resultArray count] > 0)
//    {
//        guidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        guidBtn.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//        if(IS_IPHONE_5)
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_list" withType:@"png"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_list_s" withType:@"png"] forState:UIControlStateNormal];
//        }
//        [guidBtn addTarget:self
//                    action:@selector(guidImageViewClicked)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.view addSubview:guidBtn];
//    }
    
    if (!_listViewController)
    {
        _listViewController = [[WaybillCTTabbarContentViewController alloc]initWithNibName:@"WaybillCTTabbarContentViewController" bundle:nil];
    }
   
    _listViewController.navController = self.navigationController;
    _listViewController.willRefresh = YES;
    _listViewController.delegate = self;
    _listViewController.awbCode = self.awbCode;
    //listViewController.index = 0;
  
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:_listViewController,nil];
    
    self.ctTabbarViewController = [[CTTabbarViewController alloc]initWithNibName:@"CTTabbarViewController" bundle:nil];
    [self.ctTabbarViewController setContentArray:viewControllers];
 
    [self.view addSubview:[self.ctTabbarViewController.view.subviews objectAtIndex:0]];
    [self.ctTabbarViewController.ctTabbarView setFrame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - 53)];
    [self.ctTabbarViewController addCurrentChildTab:nil];
    [self analyzeData];
 
}

- (void)setAwbCodeStatus:(NSString *)code status:(NSString *)status
{

}


#pragma mark  -  导航栏 设置
- (void)setNavbar
{
    self.navigationController.title = nil;
    [self setTitle:@"指尖货运"];
   
    UIButton *rodoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem=redoButtonItem;
}
 
- (void)goback
{
    [MobClick event:@"从运单列表页面返回运单订阅页面"];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - reply the search batton
- (IBAction)SearchEcho:(id)sender
{
    //NSLog(@"-----%@", NSStringFromSelector(_cmd));
    [MobClick event:@"从运单列表页面返回运单订阅页面"];
    [self.navigationController popViewControllerAnimated:YES];
    
//    self.searchController = [[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil]autorelease];
//    [self.navigationController pushViewController:_searchController animated:YES];
}
@end
