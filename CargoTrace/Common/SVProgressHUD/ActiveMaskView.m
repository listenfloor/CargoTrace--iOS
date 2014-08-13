//
//  ActiveMaskView.m
//  Glert
//
//  Created by Guo Jian on 11-9-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActiveMaskView.h"

static ActiveMaskView *sharedIndicator;

@implementation ActiveMaskView

@synthesize m_MaskView;
@synthesize m_Indicator;

+(ActiveMaskView*)SharedIndicator
{
    if (sharedIndicator == nil) {
        sharedIndicator = [[ActiveMaskView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return sharedIndicator;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIView *maskView = [[UIView alloc] initWithFrame:frame];
		maskView.alpha = 0.5;
		maskView.backgroundColor = [UIColor grayColor];
		self.m_MaskView = maskView;
		
		UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		indicatorView.frame = CGRectMake(CGRectGetMidX(frame) - 25, CGRectGetMidY(frame) - 25, 50, 50);
		self.m_Indicator = indicatorView;
		
		
		[self addSubview:self.m_MaskView];
		[self addSubview:self.m_Indicator];
        
        mTipView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, TIP_WIDTH, 60)];
        mTipView.backgroundColor = [CommonUtil UIColorFromRGB:TIP_BG_COLOR];
        [mTipView MakeViewRoundCorner:6 andMaskBounds:NO];
        [mTipView MakeViewShadow:CGSizeMake(0, 0) withColor:[UIColor blackColor] withRadius:3];
        [self addSubview:mTipView];
        
        CGRect labelRect = CGRectMake(0, 0, TIP_LABEL_WIDTH, TIP_LABEL_HEIGHT);
        mTipLabel = [[UILabel alloc] initWithFrame:labelRect];
        mTipLabel.center = mTipView.center;
        mTipLabel.backgroundColor = [UIColor clearColor];
        mTipLabel.font = [UIFont systemFontOfSize:TIP_FONT_HEIGHT];
        mTipLabel.textColor = [UIColor blackColor];
        mTipLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:mTipLabel];
        
        mBtn = [[UIButton alloc] initWithFrame:self.bounds];
        mBtn.backgroundColor = [UIColor clearColor];
        [mBtn addTarget:self action:@selector(BtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mBtn];
    }
    return self;
}

-(void)BtnPressed
{
    [self HideInWindow];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

-(void)StartActive
{
	[self.m_Indicator startAnimating];
}
-(void)StopActive
{
	[self.m_Indicator stopAnimating];
}

-(void)ShowInWindow
{
    mTipView.hidden = YES;
    mBtn.hidden = YES;
    mTipLabel.hidden = YES;
    m_Indicator.hidden = NO;
    [[AppDelegate ShareAppDelegate].window addSubview:self];
    [self StartActive];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(HideInWindow) withObject:nil afterDelay:10];
}

-(void)ShowInWindowWithTouchableTip:(NSString *)tip
{
    mTipLabel.hidden = NO;
    mTipView.hidden = NO;
    mBtn.hidden = NO;
    m_Indicator.hidden = YES;
    
    [self ResizeLableWithTip:tip];
    
    [[AppDelegate ShareAppDelegate].window addSubview:self];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(HideInWindow) withObject:nil afterDelay:10];
}

-(void)ShowInWindowWithTip:(NSString *)tip
{
    mTipLabel.hidden = NO;
    mTipView.hidden = NO;
    mBtn.hidden = YES;
    m_Indicator.hidden = YES;
    
    [self ResizeLableWithTip:tip];
    
    [[AppDelegate ShareAppDelegate].window addSubview:self];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(HideInWindow) withObject:nil afterDelay:10];
}

-(void)ResizeLableWithTip:(NSString *)tip
{
    CGSize srcSize = CGSizeMake(TIP_LABEL_WIDTH, TIP_LABEL_HEIGHT);
    CGSize tmpSize = [tip sizeWithFont:[UIFont systemFontOfSize:TIP_FONT_HEIGHT] constrainedToSize:CGSizeMake(srcSize.width, 1000)];
    NSInteger lineNum = tmpSize.height / srcSize.height;
    NSInteger tmp = (int)tmpSize.height % (int)srcSize.height;
    if (tmp > 0) 
    {
        lineNum += 1;
    }
    
    if (lineNum > TIP_LINE_NUM_MAX) {
        lineNum = TIP_LINE_NUM_MAX;
    }
    
    if (lineNum <= 0) {
        lineNum = 1;
    }
    
    
    mTipLabel.numberOfLines = lineNum;
    mTipLabel.text = tip;
    
    if (lineNum > 1) 
    {
        mTipLabel.frame = CGRectMake(0, 0, TIP_LABEL_WIDTH, TIP_LABEL_HEIGHT * lineNum);
    }  
    else 
    {
        mTipLabel.frame = CGRectMake(0, 0, TIP_LABEL_WIDTH, TIP_LABEL_HEIGHT);
    }

    CGRect tmpRect = CGRectInset(mTipLabel.frame, -10, -10);
    mTipView.frame = tmpRect;
    
    mTipView.center = CGPointMake(160, 200);
    mTipLabel.center = CGPointMake(160, 200);

}

-(void)HideInWindow
{
    [self StopActive];
    [self removeFromSuperview];
}

@end
