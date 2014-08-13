//
//  CityEntity.h
//  CargoTrace
//
//  Created by zhouzhi on 13-6-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityEntity : NSObject
@property (nonatomic) NSInteger pk;
@property (nonatomic, strong) NSString *threeCode;
@property (nonatomic, strong) NSString *ch_name;

- (CityEntity *)mutableCopy;

@end
