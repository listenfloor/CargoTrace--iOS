//
//  CTProgressbarView.h
//  CargoTrace
//
//  Created by yanjing on 13-4-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTProgressNob.h"

@interface CTProgressbarView : UIView

@property (nonatomic, assign) CGFloat percentage;

@property (nonatomic, strong) NSMutableArray *progressViews;

@property (nonatomic,assign) int progressSection;

@property (nonatomic, strong)  CTProgressNob *handler;

@property (nonatomic,assign) CGFloat progressbarWidth;

//+ (CTProgressbarView *)sharedInstance;


- (void) animateHandlerToIndex:(int) index;
- (id)initWithFrame:(CGRect)frame  progressSections:(int)section;
- (void)setCurrentSectionIndex:(int)index;

@end
