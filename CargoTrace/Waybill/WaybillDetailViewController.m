//
//  WaybillDetailViewController.m
//  CargoTrace
//
//  Created by efreight on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "WaybillDetailViewController.h"
#import "SEFilterControl.h"
#import "TreeViewNode.h"
#import "TreeViewNodeCell.h"
#import "TreeViewSecondNodeCell.h"
#import "CTProgressbarView.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "SBJSON.h"
#import "WXApi.h"

@interface WaybillDetailViewController (){
    
    
}



@end

@implementation WaybillDetailViewController

@synthesize topView = _topView;
@synthesize displayArray = _displayArray;
@synthesize expandTableView = _expandTableView;
@synthesize nodes = _nodes;
@synthesize indentation = _indentation;
@synthesize progressbar = _progressbar;
@synthesize status = _status;
@synthesize isWarning = _isWarning;
@synthesize alarmCount = _alarmCount;
@synthesize traceCount = _traceCount;
@synthesize data = _data;
@synthesize waybillcode = _waybillcode;
@synthesize cargocode = _cargocode;
@synthesize isSubribe = _isSubribe;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize disTraceSubscribeUtil = _disTraceSubscribeUtil;
@synthesize weixinUtil = _weixinUtil;
@synthesize candyUtil = _candyUtil;
@synthesize resultArray = _resultArray;
@synthesize isNotification = _isNotification;
@synthesize guidBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)guidImageViewClicked
//{
//    [guidBtn removeFromSuperview];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guidDetail"];
//    [self middButAction:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isSubribe = YES;
    //[self setTitle:];
    [self initDataFromPlist];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"guidDetail"])
//    {
//        guidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        guidBtn.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//        if(IS_IPHONE_5)
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_share" withType:@"png"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [guidBtn setImage:[CommonUtil CreateImage:@"guid_share_s" withType:@"png"] forState:UIControlStateNormal];
//        }
//        [guidBtn addTarget:self
//                    action:@selector(guidImageViewClicked)
//          forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.view addSubview:guidBtn];
//    }
    
    //[self initData];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"e_detail_bg.png"]]];
    self.noInfo.textColor = [CommonUtil colorWithHexString:@"#999999"];
    self.noInfo.hidden = YES;
    
    [self addEventListeners];
    
    if (self.waybillcode && ![self.waybillcode isEqualToString:@""])
    {
        [self setTitle:[NSString stringWithFormat:@"%@ %@", [self.waybillcode substringToIndex:8], [[self.waybillcode substringFromIndex:8] substringToIndex:4]]];
    }
    else
    {
        [self setTitle:@"轨迹信息"];
    }
    
    [self.expandTableView setBackgroundColor:[CommonUtil colorWithHexString:@"#ebebeb"]];
    self.topView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
    [self.bottombarView setBackgroundColor:[UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1]];
    
    [self.expandTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
  
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *tmpDate = [NSDate date];
    NSString *dateStr = [formater stringFromDate:tmpDate];
    
    if ([dateStr isEqualToString:@"2013-10-31"])
    {
        UIButton *candyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 35, 25)];
        candyButton.backgroundColor = [UIColor clearColor];
        [candyButton addTarget:self action:@selector(candyClicked) forControlEvents:UIControlEventTouchUpInside];
        [candyButton setImage:[UIImage imageNamed:@"blue_candy.png"] forState: UIControlStateNormal];
        
        //创建candy按钮
        UIBarButtonItem *candyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:candyButton];
        self.navigationItem.rightBarButtonItem = candyButtonItem;
    }

    // set expend table view
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"TreeNodeButtonClicked" object:nil];
    
    // 判断 plist 中是否有重复的历史数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [self.waybillcode substringToIndex:3], [[self.waybillcode substringFromIndex:4] substringToIndex:8]];
    
    NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
    
    //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
    if(existData.count != 0)
    {
        NSMutableDictionary *existObject = [existData objectAtIndex:0];
        
        _isSubribe = [[existObject objectForKey:@"SUBSCRIBE"] boolValue];
        if (_isSubribe)
        {
            [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn_n" withType:@"png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn" withType:@"png"] forState:UIControlStateNormal];
        }
        
        self.data = existObject;
        self.cargocode = [existObject objectForKey:@"CARGO_CODE"];
        if (![self.cargocode isEqualToString:@"NAN"])
        {
            [self filterValueChanged];
            [self updateUI];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"正在查询订单轨迹"];
        }
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在查询订单轨迹"];
    }
    
    [self refreshDataFromSever];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  导航栏 设置
