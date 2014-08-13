//
//  CustomerServiceViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerServiceCell.h"
#import "AddCustomerServiceViewController.h"

@interface CustomerServiceViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate, CustomerServiceCellDelegate, AddCustomerServiceViewDelegate>
@property(nonatomic,strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic,strong) CustomerServiceCell *currentlyRevealedCell;

@end
