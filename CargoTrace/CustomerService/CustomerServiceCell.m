//
//  CustomerServiceCell.m
//  CargoTrace
//
//  Created by zhouzhi on 13-12-12.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CustomerServiceCell.h"

@interface CustomerServiceCell ()

@property (nonatomic, retain) UIPanGestureRecognizer   *_panGesture;
@property (nonatomic, assign) CGFloat _initialTouchPositionX;
@property (nonatomic, assign) CGFloat _initialHorizontalCenter;
@property (nonatomic, assign) CustomerServiceCellDirection _lastDirection;
@property (nonatomic, assign) CustomerServiceCellDirection _currentDirection;

- (void)_slideInContentViewFromDirection:(CustomerServiceCellDirection)direction offsetMultiplier:(CGFloat)multiplier;
- (void)_slideOutContentViewInDirection:(CustomerServiceCellDirection)direction;

- (void)_pan:(UIPanGestureRecognizer *)panGesture;

- (void)_setRevealing:(BOOL)revealing;

- (CGFloat)_originalCenter;
- (CGFloat)_bounceMultiplier;

- (BOOL)_shouldDragLeft;
- (BOOL)_shouldDragRight;
- (BOOL)_shouldReveal;

@end

@implementation CustomerServiceCell

#pragma mark - Private Properties
@synthesize _panGesture;
@synthesize _initialTouchPositionX;
@synthesize _initialHorizontalCenter;
@synthesize _lastDirection;
@synthesize _currentDirection;