- (void)queryCandy
{
    if (_candyUtil)
    {
        [_candyUtil StopFunction];
        _candyUtil = nil;
    }
    
    _candyUtil = [[QueryTraceUtil alloc] init];
    _candyUtil.delegate = self;
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:@"query" forKey:@"action"];
    [postDic setObject:@"123" forKey:@"openid"];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSString *postString = [jsonParser stringWithObject:postDic];
    
    [_candyUtil PostWeixin:postString withURL:URL_CANDY];
}

- (void)candyClicked
{
    [self queryCandy];
}

- (void)goback
{
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    if (_disTraceSubscribeUtil)
    {
        [_disTraceSubscribeUtil StopFunction];
        _disTraceSubscribeUtil = nil;
    }
    
    [MobClick event:@"从运单轨迹页面返回"];
    if (_isNotification)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [[self navigationController]popViewControllerAnimated:YES];
    }
}

#pragma mark - 相应 滑竿的变动
- (void)filterValueChanged
{
    if ([self.cargocode isEqualToString:@"BKD"] || [self.cargocode isEqualToString:@"FWB"]
        || [self.cargocode isEqualToString:@"RCS"] || [self.cargocode isEqualToString:@"PRE"]
        || [self.cargocode isEqualToString:@"MAN"] || [self.cargocode isEqualToString:@"MAN-SPLIT"])
    {
        [self setCurrentSectionIndex:0];
    }
    else if ([self.cargocode isEqualToString:@"DLV"])
    {
        [self setCurrentSectionIndex:2];
    }
    else if ([self.cargocode isEqualToString:@"NAN"] || [self.cargocode isEqualToString:@""])
    {
        [self setCurrentSectionIndex:3];
    }
    else
    {
        [self setCurrentSectionIndex:1];
    }
}

- (void)setCurrentSectionIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            self.label1.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.label2.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.label3.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.lineView1.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
            self.lineView2.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
            self.lineView3.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
        }
            break;
        case 1:
        {
            self.label1.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.label2.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.label3.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.lineView1.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
            self.lineView2.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
            self.lineView3.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
        }
            break;
        case 2:
        {
            self.label1.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.label2.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.label3.textColor = [CommonUtil colorWithHexString:@"#4092cd"];
            self.lineView1.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
            self.lineView2.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
            self.lineView3.backgroundColor = [CommonUtil colorWithHexString:@"#55a6e0"];
        }
            break;
        case 3:
        {
            self.label1.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.label2.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.label3.textColor = [CommonUtil colorWithHexString:@"#999999"];
            self.lineView1.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
            self.lineView2.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
            self.lineView3.backgroundColor = [CommonUtil colorWithHexString:@"#c6c6c6"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Messages to fill the tree nodes and the display array
//This function is used to expand and collapse the node as a response to the TreeNodeButtonClicked notification
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.expandTableView reloadData];
}


//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    int index = 0;
    for (TreeViewNode *node in self.nodes ) {
        node.sectionIndex = index;
        [self.displayArray addObject:node];
        index ++;
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren section:index];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray section:(int)sectionIndex
{
    int index = 0;
    for (TreeViewNode *node in childrenArray) {
        node.sectionIndex = sectionIndex;
        node.rowIndex = index;
        
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren  section:index];
        }
        
        index ++;
    }
}

//These functions are used to expand and collapse all the nodes just connect them to two buttons and they will work
- (IBAction)expandAll:(id)sender
{
    //    [self fillNodesArray];
    [self fillNodesWithData];
    [self fillDisplayArray];
    [self.expandTableView reloadData];
}

