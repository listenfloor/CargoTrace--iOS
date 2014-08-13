//
//  WeiboSignInViewController.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class WeiboSignInViewController;
@protocol WeiboSignInViewControllerDelegate <NSObject>

- (void)didReceiveAuthorizeCode:(NSString *)code;

@end

@interface WeiboSignInViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate>
{
    UIWebView *_webView;
    UIBarButtonItem *_cancelButton;
    UIBarButtonItem *_stopButton;
    UIBarButtonItem *_refreshButton;

    id<WeiboSignInViewControllerDelegate> delegate;
    
    MBProgressHUD *HUD;
    
    BOOL _closed;
}

@property (nonatomic, assign) id<WeiboSignInViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *requestUrl;

@end
