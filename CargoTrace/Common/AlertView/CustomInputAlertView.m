//
//  CustomInputAlertView.m
//  CargoTrace
//
//  Created by zhouzhi on 13-6-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CustomInputAlertView.h"

@implementation CustomInputAlertView
@synthesize contentTextView = _contentTextView;

- (id)initWithTitle:(NSString *)title andConfirmButton:(NSString *)button andContent:(NSString *)content
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = [AppDelegate ShareAppDelegate].window.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.38;
        [self addSubview:self.backgroundView];
        
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundButton.frame = self.frame;
        [self.backgroundButton addTarget:self
                                  action:@selector(backgroundClicked:)
                        forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.backgroundButton];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.frame = CGRectMake(10, 20, 258, 20);
        
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, 258, 180)];
        self.contentTextView.text = content;
        self.contentTextView.font = [UIFont systemFontOfSize:16];
        self.contentTextView.scrollEnabled = YES;
        self.contentTextView.textColor = [CommonUtil colorWithHexString:@"#343434"];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(11, 265, 118, 40);
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.cancelBtn.tag = 0;
        [self.cancelBtn addTarget:self
                           action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirm.frame = CGRectMake(147, 265, 118, 40);
        [self.confirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
        self.confirm.tag = 1;
        [self.confirm addTarget:self
                         action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, self.confirm.frame.origin.y + self.confirm.frame.size.height + 12)];
        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
        
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tmpButton.frame = self.contentView.frame;
        [tmpButton addTarget:self
                      action:@selector(backgroundClicked:)
            forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:tmpButton];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentTextView];
        [self.contentView addSubview:self.confirm];
        [self.contentView addSubview:self.cancelBtn];
        self.contentView.center = CGPointMake(160, self.center.y - 10);
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)show
{
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [[AppDelegate ShareAppDelegate].window addSubview:self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    [[AppDelegate ShareAppDelegate].window addSubview:self];
}

- (void)hide
{
    self.contentView.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView commitAnimations];
}

- (void)buttonClicked:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(customInputAlertView:clickedButtonAtIndex:)])
    {
        [_delegate customInputAlertView:self clickedButtonAtIndex:button.tag];
    }
    
    [self hide];
}

- (void)backgroundClicked:(id)sender
{
    [self.contentTextView resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
