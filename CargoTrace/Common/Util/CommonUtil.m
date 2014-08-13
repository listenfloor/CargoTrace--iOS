//
//  CommonUtil.m
//  CargoTrace
//
//  Created by yanjing on 13-4-8.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (void)SetSubViewExternNone:(UIViewController *)viewController
{
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    viewController.extendedLayoutIncludesOpaqueBars = NO;
    viewController.modalPresentationCapturesStatusBarAppearance = NO;
    viewController.navigationController.navigationBar.translucent = NO;
}

+ (NSInteger)getInterUp:(NSInteger)molecular and:(NSInteger)denominator
{
    if (molecular % denominator == 0)
    {
        return molecular / denominator;
    }
    else
    {
        return (int)(molecular/denominator) + 1;
    }
}

+ (NSInteger)getInterDown:(NSInteger)molecular and:(NSInteger)denominator
{
    if (molecular % denominator == 0)
    {
        return molecular / denominator;
    }
    else
    {
        return (int)(molecular/denominator);
    }
}

+ (NSInteger)nsstringToUnicode:(NSString *)str
{
    NSDictionary *unicodeDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:48], @"0", [NSNumber numberWithInt:49], @"1", [NSNumber numberWithInt:50], @"2", [NSNumber numberWithInt:51], @"3", [NSNumber numberWithInt:52], @"4", [NSNumber numberWithInt:53], @"5", [NSNumber numberWithInt:54], @"6", [NSNumber numberWithInt:55], @"7", [NSNumber numberWithInt:56], @"8", [NSNumber numberWithInt:57], @"9", [NSNumber numberWithInt:97], @"a", [NSNumber numberWithInt:98], @"b", [NSNumber numberWithInt:99], @"c", [NSNumber numberWithInt:100], @"d", [NSNumber numberWithInt:101], @"e", [NSNumber numberWithInt:102], @"f", [NSNumber numberWithInt:103], @"g", [NSNumber numberWithInt:104], @"h", [NSNumber numberWithInt:105], @"i", [NSNumber numberWithInt:106], @"j", [NSNumber numberWithInt:107], @"k", [NSNumber numberWithInt:108], @"l", [NSNumber numberWithInt:109], @"m", [NSNumber numberWithInt:110], @"n", [NSNumber numberWithInt:111], @"o", [NSNumber numberWithInt:112], @"p", [NSNumber numberWithInt:113], @"q", [NSNumber numberWithInt:114], @"r", [NSNumber numberWithInt:115], @"s", [NSNumber numberWithInt:116], @"t", [NSNumber numberWithInt:117], @"u", [NSNumber numberWithInt:118], @"v", [NSNumber numberWithInt:119], @"w", [NSNumber numberWithInt:120], @"x", [NSNumber numberWithInt:121], @"y", [NSNumber numberWithInt:122], @"z", [NSNumber numberWithInt:65], @"A", [NSNumber numberWithInt:66], @"B", [NSNumber numberWithInt:67], @"C", [NSNumber numberWithInt:68], @"D", [NSNumber numberWithInt:69], @"E", [NSNumber numberWithInt:70], @"F", [NSNumber numberWithInt:71], @"G", [NSNumber numberWithInt:72], @"H", [NSNumber numberWithInt:73], @"I", [NSNumber numberWithInt:74], @"J", [NSNumber numberWithInt:75], @"K", [NSNumber numberWithInt:76], @"L", [NSNumber numberWithInt:77], @"M", [NSNumber numberWithInt:78], @"N", [NSNumber numberWithInt:79], @"O", [NSNumber numberWithInt:80], @"P", [NSNumber numberWithInt:81], @"Q", [NSNumber numberWithInt:82], @"R", [NSNumber numberWithInt:83], @"S", [NSNumber numberWithInt:84], @"T", [NSNumber numberWithInt:85], @"U", [NSNumber numberWithInt:86], @"V", [NSNumber numberWithInt:87], @"W", [NSNumber numberWithInt:88], @"X", [NSNumber numberWithInt:89], @"Y", [NSNumber numberWithInt:90], @"Z", [NSNumber numberWithInt:47], @"/", [NSNumber numberWithInt:37], @"%", [NSNumber numberWithInt:46], @".", nil];
    
    NSInteger tmpInt = [[unicodeDic objectForKey:str] intValue];
    return tmpInt;
}

#pragma mark - image 圆角
+ (void)setImageRound:(UIImageView*) aImageView image:(UIImage *) aImage  cornerRadius: (CGFloat)cornerRadius borderWidth :(CGFloat)borderWidth
 {
    UIColor *color = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0];
    
    [aImageView setBackgroundColor:color]; //设置背景透明
     aImageView.layer.masksToBounds = YES;
     aImageView.layer.cornerRadius = cornerRadius;
     aImageView.layer.borderWidth = borderWidth;
     aImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [aImageView setImage:aImage];
}

