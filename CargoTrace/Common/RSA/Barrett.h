//
//  Barrett.h
//  CargoTrace
//
//  Created by zhouzhi on 13-5-27.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInt.h"

@interface Barrett : NSObject
{
    BigInt *modulus;
	NSInteger k;
	BigInt *b2k;
	BigInt *mu;
	BigInt *bkplus1;
//	this.modulo;
//	this.multiplyMod;
//	this.powMod;
}

- (id)initWith:(BigInt *)m;
- (BigInt *)BarrettMu_powMod:(BigInt *)x and:(BigInt *)y;

@end
