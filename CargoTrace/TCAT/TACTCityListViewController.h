//
//  TCATCityListViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TACTCityListViewController;

@protocol TACTCityListViewDelegate <NSObject>

- (void)portSelected:(NSString *)cityCode andIndex:(NSInteger)index;

@end

@interface TACTCityListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CustomAlertViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *keywordTextField;
@property (nonatomic, strong) NSString *keywordStr;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (nonatomic) NSInteger type;
@property (nonatomic, assign) id<TACTCityListViewDelegate> delegate;

- (IBAction)search:(id)sender;

@end
