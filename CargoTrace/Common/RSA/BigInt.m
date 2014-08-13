//
//  BigInt.m
//  CargoTrace
//
//  Created by zhouzhi on 13-5-27.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "BigInt.h"

@implementation BigInt
@synthesize digits;
@synthesize isNeg;

static BigInt* sharedInstance = nil;

+ (id)SharedInstance
{
    @synchronized(self){
        
        if (nil == sharedInstance)
        {
            sharedInstance = [[self alloc] init];
            [sharedInstance setFlag:NO];
        }
    }
    return sharedInstance;
}

- (NSInteger)min:(NSInteger)first and:(NSInteger)second
{
    if (first >= second)
    {
        return second;
    }
    else
    {
        return first;
    }
}

- (NSInteger)max:(NSInteger)first and:(NSInteger)second
{
    if (first >= second)
    {
        return first;
    }
    else
    {
        return second;
    }
}

- (void)setFlag:(BOOL)flag
{
    biRadixBase = 2;
    biRadixBits = 16;
    bitsPerDigit = biRadixBits;
    biRadix = 65536; // = 2^16 = 65536
    biHalfRadix = 32768;
    biRadixSquared = (long long)biRadix * (long long)biRadix;
    maxDigitVal = biRadix - 1;
    maxInteger = 9999999999999998;
    
    maxDigits = 130;
    ZERO_ARRAY = [[NSMutableArray alloc] initWithCapacity:maxDigits];
    for (int iza = 0; iza < maxDigits; iza++)
    {
        [ZERO_ARRAY addObject:[NSNumber numberWithInt:0]];
    }
    
    if (flag)
    {
        self.digits = nil;
    }
    else
    {
        self.digits = [[NSMutableArray alloc] initWithArray:ZERO_ARRAY];
    }
    
    self.isNeg = NO;
}

- (NSString *)reverseStr:(NSString *)s
{
	NSMutableString *result = [[NSMutableString alloc] init];
	for (int i = s.length - 1; i > -1; --i)
    {
        [result appendFormat:@"%@", [[s substringFromIndex:i] substringToIndex:1]];
	}
	return result;
}

- (NSString *)digitToHex:(NSInteger)n
{
	NSInteger mask = 0xf;
	NSMutableString *result = [[NSMutableString alloc] init];
    NSArray *hexToChar = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", nil];
	for (int i = 0; i < 4; ++i)
    {
        [result appendFormat:@"%@", hexToChar[n & mask]];
        if (n < 0)
        {
            n = ~n + 0x01;
        }
		n >>= 4;
	}
	return [self reverseStr:result];
}

- (NSString *)biToHex:(BigInt *)x
{
    NSMutableString *result = [[NSMutableString alloc] init];
	for (int i = [self biHighIndex:x]; i > -1; --i)
    {
        [result appendFormat:@"%@", [self digitToHex:[x.digits[i] intValue]]];
	}
	return result;
}

- (NSString *)biToString:(BigInt *)x and:(NSInteger)radix
{
    BigInt *b = [[BigInt alloc] init];
    [b setFlag:NO];
	b.digits[0] = [NSNumber numberWithInt:radix];
	NSArray *qr = [[BigInt SharedInstance] biDivideModulo:x and:b];
    NSMutableArray *hexatrigesimalToChar = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    BigInt *tmpBigInt = (BigInt *)qr[1];
    if (!bigZero)
    {
        bigZero = [[BigInt alloc] init];
        [bigZero setFlag:NO];
    }
    
	NSString *result = hexatrigesimalToChar[[tmpBigInt.digits[0] intValue]];
	while ([[BigInt SharedInstance] biCompare:(BigInt *)qr[0] and:bigZero] == 1)
    {
		qr = [[BigInt SharedInstance]  biDivideModulo:(BigInt *)qr[0] and:b];
		//digit = qr[1].digits[0];
        result = [NSString stringWithFormat:@"%@%@", result, hexatrigesimalToChar[[tmpBigInt.digits[0] intValue]]];
	}
    result = [NSString stringWithFormat:@"%@%@", (x.isNeg ? @"-" : @""), [self reverseStr:result]];
	return  result;
}

- (NSInteger)biHighIndex:(BigInt *)x
{
    NSInteger result = [x.digits count] - 1;
    while (result > 0 && [x.digits[result] intValue] == 0)
    {
        --result;
    }
	return result;
}

