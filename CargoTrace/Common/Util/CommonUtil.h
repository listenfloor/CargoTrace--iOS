//
//  CommonUtil.h
//  CargoTrace
//
//  Created by yanjing on 13-4-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

//判断iphone 5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
// logo文件 路径
#define GETLOGOFILE(FILE_NAME) [NSString stringWithFormat:@"%@/Documents/aircompany/%@.png", NSHomeDirectory(),FILE_NAME]
//文件 目录9
#define GETLOGOFOLDER() [NSString stringWithFormat:@"%@/Documents/aircompany", NSHomeDirectory()]
//plist文件 路径
#define LISTFILE(FILE_NAME) [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),FILE_NAME]
//candy gif图片 路径
#define GIFFILE(FILE_NAME) [NSString stringWithFormat:@"%@/Documents/%@.gif", NSHomeDirectory(),FILE_NAME]

#define SETTING_LOGIN 5
#define SETTING_SUPPORT 4
#define SETTING_WEIXIN 3
#define SETTING_OPENCLOSEALERT 2
#define SETTING_PERSONINFO 1
#define SETTING_HOME 0

//ptr release macro
#define RELEASE_PTR(_ptr_) if((_ptr_) != nil){[_ptr_ release];_ptr_ = nil;}
//null judge
#define _NULL_JUDGE_(_ptr_) ((_ptr_) != nil && (NSNull*)(_ptr_) != [NSNull null])

#define URL_POST    @"http://awbtrace.efreight.cn:8080/cargotrace/HttpEngine"//生产环境
//#define URL_POST    @"http://115.28.44.200:8080/cargotrace/HttpEngine"//阿里云测试环境
//#define URL_POST    @"http://app.efreight.me/HttpEngine"//测试环境
#define URL_LOGIN   @"http://emall.efreight.cn/eFreightHttpEngine"//生产环境
#define URL_TCAT    @"http://app.efreight.me/HttpEngine"//测试环境
#define URL_WEIXIN  @"http://m.eft.cn/UserAWBHisServlet"//生产环境
#define URL_CANDY   @"http://m.eft.cn/HalloweenServlet"//生产环境
//#define URL_CANDY   @"http://192.168.0.232/HalloweenServlet"//测试环境

// nsnotificationcenter 's define

#define  LOGIN_SUCESS  @"1"
#define  LOGIN_FAIL    @"0"
#define  LOGOUT        @"2"

@interface CommonUtil : NSObject

+ (void)SetSubViewExternNone:(UIViewController *)viewController;
+ (NSInteger)getInterUp:(NSInteger)molecular and:(NSInteger)denominator;
+ (NSInteger)getInterDown:(NSInteger)molecular and:(NSInteger)denominator;
+ (NSInteger)nsstringToUnicode:(NSString *)str;

+ (void)setImageRound:(UIImageView*)aImageView image:(UIImage *)aImage cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth;
+ (void)setButtonRound:(UIButton *)aButton cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth;
+ (void)setLabelRound:(UILabel *)aLabel cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (void)setLayerRound:(CALayer *)aLayer cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth  red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (void)getAllFonts;
+ (UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - 设置响应系统声音
+ (void)setSystemAlarm ;

//modify by zhouzhi
#pragma mark ------UIColor------
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)UIColorFromRGB:(long)rgbValue;
+ (UIColor *)UIColorFromRGB:(long)rgbValue withAlpha:(double)alpha;

#pragma mark ------生成图片------
+ (UIImage *)CreateImage:(NSString *)name withType:(NSString *)type;
+ (UIImage *)CreateRetainedPNGImage:(NSString *)name;
+ (UIImage *)CreatePNGImage:(NSString *)name;
+ (UIImage *)CreateImageWithWholeName:(NSString *)name;
#pragma mark ------获取现支持的航空公司------------
+ (NSArray *)getCompanys;

@end
