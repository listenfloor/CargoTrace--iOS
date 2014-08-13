//
//  CustomerServiceViewController.m
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "CustomerServiceMutualViewController1.h"

@interface CustomerServiceViewController ()
{
    CustomerServiceCell *_currentlyRevealedCell;
}
@end

@implementation CustomerServiceViewController

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
    self.resultArray = [[NSMutableArray alloc] initWithObjects:@"中外运官方客服--小可", nil];
    self.mTableView.frame = self.view.frame;
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
    self.title = @"微客服";
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
    [addButton addTarget:self action:@selector(goToAddPage) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"e_back_arrow.png"] forState: UIControlStateNormal];
    
    //创建redo按钮
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)goback
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)goToAddPage
{
    AddCustomerServiceViewController *vc = [[AddCustomerServiceViewController alloc] initWithNibName:@"AddCustomerServiceViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Accessors
- (CustomerServiceCell *)currentlyRevealedCell
{
	return _currentlyRevealedCell;
}

- (void)setCurrentlyRevealedCell:(CustomerServiceCell *)currentlyRevealedCell
{
	if (_currentlyRevealedCell == currentlyRevealedCell)
		return;
	
	[_currentlyRevealedCell setRevealing:NO];
	
	[self willChangeValueForKey:@"currentlyRevealedCell"];
	_currentlyRevealedCell = currentlyRevealedCell ;
	[self didChangeValueForKey:@"currentlyRevealedCell"];
}

#pragma mark - CustomerServiceCellDelegate
- (BOOL)cellShouldReveal:(CustomerServiceCell *)cell
{
	return YES;
}

- (void)cellDidReveal:(CustomerServiceCell *)cell
{
	self.currentlyRevealedCell = cell;
}

- (void)cellDidBeginPan:(CustomerServiceCell *)cell
{
	if (cell != self.currentlyRevealedCell)
		self.currentlyRevealedCell = nil;
}

- (void)cellDidPad:(CustomerServiceCell *)cell Direction:(NSInteger)direction
{
    //NSLog(@"%@", cell.detailNumber.text);
    
}

- (void)deleteCell
{
    
}

#pragma mark - tabelView fuctions
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerServiceCell";
    
    CustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerServiceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell laySubviews];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mContent.text = [self.resultArray objectAtIndex:indexPath.row];
	cell.delegate = self;
    cell.direction = CustomerServiceCellDirectionBoth;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerServiceCell *cell = (CustomerServiceCell *)[tableView cellForRowAtIndexPath:indexPath];
    CustomerServiceMutualViewController1 *vc = [[CustomerServiceMutualViewController1 alloc] init];
    vc.mTitle = cell.mContent.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AddCustomerServiceViewDelegate
- (void)ServiceSelected:(NSArray *)array
{
    
}

@end
