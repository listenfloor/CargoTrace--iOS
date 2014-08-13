//
//  TCATResultViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TACTResultViewController.h"
#import "GDataXMLNode.h"
#import "TACTPriceCell.h"

@interface TACTResultViewController ()

@end

@implementation TACTResultViewController
@synthesize queryTraceUtil = _queryTraceUtil;

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
    
    self.title = @"TACT运价";
    // Do any additional setup after loading the view from its nib.
    UIButton *rodoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
    
    self.displayArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)middButAction:(id)sender
{
    [MobClick event:@"点击TACT运价分享按钮"];
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc] initWithDelegate:self];
    actionSheet.mDelegate = self;
    //[actionSheet setNeedsDisplay];
    [actionSheet showInView:self.view];
}

- (void)goback
{
    [MobClick event:@"从TACT运价结果页面返回TACT查询页面"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)queryTCATPriceWithDepartPort:(NSString *)depart andDestPort:(NSString *)dest
{
    self.departLabel.text = depart;
    self.destLabel.text = dest;
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
    NSString *postString = [NSString stringWithFormat:
                            @"<Service>"
                            @"<ServiceURL>QueryTACT</ServiceURL>"
                            @"<ServiceAction>queryAirport</ServiceAction>"
                            @"<ServiceData>"
                            @"<Departure>%@</Departure>"
                            @"<Destination>%@</Destination>"
                            @"</ServiceData>"
                            @"</Service>"
                            , depart
                            , dest];
    
    [_queryTraceUtil PostForASync:postString withURL:URL_TCAT];
    [SVProgressHUD showWithStatus:@"正在查询TACT运价"];
}

#pragma mark - tabelView fuctions
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TACTPriceCell";
    
    TACTPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TACTPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tactDic = [self.displayArray objectAtIndex:indexPath.row];
    
    cell.typeLabel.text = [tactDic objectForKey:@"Weight"];
    
    if ([[tactDic objectForKey:@"Curr"] isEqualToString:@"CNY"])
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@", [tactDic objectForKey:@"Rate"]];
    }
    else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"$ %@", [tactDic objectForKey:@"Rate"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
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
        NSString *resultCode = [QueryTraceUtil getElementString:[doc nodesForXPath:@"//ResultData" error:nil]];
        if ([resultCode isEqualToString:@"您输入的不是三字码哦，请重新检查一下吧！"])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的三字码！"];
            return;
        }
        
        NSArray *TACTArray = [doc nodesForXPath:@"//QueryTACT" error:nil];
        for (NSInteger i = 0; i < TACTArray.count; i ++ )
        {
            NSMutableDictionary *tactDic = [[NSMutableDictionary alloc] init];
            [tactDic setObject:[QueryTraceUtil getElementString: [[TACTArray objectAtIndex:i] nodesForXPath:@"Departure" error:nil]]  forKey:@"Departure"];
            [tactDic setObject:[QueryTraceUtil getElementString: [[TACTArray objectAtIndex:i] nodesForXPath:@"Destination" error:nil]] forKey:@"Destination"];
            [tactDic setObject:[QueryTraceUtil getElementString: [[TACTArray objectAtIndex:i] nodesForXPath:@"Weight" error:nil]] forKey:@"Weight"];
            [tactDic setObject:[QueryTraceUtil getElementString: [[TACTArray objectAtIndex:i] nodesForXPath:@"Rate" error:nil]] forKey:@"Rate"];
            [tactDic setObject:[QueryTraceUtil getElementString: [[TACTArray objectAtIndex:i] nodesForXPath:@"Curr" error:nil]] forKey:@"Curr"];
            [self.displayArray addObject:tactDic];
        }
        if(err != nil)
        {
            [SVProgressHUD showErrorWithStatus:@"TACT运价查询失败"];
            return;
        }
        [SVProgressHUD dismissWithSuccess:@"TACT运价查询成功"];
        
        [self.tableView reloadData];
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        [SVProgressHUD dismissWithError:@"TACT运价查询失败"];
    }
}

- (NSString *)getShareString
{
    NSString *shareString = [NSString stringWithFormat:@"从%@到%@的运价是: ", self.departLabel.text, self.destLabel.text];
    int num = 0;
    NSString *country = @"";

    for (NSDictionary *tactDic in self.displayArray)
    {
        num++;
        if ([[tactDic objectForKey:@"Curr"] isEqualToString:@"CNY"])
        {
            country = @"￥";
        }
        else
        {
            country = @"$";
        }
        if (num == [self.displayArray count])
        {
            shareString = [NSString stringWithFormat:@"%@%@:%@%@", shareString, [tactDic objectForKey:@"Weight"], country, [tactDic objectForKey:@"Rate"]];
        }
        else
        {
            shareString = [NSString stringWithFormat:@"%@%@:%@%@; ", shareString, [tactDic objectForKey:@"Weight"], country, [tactDic objectForKey:@"Rate"]];
        }
    }
    
    return shareString;
}

#pragma mark CustomActionSheetDelegate
- (void)Share:(NSInteger)tag
{
    NSString *shareString = [self getShareString];
    switch (tag)
    {
        case 1:
        {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            
            if (mailClass != nil)
            {
                if ([mailClass canSendMail])
                {
                    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
                    
                    mailPicker.mailComposeDelegate = self;
                    
                    //设置主题
                    [mailPicker setSubject: @"指尖货运"];
                    [mailPicker setMessageBody:shareString isHTML:YES];
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
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            if (messageClass != nil)
            {
                if ([messageClass canSendText])
                {
                    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                    picker.messageComposeDelegate = self;
                    [picker setBody:shareString];
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
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"sinaWeibo", @"client", shareString, @"content", nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 4:
        {
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencentWeibo", @"client", shareString, @"content", nil];
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
            
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencentQQ", @"client", shareString, @"content", nil];
            [[AppDelegate ShareAppDelegate] performSelector:@selector(sendText:) withObject:tmpDic afterDelay:0.2];
        }
            break;
        case 6:
        {
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Qzone", @"client", shareString, @"content", nil];
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
            
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"weChat", @"client", shareString, @"content", nil];
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
            
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:@"weChatCircle", @"client", shareString, @"content", nil];
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
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
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
			[self alertWithTitle:nil msg:msg];
			break;
		case MessageComposeResultFailed:
			msg = @"发送失败";
			[self alertWithTitle:nil msg:msg];
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark CustomAlertViewDelegate
- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    return;
}

@end
