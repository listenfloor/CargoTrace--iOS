//
//  DBUtil.h
//  CargoTrace
//
//  Created by zhouzhi on 13-6-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DBUtil : NSObject
@property (nonatomic)sqlite3 *database;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableArray *departCityArray;
@property (nonatomic, strong) NSMutableArray *destCityArray;

+ (DBUtil*)SharedDBEngine;
- (NSMutableArray*)GetAllDepartCitysAndPorts;
- (NSMutableArray*)GetAllDestCitysAndPorts;
- (void)insertDepartData;
- (void)insertDestData;

@end
