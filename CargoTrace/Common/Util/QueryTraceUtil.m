//
//  QueryTraceUtil.m
//  CargoTrace
//
//  Created by Liu Weiwei on 13-1-6.
//  Copyright (c) 2013年 eFreight. All rights reserved.
//

#import "QueryTraceUtil.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "SBJSON.h"

@implementation QueryTraceUtil
@synthesize delegate = delegate;
@synthesize request = _request;
@synthesize loginRequest = _loginRequest;

-(id) init  {
    if(self = [super init]){
        
    }
    return self;
}

+ (NSString *) getElementString:(NSArray *)nodeArr{
    if(nodeArr != nil && nodeArr.count > 0)
        return [[nodeArr objectAtIndex:0] stringValue];
    else
        return @"";
}

+(NSString *)shorten:(NSString*)httpURL
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:httpURL]];
    [request startSynchronous];
    NSString *returnStr = @"";
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *parseError = nil;
        NSDictionary *tmpDic = [jsonParser objectWithString:dataString error:&parseError];
        if (tmpDic)
        {
            NSArray *resultArray = [tmpDic objectForKey:@"urls"];
            if (resultArray)
            {
                returnStr = [[resultArray objectAtIndex:0] objectForKey:@"url_short"];
            }
        }
    }
    
    return returnStr;
}

-(void)GetPublicKey:(NSString *)httpURL
{
    _loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:httpURL]];
    [_loginRequest setDelegate:self];
    [_loginRequest startAsynchronous];
}

-(void)GetForASync:(NSString*)httpURL
{
	if(httpURL == nil || [httpURL compare:@""] == NSOrderedSame) return;
	
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:httpURL]];
    _request.delegate = self;
    [_request setRequestMethod:@"GET"];
    [_request startAsynchronous];
}

//modify by zhouzhi
//异步数据传输部分
- (void)PostForASync:(NSString*)postString withURL:(NSString*)httpURL
{
    NSLog(@"%@?%@", httpURL, postString);
	if(httpURL == nil || [httpURL compare:@""] == NSOrderedSame) return;
	if(postString == nil || [postString compare:@""] == NSOrderedSame) return;
	
	//发送请求时判断是否有[null] <null> null  
	postString = [postString stringByReplacingOccurrencesOfString:@"[null]" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"null" withString:@""];
	
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:httpURL]];
    _request.delegate = self;
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:postString forKey:@"serviceXml"];
    [_request setTimeOutSeconds:8];
    [_request setRequestHeaders:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/x-www-form-urlencoded;charset=UTF-8",@"Content-Type", nil]];
    [_request startAsynchronous];
}

//异步数据传输微信
- (void)PostWeixin:(NSString*)postString withURL:(NSString*)httpURL
{
    NSLog(@"%@?%@", httpURL, postString);
	if(httpURL == nil || [httpURL compare:@""] == NSOrderedSame) return;
	if(postString == nil || [postString compare:@""] == NSOrderedSame) return;
	
    NSMutableData *data = (NSMutableData *)[postString dataUsingEncoding:NSUTF8StringEncoding];
	//发送请求时判断是否有[null] <null> null
	postString = [postString stringByReplacingOccurrencesOfString:@"[null]" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"null" withString:@""];
	
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:httpURL]];
    _request.delegate = self;
    [_request setRequestMethod:@"POST"];
    [_request setPostBody:data];
    [_request setTimeOutSeconds:8];
    [_request setRequestHeaders:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/x-www-form-urlencoded;charset=UTF-8",@"Content-Type", nil]];
    [_request startAsynchronous];
}

//异步绑定用户
- (void)binding:(NSString*)postString withURL:(NSString*)httpURL
{
    NSLog(@"%@?%@", httpURL, postString);
	if(httpURL == nil || [httpURL compare:@""] == NSOrderedSame) return;
	if(postString == nil || [postString compare:@""] == NSOrderedSame) return;
    
	//发送请求时判断是否有[null] <null> null
	postString = [postString stringByReplacingOccurrencesOfString:@"[null]" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"null" withString:@""];
	
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:httpURL]];
    _request.delegate = self;
    [_request setRequestMethod:@"GET"];
    [_request setPostValue:postString forKey:@"serviceJson"];
    [_request setTimeOutSeconds:8];
    [_request setRequestHeaders:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/x-www-form-urlencoded;charset=UTF-8",@"Content-Type", nil]];
    [_request startAsynchronous];
}

//异步数据传输部分
- (void)Login:(NSString*)postString withURL:(NSString*)httpURL
{
    NSLog(@"%@?%@", httpURL, postString);
	if(httpURL == nil || [httpURL compare:@""] == NSOrderedSame) return;
	if(postString == nil || [postString compare:@""] == NSOrderedSame) return;
	
	//发送请求时判断是否有[null] <null> null
	postString = [postString stringByReplacingOccurrencesOfString:@"[null]" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
	postString = [postString stringByReplacingOccurrencesOfString:@"null" withString:@""];
    
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:httpURL]];
    _request.delegate = self;
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:postString forKey:@"serviceXml"];
    [_request setPostValue:@"true" forKey:@"ecrypt"];
    [_request setPostValue:@"5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36" forKey:@"clientinfo"];
    [_request setPostValue:@"" forKey:@"token"];
    
    [_request setTimeOutSeconds:30];
    [_request setRequestHeaders:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"application/x-www-form-urlencoded;charset=utf-8",@"Content-Type", nil]];
    [_request startAsynchronous];
}

- (void)StopFunction
{
    if (self != nil)
    {
		[self ExitCommunicateWithServer];
		self.delegate = nil;
    }
}

- (void)ExitCommunicateWithServer
{
	[_request clearDelegatesAndCancel];
}

#pragma mark - ASIHttpRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)httpRequest
{
    // 当以二进制形式读取返回内容时用这个方法
    NSData *responseData = [httpRequest responseData];
    if (httpRequest == _loginRequest)
    {
        [AppDelegate ShareAppDelegate].cookieArray = (NSMutableArray *)httpRequest.responseCookies;
    }
    
    if(self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(ReturnDataFromNetwork:withData:)])
	{
		if([responseData length] == 0)
		{
			[self.delegate ReturnDataFromNetwork:self withData:nil];
		}
		else
		{
			[self.delegate ReturnDataFromNetwork:self withData:responseData];
		}
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [_request error];
    if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(NetworkError:Message:)])
	{
		[self.delegate NetworkError:self Message:[error localizedDescription]];
	}
}

@end
