//
//  CityEntity.m
//  CargoTrace
//
//  Created by zhouzhi on 13-6-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "CityEntity.h"

@implementation CityEntity
@synthesize pk;
@synthesize threeCode;
@synthesize ch_name;

- (id)init
{
    self = [super init];
    if (self)
    {
        @autoreleasepool
        {
            self.pk = -1;
            self.threeCode = @"";
            self.ch_name = @"";
        }
    }
    
    return self;
}

- (CityEntity *)mutableCopy
{
    CityEntity *tmpCity = [[CityEntity alloc] init];
    tmpCity.threeCode = [self.threeCode mutableCopy];
    tmpCity.ch_name = [self.ch_name mutableCopy];
    return tmpCity;
}

@end
