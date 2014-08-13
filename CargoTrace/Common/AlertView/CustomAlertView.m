//
//  CutomAlertView.m
//  CargoTrace
//
//  Created by zhouzhi on 13-6-7.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIImageView+DispatchLoad.h"
#import "UIWebView+DispatchLoad.h"

@implementation CustomAlertView
@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize contentLabel = _contentLabel;
@synthesize cancelBtn = _cancelBtn;
@synthesize confirm = _confirm;
@synthesize cityCode = _cityCode;
@synthesize delegate = _delegate;
@synthesize webView = _webView;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        self.frame = [AppDelegate ShareAppDelegate].window.frame;
//        self.backgroundView.frame = self.frame;
//        self.backgroundView.backgroundColor = [UIColor blackColor];
//        self.backgroundView.alpha = 0.38;
//        [self addSubview:self.backgroundView];
//        
//        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, 102)];
//        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
//        [self addSubview:self.contentView];
//    }
//    return self;
//}

- (id)initWithSeleted
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = [AppDelegate ShareAppDelegate].window.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.38;
        [self addSubview:self.backgroundView];
        
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundBtn.frame = self.frame;
        [backgroundBtn addTarget:self
                          action:@selector(hide)
                forControlEvents:UIControlEventTouchDown];
        [self insertSubview:backgroundBtn atIndex:1];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(11, 25, 118, 40);
        [self.cancelBtn setTitle:@"始发港" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.cancelBtn.tag = 0;
        [self.cancelBtn addTarget:self
                           action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirm.frame = CGRectMake(147, 25, 118, 40);
        [self.confirm setTitle:@"目的港" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
        self.confirm.tag = 1;
        [self.confirm addTarget:self
                         action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, self.confirm.frame.origin.y + self.confirm.frame.size.height + 25)];
        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.confirm];
        [self.contentView addSubview:self.cancelBtn];
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andConfirmButton:(NSString *)button
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = [AppDelegate ShareAppDelegate].window.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.38;
        [self addSubview:self.backgroundView];
        
        UIFont *cellFont = [UIFont systemFontOfSize:16];
        CGFloat contentWidth = 258.0;
        CGSize constraintSize = CGSizeMake(contentWidth, MAXFLOAT);
        CGSize everyLineHeight = [title sizeWithFont:cellFont];
        CGSize labelSize = [title sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = cellFont;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.text = title;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.frame = CGRectMake(10, 20, contentWidth, labelSize.height);
        self.contentLabel.numberOfLines = ceil(labelSize.height/everyLineHeight.height);
        
        if (button == nil || [button isEqualToString:@""])
        {
            self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
            self.confirm.frame = CGRectMake(0, labelSize.height + 35, 118, 40);
            [self.confirm setTitle:@"确定" forState:UIControlStateNormal];
            [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
            self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
            self.confirm.tag = 0;
            [self.confirm addTarget:self
                             action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.confirm.center = CGPointMake(139, self.confirm.center.y);
        }
        else
        {
            self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelBtn.frame = CGRectMake(11, labelSize.height + 35, 118, 40);
            [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
            self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            self.cancelBtn.tag = 0;
            [self.cancelBtn addTarget:self
                             action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
            self.confirm.frame = CGRectMake(147, labelSize.height + 35, 118, 40);
            [self.confirm setTitle:@"确定" forState:UIControlStateNormal];
            [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
            self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
            self.confirm.tag = 1;
            [self.confirm addTarget:self
                             action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, self.confirm.frame.origin.y + self.confirm.frame.size.height + 12)];
        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.confirm];
        [self.contentView addSubview:self.cancelBtn];
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
    }
    return self;
}

- (id)initWithUrlImage:(NSString *)url
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = [AppDelegate ShareAppDelegate].window.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.38;
        [self addSubview:self.backgroundView];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(11, 300, 118, 40);
        [self.cancelBtn setTitle:@"给糖" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.cancelBtn.tag = 0;
        [self.cancelBtn.layer setMasksToBounds:YES];
        [self.cancelBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        [self.cancelBtn.layer setBorderWidth:2]; //边框宽度
        [self.cancelBtn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
        [self.cancelBtn addTarget:self
                           action:@selector(animationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirm.frame = CGRectMake(147, 300, 118, 40);
        [self.confirm setTitle:@"残忍的拒绝" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
        self.confirm.tag = 1;
        [self.confirm.layer setMasksToBounds:YES];
        [self.confirm.layer setCornerRadius:4]; //设置矩形四个圆角半径
        [self.confirm.layer setBorderWidth:2]; //边框宽度
        [self.confirm.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
        [self.confirm addTarget:self
                         action:@selector(animationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 360)];
        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 12;
        self.contentView.layer.borderWidth = 4;
        self.contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [self initWebView:url];
        
        [self.contentView addSubview:_webView];
        [self.contentView addSubview:self.confirm];
        [self.contentView addSubview:self.cancelBtn];
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)initWebView:(NSString *)url
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.contentView.frame];
    }
    _webView.userInteractionEnabled = NO;//用户不可交互
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:GIFFILE(@"candy")])
    {
        NSData *tempData = [NSData dataWithContentsOfFile:GIFFILE(@"candy")];
        [_webView loadData:tempData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *urlString = [NSURL URLWithString:url];
            NSData *responseData = [NSData dataWithContentsOfURL:urlString];
            if (responseData)
            {
                [responseData writeToFile:GIFFILE(@"candy") atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_webView loadData:responseData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                });
            }
        });
        
        NSData *tempData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tangguo" ofType:@"png"]];
        [_webView loadData:tempData MIMEType:@"image/png" textEncodingName:nil baseURL:nil];
    }
}

- (id)initWithCandy:(NSString *)content
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = [AppDelegate ShareAppDelegate].window.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.38;
        [self addSubview:self.backgroundView];
        
        UIFont *cellFont = [UIFont systemFontOfSize:16];
        CGFloat contentWidth = 258.0;
        CGSize constraintSize = CGSizeMake(contentWidth, 400);
        CGSize everyLineHeight = [content sizeWithFont:cellFont];
        CGSize labelSize = [content sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = cellFont;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.text = content;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.frame = CGRectMake(10, 20, contentWidth, labelSize.height);
        self.contentLabel.numberOfLines = labelSize.height/everyLineHeight.height + 1;
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(11, labelSize.height + 35, 118, 40);
        [self.cancelBtn setTitle:@"炫耀一下" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.cancelBtn.tag = 0;
        [self.cancelBtn addTarget:self
                           action:@selector(animationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirm.frame = CGRectMake(147, labelSize.height + 35, 118, 40);
        [self.confirm setTitle:@"取消" forState:UIControlStateNormal];
        [self.confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirm setBackgroundImage:[CommonUtil CreateImage:@"e_alert_btn" withType:@"png"] forState:UIControlStateNormal];
        self.confirm.titleLabel.font = [UIFont systemFontOfSize:18];
        self.confirm.tag = 1;
        [self.confirm addTarget:self
                         action:@selector(animationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, self.confirm.frame.origin.y + self.confirm.frame.size.height + 12)];
        self.contentView.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.confirm];
        [self.contentView addSubview:self.cancelBtn];
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setWebViewImage:(NSString *)url andImageName:(NSString *)name
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:GIFFILE(name)])
    {
        NSData *tempData = [NSData dataWithContentsOfFile:GIFFILE(name)];
        [_webView loadData:tempData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *urlString = [NSURL URLWithString:url];
            NSData *responseData = [NSData dataWithContentsOfURL:urlString];
            if (responseData)
            {
                [responseData writeToFile:GIFFILE(name) atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_webView loadData:responseData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                });
            }
        });
    }
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

- (void)showSlow
{
    self.confirm.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [[AppDelegate ShareAppDelegate].window addSubview:self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    self.contentView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    [[AppDelegate ShareAppDelegate].window addSubview:self];
}

- (void)hideSlow
{
    self.contentView.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView commitAnimations];
}

- (void)hideQuickly
{
    [self removeFromSuperview];
}

- (void)animationButtonClicked:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
    {
        [_delegate customAlertView:self clickedButtonAtIndex:button.tag];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
    {
        [_delegate customAlertView:self clickedButtonAtIndex:button.tag];
    }
    
    [self hide];
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