- (IBAction)collapseAll:(id)sender
{
    for (TreeViewNode *treeNode in self.nodes ) {
        treeNode.isExpanded = NO;
    }
    [self fillDisplayArray];
    [self.expandTableView reloadData];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TreeViewSecondNodeCell class]])
    {
        TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
        UIFont *cellFont = [UIFont systemFontOfSize:14];
        CGFloat dep_landY = 15.0;
        CGSize labelSize1;
        
        if (node.isAlarm)
        {
            CGFloat contentWidth = 285.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            NSString *contentLabel = node.nodeContent;
            CGSize labelSize = [contentLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            return dep_landY*2 + labelSize.height + 10;
        }
        
        if (node.nodeDate == nil || [node.nodeDate isEqualToString:@""])
        {
            CGFloat contentWidth = 290.0;
            CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
            NSString *contentLabel = node.nodeContent;
            labelSize1 = [contentLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        else
        {
            if (node.nodeTime == nil || [node.nodeTime isEqualToString:@""])
            {
                CGFloat contentWidth = 225.0;
                CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
                NSString *contentLabel = node.nodeContent;
                labelSize1 = [contentLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            }
            else
            {
                CGFloat contentWidth = 225.0;
                CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
                NSString *contentLabel = node.nodeContent;
                labelSize1 = [contentLabel sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
                
                if (dep_landY*2 + labelSize1.height + 10 + 25 < 85)
                {
                    return 85;
                }
                
                return dep_landY*2 + labelSize1.height + 10 + 25;
            }
        }
        
        if (dep_landY*2 + labelSize1.height + 10 < 85)
        {
            return 85;
        }
        
        return dep_landY*2 + labelSize1.height + 10;
    }
    
    return 45;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"self.displayArray.count = %d", self.displayArray.count);
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    TreeViewNodeCell *cell = nil;
    if (node.nodeLevel == 0)
    {
        static NSString *CellIdentifier = @"TreeViewNodeCell";
        UINib *nib = [UINib nibWithNibName:@"TreeViewNodeCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        cell = (TreeViewNodeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.treeNode = node;
        
        cell.timeLabel.text = node.nodeTime;
        cell.locationLabel.text = node.nodeLocation;
        
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"pinround"]];
        
        if (indexPath.row == 0 ) {
            cell.vbarLabel.hidden = YES;
        }
        
        [cell setNeedsDisplay];
    }
    if (node.nodeLevel == 1)
    {
        static NSString *CellIdentifier = @"TreeViewSecondNodeCell";
        TreeViewSecondNodeCell *cell2 = [[TreeViewSecondNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell2.treeNode = node;
        [cell2 setData:indexPath];
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell2 setNeedsDisplay];
        return cell2;
    }
    
    //    tableView.rowHeight = 60;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
//    NSLog(@"node section: %d",node.sectionIndex);
//    NSLog(@"node row: %d",node.rowIndex);
//    NSLog(@"---------------");
    
}

#pragma mark -底部bar 按钮响应
- (IBAction)leftButAction:(id)sender
{
    if (_isSubribe)
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"是否取消订阅！" andConfirmButton:@"确定"];
        alertView.delegate = self;
        alertView.tag = 101;
        [alertView show];
    }
    else
    {
        [MobClick event:@"订阅运单"];
        [self disSubscribe];
    }
}

- (IBAction)middButAction:(id)sender
{
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithDelegate:self];
    actionSheet.mDelegate = self;
    [actionSheet showInView:self.view];
}

- (IBAction)rightButAction:(id)sender
{
//    NSDictionary *tmpDic = [NSDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
//    NSString *username = [tmpDic objectForKey:@"username"];
//    if (username && ![username isEqualToString:@""])
//    {
//        [self refreshDataFromSever];
//    }
//    else
//    {
//        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"如需查看通关信息请登录！" andConfirmButton:@"确定"];
//        alertView.delegate = self;
//        alertView.tag = 102;
//        [alertView show];
//    }
}

- (NSString *)toShorten
{
    NSString *url = [NSString stringWithFormat:@"http://m.eft.cn/waybill/index.html?mawbcode=%@pIOSpnull", self.waybillcode];
    NSString *httpUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/short_url/shorten.json?source=%@&url_long=%@", kWBSDKDemoAppKey, url];
    NSString *tmpStr = [QueryTraceUtil shorten:httpUrl];
    if (tmpStr && ![tmpStr isEqualToString:@""])
    {
        return tmpStr;
    }
    return url;
}

