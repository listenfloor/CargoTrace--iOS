//
//  CTProgressbarView.m
//  CargoTrace
//
//  Created by yanjing on 13-4-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CTProgressbarView.h"

//#define LEFT_OFFSET 0
//#define RIGHT_OFFSET 25
//#define TITLE_SELECTED_DISTANCE 5
//#define TITLE_FADE_ALPHA .5f
//#define TITLE_FONT [UIFont fontWithName:@"Optima" size:14]
//#define TITLE_SHADOW_COLOR [UIColor lightGrayColor]
//#define TITLE_COLOR [UIColor blackColor]


@implementation CTProgressbarView

@synthesize progressViews = _progressViews;
@synthesize percentage = _percentage;
@synthesize progressSection = _progressSection;
@synthesize handler = _handler;
@synthesize progressbarWidth = _progressbarWidth;


- (id)initWithFrame:(CGRect)frame  progressSections:(int)section
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         self.progressSection = section ;
         self.progressViews  =  [[NSMutableArray alloc]initWithCapacity:self.progressSection ];
        
        int width = self.frame.size.width;
        
        _progressbarWidth = (width - 2*20)*1.0f/section;
        //[self drawRect:self.frame];
    }
    return self;
}


 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   // CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * cl = nil;
    //NSLog(@"width  ------ %f",_progressbarWidth);
    // Drawing code
    for (int x = 0 ; x < self.progressSection ; x++) {
             
        UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, _progressbarWidth, 5.0)];
        //label.text = @"1";
        label.tag = x ;
        
        if (x%2 == 0) {
            [label setBackgroundColor:[UIColor blueColor]];
         }
        if (x%2 == 1) {
            [label setBackgroundColor:[UIColor grayColor]];
        }

       [self.progressViews addObject:label];
        
       
//         cl = [UIColor colorWithRed:0.5 + x* 0.1 green:0.1 +x* 0.1 blue:1.0 alpha:1.0];
//        [label setBackgroundColor:cl];

    }
    
    CGFloat left = _progressbarWidth/2.0f + 15;
    NSInteger count = 0;
    //CGPoint temppiont;
    CGRect temprect ;
    
    for ( UILabel *progressLabel in self.progressViews) {
      
//        progressLabel.center = CGPointMake(left + (_progressbarWidth+5) * count, self.frame.size.height / 2);
//       
//         cl = [UIColor colorWithRed:0.5 + count* 0.1 green:0.1 + count* 0.1 blue:1.0 alpha:1.0];
//         CGContextSetFillColorWithColor(context, cl.CGColor);
//         //CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
//         CGContextFillEllipseInRect(context, CGRectMake(progressLabel.frame.origin.x-10, progressLabel.frame.origin.y-3, 5, 5));
        
        progressLabel.center = CGPointMake(left + (_progressbarWidth+1) * count, self.frame.size.height / 2);
//        cl = [UIColor colorWithRed:0.5 + count* 0.1 green:0.1 + count* 0.1 blue:1.0 alpha:1.0];
//        CGContextSetFillColorWithColor(context, cl.CGColor);
//        CGContextFillEllipseInRect(context, CGRectMake(progressLabel.frame.origin.x-10, progressLabel.frame.origin.y-3, 5, 5));
        [self addSubview:progressLabel];
        
        //NSLog(@"------ %d",count);
        if (progressLabel.tag == 0) {
           // temppiont = progressLabel.center;
            temprect = progressLabel.frame;
        }
        count++;
        
        if (count == self.progressSection) {
         
//            CGContextFillEllipseInRect(context, CGRectMake(progressLabel.frame.size.width +  progressLabel.frame.origin.x -5, progressLabel.frame.origin.y-3, 15, 15));

        }
    }
   

    self.handler =  [CTProgressNob buttonWithType:UIButtonTypeCustom];
    [_handler setFrame:CGRectMake(temprect.origin.x-5, temprect.origin.y-10, temprect.size.width/5.0f, temprect.size.height * 2.0f)];
    
    [_handler setHandlerColor:cl];
    
    [_handler setAdjustsImageWhenHighlighted:NO];
    [self addSubview: _handler];
 
}

-(CGPoint)getPointForIndex:(int) index{
    CGPoint toPoint ;
    
  if(  index <= self.progressSection)
  {
    NSInteger count = 0;
 // UILabel *progressLabel = nil;
    for ( UILabel *progressLabel in self.progressViews) {
        
        if (progressLabel.tag == index) {
            
           toPoint = progressLabel.frame.origin;
        } 
        
//        NSLog(@"------ %d",count);
        count++;
    }
    
    if   (index == self.progressSection)  {
         UILabel *progressLabel = [self.progressViews objectAtIndex: index-1 ];
         toPoint = CGPointMake(progressLabel.frame.origin.x + progressLabel.frame.size.width +5, progressLabel.frame.origin.y );
        
    }
  }
    return toPoint;
    
}

-(void) animateHandlerToIndex:(int) index{
    
    CGPoint toPoint = [self getPointForIndex:index];
    [UIView beginAnimations:nil context:nil];
    [_handler setFrame:CGRectMake(toPoint.x-5, toPoint.y-10, _handler.frame.size.width, _handler.frame.size.height)];
    [UIView commitAnimations];
}

-(void)setCurrentSectionIndex:(int)index{
    
    [self animateHandlerToIndex:index];
}

@end
