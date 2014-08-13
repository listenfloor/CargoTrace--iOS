//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarView.h"



@implementation tabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
//        [self setBackgroundColor:[UIColor blueColor]];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    self.backgroundColor = [CommonUtil colorWithHexString:@"#f2f2f0"];
    [self layoutBtn];
}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button_1 setFrame:CGRectMake(20, 0, 65, 44)];
    [_button_1 setTag:101];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setImage:[CommonUtil CreateImage:@"e_home_search" withType:@"png"] forState:UIControlStateNormal];
    [_button_2 setFrame:CGRectMake(106, 0, 108, 50)];
    [_button_2 setTag:102];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button_1];
    [self addSubview:_button_2];
}

-(void)btn1Click:(id)sender
{
        
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%i",btn.tag);
    switch (btn.tag)
    {
        case 101:
        {
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 102:
        {
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
            break;
        case 104:
            break;
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
