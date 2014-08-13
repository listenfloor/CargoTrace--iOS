//
//  RegisterViewController.h
//  CargoTrace
//
//  Created by yanjing on 13-4-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterViewController;

@interface RegisterViewController : UIViewController<UITextFieldDelegate, QueryTraceUtilDelegate, CustomAlertViewDelegate>

@property(nonatomic,strong) NSMutableArray *registerDataArray;

@property(nonatomic,strong) IBOutlet UITextField *password;

@property(nonatomic,strong) IBOutlet UITextField *email;
@property(nonatomic,strong) IBOutlet UILabel *note;
@property(nonatomic,strong) QueryTraceUtil *queryTraceUtil;
@property(nonatomic,strong) QueryTraceUtil *queryEmailUtil;
@property(nonatomic,strong) QueryTraceUtil *bindingUserUtil;
@property(nonatomic) NSInteger textFieldIndex;
 

-(IBAction)doSubmit:(id)sender;
@end