@synthesize direction    = _direction;
@synthesize delegate     = _delegate;
@synthesize shouldBounce = _shouldBounce;
@synthesize pixelsToReveal = _pixelsToReveal;
@synthesize backView     = _backView;
@synthesize leftImageView = _leftImageView;
@synthesize rightImageView = _rightImageView;
@synthesize location = _location;
@synthesize leftView = _leftView;
@synthesize mContent = _mContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)laySubviews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.shouldBounce = NO;
    self.pixelsToReveal = 0;
    
    self._panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
    self._panGesture.delegate = self;
    [self addGestureRecognizer:self._panGesture];
    
    UIView *backgroundView   = [[UIView alloc] initWithFrame:self.contentView.frame];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.backView                  = backgroundView;
    
    self.colorView = [[UIView alloc] initWithFrame:self.backView.frame];
    [self.backView addSubview:self.colorView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.image = [CommonUtil CreateImage:@"delete_icon" withType:@"png"];
    self.leftImageView = imageView;
    self.leftImageView.center = CGPointMake(-30, 22);
    [self.backView addSubview:self.leftImageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView1.image = [CommonUtil CreateImage:@"more_icon" withType:@"png"];
    self.rightImageView = imageView1;
    self.rightImageView.center = CGPointMake(350, 22);
    [self.backView addSubview:self.rightImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self addSubview:self.backView];
	[self addSubview:self.contentView];
	self.backView.frame = self.contentView.frame;
}

#pragma mark - Accessors
#import <objc/runtime.h>

static char BOOLRevealing;

- (BOOL)isRevealing
{
	return [(NSNumber *)objc_getAssociatedObject(self, &BOOLRevealing) boolValue];
}

- (void)setRevealing:(BOOL)revealing
{
	// Don't change the value if its already that value.
	// Reveal unless the delegate says no
	if (revealing == self.revealing ||
		(revealing && self._shouldReveal))
		return;
	
	[self _setRevealing:revealing];
	
	if (self.isRevealing)
		[self _slideOutContentViewInDirection:(self.isRevealing) ? self._currentDirection : self._lastDirection];
	else
		[self _slideInContentViewFromDirection:(self.isRevealing) ? self._currentDirection : self._lastDirection offsetMultiplier:self._bounceMultiplier];
}

- (void)_setRevealing:(BOOL)revealing
{
	[self willChangeValueForKey:@"isRevealing"];
	objc_setAssociatedObject(self, &BOOLRevealing, [NSNumber numberWithBool:revealing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self didChangeValueForKey:@"isRevealing"];
	
	if (self.isRevealing && [self.delegate respondsToSelector:@selector(cellDidReveal:)])
		[self.delegate cellDidReveal:self];
}

- (BOOL)_shouldReveal
{
	// Conditions are checked in order
	return (![self.delegate respondsToSelector:@selector(cellShouldReveal:)] || [self.delegate cellShouldReveal:self]);
}

#pragma mark - Handing Touch

- (void)_pan:(UIPanGestureRecognizer *)recognizer
{
	
	CGPoint translation           = [recognizer translationInView:self];
	CGPoint currentTouchPoint     = [recognizer locationInView:self];
	CGPoint velocity              = [recognizer velocityInView:self];
	
	CGFloat originalCenter        = self._originalCenter;
	CGFloat currentTouchPositionX = currentTouchPoint.x;
	CGFloat panAmount             = self._initialTouchPositionX - currentTouchPositionX;
	CGFloat newCenterPosition     = self._initialHorizontalCenter - panAmount;
	CGFloat centerX               = self.contentView.center.x;
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		
		// Set a baseline for the panning
		self._initialTouchPositionX = currentTouchPositionX;
		self._initialHorizontalCenter = self.contentView.center.x;
		
		if ([self.delegate respondsToSelector:@selector(cellDidBeginPan:)])
			[self.delegate cellDidBeginPan:self];
		
		
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		
		// If the pan amount is negative, then the last direction is left, and vice versa.
		if (newCenterPosition - centerX < 0)
        {
            self._lastDirection = CustomerServiceCellDirectionLeft;
        }
		else
        {
			self._lastDirection = CustomerServiceCellDirectionRight;
        }
		
		// Don't let you drag past a certain point depending on direction
		if ((newCenterPosition < originalCenter && !self._shouldDragLeft) || (newCenterPosition > originalCenter && !self._shouldDragRight))
			newCenterPosition = originalCenter;
		
		if (self.pixelsToReveal != 0) {
			// Let's not go waaay out of bounds
			if (newCenterPosition > originalCenter + self.pixelsToReveal)
				newCenterPosition = originalCenter + self.pixelsToReveal;
			
			else if (newCenterPosition < originalCenter - self.pixelsToReveal)
				newCenterPosition = originalCenter - self.pixelsToReveal;
		}else {
			// Let's not go waaay out of bounds
			if (newCenterPosition > self.bounds.size.width + originalCenter)
				newCenterPosition = self.bounds.size.width + originalCenter;
			
			else if (newCenterPosition < -originalCenter)
				newCenterPosition = -originalCenter;
		}
		
		CGPoint center = self.contentView.center;
		center.x = newCenterPosition;
		
		self.contentView.layer.position = center;
        
        if (center.x >= 160)
        {
            self.leftImageView.center = CGPointMake(center.x - 190, 22);
            self.rightImageView.center = CGPointMake(350, 22);
            self.colorView.backgroundColor = [CommonUtil colorWithHexString:@"#fd6b05"];//[UIColor redColor];
            self.colorView.alpha = (center.x - 160)/200.0;
        }
        else
        {
            self.leftImageView.center = CGPointMake(-30, 22);
            self.rightImageView.center = CGPointMake(center.x + 190, 22);
            self.colorView.backgroundColor = [CommonUtil colorWithHexString:@"#75bb42"];
            self.colorView.alpha = (160 - center.x)/200.0;
        }
		
	} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
		// Swiping left, velocity is below 0.
		// Swiping right, it is above 0
		// If the velocity is above the width in points per second at any point in the pan, push it to the acceptable side
		// Otherwise, if we are 60 points in, push to the other side
		// If we are < 60 points in, bounce back
		
#define kMinimumVelocity self.contentView.frame.size.width
#define kMinimumPan      160.0
		
		CGFloat velocityX = velocity.x;
		
		BOOL push = (velocityX < -kMinimumVelocity);
		push |= (velocityX > kMinimumVelocity);
		push |= ((self._lastDirection == CustomerServiceCellDirectionLeft && translation.x < -kMinimumPan) || (self._lastDirection == CustomerServiceCellDirectionRight && translation.x > kMinimumPan));
		push &= self._shouldReveal;
		push &= ((self._lastDirection == CustomerServiceCellDirectionRight && self._shouldDragRight) || (self._lastDirection == CustomerServiceCellDirectionLeft && self._shouldDragLeft));
		
		if (velocityX > 0 && self._lastDirection == CustomerServiceCellDirectionLeft)
			push = NO;
		
		else if (velocityX < 0 && self._lastDirection == CustomerServiceCellDirectionRight)
			push = NO;
		
		if (push && !self.isRevealing) {
			if (translation.x < -kMinimumPan || translation.x > kMinimumPan)
            {
                [self _slideOutContentViewInDirection:self._lastDirection];
            }
            else
            {
                [self _slideOutContentViewInDirection:CustomerServiceCellDirectionNone];
            }
			[self _setRevealing:YES];
			
			self._currentDirection = self._lastDirection;
			
		} else if (self.isRevealing && translation.x != 0) {
			CGFloat multiplier = self._bounceMultiplier;
			if (!self.isRevealing)
				multiplier *= -1.0;
            
			[self _slideInContentViewFromDirection:self._currentDirection offsetMultiplier:multiplier];
			[self _setRevealing:NO];
			
		} else if (translation.x != 0) {
			// Figure out which side we've dragged on.
			CustomerServiceCellDirection finalDir = CustomerServiceCellDirectionRight;
			if (translation.x < 0)
				finalDir = CustomerServiceCellDirectionLeft;
            
			[self _slideInContentViewFromDirection:finalDir offsetMultiplier:-1.0 * self._bounceMultiplier];
			[self _setRevealing:NO];
		}
	}
}

- (BOOL)_shouldDragLeft
{
	return (self.direction == CustomerServiceCellDirectionBoth || self.direction == CustomerServiceCellDirectionLeft);
}

- (BOOL)_shouldDragRight
{
	return (self.direction == CustomerServiceCellDirectionBoth || self.direction == CustomerServiceCellDirectionRight);
}

