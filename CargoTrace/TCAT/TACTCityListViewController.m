//
//  TCATCityListViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "TACTCityListViewController.h"
#import "DBUtil.h"
#import "CityEntity.h"
#import "TACTCityAndPortCell.h"

@interface TACTCityListViewController ()

@end

@implementation TACTCityListViewController
@synthesize type;

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
    if (self.type == 0)
    {
        self.resultArray = [[DBUtil SharedDBEngine] GetAllDepartCitysAndPorts];
    }
    else
    {
        self.resultArray = [[DBUtil SharedDBEngine] GetAllDestCitysAndPorts];
    }
    
    self.title = @"城市港口列表";
    // Do any additional setup after loading the view from its nib.
    UIButton *rodoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
    
    self.displayArray = [[NSMutableArray alloc] initWithCapacity:9];
    self.keywordTextField.text = self.keywordStr;
    
    [self initDisplayArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback
{
    [MobClick event:@"从城市港口列表返回TACT查询页面"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initDisplayArray
{
    @autoreleasepool
    {
        [self.displayArray removeAllObjects];
        if ([self.keywordStr isEqualToString:@""] || !self.keywordStr)
        {
            for (CityEntity *city in self.resultArray)
            {
                [self.displayArray addObject:[city mutableCopy]];
            }
        }
        else
        {
            for (CityEntity *city in self.resultArray)
            {
                NSRange searchRange = [[city.threeCode uppercaseString] rangeOfString:[self.keywordStr uppercaseString]];
                if  (searchRange.location != NSNotFound)
                {
                    [self.displayArray addObject:[city mutableCopy]];
                    continue;
                }
                searchRange = [city.ch_name rangeOfString:self.keywordStr];
                if  (searchRange.location != NSNotFound)
                {
                    [self.displayArray addObject:[city mutableCopy]];
                    continue;
                }
            }
        }
    }
}

- (IBAction)search:(id)sender
{
    [MobClick event:@"点击城市港口查询按钮"];
    self.keywordStr = self.keywordTextField.text;
    [self initDisplayArray];
    [self.tableView reloadData];
}

- (void)searchRightNow
{
    self.keywordStr = self.keywordTextField.text;
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [self.keywordStr componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    self.keywordStr = [filteredArray componentsJoinedByString:@""];
    
    [self initDisplayArray];
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    self.keywordStr = self.keywordTextField.text;
//    if (range.length == 0 && ![string isEqualToString:@"\n"])
//    {
//        self.keywordStr = [NSString stringWithFormat:@"%@%@", self.keywordTextField.text, string];
//    }
//    else if (range.length == 1  && string.length == 0)
//    {
//        self.keywordStr = [self.keywordStr substringToIndex:self.keywordStr.length - 1];
//    }
//    if (range.length > 1)
//    {
//        self.keywordStr = string;
//    }
//    
//    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
//    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
//    NSArray *parts = [self.keywordStr componentsSeparatedByCharactersInSet:whitespaces];
//    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
//    self.keywordStr = [filteredArray componentsJoinedByString:@""];
//    
//    [self initDisplayArray];
//    [self.tableView reloadData];;
    [self performSelector:@selector(searchRightNow) withObject:nil afterDelay:0.2];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.keywordStr = @"";
    [self initDisplayArray];
    [self.tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.keywordTextField resignFirstResponder];
    return YES;
}

#pragma mark - tabelView fuctions
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
    static NSString *CellIdentifier = @"TACTResultCell";
    
    TACTCityAndPortCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TACTCityAndPortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    
    CityEntity *city = [self.displayArray objectAtIndex:row];
    
    cell.portLabel.text = city.threeCode;
    cell.cityLabel.text = city.ch_name;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"选择港口城市"];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.keywordTextField resignFirstResponder];
    
    CityEntity *city = [self.displayArray objectAtIndex:indexPath.row];
    
    if (self.type == 0)
    {
        [self.delegate portSelected:city.threeCode andIndex:0];
    }
    else
    {
        [self.delegate portSelected:city.threeCode andIndex:1];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
