//
//  UnderlineUILabel.m
//  Coupon
//
//  Created by zhou zhi on 12-1-13.
//  Copyright 2012 isoftstone. All rights reserved.
//

#import "UnderlineUILabel.h"
#import<QuartzCore/QuartzCore.h>

@implementation UnderlineUILabel

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
	}
	return self;
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGSize fontSize = [self.text sizeWithFont:self.font
									forWidth:self.bounds.size.width
							   lineBreakMode:NSLineBreakByTruncatingTail];
	
	
	
	// Get the fonts color.
	//const float * colors = CGColorGetComponents([UIColor blackColor].CGColor);
	// Sets the color to draw the line
	CGContextSetRGBStrokeColor(ctx, 170/255, 170/255, 170/255, 0.5f); // Format : RGBA
	
	// Line Width : make thinner or bigger if you want
	CGContextSetLineWidth(ctx, 0.5f);
	
	// Calculate the starting point (left) and target (right)
	CGPoint l = CGPointMake(0,
							self.frame.size.height/2.0 + fontSize.height/2.0 - 1);
	CGPoint r = CGPointMake(fontSize.width - 3,
							self.frame.size.height/2.0 + fontSize.height/2.0 - 1);
	
	
    //NSLog(@"point l = (%f, %f)", l.x, l.y);
    //NSLog(@"point r = (%f, %f)", r.x, r.y);
	// Add Move Command to point the draw cursor to the starting point
	CGContextMoveToPoint(ctx, l.x, l.y);
	
	// Add Command to draw a Line
	CGContextAddLineToPoint(ctx, r.x, r.y);
	
	
	// Actually draw the line.
	CGContextStrokePath(ctx);
	
	// should be nothing, but who knows...
	[super drawRect:rect];  
}

@end
