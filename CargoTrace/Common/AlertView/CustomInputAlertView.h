//
//  CustomInputAlertView.h
//  CargoTrace
//
//  Created by zhouzhi on 13-6-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomInputAlertView;
@protocol CustomInputAlertViewDelegate <NSObject>

- (void)customInputAlertView:(CustomInputAlertView *)customInputAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomInputAlertView : UIView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirm;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) id <CustomInputAlertViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title andConfirmButton:(NSString *)button andContent:(NSString *)content;
- (void)show;
- (void)hide;
- (void)buttonClicked:(UIButton *)button;

@end
