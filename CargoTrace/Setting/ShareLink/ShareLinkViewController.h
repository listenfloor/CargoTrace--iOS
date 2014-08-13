//
//  ShareLinkViewController.h
//  CargoTrace
//
//  Created by zhouzhi on 13-5-21.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareLinkViewController : UIViewController <WBEngineDelegate, TencentLoginDelegate, TencentSessionDelegate, CustomAlertViewDelegate>

@property (nonatomic, strong) UIButton* mSinaWeiboBtn;
@property (nonatomic, strong) UIButton* mTencentWeiboBtn;
@property (nonatomic, strong) UIButton* mQzoneBtn;
@property (nonatomic, strong) UILabel* mSinaWeiboLabel;
@property (nonatomic, strong) UILabel* mTencentWeiboLabel;
@property (nonatomic, strong) UILabel* mQzoneLabel;
@property (strong, nonatomic) WBEngine *SinaWeiboOAuth;
@property (strong, nonatomic) TencentOAuth *QzoneOAuth;
@property (strong, nonatomic) NSMutableArray *permissions;
@property (strong, nonatomic) TCWBEngine *TCWeiboOAuth;

@end
