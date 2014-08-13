//
//  CTGridButton.h
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface CTGridButton : NSObject

@property (strong,nonatomic) UIImage * companyImage;
@property (strong,nonatomic) NSString * companyCode;
@property (strong,nonatomic) NSString * companyName;
@property (strong,nonatomic) NSString * companyPic;
@property (strong,nonatomic) CALayer * layer;
@property (assign,nonatomic) int  companyIntTag;
@property (assign,nonatomic) int  tag;
- (id)initWithFrame:(CGRect)frame type:(UIButtonType)buttonType ;
//-(void)btnPressed:(id)sender;
//- (CALayer *)hitTest:(CGPoint)p;
//- (id)presentationLayer;
@end
