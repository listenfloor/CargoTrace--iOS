//
//  CTGridView.m
//  CargoTrace
//
//  Created by yanjing on 13-4-10.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CTGridView.h"
#import "CTGridButton.h"
#import "CommonUtil.h"
#import "SearchViewController.h"
#import "AppDelegate.h"


#define  HORIZONTAL_DISTANCE  32
#define  HORIZONTAL_DISTANCE_BIG  15

#define  VERTICAL_DISTANCE    15

//#if IS_IPHONE_5
//   #define  HORIZONTAL_DISTANCE  12
//#else
//    #define  HORIZONTAL_DISTANCE  15
//#endif

@implementation CTGridView

@synthesize gridButtonArray = _gridButtonArray;
@synthesize delegateHome =  _delegateHome;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesPoint:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -   touch事件
- (void)touchesPoint:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint locationInView = [gestureRecognizer locationInView:self];
    CTGridButton *temp_but = nil;
    for (CTGridButton *but in self.gridButtonArray) {
        
        temp_but = (CTGridButton *)[[but.layer presentationLayer] hitTest:locationInView];
        if(temp_but!=nil) {
//            NSLog(@"------ 点击了 companyName %@",but.companyName);
            [self.delegateHome delgateAction:but.companyCode];
        }
    }
    
}

- (void)setGridButtonsDeploy{
    
    if (IS_IPHONE_5) {
        [self setGridButtonsDeploy_IS_IPHON5];
    }else{
        [self setGridButtonsDeploy_NO_IPHONE5];
    }
}

- (void)setGridButtonsDeploy_IS_IPHON5
{
    if ([self.gridButtonArray count] != 0)
    {
        int count = [self.gridButtonArray count];
        int page = count/12;
        if (count%12 != 0)
        {
            page++;
        }
        
        //设置最大可移动位置
        self.contentSize = CGSizeMake( page * 320 , self.frame.size.height);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        
        for (int i = 0; i < page; i++)
        {
            UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, self.frame.size.width, 212)];
            tmpImageView.image = [CommonUtil CreateImage:@"e_home_gridbg" withType:@"png"];
            [self addSubview:tmpImageView];
            for (int j = 0; j < 3; j++)
            {
                for (int k = 0; k < 4; k++)
                {
                    if (i*12 + j*4 + k < count)
                    {
                        CTGridButton *ctgButton = (CTGridButton *)[self.gridButtonArray objectAtIndex:(i*12 + j*4 + k)];
                        [ctgButton setTag:(i*12 + j*4 + k)];
                        int center_x = (i * 320) + (k * 80) + 42;
                        int center_y = (j * 71) + 35;
                        CGRect rect = CGRectMake(center_x - ctgButton.layer.frame.size.width/2.0, center_y - ctgButton.layer.frame.size.height/2.0, ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
                        //NSLog(@"rect = (%f,%f,%f,%f)", center_x - ctgButton.layer.frame.size.width/2.0, center_y - ctgButton.layer.frame.size.height/2.0, ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
                        [ctgButton.layer setFrame:rect];
                        
                        [self.layer addSublayer:ctgButton.layer];
                    }
                }
            }
        }
        
    }
}

- (void)setGridButtonsDeploy_NO_IPHONE5
{
    int count = [self.gridButtonArray count];
    int page = count/8;
    if (count%8 != 0)
    {
        page++;
    }
    
    //设置最大可移动位置
    self.contentSize = CGSizeMake( page * 320 , self.frame.size.height);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    for (int i = 0; i < page; i++)
    {
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, self.frame.size.width, 171)];
        tmpImageView.image = [CommonUtil CreateImage:@"e_home_gridbg960" withType:@"png"];
        [self addSubview:tmpImageView];
        for (int j = 0; j < 2; j++)
        {
            for (int k = 0; k < 4; k++)
            {
                if (i*8 + j*4 + k < count)
                {
                    CTGridButton *ctgButton = (CTGridButton *)[self.gridButtonArray objectAtIndex:(i*8 + j*4 + k)];
                    [ctgButton setTag:(i*8 + j*4 + k)];
//                    int rect_x = (i * 320) + (k * ctgButton.layer.frame.size.width) + (HORIZONTAL_DISTANCE_BIG * (k + 1));
//                    int rect_y = (j * ctgButton.layer.frame.size.height) + 25;
//                    CGRect rect = CGRectMake(rect_x,rect_y,ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
//                    NSLog(@"rect = (%d,%d,%f,%f)", rect_x, rect_y, ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
//                    [ctgButton.layer setFrame:rect];
                    int center_x = (i * 320) + (k * 80) + 42;
                    int center_y = (j * 71) + 35;
                    CGRect rect = CGRectMake(center_x - ctgButton.layer.frame.size.width/2.0, center_y - ctgButton.layer.frame.size.height/2.0, ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
                    //NSLog(@"rect = (%f,%f,%f,%f)", center_x - ctgButton.layer.frame.size.width/2.0, center_y - ctgButton.layer.frame.size.height/2.0, ctgButton.layer.frame.size.width,ctgButton.layer.frame.size.height);
                    [ctgButton.layer setFrame:rect];
                    
                    [self.layer addSublayer:ctgButton.layer];
                }
            }
        }
    }
}

- (void)btnPressed:(id)sender{
    //NSLog(@" ---- %@",NSStringFromSelector(_cmd));
    CTGridButton *tempbut = (CTGridButton*)sender;
    [self.delegateHome delgateAction:tempbut.companyCode];
}



@end
