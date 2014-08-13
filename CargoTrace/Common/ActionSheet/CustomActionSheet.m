//
//  CustomActionSheet.m
//  CargoTrace
//
//  Created by zhouzhi on 13-5-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CustomActionSheet.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"

@implementation CustomActionSheet
@synthesize height;
@synthesize mDelegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super initWithTitle:nil
                       delegate:delegate
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil, nil];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor blackColor];
        [self updateUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    view.backgroundColor = [CommonUtil colorWithHexString:@"#343434"];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 1)];
    line1.backgroundColor = [CommonUtil colorWithHexString:@"#2d2d2d"];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 320, 1)];
    line2.backgroundColor = [CommonUtil colorWithHexString:@"#3d3d3d"];
    [view addSubview:line1];
    [view addSubview:line2];
    [self insertSubview:view atIndex:0];
}

- (void)updateUI
{
    NSArray *subViews = [self subviews];
    for (id object in subViews)
    {
        if ([object isKindOfClass:[UIButton class]])
        {
            [object removeFromSuperview];
        }
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"邮件", @"信息", @"新浪", @"腾讯微博", @"QQ", @"QQ空间", @"微信", @"微信朋友圈", nil];
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"e_detail_mailBtn", @"e_detail_messageBtn", @"e_detail_weiboBtn", @"e_detail_tencentBtn", @"e_detail_qqBtn", @"e_detail_qzoneBtn", @"e_detail_weixinBtn", @"e_detail_weixinCircleBtn", nil];
    NSArray *disableImageArray = [[NSArray alloc] initWithObjects:@"e_detail_mailBtn", @"e_detail_messageBtn", @"e_detail_weiboBtn", @"e_detail_tencentBtn", @"e_detail_qqBtn_n", @"e_detail_qzoneBtn", @"e_detail_weixinBtn_n", @"e_detail_weixinCircleBtn_n", nil];
    
    int row = [array count]/3;
    if ([array count]%3 != 0)
    {
        row++;
    }
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            if (i*3 + j < [array count])
            {
                NSString *str = [array objectAtIndex:i*3 + j];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i*3 +j + 1;
                button.frame = CGRectMake((WIDTH_EVERY*(j+1) + HEIGHT_BUTTON*j), (HEIGHT_EVERY*(i+1) + HEIGHT_BUTTON*i), HEIGHT_BUTTON, HEIGHT_BUTTON);
                NSString *schemesStr = [imageArray objectAtIndex:i*3 +j];
                [button setImage:[CommonUtil CreateImage:schemesStr withType:@"png"] forState:UIControlStateNormal];
                [button addTarget:self
                           action:@selector(Clicked:)
                 forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH_EVERY*(j+1) + HEIGHT_BUTTON*j), (HEIGHT_EVERY*(i+1) + HEIGHT_BUTTON*(i+1)) + 5, HEIGHT_BUTTON, 15)];
                label.backgroundColor = [UIColor clearColor];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
                {
                    label.textColor = [UIColor blackColor];
                }
                else
                {
                    label.textColor = [UIColor whiteColor];
                }
                
                label.font = [UIFont systemFontOfSize:12];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = str;
                [self addSubview:label];
                
                if (i*3 + j == 4)
                {
                    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])
                    {
                        [button setImage:[CommonUtil CreateImage:schemesStr withType:@"png"] forState:UIControlStateNormal];
                        label.text = str;
                    }
                    else
                    {
                        [button setImage:[CommonUtil CreateImage:[disableImageArray objectAtIndex:i*3 +j] withType:@"png"] forState:UIControlStateNormal];
                    }
                }
                
                
                if (i*3 + j == 6 || i*3 + j == 7)
                {
                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
                    {
                        [button setImage:[CommonUtil CreateImage:schemesStr withType:@"png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button setImage:[CommonUtil CreateImage:[disableImageArray objectAtIndex:i*3 +j] withType:@"png"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    
    height = HEIGHT_EVERY * (row + 1) + HEIGHT_BUTTON * row + 15;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(24, height, 272, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelButton.titleLabel setTextColor:[UIColor whiteColor]];
    [cancelButton setBackgroundImage:[CommonUtil CreateImage:@"e_detail_cancleBtn" withType:@"png"] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    
    height = height + 120;
}

- (void)cancel
{
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}

- (void)Clicked:(id)sender
{
    [self cancel];
    
    int tag = ((UIButton *)sender).tag;
    
    if ([mDelegate respondsToSelector:@selector(Share:)])
    {
        [mDelegate Share:tag];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, [AppDelegate ShareAppDelegate].window.frame.size.height - height, 320, height);
    //NSLog(@"%d", height);
}

@end
