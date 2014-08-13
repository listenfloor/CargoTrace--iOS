//
//  UIImage+DispatchLoad.m
//  DreamChannel
//
//  Created by Slava on 3/28/11.
//  Copyright 2011 Alterplay. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"

@implementation UIWebView (DispatchLoad)

- (void) setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:NULL];
}

- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion {
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"Starting: %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        NSLog(@"Finishing: %@", urlString);
        
        if (responseData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = NO;
                [self loadData:responseData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            });
            if (completion)
            {
                dispatch_async(dispatch_get_main_queue(), completion);
            }
        }
        else {
            NSLog(@"-- impossible download: %@", urlString);
        }
	});
    
}

@end