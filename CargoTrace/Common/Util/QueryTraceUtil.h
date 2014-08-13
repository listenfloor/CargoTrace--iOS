//
//  QueryTraceUtil.h
//  CargoTrace
//
//  Created by Liu Weiwei on 13-1-6.
//  Copyright (c) 2013年 eFreight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class QueryTraceUtil;
@protocol QueryTraceUtilDelegate <NSObject>
- (void)ReturnDataFromNetwork:(QueryTraceUtil *)util withData:(NSData *)data;
- (void)NetworkError:(QueryTraceUtil *)util Message:(NSString *)message;
@end

@interface QueryTraceUtil : NSObject{
    id<QueryTraceUtilDelegate> __weak delegate;
    ASIFormDataRequest *request;
}

@property(nonatomic,weak) id<QueryTraceUtilDelegate> delegate;
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) ASIHTTPRequest *loginRequest;

//modify by zhouzhi
+(NSString *)shorten:(NSString*)httpURL;
-(void)GetPublicKey:(NSString*)httpURL;
-(void)GetForASync:(NSString*)httpURL;
-(void)PostForASync:(NSString*)postString withURL:(NSString*)httpURL;
-(void)PostWeixin:(NSString*)postString withURL:(NSString*)httpURL;
- (void)binding:(NSString*)postString withURL:(NSString*)httpURL;
-(void)Login:(NSString*)postString withURL:(NSString*)httpURL;
-(void)StopFunction;
-(void)ExitCommunicateWithServer;
+(NSString *)getElementString:(NSArray *)nodeArr;
@end


