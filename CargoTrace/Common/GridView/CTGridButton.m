//
//  CTGridButton.m
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CTGridButton.h"
#import "CommonUtil.h"

@implementation CTGridButton

@synthesize companyIntTag = _companyIntTag;
@synthesize companyCode = _companyCode;
@synthesize companyImage = _companyImage;
@synthesize companyName = _companyName;
@synthesize companyPic = _companyPic;
@synthesize tag = _tag;
@synthesize layer = _layer;
 
- (id)initWithFrame:(CGRect)frame type:(UIButtonType)buttonType 
{
    self = [super init];
    if (self) {
        // Initialization code
        self.layer = [CALayer layer];
        [self.layer setFrame:frame];
       }
   return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.layer = [CALayer layer];
        if (IS_IPHONE_5) {
            [self.layer setFrame:CGRectMake(0, 0, 60, 60)];
             }else{
                 [self.layer setFrame:CGRectMake(0, 0, 60, 60)];
                }
            }
     return self;
}

//- (CTGridButton *)presentationLayer{
//    
//    if (![[super presentationLayer] isEqual:nil]) {
//        return self;
//    }else{
//        return nil;
//    }
//}
//- (CTGridButton *)hitTest:(CGPoint)p{
//    if(![[super hitTest:p] isEqual:nil]) {
//        return self;
//    }else{
//        return nil;
//    }
//    
// }

//-(id)setButtonProperty{
//    
//    //这里创建一个圆角矩形的按钮
//    self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    //给定button在view上的位置
//    self.frame = CGRectMake(0, 0, 80, 80);
//    //button背景色
//    self.backgroundColor = [UIColor clearColor];
//    //设置button标题
//    [self setTitle:@"点击" forState:UIControlStateNormal];
//    
//
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