- (NSInteger)charToHex:(NSString *)str
{
    NSInteger ZERO = 48;
	NSInteger NINE = ZERO + 9;
	NSInteger littleA = 97;
	NSInteger littleZ = littleA + 25;
	NSInteger bigA = 65;
	NSInteger bigZ = 65 + 25;
	NSInteger result;
    
    NSInteger tmpInt = [CommonUtil nsstringToUnicode:str];
	if (tmpInt >= ZERO && tmpInt <= NINE) {
		result = tmpInt - ZERO;
	} else if (tmpInt >= bigA && tmpInt <= bigZ) {
		result = 10 + tmpInt - bigA;
	} else if (tmpInt >= littleA && tmpInt <= littleZ) {
		result = 10 + tmpInt - littleA;
	} else {
		result = 0;
	}
	return result;
}

- (NSInteger)hexToDigit:(NSString *)str
{
    NSInteger result = 0;
    NSInteger sl = [self min:str.length and:4];
    NSString *tmpStr = @"";
    for (int i = 0; i < sl; ++i)
    {
        result <<= 4;
        tmpStr = [[str substringFromIndex:i] substringToIndex:1];
        result |= [self charToHex:tmpStr];
    }
    
    return result;
}

- (BigInt *)biFromHex:(NSString *)str
{
    BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
    NSInteger length = str.length;
    int j = 0;
    NSString *tmpStr = @"";
    for (int i = length; i > 0; i = i - 4)
    {
        tmpStr = [str substringWithRange:NSMakeRange([self max:i - 4 and:0], [self min:i and:4])];
        result.digits[j] = [NSNumber numberWithInt:[self hexToDigit:tmpStr]];
        j++;
    }

    return result;
}

- (BigInt *)biCopy:(BigInt *)bi
{
    BigInt *result = [[BigInt alloc] init];
    [result setFlag:YES];
	result.digits = [NSMutableArray arrayWithArray:bi.digits];
	result.isNeg = bi.isNeg;
	return result;
}

- (NSInteger)biNumBits:(BigInt *)x
{
    NSInteger n = [self biHighIndex:x];
	NSInteger d = [x.digits[n] intValue];
	NSInteger m = (n + 1) * bitsPerDigit;
	NSInteger result;
	for (result = m; result > m - bitsPerDigit; --result)
    {
		if ((d & 0x8000) != 0) break;
		d <<= 1;
	}
	return result;
}

- (BigInt *)biAdd:(BigInt *)x and:(BigInt *)y
{
    BigInt *result = nil;
    
	if (x.isNeg != y.isNeg)
    {
		y.isNeg = !y.isNeg;
		result = [self biSubtract:x and:y];
		y.isNeg = !y.isNeg;
	}
	else
    {
		result = [[BigInt alloc] init];
        [result setFlag:NO];
		NSInteger c = 0;
		NSInteger n;
		for (int i = 0; i < [x.digits count]; ++i)
        {
			n = [x.digits[i] intValue] + [y.digits[i] intValue] + c;
			result.digits[i] = [NSNumber numberWithInt:n % biRadix];
            
            if (n >= biRadix)
            {
                c = 1;
            }
            else
            {
                c = 0;
            }
		}
		result.isNeg = x.isNeg;
	}
	return result;
}

- (BigInt *)biSubtract:(BigInt *)x and:(BigInt *)y
{
    BigInt * result = nil;
	if (x.isNeg != y.isNeg)
    {
		y.isNeg = !y.isNeg;
		result = [self biAdd:x and:y];
		y.isNeg = !y.isNeg;
	}
    else
    {
		result = [[BigInt alloc] init];
        [result setFlag:NO];
		NSInteger n, c;
		c = 0;
        //NSInteger index = [self biHighIndex:x];
		for (int i = 0; i < [x.digits count]; ++i)
        {
			n = [x.digits[i] intValue] - [y.digits[i] intValue] + c;
			result.digits[i] = [NSNumber numberWithInt:n % biRadix];
			// Stupid non-conforming modulus operation.
			if ([result.digits[i] intValue] < 0)
            {
                NSInteger tmpInt = [result.digits[i] intValue];
                tmpInt += biRadix;
                result.digits[i] = [NSNumber numberWithInt:tmpInt];
            }
            if (n < 0)
            {
                c = -1;
            }
            else
            {
                c = 0;
            }
		}
		// Fix up the negative sign, if any.
		if (c == -1)
        {
			c = 0;
			for (int i = 0; i < [x.digits count]; ++i)
            {
				n = 0 - [result.digits[i] intValue] + c;
				result.digits[i] = [NSNumber numberWithInt:n % biRadix];
				// Stupid non-conforming modulus operation.
				if ([result.digits[i] intValue] < 0)
                {
                    NSInteger tmpInt = [result.digits[i] intValue];
                    tmpInt += biRadix;
                    result.digits[i] = [NSNumber numberWithInt:tmpInt];
                }
                if (n < 0)
                {
                    c = -1;
                }
                else
                {
                    c = 0;
                }
			}
			// Result is opposite sign of arguments.
			result.isNeg = !x.isNeg;
		}
        else
        {
			// Result is same sign.
			result.isNeg = x.isNeg;
		}
	}
	return result;
}

