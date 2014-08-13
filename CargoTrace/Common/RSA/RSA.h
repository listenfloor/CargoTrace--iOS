//
//  RSA.h
//  CargoTrace
//
//  Created by zhouzhi on 13-5-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigInt.h"
#import "Barrett.h"

@interface RSA : NSObject
{
    BigInt *e;
	BigInt *d;
	BigInt *m;
	// We can do two bytes per digit, so
	// chunkSize = 2 * (number of digits in modulus - 1).
	// Since biHighIndex returns the high index, not the number of digits, 1 has
	// already been subtracted.
    NSInteger chunkSize;
	NSInteger radix;
	Barrett *barrett;
}

@property (nonatomic, strong) BigInt *e;
@property (nonatomic) NSInteger chunkSize;
@property (nonatomic, strong) Barrett *barrett;
@property (nonatomic) NSInteger radix;

- (void)RSAKeyPair:(NSString *)encryptionExponent and:(NSString *)decryptionExponent and:(NSString *)modulus;
- (NSString *)encryptedString:(RSA *)key and:(NSString *)s;

@end
