//
//  BigInt.h
//  CargoTrace
//
//  Created by zhouzhi on 13-5-27.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigInt : NSObject
{
    NSInteger biRadixBase;
    NSInteger biRadixBits;
    NSInteger bitsPerDigit;
    long long biRadix ; // = 2^16 = 65536
    long long biHalfRadix;
    long long biRadixSquared;
    NSInteger maxDigitVal;
    long long maxInteger;
    NSInteger maxDigits;
    NSMutableArray *ZERO_ARRAY;
    BigInt *bigZero;
    BigInt *bigOne;
    NSMutableArray *digits;
    NSArray *highBitMasks;
    NSArray *lowBitMasks;
    NSDictionary *unicodeDic;
}

@property (nonatomic, strong) NSMutableArray *digits;
@property (nonatomic) BOOL isNeg;

+ (id)SharedInstance;
- (void)setFlag:(BOOL)flag;
- (NSString *)biToHex:(BigInt *)x;
- (NSString *)biToString:(BigInt *)x and:(NSInteger)radix;
- (NSInteger)biHighIndex:(BigInt *)x;
- (BigInt *)biFromHex:(NSString *)str;
- (BigInt *)biCopy:(BigInt *)bi;
- (BigInt *)biAdd:(BigInt *)x and:(BigInt *)y;
- (BigInt *)biSubtract:(BigInt *)x and:(BigInt *)y;
- (NSInteger)biCompare:(BigInt *)x and:(BigInt *)y;
- (BigInt *)biShiftLeft:(BigInt *)x and:(NSInteger)n;
- (BigInt *)biShiftRight:(BigInt *)x and:(NSInteger)n;
- (BigInt *)biDivide:(BigInt *)x and:(BigInt *)y;
- (BigInt *)biDivideByRadixPower:(BigInt *)x and:(NSInteger)n;
- (BigInt *)biModuloByRadixPower:(BigInt *)x and:(NSInteger)n;
- (BigInt *)biMultiply:(BigInt *)x and:(BigInt *)y;

@end
