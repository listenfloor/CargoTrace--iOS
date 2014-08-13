//
//  ActiveMaskView.h
//  Glert
//
//  Created by Guo Jian on 11-9-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TIP_BG_COLOR                    0xdeedf4
#define TIP_FONT_HEIGHT                 20
#define TIP_LINE_NUM_MAX                8
#define TIP_WIDTH                       240
#define TIP_LABEL_WIDTH                 220
#define TIP_LABEL_HEIGHT                22
@interface ActiveMaskView : UIView {
	UIView							*m_MaskView;
	UIActivityIndicatorView			*m_Indicator;
    UIView                          *mTipView;
    UILabel                         *mTipLabel;
    UIButton                        *mBtn;
}

@property (nonatomic, strong)UIView								*m_MaskView;
@property (nonatomic, strong)UIActivityIndicatorView			*m_Indicator;

-(void)StartActive;
-(void)StopActive;

-(void)ShowInWindow;
-(void)HideInWindow;

-(void)ShowInWindowWithTip:(NSString*)tip;
-(void)ShowInWindowWithTouchableTip:(NSString *)tip;

-(void)ResizeLableWithTip:(NSString*)tip;

-(void)BtnPressed;

+(ActiveMaskView*)SharedIndicator;
@end