- (CGFloat)_originalCenter
{
	return ceil(self.bounds.size.width/2);
}

- (CGFloat)_bounceMultiplier
{
	return self.shouldBounce ? MIN(ABS(self._originalCenter - self.contentView.center.x) / kMinimumPan, 1.0) : 0.0;
}

#pragma mark - Sliding
#define kBOUNCE_DISTANCE 7.0

- (void)_slideInContentViewFromDirection:(CustomerServiceCellDirection)direction offsetMultiplier:(CGFloat)multiplier
{
	CGFloat bounceDistance;
	
	if (self.contentView.center.x == self._originalCenter)
		return;
	
	switch (direction) {
		case CustomerServiceCellDirectionRight:
			bounceDistance = kBOUNCE_DISTANCE * multiplier;
			break;
		case CustomerServiceCellDirectionLeft:
			bounceDistance = -kBOUNCE_DISTANCE * multiplier;
			break;
		default:
			@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
			break;
	}
	
	
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
					 animations:^
     {
         self.contentView.center = CGPointMake(self._originalCenter, self.contentView.center.y);
         if (self.contentView.center.x > 160)
         {
             self.leftImageView.center = CGPointMake(self.contentView.center.x - 190, self.contentView.center.y);
         }
         else
         {
             self.rightImageView.center = CGPointMake(self.contentView.center.x + 190, self.contentView.center.y);
         }
     }
					 completion:^(BOOL f) {
                         
						 [UIView animateWithDuration:0.1 delay:0
											 options:UIViewAnimationCurveEaseOut
										  animations:^
                          {
                              self.contentView.frame = CGRectOffset(self.contentView.frame, bounceDistance, 0);
                              if (self.contentView.center.x > 160)
                              {
                                  self.leftImageView.center = CGPointMake(self.contentView.center.x - 190, self.contentView.center.y);
                              }
                              else
                              {
                                  self.rightImageView.center = CGPointMake(self.contentView.center.x + 190, self.contentView.center.y);
                              }
                          }
										  completion:^(BOOL f) {
											  
                                              [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationCurveEaseIn
                                                               animations:^
                                               {
                                                   self.contentView.frame = CGRectOffset(self.contentView.frame, -bounceDistance, 0);
                                                   if (self.contentView.center.x > 160)
                                                   {
                                                       self.leftImageView.center = CGPointMake(self.contentView.center.x - 190, self.contentView.center.y);
                                                   }
                                                   else
                                                   {
                                                       self.rightImageView.center = CGPointMake(self.contentView.center.x + 190, self.contentView.center.y);
                                                   }
                                               }
                                                               completion:NULL];
										  }
						  ];
					 }];
    
    [self performSelector:@selector(Padding) withObject:nil afterDelay:0.3];
}

- (void)_slideOutContentViewInDirection:(CustomerServiceCellDirection)direction;
{
	CGFloat x;
	
	if (self.pixelsToReveal != 0) {
		switch (direction) {
			case CustomerServiceCellDirectionLeft:
				x = self._originalCenter - self.pixelsToReveal;
				break;
			case CustomerServiceCellDirectionRight:
				x = self._originalCenter + self.pixelsToReveal;
				break;
            case CustomerServiceCellDirectionNone:
				x = 160 + self.pixelsToReveal;
				break;
			default:
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
				break;
		}
	}
	else {
		switch (direction) {
			case CustomerServiceCellDirectionLeft:
				x = - self._originalCenter;
				break;
			case CustomerServiceCellDirectionRight:
				x = self.contentView.frame.size.width + self._originalCenter;
				break;
            case CustomerServiceCellDirectionNone:
				x = 160;
                break;
			default:
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:direction] forKey:@"direction"]];
				break;
		}
	}
	
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^
     {
         self.contentView.center = CGPointMake(x, self.contentView.center.y);
         if (self.contentView.center.x > 160)
         {
             self.leftImageView.center = CGPointMake(x - 190, self.contentView.center.y);
         }
         else if (self.contentView.center.x < 160)
         {
             self.rightImageView.center = CGPointMake(x + 190, self.contentView.center.y);
         }
         else
         {
             self.leftImageView.center = CGPointMake(x - 190, self.contentView.center.y);
             self.rightImageView.center = CGPointMake(x + 190, self.contentView.center.y);
         }
         
     }
					 completion:NULL];
    
    [self performSelector:@selector(Padding) withObject:nil afterDelay:0.2];
}

- (void)Padding
{
    if (self.contentView.center.x > 160)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidPad:Direction:)])
        {
            [self.delegate cellDidPad:self Direction:CustomerServiceCellDirectionLeft];
        }
    }
    else if (self.contentView.center.x < 160)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidPad:Direction:)])
        {
            [self.delegate cellDidPad:self Direction:CustomerServiceCellDirectionRight];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self._panGesture) {
		UIScrollView *superview = (UIScrollView *)self.superview;
		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
		
		// Make sure it is scrolling horizontally
		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO && (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
	}
	return NO;
}

@end
