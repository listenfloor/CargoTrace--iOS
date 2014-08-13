//
//  CutomAlertView.h
//  CargoTrace
//
//  Created by zhouzhi on 13-6-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomAlertView;
@protocol CustomAlertViewDelegate <NSObject>

- (void)customAlertView:(CustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomAlertView : UIView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirm;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) id <CustomAlertViewDelegate> delegate;

- (id)initWithSeleted;
- (id)initWithTitle:(NSString *)title andConfirmButton:(NSString *)button;
- (id)initWithUrlImage:(NSString *)url;
- (id)initWithCandy:(NSString *)content;
- (void)show;
- (void)hide;
- (void)showSlow;
- (void)hideSlow;
- (void)hideQuickly;
- (void)buttonClicked:(UIButton *)button;
- (void)setWebViewImage:(NSString *)url andImageName:(NSString *)name;

@end