- (void)arrayCopy:(NSMutableArray *)src start:(NSInteger)srcStart to:(NSMutableArray *)dest start:(NSInteger)destStart lenght:(NSInteger)n
{
    NSInteger m = [self min:srcStart + n and:[src count]];
	for (int i = srcStart, j = destStart; i < m; ++i, ++j)
    {
		dest[j] = src[i];
	}
}

- (BigInt *)biShiftLeft:(BigInt *)x and:(NSInteger)n
{
    NSInteger digitCount = floor(n / bitsPerDigit);
	BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
    [self arrayCopy:x.digits start:0 to:result.digits start:digitCount lenght:[result.digits count] - digitCount];
	NSInteger bits = n % bitsPerDigit;
	NSInteger rightBits = bitsPerDigit - bits;
    int i = [result.digits count] - 1;
    
    highBitMasks = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0x0000], [NSNumber numberWithInt:0x8000], [NSNumber numberWithInt:0xC000], [NSNumber numberWithInt:0xE000], [NSNumber numberWithInt:0xF000], [NSNumber numberWithInt:0xF800], [NSNumber numberWithInt:0xFC00], [NSNumber numberWithInt:0xFE00], [NSNumber numberWithInt:0xFF00], [NSNumber numberWithInt:0xFF80], [NSNumber numberWithInt:0xFFC0], [NSNumber numberWithInt:0xFFE0], [NSNumber numberWithInt:0xFFF0], [NSNumber numberWithInt:0xFFF8], [NSNumber numberWithInt:0xFFFC], [NSNumber numberWithInt:0xFFFE], [NSNumber numberWithInt:0xFFFF], nil];
    
	for (int i1 = i - 1; i > 0; --i, --i1)
    {
        NSInteger tmpInt = [result.digits[i1] intValue] & [highBitMasks[bits] intValue];
        if (tmpInt < 0)
        {
            tmpInt = ~tmpInt + 0x01;
        }
        tmpInt = tmpInt >> rightBits;
        
		result.digits[i] = [NSNumber numberWithInt:(([result.digits[i] intValue] << bits) & maxDigitVal) | tmpInt];
	}
	result.digits[0] = [NSNumber numberWithInt:(([result.digits[i] intValue] << bits) & maxDigitVal)];
	result.isNeg = x.isNeg;
	return result;
}

- (BigInt *)biShiftRight:(BigInt *)x and:(NSInteger)n
{
    NSInteger digitCount = floor(n / bitsPerDigit);
	BigInt * result = [[BigInt alloc] init];
    [result setFlag:NO];
    [self arrayCopy:x.digits start:digitCount to:result.digits start:0 lenght:[result.digits count] - digitCount];
	NSInteger bits = n % bitsPerDigit;
	NSInteger leftBits = bitsPerDigit - bits;
    int i = 0;
    lowBitMasks = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0x0000], [NSNumber numberWithInt:0x0001], [NSNumber numberWithInt:0x0003], [NSNumber numberWithInt:0x0007], [NSNumber numberWithInt:0x000F], [NSNumber numberWithInt:0x001F], [NSNumber numberWithInt:0x003F], [NSNumber numberWithInt:0x007F], [NSNumber numberWithInt:0x00FF], [NSNumber numberWithInt:0x01FF], [NSNumber numberWithInt:0x03FF], [NSNumber numberWithInt:0x07FF], [NSNumber numberWithInt:0x0FFF], [NSNumber numberWithInt:0x1FFF], [NSNumber numberWithInt:0x3FFF], [NSNumber numberWithInt:0x7FFF], [NSNumber numberWithInt:0xFFFF], nil];
	for (int i1 = i + 1; i < [result.digits count] - 1; ++i, ++i1)
    {
        NSInteger tmpInt1 = [result.digits[i] intValue];
        if (tmpInt1 < 0)
        {
            tmpInt1 = ~tmpInt1 + 0x01;
        }
        tmpInt1 >>= bits;
		result.digits[i] = [NSNumber numberWithInt:tmpInt1 | (([result.digits[i1] intValue] & [lowBitMasks[bits] intValue]) << leftBits)];
	}
    NSInteger tmpInt = [result.digits[[result.digits count] - 1] intValue];
    if (tmpInt < 0)
    {
        tmpInt = ~tmpInt + 0x01;
    }
    tmpInt >>= bits;
	result.digits[[result.digits count] - 1] = [NSNumber numberWithInt:tmpInt];
	result.isNeg = x.isNeg;
	return result;
}

