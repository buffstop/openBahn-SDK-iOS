//
//  MMAPIClient.h
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "MMHTTPRequestOperationDelegate.h"
#import "MMAPIClientSessionDelegate.h"

typedef NS_OPTIONS(NSUInteger, MMAPIClientOptions) {
    MMAPIClientOptionsDefault = 0,
    MMAPIClientOptionsValidateParams = 1 << 0 // will check required params of JSON objects before sending to server
};


@interface MMAPIClient : AFHTTPRequestOperationManager <MMHTTPRequestOperationDelegate>
@property (nonatomic, assign, readonly) MMAPIClientOptions options;
@property (nonatomic, weak) id<MMAPIClientSessionDelegate> sessionDelegate;

#pragma mark - Generic request by api description

- (AFHTTPRequestOperation*)requestWithAPIKey:(NSString *)key
                                   URIParams:(NSDictionary *)uriParams
                                      params: (NSDictionary *)params
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation*)requestWithAPIKey:(NSString *)key
                                headerParams:(NSDictionary *)headerParam
                                   URIParams:(NSDictionary *)uriParams
                                      params: (NSDictionary *)params
                                    httpBody:(NSData *)body
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark -

- (instancetype)initWithBaseURL:(NSURL *)url options:(MMAPIClientOptions)options;

@end
