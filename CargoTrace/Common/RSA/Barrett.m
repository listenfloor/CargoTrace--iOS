//
//  Barrett.m
//  CargoTrace
//
//  Created by zhouzhi on 13-5-27.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "Barrett.h"

@implementation Barrett

- (id)initWith:(BigInt *)m
{
    if (self == [super init])
    {
        modulus = [[BigInt SharedInstance] biCopy:m];
        k = [[BigInt SharedInstance] biHighIndex:modulus] + 1;
        b2k = [[BigInt alloc] init];
        [b2k setFlag:NO];
        b2k.digits[2 * k] = [NSNumber numberWithInt:1];
        mu = [[BigInt SharedInstance] biDivide:b2k and:modulus];
        bkplus1 = [[BigInt alloc] init];
        [bkplus1 setFlag:NO];
        bkplus1.digits[k + 1] = [NSNumber numberWithInt:1];// bkplus1 = b^(k+1)
//        modulo = BarrettMu_modulo;
//        this.multiplyMod = BarrettMu_multiplyMod;
//        this.powMod = BarrettMu_powMod;
    }
    
    return self;
}

- (BigInt *)BarrettMu_modulo:(BigInt *)x
{
    BigInt *q1 = [[BigInt SharedInstance] biDivideByRadixPower:x and:k - 1];
	BigInt * q2 = [[BigInt SharedInstance] biMultiply:q1 and:mu];
	BigInt * q3 = [[BigInt SharedInstance] biDivideByRadixPower:q2 and:k + 1];
	BigInt * r1 = [[BigInt SharedInstance] biModuloByRadixPower:x and:k + 1];
	BigInt * r2term = [[BigInt SharedInstance] biMultiply:q3 and:modulus];
	BigInt * r2 = [[BigInt SharedInstance] biModuloByRadixPower:r2term and:k + 1];
	BigInt * r = [[BigInt SharedInstance] biSubtract:r1 and:r2];
	if (r.isNeg)
    {
		r = [[BigInt SharedInstance] biAdd:r and:bkplus1];
	}
	BOOL rgtem;
    if ([[BigInt SharedInstance] biCompare:r and:modulus] >= 0)
    {
        rgtem = YES;
    }
    else
    {
        rgtem = NO;
    }
	while (rgtem)
    {
		r = [[BigInt SharedInstance] biSubtract:r and:modulus];
		if ([[BigInt SharedInstance] biCompare:r and:modulus] >= 0)
        {
            rgtem = YES;
        }
        else
        {
            rgtem = NO;
        }
	}
	return r;
}

- (BigInt *)BarrettMu_multiplyMod:(BigInt *)x and:(BigInt *)y
{
	/*
     x = this.modulo(x);
     y = this.modulo(y);
     */
	BigInt *xy = [[BigInt SharedInstance] biMultiply:x and:y];
	return [self BarrettMu_modulo:xy];
}

- (BigInt *)BarrettMu_powMod:(BigInt *)x and:(BigInt *)y
{
	BigInt * result = [[BigInt alloc] init];
    [result setFlag:NO];
	result.digits[0] = [NSNumber numberWithInt:1];
	BigInt *a = x;
	BigInt *b = y;
	while (1)
    {
		if (([b.digits[0] intValue] & 1) != 0)
        {
            result = [self BarrettMu_multiplyMod:result and:a];
        }
            
		b = [[BigInt SharedInstance] biShiftRight:b and:1];
		if ([b.digits[0] intValue] == 0 && [[BigInt SharedInstance] biHighIndex:b] == 0)
        {
            break;
        }
		a = [self BarrettMu_multiplyMod:a and:a];
	}
	return result;
}

@end
