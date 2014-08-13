//
//  AddCustomerServiceViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddCustomerServiceViewController;

@protocol AddCustomerServiceViewDelegate <NSObject>

- (void)ServiceSelected:(NSArray *)array;

@end

@interface AddCustomerServiceViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *keywordTextField;
@property (nonatomic, strong) NSString *keywordStr;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic, strong) NSMutableArray *saveArray;
@property (nonatomic, assign) id<AddCustomerServiceViewDelegate> delegate;
@end
