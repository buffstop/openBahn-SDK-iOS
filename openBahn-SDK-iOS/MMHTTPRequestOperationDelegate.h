//
//  MMHTTPRequestOperationDelegate.h
//
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@protocol MMHTTPRequestOperationDelegate <NSObject>
@required
-(NSString*)sessionToken;

/**
 Refreshes the session.
 This method will be called by API calls that allow a retry in case the sessionToken has become invalid.
 An attempt to relogin is made with the current userName and password. __Important:__ The error parameter of the completion block is guaranteed to be `nil` upon successful completion, since the `operation` parameter will _not_ be `nil` upon failure.
 @param finished The completionBlock that will be called after the API call has been completed.
 */
-(AFHTTPRequestOperation *)refreshSessionWithCompletionBlock:(void(^)(BOOL success))completionBlock;

-(AFHTTPRequestOperation *)requeueRequest:(NSMutableURLRequest*) request
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