#pragma mark CustomActionSheetDelegate
- (void)Share:(NSInteger)tag
{
    NSString *shortUrl = [self toShorten];
    switch (tag)
    {
        case 1:
        {
            [MobClick event:@"点击邮件分享"];
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            
            if (mailClass != nil)
            {
                if ([mailClass canSendMail])
                {
                    NSString *message = [NSString stringWithFormat:@"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅，还有更多功能等您发现！\n点击查看<a href=\"%@\">%@</a>的轨迹%@",shortUrl, self.waybillcode, shortUrl];
                    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
                    
                    mailPicker.mailComposeDelegate = self;
                    
                    //设置主题
                    [mailPicker setSubject: @"指尖货运"];
                    [mailPicker setMessageBody:message isHTML:YES];
                    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"e_dimensional_code.png"]);
                    [mailPicker addAttachmentData:imageData mimeType:@"image/png" fileName:@"指尖货运"];
                    mailPicker.navigationBar.tintColor= [UIColor blackColor];
                    [self presentModalViewController:mailPicker animated:YES];
                }
                else
                {
                    NSString *msg = @"设备不支持发送邮件！";
                    [self alertWithTitle:nil msg:msg];
                }
            }
            else   
            {  
                NSString *msg = @"设备不支持发送邮件！";
                [self alertWithTitle:nil msg:msg];
            }
        }
            break;
        case 2:
        {
            [MobClick event:@"点击短信分享"];
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            NSString *message = [NSString stringWithFormat:@"分享自指尖货运，微信搜索\"指尖货运\"添加公众账号。%@的轨迹:%@", self.waybillcode, shortUrl];
            if (messageClass != nil)
            {
                if ([messageClass canSendText])
                {
                    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                    picker.messageComposeDelegate = self;
                    [picker setBody:message];
                    picker.navigationBar.tintColor= [UIColor blackColor];
                    [self presentModalViewController:picker animated:YES];
                }
                else
                {
                    [self alertWithTitle:nil msg: @"设备没有短信功能"];
                }  
            }  
            else 
            {  
                [self alertWithTitle:nil msg: @"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
            }
        }
            break;
        case 3:
        {
            NSString *message = [NSString stringWithFormat:@"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅，还有更多功能等您发现！\n点击查看%@的轨迹%@", self.waybillcode, shortUrl];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"sinaWeibo", @"client", message, @"content", shortUrl, @"shortenurl", nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 4:
        {
            NSString *message = [NSString stringWithFormat:@"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅，还有更多功能等您发现！\n点击查看%@的轨迹%@", self.waybillcode, shortUrl];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencentWeibo", @"client", message, @"content", shortUrl, @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 5:
        {
            if (![QQApiInterface isQQInstalled])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您没有安装QQ，请问您是否现在前往下载？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            if (![QQApiInterface isQQSupportApi])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您的QQ版本过低，请问您是否现在前往下载最新版QQ？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            NSString *message = [NSString stringWithFormat:@"分享自指尖货运，扫描二维码添加微信公众账号。%@的轨迹", self.waybillcode];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencentQQ", @"client", message, @"content", shortUrl, @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 6:
        {
            NSString *message = @"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅!";
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Qzone", @"client", message, @"content", shortUrl, @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 7:
        {
            if (![WXApi isWXAppInstalled])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您没有安装微信，请问您是否现在前往下载？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            if (![WXApi isWXAppSupportApi])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您的微信版本过低，请问您是否现在前往下载最新版微信？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            NSString *message = [NSString stringWithFormat:@"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅，还有更多功能等您发现！\n点击查看<a href=\"%@\">%@</a>的轨迹%@",shortUrl, self.waybillcode, shortUrl];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"weChat", @"client", message, @"content", shortUrl, @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 8:
        {
            if (![WXApi isWXAppInstalled])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您没有安装微信，请问您是否现在前往下载？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            if (![WXApi isWXAppSupportApi])
            {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"您的微信版本过低，请问您是否现在前往下载最新版微信？" andConfirmButton:@"前往下载"];
                alertView.delegate = self;
                alertView.tag = tag;
                [alertView show];
                return;
            }
            
            NSString *message = [NSString stringWithFormat:@"我正在使用指尖货运iOS客户端查询订阅我的运单状态，扫描下面的二维码也可通过微信订阅，还有更多功能等您发现！\n点击查看%@的轨迹%@", self.waybillcode, shortUrl];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"weChatCircle", @"client", message, @"content", shortUrl, @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        default:
            break;
    }
}

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:msg andConfirmButton:@""];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            [MobClick event:@"邮件分享运单成功"];
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            [MobClick event:@"邮件分享运单失败"];
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result
{
	NSString*msg;
	
	switch (result) {
		case MessageComposeResultCancelled:
			msg = @"发送取消";
			break;
		case MessageComposeResultSent:
			msg = @"发送成功";
            [MobClick event:@"短信分享运单成功"];
			[self alertWithTitle:nil msg:msg];
			break;
		case MessageComposeResultFailed:
			msg = @"发送失败";
            [MobClick event:@"短信分享运单失败"];
			[self alertWithTitle:nil msg:msg];
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

//#pragma mark UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}

#pragma mark CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (customAlertView.tag == 102)
        {
            LoginViewController *vc = nil;
            if (IS_IPHONE_5)
            {
                vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            }
            else
            {
                vc = [[LoginViewController alloc]initWithNibName:@"LoginViewControllerSmall" bundle:nil];
            }
            
            UINavigationController *navLoginController = [[UINavigationController alloc]initWithRootViewController:vc];
            [navLoginController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
            [self presentModalViewController:navLoginController animated:YES];
        }
        else if (customAlertView.tag == 101)
        {
            [MobClick event:@"取消订阅运单"];
            [self disSubscribe];
        }
        else if (customAlertView.tag == 5)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[QQApi getQQInstallURL]]];
        }
        else if (customAlertView.tag == 7 || customAlertView.tag == 8)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
        }
        else if (customAlertView.tag == 108)
        {
            [customAlertView hide];
        }
    }
    else if (buttonIndex == 0)
    {
        if (customAlertView.tag == 108)
        {
            [customAlertView hide];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"weChatCircle", @"client", @"我参与指尖货运万圣节活动，为自闭症儿童送上了节日的祝福，快来参加吧！", @"content", @"http://m.eft.cn/meftcn/activity/halloween/rankinglist.html", @"shortenurl",nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
    }
    
    return;
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
    [self refreshDataFromSever];
    [self removeEventListeners];
}

#pragma mark - ------ alarm & trace  info-------
- (NSDictionary *)getContent:(int )index
{
    NSDictionary *content = nil;
    
    content = [[self.data objectForKey:@"TRACES"] objectAtIndex:index];
    //self.waybillcode = [NSString stringWithFormat:@"%@-%@", [self.data objectForKey:@"AIRCOMPANYCODE"] ,[self.data objectForKey:@"MAWBCODE"]];
    
    return content;
}

- (NSDictionary *)getAlarmsContent:(int )index
{
    NSDictionary *content = nil;
    
    content = [[self.data objectForKey:@"ALARMS"] objectAtIndex:index];
    //self.waybillcode = [NSString stringWithFormat:@"%@-%@", [self.data objectForKey:@"AIRCOMPANYCODE"] ,[self.data objectForKey:@"MAWBCODE"]];
    
    return content;
}

- (void)initData
{
    self.status = [self.data objectForKey:@"STATUS"];
    self.isWarning = [self.status isEqualToString:@"WARNING"];
    self.alarmCount = ((NSArray *)[self.data objectForKey:@"ALARMS"]).count;
    self.traceCount = ((NSArray *)[self.data objectForKey:@"TRACES"]).count;
    self.nodes = [[NSMutableArray alloc] init];
    //NSLog(@"self.data: %@",self.data);
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
}

- (void)fillNodesWithData
{
    int count_alarm = self.alarmCount;
    int count_group = self.traceCount;
    
    for (int index_alarm = 0; index_alarm < count_alarm; index_alarm++)
    {
        TreeViewNode *secondLevelNode = [[TreeViewNode alloc]init];
        secondLevelNode.nodeLevel = 1;
        NSString *content = [[self getAlarmsContent:index_alarm] objectForKey:@"CONTENT"];
        secondLevelNode.nodeContent = [NSString stringWithFormat:@"%@",content];
        secondLevelNode.isAlarm = YES;
        [self.nodes addObject:secondLevelNode];
    }
    
    // NSLog(@"count_group: %d",count_group);
    for (int index_group = 0; index_group < count_group; index_group++)
    {
        TreeViewNode *secondLevelNode = [[TreeViewNode alloc]init];
        secondLevelNode.nodeLevel = 1;
        NSString * airport_land = [[self getContent:index_group] objectForKey:@"AIRPORT_LAND"];
        NSString * trace_code = [[self getContent:index_group] objectForKey:@"AWB_CODE"];
        NSString * content = [[self getContent:index_group] objectForKey:@"TRACE_DATA"];
        NSString * cargo_name = [[self getContent:index_group] objectForKey:@"CARGO_NAME"];
        NSString * cargo_code = [[self getContent:index_group] objectForKey:@"CARGO_CODE"];
        NSString * airport_dep = [[self getContent:index_group] objectForKey:@"AIRPORT_DEP"];
        NSString * op_time = [[self getContent:index_group] objectForKey:@"TRACE_TIME"];
        
        if (op_time.length > 15) {
            secondLevelNode.nodeTime = [op_time substringFromIndex:11];
        }else{
            secondLevelNode.nodeTime = @"";
        }
        
        if (op_time.length > 9)
        {
            secondLevelNode.nodeDate = [[op_time substringFromIndex:5] substringToIndex:5];
        }else{
            secondLevelNode.nodeDate = @"";
        }
        
        secondLevelNode.nodeAirportland = [NSString stringWithFormat:@"%@",airport_land];
        secondLevelNode.nodeTracecode = [NSString stringWithFormat:@"%@",trace_code];
        secondLevelNode.nodeContent = [NSString stringWithFormat:@"%@",content];
        secondLevelNode.nodeCargoname = [NSString stringWithFormat:@"%@",cargo_name];
        secondLevelNode.nodeCargocode = [NSString stringWithFormat:@"%@",cargo_code];
        secondLevelNode.nodeAirportdep = [NSString stringWithFormat:@"%@",airport_dep];
        if (index_group == 0)
        {
            secondLevelNode.isFirstTrace = YES;
        }
        
        [self.nodes addObject:secondLevelNode];
        
    }//end for1
}

#pragma mark disSubscribe
- (void)disSubscribe
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
                            self.waybillcode,
                            @"N",
                            appDelegate.token,
                            @"IOS",
                            self.isSubribe ? @"<offflag>1</offflag>" : @"<offflag></offflag>",
                            dateStr];
    
    NSLog(@"%@", postString);
    [_disTraceSubscribeUtil PostForASync:postString withURL:URL_POST];
    
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
        if (self.isSubribe)
        {
            [postDic setObject:@"0" forKey:@"ops"];
        }
        else
        {
            [postDic setObject:@"1" forKey:@"ops"];
        }
        [postDic setObject:self.waybillcode forKey:@"awbnum"];
        [postDic setObject:@"IOS" forKey:@"resource"];
    }
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    postString = [jsonParser stringWithObject:postDic];
    
    [_weixinUtil PostWeixin:postString withURL:URL_WEIXIN];
    
    [SVProgressHUD show];
}

