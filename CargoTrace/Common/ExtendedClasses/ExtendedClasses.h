//
//  ExtendedClasses.h
//  GeoBell
//
//  Created by Jian Guo on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar (CustomBgNavBar)  
- (void)drawRect:(CGRect)rect;
-(void)CustomBg;
@end 

@interface UINavigationController (CustomNavigationController)
-(NSString*)BackTitle;
-(id)initCustomWithRootViewController:(UIViewController *)rootViewController;
@end

@interface NSDictionary (CustomDict)  
- (NSString*)stringForKey:(id)key;
- (NSInteger)intForKey:(id)key;
- (double)doubleForKey:(id)key;
- (BOOL)boolForKey:(id)key;
@end 

@interface UIView (CustonView)
-(void)AddGradientBgWithStartColor:(UIColor*)startColor withEndColor:(UIColor*)endColor;
-(void)AddGradientBg:(NSArray*)colors;
-(void)MakeViewRoundCorner:(CGFloat)size andMaskBounds:(BOOL)flag;
-(void)MakeViewBorder:(CGFloat)size withColor:(UIColor*)color;
-(void)MakeViewShadow:(CGSize)offset withColor:(UIColor*)color withRadius:(CGFloat)radius;
@end

@interface UIButton (CustomBtn)
-(void)SetDefaultBg;
-(void)SetBg:(NSString*)bg;
@end

@interface UIViewController(CustomVC)
-(void)BackPressed;
-(void)ModalBackPressed;

-(UIViewController*)GetParentVC;
@end

@interface UINavigationItem(CustomUINavigationItem)
-(void)SetCustomTitle:(NSString*)title;
@end

@interface UITextField(CustomTextField)
-(void)MakeTextFieldBigBorder;
@end

@interface UITableViewCell(CustomCell)
-(void)SetDefaultSelectedBg;

@end

@interface ExtendedClasses : NSObject

@end