- (BigInt *)biMultiplyByRadixPower:(BigInt *)x and:(NSInteger)n
{
	BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
    [self arrayCopy:x.digits start:0 to:result.digits start:n lenght:[result.digits count] - n];
	return result;
}

- (BigInt *)biDivideByRadixPower:(BigInt *)x and:(NSInteger)n
{
    BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
    [self arrayCopy:x.digits start:n to:result.digits start:0 lenght:[result.digits count] - n];
	return result;
}

- (BigInt *)biModuloByRadixPower:(BigInt *)x and:(NSInteger)n
{
    BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
    [self arrayCopy:x.digits start:0 to:result.digits start:0 lenght:n];
	return result;
}

- (NSInteger)biCompare:(BigInt *)x and:(BigInt *)y
{
	if (x.isNeg != y.isNeg)
    {
        NSInteger tmpInt = 0;
        if(x.isNeg)
        {
            tmpInt = 1;
        }
		return 1 - 2 * tmpInt;
	}
	for (int i = [x.digits count] - 1; i >= 0; --i)
    {
		if (x.digits[i] != y.digits[i])
        {
			if (x.isNeg)
            {
                NSInteger tmpInt = 0;
                if ([x.digits[i] intValue] > [y.digits[i] intValue])
                {
                    tmpInt = 1;
                }
				return 1 - 2 * tmpInt;
			}
            else
            {
                NSInteger tmpInt = 0;
                if ([x.digits[i] intValue] < [y.digits[i] intValue])
                {
                    tmpInt = 1;
                }
				return 1 - 2 * tmpInt;
			}
		}
	}
	return 0;
}

- (BigInt *)biMultiply:(BigInt *)x and:(BigInt *)y
{
	BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
	NSInteger c;
	NSInteger n = [self biHighIndex:x];
	NSInteger t = [self biHighIndex:y];
	long long uv, k;
    
	for (int i = 0; i <= t; ++i) {
		c = 0;
		k = i;
		for (int j = 0; j <= n; ++j, ++k)
        {
			uv = [result.digits[k] intValue] + (long long)[x.digits[j] intValue] * (long long)[y.digits[i] intValue] + c;
			result.digits[k] = [NSNumber numberWithInt:uv & maxDigitVal];
            if (uv < 0)
            {
                uv = ~uv + 0x01;
            }
            c = uv >> biRadixBits;
			//c = Math.floor(uv / biRadix);
		}
		result.digits[i + n + 1] = [NSNumber numberWithInt:c];
	}
	// Someone give me a logical xor, please.
	result.isNeg = x.isNeg != y.isNeg;
	return result;
}

- (BigInt *)biMultiplyDigit:(BigInt *)x and:(NSInteger)y
{
    NSInteger n, c;
    long long uv;
    
	BigInt *result = [[BigInt alloc] init];
    [result setFlag:NO];
	n = [self biHighIndex:x];
	c = 0;
	for (int j = 0; j <= n; ++j)
    {
		uv = [result.digits[j] intValue] + (long long)[x.digits[j] intValue] * (long long)y + c;
		result.digits[j] = [NSNumber numberWithInt:uv & maxDigitVal];
		if (uv < 0)
        {
            uv = ~uv + 0x01;
        }
        c = uv >> biRadixBits;
		//c = Math.floor(uv / biRadix);
	}
	result.digits[1 + n] = [NSNumber numberWithInt:c];
	return result;
}