#pragma mark  -  更新本地数据
- (void)refreshDataFromSever
{
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    if (![self.waybillcode isEqual: @""])
    {
        if (_queryTraceUtil)
        {
            [_queryTraceUtil StopFunction];
            _queryTraceUtil = nil;
        }
        
        _queryTraceUtil = [[QueryTraceUtil alloc] init];
        _queryTraceUtil.delegate = self;
        
        BOOL subscribe = NO;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *postString = [NSString stringWithFormat:
                                @"<eFreightService>"
                                @"<ServiceURL>Subscribe</ServiceURL>"
                                @"<ServiceAction>TRANSACTION</ServiceAction>"
                                @"<ServiceData>"
                                @"<Subscribe>"
                                @"<type>traceAndAlarm</type><target>%@</target><targettype>MAWB</targettype>"
                                @"<sync>%@</sync><subscriber>%@</subscriber><subscribertype>%@</subscribertype>"
                                @"<standard_type>3</standard_type>"
                                @"<limit_num>0</limit_num>"
                                @"</Subscribe>"
                                @"</ServiceData>"
                                @"</eFreightService>",
                                self.waybillcode,
                                subscribe ? @"Y" : @"N",
                                appDelegate.token,
                                subscribe ? @"IOS" : @"NONE"];
        
        NSLog(@"%@", postString);
        [_queryTraceUtil PostForASync:postString withURL:URL_POST];
        //[SVProgressHUD showWithStatus:@"正在查询订单轨迹"];
    }
}

