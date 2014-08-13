//
//  tabbarView.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@interface tabbarView : UIView

@property(nonatomic,strong) UIButton *button_1;
@property(nonatomic,strong) UIButton *button_2;

@property(nonatomic,weak) id<tabbarDelegate> delegate;

@end
