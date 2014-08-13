//
//  NetWorkUtil.m
//  DeviceCheck
//
//  Created by yanjing on 12-6-28.
//  Copyright (c) 2012年  own . All rights reserved.
//

#import "NetWorkUtil.h"

@implementation NetWorkUtil


//初始化reachability  
- (Reachability *)initReachabilityWithLocaHost{  
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  
    return reachability;  
}  

//初始化reachability   
- (Reachability *)initReachabilityWithInternet{  
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    return reachability;  
}  
//初始化reachability   
- (Reachability *)initReachabilityWithWifi{  
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];  
    return reachability;  
}  

//判断网络是否可用  
- (BOOL)getNetWorkStatus
{
    if ([[self initReachabilityWithInternet] currentReachabilityStatus] == NotReachable) {
        return NO;  
    }else {  
        return YES;  
    }  
}  

//判断wifi网络是否可用  
 
/** 
 获取网络类型 
 return 
 */  
+ (NSString *)getNetWorkType  
{  
    NSString *netWorkType;  
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];//[self initReachabilityWithWifi];  
    switch ([reachability currentReachabilityStatus]) {  
        case ReachableViaWiFi:   //Wifi网络  
            netWorkType = @"wifi";  
            break;  
        case ReachableViaWWAN:  //无线广域网  
            netWorkType = @"wwan";   
            break;  
        default:  
            netWorkType = @"no";  
            break;  
    }  
    return netWorkType;  
}  

/** 
 判断网络是否可用 
 return 
 */  
+ (BOOL)connectedToNetWork
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		   printf("Error. Count not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}


 

@end
