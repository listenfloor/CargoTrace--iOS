//
//  DBUtil.m
//  CargoTrace
//
//  Created by zhouzhi on 13-6-28.
//  Copyright (c) 2013年 efreight. All rights reserved.
//

#import "DBUtil.h"
#import "CityEntity.h"

static DBUtil *_sharedDBUtil;

@implementation DBUtil
@synthesize database;
@synthesize dbQueue;

#pragma mark -----Shared DBEngine-----
+ (DBUtil*)SharedDBEngine
{
	@synchronized(self)
	{
		if (!_sharedDBUtil)
        {
			_sharedDBUtil = [[self alloc] init];
            
            _sharedDBUtil.departCityArray = [[NSMutableArray alloc] init];
            _sharedDBUtil.destCityArray = [[NSMutableArray alloc] init];
            // 创建，最好放在一个单例的类中
//            FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
		}
	}
	return _sharedDBUtil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *dbPath = [self dataFilePath];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return  self;
}

#pragma mark -----db Function------
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userPath = @"CargoTrace.sql";
    return [documentsDirectory stringByAppendingPathComponent:userPath];
}

- (BOOL)isDepartTableExist
{
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        if ([db open])
//        {
//            NSString * sql = @"create table if not exists departcity (pk integer primary key, threecode, chinesename);";
//            [db executeUpdate:sql];
//            [db close];
//        }
//        else
//        {
//            
//        }
//        
//    }];
//    
//    return YES;
    
    // create it
    FMDatabase * db = [FMDatabase databaseWithPath:[self dataFilePath]];
    if ([db open]) {
        NSString * sql = @"create table if not exists departcity (pk integer primary key, threecode, chinesename);";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            return NO;
        } else {
            return YES;
        }
        [db close];
    } else {
        return NO;
    }
    
    return YES;
    
//	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK)//打开数据库不成功
//	{
//		sqlite3_close(database);
//	}
//	else
//	{
//		char *errorMsg;
//		NSString *createSQL = @"create table if not exists departcity (pk integer primary key, threecode, chinesename);";
//		if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK)
//		{
//			sqlite3_close(database);
//			NSAssert1(0,@"Error creating table: %s",errorMsg);
//			return NO;
//		}
//        return YES;
//    }
//    return NO;
}

- (BOOL)isDestTableExist
{
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        if ([db open])
//        {
//            NSString * sql = @"create table if not exists destcity (pk integer primary key, threecode, chinesename);";
//            [db executeUpdate:sql];
//            [db close];
//        }
//        else
//        {
//            
//        }
//        
//    }];
//    
//    return YES;
    
    // create it
    FMDatabase * db = [FMDatabase databaseWithPath:[self dataFilePath]];
    if ([db open]) {
        NSString * sql = @"create table if not exists destcity (pk integer primary key, threecode, chinesename);";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            return NO;
        } else {
            return YES;
        }
        [db close];
    } else {
        return NO;
    }
    
    return YES;
    
//	if(sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK)//打开数据库不成功
//	{
//		sqlite3_close(database);
//	}
//	else
//	{
//		char *errorMsg;
//        //        frdid,frdname,type,addr,addrtitle,lat,lng,content,tontid,aniid,ison,isringing,haveringed,date,contextid,bellid,dist,start,end,isaddrsave
//		NSString *createSQL = @"create table if not exists destcity (pk integer primary key, threecode, chinesename);";
//		if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK)
//		{
//			sqlite3_close(database);
//			NSAssert1(0,@"Error creating table: %s",errorMsg);
//			return NO;
//		}
//        return YES;
//    }
//    return NO;
}

+ (NSString*)UTF8ToNSString:(const unsigned char *)text
{
    if (text != nil)
    {
        return [NSString stringWithUTF8String:(char *)text];
    }
    
    return @"";
}

//- (BOOL)UpdateDBWithSql:(NSString*)sql
//{
//	BOOL ret = NO;
//	if(![self isTableExist])//打开数据库不成功
//	{
//		ret = NO;
//	}
//    else
//    {
//        [self insertTextData];
//		sqlite3_stmt *statement;
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) != SQLITE_OK)
//		{
//		}
//		
//		if (sqlite3_step(statement) == SQLITE_DONE)
//		{
//			ret = YES;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	
//	return ret;
//}

- (NSMutableArray *)GetCityAndPort:(NSString*)sql
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    FMDatabase * db = [FMDatabase databaseWithPath:[self dataFilePath]];
    if ([db open])
    {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            CityEntity *tmpCity = [[CityEntity alloc] init];
            tmpCity.pk = [rs intForColumn:@"pk"];
            tmpCity.threeCode = [rs stringForColumn:@"threecode"];
            tmpCity.ch_name = [rs stringForColumn:@"chinesename"];
            
            [ret addObject:tmpCity];
        }
        [db close];
    }
    
    return ret;