#pragma mark - 设置 圆角
+ (void)setButtonRound: (UIButton *)aButton cornerRadius: (CGFloat)cornerRadius borderWidth :(CGFloat)borderWidth;
{
    [aButton.layer setMasksToBounds:YES];
    [aButton.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
    [aButton.layer setBorderWidth:borderWidth]; //边框宽度
    
    // CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    
    [aButton.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    aButton.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1 ];
}

+ (void)setLabelRound: (UILabel *) aLabel  cornerRadius: (CGFloat)cornerRadius borderWidth :(CGFloat)borderWidth  red :(CGFloat)red green :(CGFloat)green blue :(CGFloat)blue{
    [aLabel.layer setMasksToBounds:YES];
    [aLabel.layer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
    [aLabel.layer setBorderWidth:borderWidth]; //边框宽度
    [aLabel.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    aLabel.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1 ];
}


+ (void)setLayerRound: (CALayer *) aLayer  cornerRadius: (CGFloat)cornerRadius borderWidth :(CGFloat)borderWidth  red :(CGFloat)red green :(CGFloat)green blue :(CGFloat)blue{
    [aLayer setMasksToBounds:YES];
    [aLayer setCornerRadius:cornerRadius]; //设置矩形四个圆角半径
    [aLayer setBorderWidth:borderWidth]; //边框宽度
    [aLayer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    aLayer.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1 ].CGColor;
}

#pragma mark - get all fonts the search operation

+ (void)getAllFonts{
    NSArray *array = [UIFont familyNames];
    for (NSString * familyname in array) {
        //NSLog(@"Family:%@",familyname);
        NSArray *fontnames = [UIFont fontNamesForFamilyName:familyname];
        for (NSString *name in fontnames)
        {
            //NSLog(@"Font Name:%@",name);
        }
    }    
}
#pragma mark - 设置响应系统声音
+ (void)setSystemAlarm{
    //系统声音
    AudioServicesPlaySystemSound(1105);
    //震动
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - 根据颜色返回图片
+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark ------color------
+(UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor*)UIColorFromRGB:(long)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(UIColor*)UIColorFromRGB:(long)rgbValue withAlpha:(double)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

#pragma mark ------生成图片------
+(UIImage*)CreateImage:(NSString*)name withType:(NSString*)type
{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]];
}

+(UIImage*)CreateRetainedPNGImage:(NSString*)name
{
    @autoreleasepool {
        UIImage *ret = [CommonUtil CreatePNGImage:name];
        
        return ret;
    }
}

+(UIImage*)CreatePNGImage:(NSString*)name
{
    UIImage *ret = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
    if (ret == nil) {
    }
    
    return ret;
}

+(UIImage*)CreateImageWithWholeName:(NSString*)name
{
    UIImage *ret = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    if (ret == nil) {
    }
    
    return ret;
}

#pragma mark ------获取现支持的航空公司------------
+ (NSArray *)getCompanys
{
    NSArray *companyArray = [[NSArray alloc] initWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"001", @"CODE", @"美洲航空公司", @"NAME", @"http://efreight.cn/airline.logo/AA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"006", @"CODE", @"美国达美航空公司", @"NAME", @"http://efreight.cn/airline.logo/DL.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"014", @"CODE", @"加拿大航空公司", @"NAME", @"http://efreight.cn/airline.logo/AC.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"016", @"CODE", @"美国联合航空公司", @"NAME", @"http://efreight.cn/airline.logo/UA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"020", @"CODE", @"德国汉莎航空公司", @"NAME", @"http://efreight.cn/airline.logo/LH.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"023", @"CODE", @"美联邦航空公司", @"NAME", @"http://efreight.cn/airline.logo/FX.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"043", @"CODE", @"港龙航空公司", @"NAME", @"http://efreight.cn/airline.logo/KA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"045", @"CODE", @"智利航空公司", @"NAME", @"http://efreight.cn/airline.logo/LA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"057", @"CODE", @"法国航空公司", @"NAME", @"http://efreight.cn/airline.logo/AF.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"071", @"CODE", @"埃塞俄比亚航空公司", @"NAME", @"http://efreight.cn/airline.logo/ET.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"074", @"CODE", @"荷兰皇家航空公司", @"NAME", @"http://efreight.cn/airline.logo/KL.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"077", @"CODE", @"埃及航空公司", @"NAME", @"http://efreight.cn/airline.logo/MS.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"080", @"CODE", @"波兰航空公司", @"NAME", @"http://efreight.cn/airline.logo/LO.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"081", @"CODE", @"澳大利亚航空公司", @"NAME", @"http://efreight.cn/airline.logo/QF.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"083", @"CODE", @"南非航空公司", @"NAME", @"http://efreight.cn/airline.logo/SA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"098", @"CODE", @"印度航空公司", @"NAME", @"http://efreight.cn/airline.logo/AI.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"105", @"CODE", @"芬兰航空公司", @"NAME", @"http://efreight.cn/airline.logo/AY.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"114", @"CODE", @"以色列航空公司", @"NAME", @"http://efreight.cn/airline.logo/LY.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"117", @"CODE", @"北欧航空公司", @"NAME", @"http://efreight.cn/airline.logo/SK.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"112", @"CODE", @"中国货运航空公司", @"NAME", @"http://efreight.cn/airline.logo/MU.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"125", @"CODE", @"英国航空公司", @"NAME", @"http://efreight.cn/airline.logo/BA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"126", @"CODE", @"印尼鹰航航空公司", @"NAME", @"http://efreight.cn/airline.logo/GA.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"131", @"CODE", @"日本航空公司", @"NAME", @"http://efreight.cn/airline.logo/JL.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"139", @"CODE", @"墨西哥国际航空公司", @"NAME", @"http://efreight.cn/airline.logo/AM.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"157", @"CODE", @"卡塔尔航空公司", @"NAME", @"http://efreight.cn/airline.logo/QR.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"160", @"CODE", @"国泰航空公司", @"NAME", @"http://efreight.cn/airline.logo/CX.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"172", @"CODE", @"卢森堡航空公司", @"NAME", @"http://efreight.cn/airline.logo/CV.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"176", @"CODE", @"阿联酋航空公司", @"NAME", @"http://efreight.cn/airline.logo/EK.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"180", @"CODE", @"大韩航空公司", @"NAME", @"http://efreight.cn/airline.logo/KE.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"205", @"CODE", @"全日空航空公司", @"NAME", @"http://efreight.cn/airline.logo/NH.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"214", @"CODE", @"巴基斯坦航空公司", @"NAME", @"http://efreight.cn/airline.logo/PK.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"217", @"CODE", @"泰国国际航空公司", @"NAME", @"http://efreight.cn/airline.logo/TG.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"232", @"CODE", @"马来西亚航空公司", @"NAME", @"http://efreight.cn/airline.logo/MH.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"235", @"CODE", @"土耳其航空公司", @"NAME", @"http://efreight.cn/airline.logo/TK.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"288", @"CODE", @"香港华民航空公司", @"NAME", @"http://efreight.cn/airline.logo/LD.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"297", @"CODE", @"中华航空公司", @"NAME", @"http://efreight.cn/airline.logo/CI.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"403", @"CODE", @"极地航空货运全球有限公司", @"NAME", @"http://efreight.cn/airline.logo/PO.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"406", @"CODE", @"联合包裹航空公司", @"NAME", @"http://efreight.cn/airline.logo/5X.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"555", @"CODE", @"俄罗斯航空公司", @"NAME", @"http://efreight.cn/airline.logo/SU.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"580", @"CODE", @"俄罗斯空桥货运公司", @"NAME", @"http://efreight.cn/airline.logo/RU.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"603", @"CODE", @"斯里兰卡航空公司", @"NAME", @"http://efreight.cn/airline.logo/UL.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"607", @"CODE", @"阿联酋水晶航空公司", @"NAME", @"http://efreight.cn/airline.logo/EY.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"618", @"CODE", @"新加坡航空公司", @"NAME", @"http://efreight.cn/airline.logo/SQ.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"675", @"CODE", @"澳门航空公司", @"NAME", @"http://efreight.cn/airline.logo/NX.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"695", @"CODE", @"长荣航空公司", @"NAME", @"http://efreight.cn/airline.logo/BR.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"724", @"CODE", @"瑞士国际航空公司", @"NAME", @"http://efreight.cn/airline.logo/LX.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"784", @"CODE", @"中国南方航空公司", @"NAME", @"http://efreight.cn/airline.logo/CZ.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"843", @"CODE", @"亚洲航空", @"NAME", @"http://efreight.cn/airline.logo/D7.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"851", @"CODE", @"香港航空公司", @"NAME", @"http://efreight.cn/airline.logo/HK.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"865", @"CODE", @"墨西哥麦斯航空公司", @"NAME", @"http://efreight.cn/airline.logo/MY.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"871", @"CODE", @"扬子江快运航空公司", @"NAME", @"http://efreight.cn/airline.logo/Y8.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"932", @"CODE", @"英国维珍航空公司", @"NAME", @"http://efreight.cn/airline.logo/VS.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"933", @"CODE", @"日本货运航空公司", @"NAME", @"http://efreight.cn/airline.logo/KZ.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"988", @"CODE", @"韩亚航空公司", @"NAME", @"http://efreight.cn/airline.logo/OZ.logo.png", @"URL", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"999", @"CODE", @"中国国际航空公司", @"NAME", @"http://efreight.cn/airline.logo/CA.logo.png", @"URL", nil],
                             nil];
    return companyArray;
}

@end
