//
//  MMJSONRequestSerializer.h
//  
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface MMJSONRequestSerializer : AFJSONRequestSerializer
@property (nonatomic, strong, readonly) NSDictionary *apiDescriptions;

#pragma mark - API Description Methods

- (NSString *)baseURLPathForAPIKey:(NSString *)key;
- (NSDictionary *)URIPathParamsForAPIKey:(NSString *)key;
- (NSString *)URIPathForAPIKey:(NSString *)key;
- (NSDictionary *)defaultParametersForAPIKey:(NSString *)key;

- (NSString *)requestMethodForAPIKey:(NSString *)key;
- (NSString *)acceptTypeForAPIKey:(NSString *)key;
- (BOOL)useAutoReloginForAPIKey:(NSString *)key;

#pragma mark - Generic request by api description

- (NSMutableURLRequest *)createRequestWithAPIKey:(NSString *)key
                                   baseClientURL:(NSURL *)url
                                       URIParams:(NSDictionary *)uriParams
                                          params: (NSDictionary *)params;
@end