// 	NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:1];
//	
//	sqlite3_stmt *statement;
//    NSInteger err = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil);
//    if(err == SQLITE_OK)
//    {
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CityEntity *tmpCity = [[CityEntity alloc] init];
//            tmpCity.pk = sqlite3_column_int64(statement, 0);
//            tmpCity.threeCode = [DBUtil UTF8ToNSString:sqlite3_column_text(statement, 1)];
//            tmpCity.ch_name = [DBUtil UTF8ToNSString:sqlite3_column_text(statement, 2)];
//            
//            [ret addObject:tmpCity];
//        }
//        
//        sqlite3_finalize(statement);
//    }
//    
//    sqlite3_close(database);
//	
//	return ret;
}

- (NSMutableArray*)GetAllDepartCitysAndPorts
{
    if(![self isDepartTableExist])//打开数据库不成功
	{
		return nil;
	}
    else
    {
        NSString *sql = @"select * from departcity";
        return [self GetCityAndPort:sql];
    }
}

- (NSMutableArray*)GetAllDestCitysAndPorts
{
    if(![self isDestTableExist])//打开数据库不成功
	{
		return nil;
	}
    else
    {
        NSString *sql = @"select * from destcity";
        return [self GetCityAndPort:sql];
    }
}

- (void)insertDepartData
{
//    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//    
//    dispatch_async(q1, ^{
//        
//    });
    
    NSArray *tmpArray = [self GetAllDepartCitysAndPorts];
    if ([tmpArray count] == 0)
    {
        BOOL ret = NO;
        if(![self isDepartTableExist])//打开数据库不成功
        {
            ret = NO;
        }
        else
        {
            for (int i = 0; i < [self.departCityArray count]; i++)
            {
                CityEntity *city = [self.departCityArray objectAtIndex:i];
                
                [self.dbQueue inDatabase:^(FMDatabase *db) {
                    NSString * sql = @"INSERT INTO departcity (threecode, chinesename) VALUES (?,?)";
                    BOOL ret = [db executeUpdate:sql, city.threeCode, city.ch_name];
                    if (!ret)
                    {
                        NSLog(@"Error: failed to insert into the database with message.");
                    }
                }];
            }
        }
    }
    
//                    sqlite3_stmt *statement;
//                    static char *sql =
//                    int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
//                    if (success != SQLITE_OK)
//                    {
//                        NSLog(@"Error: failed to insert:channels");
//                    }
//                    else
//                    {
//                        sqlite3_bind_text(statement, 1, [city.threeCode UTF8String], -1, SQLITE_TRANSIENT);
//                        sqlite3_bind_text(statement, 2, [city.ch_name UTF8String], -1, SQLITE_TRANSIENT);
//                        
//                        success = sqlite3_step(statement);
//                        sqlite3_finalize(statement);
//                        
//                        if (success == SQLITE_ERROR)
//                        {
//                            ret = NO;
//                            NSLog(@"Error: failed to insert into the database with message.");
//                        }
//                        else
//                        {
//                            ret = (YES && ret);
//                        }
//                    }
//                }
//                
//                sqlite3_close(database);
//            }
//        }
//        for (int i = 0; i < 100; ++i) {
//            
//        }
//    });
    
}

- (void)insertDestData
{
//    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
//    
//    dispatch_async(q2, ^{
//        
//    });
    NSArray *tmpArray = [self GetAllDestCitysAndPorts];
    if ([tmpArray count] == 0)
    {
        BOOL ret = NO;
        if(![self isDestTableExist])//打开数据库不成功
        {
            ret = NO;
        }
        else
        {
            for (int i = 0; i < [self.destCityArray count]; i++)
            {
                CityEntity *city = [self.destCityArray objectAtIndex:i];
                
                [self.dbQueue inDatabase:^(FMDatabase *db) {
                    NSString * sql = @"INSERT INTO destcity (threecode, chinesename) VALUES (?,?)";
                    BOOL ret = [db executeUpdate:sql, city.threeCode, city.ch_name];
                    if (!ret)
                    {
                        NSLog(@"Error: failed to insert into the database with message.");
                    }
                }];
            }
        }
    }
    
//    NSArray *tmpArray = [self GetAllDestCitysAndPorts];
//    if ([tmpArray count] == 0)
//    {
//        BOOL ret = NO;
//        if(![self isDestTableExist])//打开数据库不成功
//        {
//            ret = NO;
//        }
//        else
//        {
//            for (int i = 0; i < [self.destCityArray count]; i++)
//            {
//                CityEntity *city = [self.destCityArray objectAtIndex:i];
//                
//                sqlite3_stmt *statement;
//                static char *sql = "INSERT INTO destcity (threecode, chinesename) VALUES (?,?)";
//                int success = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
//                if (success != SQLITE_OK)
//                {
//                    NSLog(@"Error: failed to insert:channels");
//                }
//                else
//                {
//                    sqlite3_bind_text(statement, 1, [city.threeCode UTF8String], -1, SQLITE_TRANSIENT);
//                    sqlite3_bind_text(statement, 2, [city.ch_name UTF8String], -1, SQLITE_TRANSIENT);
//                    
//                    success = sqlite3_step(statement);
//                    sqlite3_finalize(statement);
//                    
//                    if (success == SQLITE_ERROR)
//                    {
//                        ret = NO;
//                        NSLog(@"Error: failed to insert into the database with message.");
//                    }
//                    else
//                    {
//                        ret = (YES && ret);
//                    }
//                }
//            }
//            
//            sqlite3_close(database);
//        }
//    }
}

@end
