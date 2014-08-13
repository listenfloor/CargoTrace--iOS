//
//  TCATQueryViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TACTQueryViewController.h"
#import "TACTResultViewController.h"
#import "DBUtil.h"
#import "CityEntity.h"

@interface TACTQueryViewController ()

@end

@implementation TACTQueryViewController

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
    
    self.title = @"TACT查询";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
	// Do any additional setup after loading the view.
    self.departArray = [[DBUtil SharedDBEngine] GetAllDepartCitysAndPorts];
    if (self.departArray && [self.departArray count] != 0)
    {
        self.isDepartLimit = YES;
    }
    else
    {
        self.isDepartLimit = NO;
    }
    self.destArray = [[DBUtil SharedDBEngine] GetAllDestCitysAndPorts];
    if (self.destArray && [self.destArray count] != 0)
    {
        self.isDestLimit = YES;
    }
    else
    {
        self.isDestLimit = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *rodoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback
{
    [MobClick event:@"从TACT查询页面返回首页"];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)isDepartCityExsit:(NSString *)cityStr
{
    for (CityEntity *city in self.departArray)
    {
        NSRange searchRange = [[city.threeCode uppercaseString] rangeOfString:[cityStr uppercaseString]];
        if  (searchRange.location != NSNotFound)
        {
            return YES;
        }
        searchRange = [city.ch_name rangeOfString:cityStr];
        if  (searchRange.location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isDestCityExsit:(NSString *)cityStr
{
    for (CityEntity *city in self.destArray)
    {
        NSRange searchRange = [[city.threeCode uppercaseString] rangeOfString:[cityStr uppercaseString]];
        if  (searchRange.location != NSNotFound)
        {
            return YES;
        }
        searchRange = [city.ch_name rangeOfString:cityStr];
        if  (searchRange.location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)queryDepartCityCode:(NSString *)cityStr
{
    for (CityEntity *city in self.departArray)
    {
        NSRange searchRange = [[city.threeCode uppercaseString] rangeOfString:[cityStr uppercaseString]];
        if  (searchRange.location != NSNotFound)
        {
            return [city.threeCode uppercaseString];
        }
        searchRange = [city.ch_name rangeOfString:cityStr];
        if  (searchRange.location != NSNotFound)
        {
            return [city.threeCode uppercaseString];
        }
    }
    
    return @"";
}

- (NSString *)queryDestCityCode:(NSString *)cityStr
{
    for (CityEntity *city in self.destArray)
    {
        NSRange searchRange = [[city.threeCode uppercaseString] rangeOfString:[cityStr uppercaseString]];
        if  (searchRange.location != NSNotFound)
        {
            return [city.threeCode uppercaseString];
        }
        searchRange = [city.ch_name rangeOfString:cityStr];
        if  (searchRange.location != NSNotFound)
        {
            return [city.threeCode uppercaseString];
        }
    }
    
    return @"";
}

- (IBAction)queryBtnClicked:(id)sender
{
    [self.departTextField resignFirstResponder];
    [self.destTextField resignFirstResponder];
    
    [self textFieldDidEndEditing:self.departTextField];
    [self textFieldDidEndEditing:self.destTextField];
    
    [MobClick event:@"TACT运价查询"];
    
    if ([self.departTextField.text isEqualToString:@""])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"请输入始发港!" andConfirmButton:@""];
        [alertView show];
        return;
    }
    
    if ([self.destTextField.text isEqualToString:@""])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"请输入目的港!" andConfirmButton:@""];
        [alertView show];
        return;
    }
    
    if (![self isDepartCityExsit:self.departTextField.text] && self.isDepartLimit)
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"请输入正确的始发港!" andConfirmButton:@""];
        [alertView show];
        return;
    }
    
    if (![self isDestCityExsit:self.destTextField.text] && self.isDestLimit)
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"请输入正确的目的港!" andConfirmButton:@""];
        [alertView show];
        return;
    }
    
    TACTResultViewController *vc = nil;
    if (IS_IPHONE_5)
    {
        vc = [[TACTResultViewController alloc] initWithNibName:@"TACTResultViewController" bundle:nil];
    }
    else
    {
        vc = [[TACTResultViewController alloc] initWithNibName:@"TACTResultViewControllerSmall" bundle:nil];
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc queryTCATPriceWithDepartPort:self.departTextField.text andDestPort:self.destTextField.text];
}

- (IBAction)expandBtnClicked:(id)sender
{
    [MobClick event:@"进入城市港口列表"];
    UIButton *button = (UIButton *)sender;
    TACTCityListViewController *vc = nil;
    if (IS_IPHONE_5)
    {
        vc = [[TACTCityListViewController alloc] initWithNibName:@"TACTCityListViewController" bundle:nil];
    }
    else
    {
        vc = [[TACTCityListViewController alloc] initWithNibName:@"TACTCityListViewControllerSmall" bundle:nil];
    }
    if (button.tag == 101)
    {
        vc.keywordStr = self.departTextField.text;
        vc.type = 0;
    }
    else if (button.tag == 102)
    {
        vc.keywordStr = self.destTextField.text;
        vc.type = 1;
    }
    
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)textBtnClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 10)
    {
        [self.departTextField becomeFirstResponder];
    }
    else if (button.tag == 11)
    {
        [self.destTextField becomeFirstResponder];
    }
}

#pragma mark - keyboard event
- (IBAction)backgroundTap:(id)sender
{
    [self.departTextField resignFirstResponder];
    [self.destTextField resignFirstResponder];
    [self.departImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dep" withType:@"png"]];
    [self.destImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dt" withType:@"png"]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tmpStr = textField.text;
    if (range.length == 0 && ![string isEqualToString:@"\n"])
    {
        tmpStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
    }
    else if (range.length == 1  && string.length == 0)
    {
        tmpStr = [tmpStr substringToIndex:tmpStr.length - 1];
    }
    if (range.length > 1)
    {
        tmpStr = string;
    }
    
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [tmpStr componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    tmpStr = [filteredArray componentsJoinedByString:@""];

    if (textField == self.departTextField)
    {
        if (![self isDepartCityExsit:tmpStr] && self.isDepartLimit)
        {
            textField.textColor = [UIColor redColor];
        }
        else
        {
            textField.textColor = [UIColor blackColor];
        }
    }
    else
    {
        if (![self isDestCityExsit:tmpStr] && self.isDestLimit)
        {
            textField.textColor = [UIColor redColor];
        }
        else
        {
            textField.textColor = [UIColor blackColor];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *cityCode = @"";
    if (textField == self.departTextField)
    {
        cityCode = [self queryDepartCityCode:textField.text];
    }
    else
    {
        cityCode = [self queryDestCityCode:textField.text];
    }
    
    if (![cityCode isEqualToString:@""])
    {
        textField.textColor = [UIColor blackColor];
        textField.text = cityCode;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.departTextField resignFirstResponder];
    [self.destTextField resignFirstResponder];
    [self.departImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dep" withType:@"png"]];
    [self.destImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dt" withType:@"png"]];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.departTextField)
    {
        [self.departImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dep_h" withType:@"png"]];
        [self.destImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dt" withType:@"png"]];
    }
    else
    {
        [self.departImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dep" withType:@"png"]];
        [self.destImageView setImage:[CommonUtil CreateImage:@"tact_query_input_dt_h" withType:@"png"]];
    }
}

#pragma mark - TACTCityListViewDelegate
- (void)portSelected:(NSString *)cityCode andIndex:(NSInteger)index
{
    if (index == 0)
    {
        self.departTextField.text = cityCode;
    }
    else
    {
        self.destTextField.text = cityCode;
    }
}

@end
