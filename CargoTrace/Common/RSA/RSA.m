//
//  RSA.m
//  CargoTrace
//
//  Created by zhouzhi on 13-5-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "RSA.h"

@implementation RSA
@synthesize e;
@synthesize chunkSize;
@synthesize barrett;
@synthesize radix;

- (void)RSAKeyPair:(NSString *)encryptionExponent and:(NSString *)decryptionExponent and:(NSString *)modulus
{
	e = [[BigInt SharedInstance] biFromHex:encryptionExponent];
	d = [[BigInt SharedInstance] biFromHex:decryptionExponent];
	m = [[BigInt SharedInstance] biFromHex:modulus];
	// We can do two bytes per digit, so
	// chunkSize = 2 * (number of digits in modulus - 1).
	// Since biHighIndex returns the high index, not the number of digits, 1 has
	// already been subtracted.
	chunkSize = 2 * [[BigInt SharedInstance] biHighIndex:m];
	radix = 16;
	barrett = [[Barrett alloc] initWith:m];
}

//function twoDigit(n)
//{
//	return (n < 10 ? "0" : "") + String(n);
//}

- (NSString *)encryptedString:(RSA *)key and:(NSString *)s
{
    NSMutableArray *a = [[NSMutableArray alloc] init];
	NSInteger sl = s.length;
	NSInteger i = 0;
	while (i < sl)
    {
		a[i] = [NSNumber numberWithInt:[CommonUtil nsstringToUnicode:[[s substringFromIndex:i] substringToIndex:1]]];
		i++;
	}
    
	while ([a count] % key.chunkSize != 0)
    {
		a[i++] = [NSNumber numberWithInt:0];
	}
    
	NSInteger al = [a count];
	NSMutableString *result = [[NSMutableString alloc] init];
    BigInt *block; 
	for (i = 0; i < al; i += key.chunkSize)
    {
		block = [[BigInt alloc] init];
        [block setFlag:NO];
        int j = 0;
		for (int k = i; k < i + key.chunkSize; ++j)
        {
            int tmpA = [a[k++] intValue];
			block.digits[j] = [NSNumber numberWithInt:tmpA];
            int tmpInt = tmpA;
            tmpInt = tmpInt + ([a[k++] intValue] << 8);
            
			block.digits[j] = [NSNumber numberWithInt:tmpInt];
		}
        
		BigInt *crypt = [key.barrett BarrettMu_powMod:block and:key.e];//.powMod(block, key.e);
		NSString *text = @"";
        if (key.radix == 16)
        {
            text = [[BigInt SharedInstance] biToHex:crypt];
        }
        else
        {
            text = [[BigInt SharedInstance] biToString:crypt and:key.radix];
        }
        [result appendFormat:@"%@%@", text, @" "];
		//result += text + @"";
	}
    
    NSString *tmpString = [result substringWithRange:NSMakeRange(0, result.length - 1)];
    
	return tmpString;
}

//function encryptedString(key, s)
//// Altered by Rob Saunders (rob@robsaunders.net). New routine pads the
//// string after it has been converted to an array. This fixes an
//// incompatibility with Flash MX's ActionScript.
//{
//	 // Remove last space.
//}
//
//function decryptedString(key, s)
//{
//	var blocks = s.split(" ");
//	if(blocks.length<=1&&s.length>32){
//		var k=0;
//		while(s.length>32){
//			blocks[k]=s.substring(0,32);
//			s=s.substring(32);
//			k++;
//		}
//		blocks[k]=s;
//	}
//	var result = "";
//	var i, j, block;
//	for (i = 0; i < blocks.length; ++i) {
//		var blockstr="";
//		var bi;
//		if (key.radix == 16) {
//			bi = biFromHex(blocks[i]);
//		}
//		else {
//			bi = biFromString(blocks[i], key.radix);
//		}
//		
//		block = key.barrett.powMod(bi, key.d);
//		for (j = 0; j <= biHighIndex(block); ++j) {
//			tmp = String.fromCharCode(block.digits[j] & 255,
//                                      block.digits[j] >> 8);
//			
//			blockstr+=tmp;
//		}
//        // Remove trailing null, if any.
//        if (blockstr.charCodeAt(blockstr.length - 1) == 0) {
//            blockstr = blockstr.substring(0, blockstr.length - 1);
//        }
//        var outputstr ="";
//        for (x=blockstr.length-1;x>=0;x--) {
//            outputstr += blockstr.charAt(x);
//        }
//        
//        result+=outputstr;
//	}
//	return decodeURIComponent(result);
//}

@end
