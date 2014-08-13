//
//  RegisterViewController.m
//  CargoTrace
//
//  Created by yanjing on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommonUtil.h"
#import "GDataXMLNode.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize registerDataArray = _registerDataArray;
@synthesize queryTraceUtil = _queryTraceUtil;
@synthesize queryEmailUtil = _queryEmailUtil;
@synthesize bindingUserUtil = _bindingUserUtil;
@synthesize textFieldIndex = _textFieldIndex;

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
 
    [self setTitle:@"用户注册"];
    [self setNavbar];
    self.textFieldIndex = -1;
    self.note.hidden = YES;
}
   
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  -  导航栏 设置
-(void) setNavbar
{
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
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    [MobClick event:@"从注册页面返回"];
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  -  提交 注册
- (IBAction)doSubmit:(id)sender
{
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    
    if (![self doVerifyTel])
    {
        return;
    }
    
    if (_queryTraceUtil)
    {
        [_queryTraceUtil StopFunction];
        _queryTraceUtil = nil;
    }
    
    _queryTraceUtil = [[QueryTraceUtil alloc] init];
    _queryTraceUtil.delegate = self;
    
    //.2f表示精确到小数点后两位
    NSString *postString = [NSString stringWithFormat:@"<eFreightService>"
                            @"<ServiceURL>eFreightUser</ServiceURL>"
                            @"<ServiceAction>register</ServiceAction>"
                            @"<ServiceData>"
                            @"<eFreightUser>"
                            @"<username>%@</username>"
                            @"<password>%@</password>"
                            @"<name></name>"
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
                            , self.email.text
                            , self.password.text];
    
    //发送异步请求
    [_queryTraceUtil PostForASync:postString withURL:URL_LOGIN];
    [SVProgressHUD showWithStatus:@"正在注册"];
}

- (void)qureyEmail:(NSString *)email
{
    if (!email || [email isEqualToString:@""])
    {
        self.note.hidden = YES;
        return;
    }
    
    if (_queryEmailUtil)
    {
        [_queryEmailUtil StopFunction];
        _queryEmailUtil = nil;
    }
    
    _queryEmailUtil = [[QueryTraceUtil alloc] init];
    _queryEmailUtil.delegate = self;
    
    //.2f表示精确到小数点后两位
    NSString *postString = [NSString stringWithFormat:@"<eFreightService>"
                            @"<ServiceURL>eFreightUser</ServiceURL>"
                            @"<ServiceAction>QUERY</ServiceAction>"
                            @"<ServiceData>"
                            @"<eFreightUser>"
                            @"<username>%@</username>"
                            @"</eFreightUser>"
                            @"</ServiceData>"
                            @"</eFreightService>"
                            , email];
    
    //发送异步请求
    [_queryEmailUtil PostForASync:postString withURL:URL_LOGIN];
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

- (BOOL)doVerifyTel
{
    NSString *resultStr = @"";
    if (!self.email.text || [self.email.text isEqualToString:@""])
    {
        resultStr = @"邮箱不可为空！";
    }
    else if (!self.password.text || [self.password.text isEqualToString:@""])
    {
        resultStr = @"密码不可为空！";
    }
    else if (![self isValidateEmail:self.email.text])
    {
        resultStr = @"您输入的邮箱格式不正确，请重新输入！";
    }
    
    if ([resultStr isEqualToString:@""])
    {
        return YES;
    }
    
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:resultStr andConfirmButton:@""];
    alertView.delegate = self;
    [alertView show];
    return NO;
}

- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - keyboard event
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
    
    if (_textFieldIndex == 0)
    {
        [self qureyEmail:self.email.text];
        _textFieldIndex = -1;
    }
}

//开始编辑输入框的时候，软键盘出现，执行此事件
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
    
    if (textField == self.email)
    {
        self.textFieldIndex = 0;
    }
    else if (textField == self.password)
    {
        self.textFieldIndex = 1;
        [self qureyEmail:self.email.text];
    }
}

//当用户按下return键或者按回车键，keyboard消失
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
        [self doSubmit:nil];
    }
    
    return YES;
}

#pragma mark - QueryTraceUtilDelegate Methods
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=================%@==================",response);
    NSError *err = nil;
    GDataXMLDocument * doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
    if (err)
    {
        
    }
    else
    {
        if (util == _queryEmailUtil)
        {
            NSString *username = [QueryTraceUtil getElementString:[doc nodesForXPath:@"//username" error:nil]];
            if (username && ![username isEqualToString:@""])
            {
                self.note.hidden = NO;
            }
            else
            {
                self.note.hidden = YES;
            }
        }
        else if (util == _queryTraceUtil)
        {
            NSInteger resultCode = [[QueryTraceUtil getElementString:[doc nodesForXPath:@"//ResultCode" error:nil]] intValue];
            if (resultCode == 1)
            {
                [MobClick event:@"注册成功"];
                [SVProgressHUD dismissWithSuccess:@"注册成功"];
                [self bindingUser:self.email.text];
                NSFileManager *manager = [NSFileManager defaultManager];
                NSMutableDictionary *loginDic = nil;
                if([manager fileExistsAtPath:LISTFILE(@"login.plist")])
                {
                    loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:LISTFILE(@"login.plist")];
                    if (!loginDic)
                    {
                        loginDic = [[NSMutableDictionary alloc] init];
                    }
                    
                    [loginDic setObject:self.email.text forKey:@"username"];
                    [loginDic setObject:self.email.text forKey:@"nikename"];
                }
                else
                {
                    loginDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.email.text, @"nikename", self.email.text, @"username", nil];
                }
                [loginDic writeToFile:LISTFILE(@"login.plist") atomically:YES];
                
                NSMutableDictionary *info= [[NSMutableDictionary alloc] init];
                [info setObject:LOGIN_SUCESS forKey:@"login"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLogin" object:nil userInfo:info];
                [self dismissModalViewControllerAnimated:YES];
            }
            else if (resultCode == -301)
            {
                [MobClick event:@"重复注册"];
                [SVProgressHUD showSuccessWithStatus:@"该邮箱已被注册"];
            }
            else
            {
                [MobClick event:@"注册失败"];
                [SVProgressHUD showErrorWithStatus:@"注册失败"];
            }
        }
    }
}

- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message
{
    if (util == _queryTraceUtil)
    {
        [MobClick event:@"注册失败"];
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    }
}

- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
