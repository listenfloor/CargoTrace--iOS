//
//  TCATResultViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-7-1.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"
#import <MessageUI/MessageUI.h>

@interface TACTResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QueryTraceUtilDelegate, CustomActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, CustomAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *departLabel;
@property (nonatomic, strong) IBOutlet UILabel *destLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *displayArray;
@property (strong,nonatomic) QueryTraceUtil *queryTraceUtil;

- (void)queryTCATPriceWithDepartPort:(NSString *)depart andDestPort:(NSString *)dest;

@end
