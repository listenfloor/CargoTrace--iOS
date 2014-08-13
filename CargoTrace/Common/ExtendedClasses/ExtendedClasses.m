//
//  ExtendedClasses.m
//  GeoBell
//
//  Created by Jian Guo on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ExtendedClasses.h"

@implementation UINavigationBar (CustomBgNavBar) 
- (void)drawRect:(CGRect)rect {  
	UIImage *image = [CommonUtil CreateRetainedPNGImage:@"nav_bg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
}  

-(void)CustomBg
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        UIImage *srcImg = [CommonUtil CreatePNGImage:@"nav_bg"];
        CGRect tmpRect = self.bounds;
        UIGraphicsBeginImageContext(tmpRect.size);
        [srcImg drawInRect:tmpRect];
        UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    }
    [self MakeViewShadow:CGSizeMake(0, 0) withColor:[UIColor blackColor] withRadius:5];
}
@end 

@implementation UINavigationController (CustomNavigationController)
-(NSString*)BackTitle
{
    if (self.viewControllers.count == 1) {
        return @"返回";
    }
    
    UIViewController *backVc = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    NSString *ret = backVc.navigationItem.title;
    if (ret == nil || [ret length] == 0) {
        ret = @"返回";
    }
    
    return ret;
}

-(id)initCustomWithRootViewController:(UIViewController *)rootViewController
{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        @autoreleasepool {
            if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                UIImage *srcImg = [CommonUtil CreatePNGImage:@"nav_bg"];
                CGRect tmpRect = self.navigationBar.bounds;
                UIGraphicsBeginImageContext(tmpRect.size);
                [srcImg drawInRect:tmpRect];
                UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [self.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
            }
            
            [self.navigationBar MakeViewShadow:CGSizeMake(0, 0) withColor:[UIColor blackColor] withRadius:5];
        } 
    }
    return self;
}
@end

@implementation NSDictionary (CustomDict)  
- (NSString*)stringForKey:(id)key {  
	if (_NULL_JUDGE_([self objectForKey:key])) {
        return [self objectForKey:key];
    }
    
    return @"";
}  

- (NSInteger)intForKey:(id)key
{
    if (_NULL_JUDGE_([self objectForKey:key])) {
        return [[self objectForKey:key] intValue];
    }
    
    return -1;
}

- (BOOL)boolForKey:(id)key
{
    if (_NULL_JUDGE_([self objectForKey:key])) {
        return [[self objectForKey:key] boolValue];
    }
    
    return NO;
}

- (double)doubleForKey:(id)key
{
    if (_NULL_JUDGE_([self objectForKey:key])) {
        return [[self objectForKey:key] doubleValue];
    }
    
    return -1;
}

@end 

@implementation UIView (CustonView)
-(void)AddGradientBgWithStartColor:(UIColor*)startColor withEndColor:(UIColor*)endColor
{
    NSArray *array = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    [self AddGradientBg:array];
}

-(void)AddGradientBg:(NSArray*)colors
{
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = colors;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    
//    [self.layer addSublayer:layer];
    [self.layer insertSublayer:layer atIndex:0];
}

-(void)MakeViewRoundCorner:(CGFloat)size andMaskBounds:(BOOL)flag
{
    CALayer *layer = self.layer;
	[layer setCornerRadius:size];
    [layer setMasksToBounds:flag];
    
    for (CALayer *tmpLayer in layer.sublayers) {
        if (CGRectEqualToRect(tmpLayer.bounds, layer.bounds)) {
            [tmpLayer setCornerRadius:size];
            [tmpLayer setMasksToBounds:flag];
        }
    }
}

-(void)MakeViewBorder:(CGFloat)size withColor:(UIColor*)color
{
    CALayer *layer = self.layer;
    [layer setBorderColor:[color CGColor]];
    [layer setBorderWidth:size];
}

-(void)MakeViewShadow:(CGSize)offset withColor:(UIColor*)color withRadius:(CGFloat)radius
{
    CALayer *layer = self.layer;
    [layer setShadowOffset:offset];
    [layer setShadowRadius:radius];
    [layer setShadowOpacity:0.5];
    [layer setShadowColor:color.CGColor];
}
@end

@implementation UIButton (CustomBtn)
-(void)SetDefaultBg
{
    @autoreleasepool {
        [self setBackgroundImage:[CommonUtil CreatePNGImage:@"btn_normal_bg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[CommonUtil CreatePNGImage:@"btn_pressed_bg"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[CommonUtil CreatePNGImage:@"btn_disable_bg"] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self MakeViewRoundCorner:6 andMaskBounds:YES];
    }
}

-(void)SetBg:(NSString *)bg
{
    @autoreleasepool {
        [self setBackgroundImage:[CommonUtil CreatePNGImage:bg] forState:UIControlStateNormal];
        [self setBackgroundImage:[CommonUtil CreatePNGImage:[NSString stringWithFormat:@"%@_pressed", bg]] forState:UIControlStateHighlighted];
        
        [self MakeViewRoundCorner:3 andMaskBounds:YES];
    }
}
@end

@implementation UIViewController(CustomVC)
-(void)BackPressed
{
    if (self.navigationController != nil) {
        if ([self.navigationController.viewControllers count] == 1) {
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)ModalBackPressed
{
    [self dismissModalViewControllerAnimated:YES];
}


-(UIViewController*)GetParentVC
{
    UIViewController *vc = [self parentViewController];
    if (vc == nil && [self respondsToSelector:@selector(presentingViewController)]) {
        vc = [self performSelector:@selector(presentingViewController)];
    }
    
    return vc;
}

@end

@implementation UINavigationItem(CustomUINavigationItem)
-(void)SetCustomTitle:(NSString*)title
{
    self.title = title;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 24)];
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    titleLable.backgroundColor = [UIColor clearColor];
    self.titleView = titleLable;
}
@end

@implementation UITextField(CustomTextField)
-(void)MakeTextFieldBigBorder
{
//    self.borderStyle = UITextBorderStyleLine;
        self.leftViewMode = UITextFieldViewModeAlways;
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 3, self.bounds.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        self.leftView = leftView;
    
}

@end

@implementation UITableViewCell(CustomCell)

-(void)SetDefaultSelectedBg
{
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [CommonUtil UIColorFromRGB:0x8bcaee];
    self.selectedBackgroundView = bgView;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

@end

@implementation ExtendedClasses

@end
