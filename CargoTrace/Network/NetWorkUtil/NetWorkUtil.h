//
//  NetWorkUtil.h
//  DeviceCheck
//
//  Created by yanjing on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h" 
#import <netdb.h>

@interface NetWorkUtil : NSObject

//- (Reachability *)initReachability;
- (BOOL)getNetWorkStatus;  
//- (NSString *)getNetWorkType;

@end
