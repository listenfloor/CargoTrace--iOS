//
//  AddCustomerServiceViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "AddCustomerServiceViewController.h"

@interface AddCustomerServiceViewController ()

@end

@implementation AddCustomerServiceViewController

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
    [self setNavbar];
    self.resultArray = [[NSMutableArray alloc] initWithObjects:@"中外运官方客服--小胖", @"中外运官方客服--小星", nil];
    self.displayArray = [[NSMutableArray alloc] initWithCapacity:[self.resultArray count]];
    self.saveArray = [[NSMutableArray alloc] initWithCapacity:[self.resultArray count]];
    for (int i = 0; i < [self.resultArray count]; i++)
    {
        [self.saveArray addObject:[NSNumber numberWithBool:NO]];
    }
    self.keywordStr = @"";
    [self initDisplayArray];
    
    self.tableView.frame = CGRectMake(0, 88, 320, self.view.frame.size.height - 88);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -  导航栏 设置
- (void)setNavbar
{
    self.navigationController.title = nil;
    self.title = @"添加客服";
    [self.navigationController.navigationBar setBarStyle: UIBarStyleBlack];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarbg.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *rodoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    rodoButton.backgroundColor = [UIColor clearColor];
    [rodoButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [rodoButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *redoButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rodoButton];
    self.navigationItem.leftBarButtonItem = redoButtonItem;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 30, 20)];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    for (int i = 0; i < [self.saveArray count]; i++)
    {
        NSNumber *number = [self.saveArray objectAtIndex:i];
        if (![number boolValue])
        {
            [self.resultArray removeObjectAtIndex:i];
        }
    }
    
    [self.delegate ServiceSelected:self.resultArray];
}

- (void)initDisplayArray
{
    @autoreleasepool
    {
        [self.displayArray removeAllObjects];
        if ([self.keywordStr isEqualToString:@""] || !self.keywordStr)
        {
            for (id object in self.resultArray)
            {
                [self.displayArray addObject:[object mutableCopy]];
            }
        }
        else
        {
            for (id object in self.resultArray)
            {
                NSRange searchRange = [[object uppercaseString] rangeOfString:[self.keywordStr uppercaseString]];
                if  (searchRange.location != NSNotFound)
                {
                    [self.displayArray addObject:[object mutableCopy]];
                    continue;
                }
            }
        }
    }
}

- (IBAction)search:(id)sender
{
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [self.displayArray objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.keywordTextField resignFirstResponder];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.saveArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.saveArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
}

- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