#pragma mark - QueryTraceUtilDelegate
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    if (util == _queryTraceUtil)
    {
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"=================%@==================",response);
        NSError *err = nil;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];

        if(err != nil)
        {
            [SVProgressHUD showErrorWithStatus:@"刷新数据失败！"];
            //NSLog(@"-======   订阅失败！ ======" );
            return;
        }
        
        [SVProgressHUD dismissWithSuccess:@"订单轨迹查询成功"];
        
        NSArray *routesArray = [doc nodesForXPath:@"//route" error:nil];
        NSArray *tracesArray = [doc nodesForXPath:@"//TraceTranslate" error:nil];
        if (!tracesArray || [tracesArray count] == 0)
        {
            self.noInfo.hidden = NO;
        }
        else
        {
            self.noInfo.hidden = YES;
        }
        self.cargocode = @"";
        
        NSMutableDictionary * tmpDic = [[NSMutableDictionary alloc] init];
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
            //[traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"STARDARD_DATA" error:nil]]  forKey:@"STARDARD_DATA"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OP_TIME" error:nil]] forKey:@"OP_TIME"];
            [traceDic setObject:[QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"OCCUR_TIME" error:nil]] forKey:@"OCCUR_TIME"];
            
            [traces addObject:traceDic];
            
            if (i == tracesArray.count - 1)
            {
                self.cargocode = [QueryTraceUtil getElementString: [[tracesArray objectAtIndex:i] nodesForXPath:@"CARGO_CODE" error:nil]];
                [self filterValueChanged];
            }
        }
        
        NSArray* sortTrances = [[traces reverseObjectEnumerator] allObjects];
        
        //NSLog(@"%@", self.waybillcode);
        [tmpDic setObject:[self.waybillcode substringFromIndex:4] forKey:@"MAWBCODE"];
        [tmpDic setObject:[self.waybillcode substringWithRange:NSRangeFromString(@"0,3")] forKey:@"AIRCOMPANYCODE"];
        [tmpDic setObject:@"NORMAL" forKey:@"STATUS"];
        [tmpDic setObject:alarms forKey:@"ALARMS"];
        [tmpDic setObject:sortTrances forKey:@"TRACES"];
        [tmpDic setObject:routes forKey: @"ROUTES"];
        [tmpDic setObject: [QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_CODE" error:nil]] forKey:@"CARGO_CODE"];
        [tmpDic setObject: [QueryTraceUtil getElementString:[[tracesArray lastObject] nodesForXPath:@"CARGO_NAME" error:nil]]forKey: @"CARGO_NAME"];
        
        //始发港 目的港 日期 信息
        for (NSInteger i = 0; i < routesArray.count; i ++ )
        {
            if (i == 0)
            {
                [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] ;
                [tmpDic setObject:  [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"dep_port" error:nil]] forKey:@"DEP_PORT"];
                [tmpDic setObject:  [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"flight_date" error:nil]]forKey: @"FLIGHT_DATE"];
                [tmpDic setObject: [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]]forKey:@"ARR_PORT"];
            }
            else
            {
                [tmpDic setObject: [QueryTraceUtil getElementString:[[routesArray objectAtIndex:i] nodesForXPath:@"arr_port" error:nil]]forKey:@"ARR_PORT"];
            }
        }

        self.data = (NSMutableDictionary *)tmpDic;
        // 判断 plist 中是否有重复的历史数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [tmpDic objectForKey:@"AIRCOMPANYCODE"], [tmpDic objectForKey:@"MAWBCODE"]];
        
        NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
        
        //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
        if(existData.count != 0)
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            _isSubribe = [[existObject objectForKey:@"SUBSCRIBE"] boolValue];
            if (_isSubribe)
            {
                [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn_n" withType:@"png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn" withType:@"png"] forState:UIControlStateNormal];
            }
            
            [self setExistData:existObject withDic:tmpDic];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        else
        {
            [self.data setObject:@"YES" forKey:@"SUBSCRIBE"];
            if (![self.data objectForKey:@"AIRCOMPANYCODE"] || [[self.data objectForKey:@"AIRCOMPANYCODE"] isEqualToString:@""]
                || ![self.data objectForKey:@"MAWBCODE"] || [[self.data objectForKey:@"MAWBCODE"] isEqualToString:@""]
                || ![[self.data objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")]
                || ![[self.data objectForKey:@"AIRCOMPANYCODE"] isKindOfClass:NSClassFromString(@"NSString")])
            {
                return;
            }
            [self.resultArray insertObject:self.data atIndex:0];
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
        
        self.waybillcode = [NSString stringWithFormat:@"%@-%@",[tmpDic objectForKey:@"AIRCOMPANYCODE"],[tmpDic objectForKey:@"MAWBCODE"]];
        if (self.waybillcode && ![self.waybillcode isEqualToString:@""])
        {
            [self setTitle:[NSString stringWithFormat:@"%@ %@", [self.waybillcode substringToIndex:8], [[self.waybillcode substringFromIndex:8] substringToIndex:4]]];
        }
        else
        {
            [self setTitle:@"轨迹信息"];
        }
        [self updateUI];
    }
    else if (util == _disTraceSubscribeUtil)
    {
        _isSubribe = !_isSubribe;
        
        if (_isSubribe)
        {
            [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn_n" withType:@"png"] forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"订阅成功"];
        }
        else
        {
            [self.leftButton setImage:[CommonUtil CreateImage:@"e_detail_subcribeBtn" withType:@"png"] forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"取消订阅成功"];
        }
        
        // 判断 plist 中是否有重复的历史数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)", [self.waybillcode substringToIndex:3], [[self.waybillcode substringFromIndex:4] substringToIndex:8]];
        
        NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
        
        //plist 没有重复的历史数据 existData.count == 0，将新数据写入plist中
        if(existData.count != 0)
        {
            NSMutableDictionary *existObject = [existData objectAtIndex:0];
            [existObject setObject:self.isSubribe ? @"YES" : @"NO" forKey:@"SUBSCRIBE"];
            if(((NSMutableArray *)[self.data objectForKey:@"ALARMS"]).count != ((NSMutableArray *)[existObject objectForKey:@"ALARMS"]).count)
            {
                [existObject setObject:[self.data objectForKey:@"ALARMS"] forKey:@"ALARMS"];
                [existObject setObject:[self.data objectForKey:@"STATUS"] forKey:@"STATUS"];
            }
            [self.resultArray writeToFile:LISTFILE(@"tracelist.plist") atomically:YES];
        }
    }
    else if (util == _candyUtil)
    {
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *parseError = nil;
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *tmpDic = [jsonParser objectWithString:response error:&parseError];
        if (tmpDic)
        {
            int candyNum = [[tmpDic objectForKey:@"candy"] integerValue];
            NSString *position = [tmpDic objectForKey:@"position"];
            int total = [[tmpDic objectForKey:@"total"] integerValue];
            
            NSString *candyStr = [NSString stringWithFormat:@"感谢您参与此次活动，目前我们已经以您的名义向自闭症儿童康复协会捐赠%d元，您的捐款额度目前排名%@位，截止到现在此次活动累计捐款%d元", candyNum*100, position, total*100];
            CustomAlertView *tangguo = [[CustomAlertView alloc] initWithCandy:candyStr];
            tangguo.tag = 108;
            tangguo.delegate = self;
            [tangguo show];
        }
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        [SVProgressHUD dismissWithError:@"暂无轨迹"];
    }
    
    if (util == _disTraceSubscribeUtil)
    {
        if (_isSubribe)
        {
            [SVProgressHUD showErrorWithStatus:@"订阅失败"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"取消订阅失败"];
        }
    }
}

- (void)setExistData:(NSMutableDictionary *)depDic withDic:(NSMutableDictionary *)sourceDic
{
    NSMutableArray *routesArray = [sourceDic objectForKey:@"ROUTES"];
    [depDic setObject:[sourceDic objectForKey:@"TRACES"] forKey:@"TRACES"];
    [depDic setObject:routesArray forKey:@"ROUTES"];
    [depDic setObject:[sourceDic objectForKey:@"CARGO_CODE"] forKey:@"CARGO_CODE"];
    [depDic setObject:[sourceDic objectForKey:@"CARGO_NAME"] forKey:@"CARGO_NAME"];
    NSString *dep_port = [sourceDic objectForKey:@"DEP_PORT"];
    if (dep_port && ![dep_port isEqualToString:@""])
    {
        [depDic setObject:dep_port forKey:@"DEP_PORT"];
    }
    NSString *flight_date = [sourceDic objectForKey:@"FLIGHT_DATE"];
    if (flight_date && ![flight_date isEqualToString:@""])
    {
        [depDic setObject:flight_date forKey:@"FLIGHT_DATE"];
    }
    NSString *arr_port = [sourceDic objectForKey:@"ARR_PORT"];
    if (arr_port && ![arr_port isEqualToString:@""])
    {
        [depDic setObject:arr_port forKey:@"ARR_PORT"];
    }
    
    if(((NSMutableArray *)[sourceDic objectForKey:@"ALARMS"]).count != ((NSMutableArray *)[depDic objectForKey:@"ALARMS"]).count)
    {
        [depDic setObject:@"WARNING" forKey:@"STATUS"];
        [depDic setObject:@"ALARMS" forKey:[sourceDic objectForKey:@"ALARMS"]];
    }
}

- (void)updateUI
{
    [self refreshDetailTrace];
}

- (void)refreshDetailTrace
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AIRCOMPANYCODE == %@) and (MAWBCODE == %@)",[self.waybillcode substringWithRange:NSRangeFromString(@"0,3")] ,[self.waybillcode substringFromIndex:4]];
    
    NSArray *existData = [self.resultArray filteredArrayUsingPredicate:predicate];
    
    if(existData.count > 0)
    {
        //self.data = [existData objectAtIndex:0];
        //[self initDataFromPlist];
        [self initData];
        [self fillNodesWithData];
        [self fillDisplayArray];
        [self.expandTableView reloadData];
    }
}

- (void)dealloc
{
    [self removeEventListeners];
}

@end
