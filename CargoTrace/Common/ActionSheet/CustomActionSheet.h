//
//  CustomActionSheet.h
//  CargoTrace
//
//  Created by zhouzhi on 13-5-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//
#define HEIGHT_BUTTON 60
#define WIDTH_EVERY 35
#define HEIGHT_EVERY 30

#import <UIKit/UIKit.h>

@class CustomActionSheet;
@protocol CustomActionSheetDelegate <NSObject>

- (void)Share:(NSInteger)tag;

@end

@interface CustomActionSheet : UIActionSheet
@property (nonatomic) NSInteger height;
@property (nonatomic, assign) id<CustomActionSheetDelegate> mDelegate;

- (id)initWithDelegate:(id)delegate;
- (void)updateUI;
@end
