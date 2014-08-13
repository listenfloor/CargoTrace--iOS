//
//  CTProgressbarView.h
//  CargoTrace
//
//  Created by yanjing on 13-4-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//


#import "CTProgressNob.h"

@implementation CTProgressNob

@synthesize handlerColor = _handlerColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    // [self setHandlerColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1]];
       [self setBackgroundImage:[UIImage imageNamed:@"pin.png"] forState:UIControlStateNormal];
    }
    return self;
} 

//-(void) setHandlerColor:(UIColor *)hc{
//    [_handlerColor release];
//     _handlerColor = nil;
//    
//    _handlerColor =  [hc retain];
//    [self setNeedsDisplay];
//}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    //    CGColorRef shadowColor = [UIColor colorWithRed:0 green:0
////                                              blue:0 alpha:.4f].CGColor;
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//   
//    //CGContextSaveGState(context);
//    CGContextSetFillColorWithColor(context, _handlerColor.CGColor );
//    CGContextFillEllipseInRect(context, CGRectMake(rect.origin.x -5 , rect.origin.y -5 , 15, 10));
//    CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y, 6, 15));
//    
//  
//    // CGContextRestoreGState(context);
//    
//
//}

@end