- (NSArray *)biDivideModulo:(BigInt *)x and:(BigInt *)y
{
    NSInteger nb = [self biNumBits:x];
	NSInteger tb = [self biNumBits:y];
	BOOL origYIsNeg = y.isNeg;
	BigInt *q = nil;
    BigInt *r = nil;
	if (nb < tb)
    {
		if (x.isNeg)
        {
            if (!bigOne)
            {
                bigOne = [[BigInt alloc] init];
                [bigOne setFlag:NO];
                bigOne.digits[0] = [NSNumber numberWithInt:1];
            }
            
			q = [self biCopy:bigOne];
			q.isNeg = !y.isNeg;
			x.isNeg = NO;
			y.isNeg = NO;
			r = [self biSubtract:y and:x];
			// Restore signs, 'cause they're references.
			x.isNeg = YES;
			y.isNeg = origYIsNeg;
		}
        else
        {
			q = [[BigInt alloc] init];
            [q setFlag:NO];
			r = [self biCopy:x];
		}
        
        NSArray *array = [[NSArray alloc] initWithObjects:q, r, nil];
		return array;
	}
    
	q = [[BigInt alloc] init];
    [q setFlag:NO];
	r = x;
    
	// Normalize Y.
	NSInteger t = [CommonUtil getInterUp:tb and:bitsPerDigit] - 1;
	NSInteger lambda = 0;
	while ([y.digits[t] intValue] < biHalfRadix) {
		y = [self biShiftLeft:y and:1];
		++lambda;
		++tb;
		t = [CommonUtil getInterUp:tb and:bitsPerDigit] - 1;
	}
	// Shift r over to keep the quotient constant. We'll shift the
	// remainder back at the end.
	r = [self biShiftLeft:r and:lambda];
	nb += lambda; // Update the bit count for x.
	NSInteger n = [CommonUtil getInterUp:nb and:bitsPerDigit] - 1;
    
	BigInt *b = [self biMultiplyByRadixPower:y and:n - t];
	while ([self biCompare:r and:b] != -1)
    {
        NSInteger tmpInt = [q.digits[n - t] intValue];
        ++tmpInt;
        q.digits[n - t] = [NSNumber numberWithInt:tmpInt];
		r = [self biSubtract:r and:b];
	}
    long long c1 = 0;
    long long c2 = 0;
	for (int i = n; i > t; --i)
    {
        long long ri = (i >= [r.digits count]) ? 0 : [r.digits[i] intValue];
        long long ri1 = (i - 1 >= [r.digits count]) ? 0 : [r.digits[i - 1] intValue];
        long long ri2 = (i - 2 >= [r.digits count]) ? 0 : [r.digits[i - 2] intValue];
        long long yt = (t >= [y.digits count]) ? 0 : [y.digits[t] intValue];
        long long yt1 = (t - 1 >= [y.digits count]) ? 0 : [y.digits[t - 1] intValue];
		if (ri == yt)
        {
			q.digits[i - t - 1] = [NSNumber numberWithInt:maxDigitVal];
		}
        else
        {
			q.digits[i - t - 1] = [NSNumber numberWithInt:floor((ri * biRadix + ri1) / yt)];
		}
        
		c1 = [q.digits[i - t - 1] intValue] * (yt * biRadix + yt1);
		c2 = (ri * biRadixSquared) + ((ri1 * biRadix) + ri2);
		while (c1 > c2)
        {
            NSInteger tmpInt = [q.digits[i - t - 1] intValue];
            --tmpInt;
            q.digits[i - t - 1] = [NSNumber numberWithInt:tmpInt];
			c1 = [q.digits[i - t - 1] intValue] * ((yt * biRadix) | yt1);
			c2 = (ri * biRadix * biRadix) + ((ri1 * biRadix) + ri2);
		}
        
		b = [self biMultiplyByRadixPower:y and:i - t - 1];
		r = [self biSubtract:r and:[self biMultiplyDigit:b and:[q.digits[i - t - 1] intValue]]];
		if (r.isNeg)
        {
			r = [self biAdd:r and:b];
			NSInteger tmpInt = [q.digits[i - t - 1] intValue];
            --tmpInt;
            q.digits[i - t - 1] = [NSNumber numberWithInt:tmpInt];
		}
	}
	r = [self biShiftLeft:r and:lambda];
	// Fiddle with the signs and stuff to make sure that 0 <= r < y.
	q.isNeg = x.isNeg != origYIsNeg;
	if (x.isNeg)
    {
        if (!bigOne)
        {
            bigOne = [[BigInt alloc] init];
            [bigOne setFlag:NO];
            bigOne.digits[0] = [NSNumber numberWithInt:1];
        }
        
		if (origYIsNeg) {
			q = [self biAdd:q and:bigOne];
		} else {
			q = [self biSubtract:q and:bigOne];
		}
		y = [self biShiftRight:y and:lambda];
		r = [self biSubtract:y and:r];
	}
	// Check for the unbelievably stupid degenerate case of r == -0.
	if ([r.digits[0] intValue] == 0 && [self biHighIndex:r] == 0) r.isNeg = NO;
    
	NSArray *array = [[NSArray alloc] initWithObjects:q, r, nil];
    return array;
}

- (BigInt *)biDivide:(BigInt *)x and:(BigInt *)y
{
    return [self biDivideModulo:x and:y][0];
}

- (BigInt *)biModulo:(BigInt *)x and:(BigInt *)y
{
	return [self biDivideModulo:x and:y][1];
}

@end
