//
//  MMHTTPRequestOperation.h
//  
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "MMAPIClient.h"
#import "MMHTTPRequestOperationDelegate.h"
@interface MMHTTPRequestOperation : AFHTTPRequestOperation
@property (nonatomic, assign) BOOL useRetry;
@property (nonatomic, weak) id<MMHTTPRequestOperationDelegate> requestOperationDelegate;


@end
