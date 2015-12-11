//
//  MMAPIClient.m
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMAPIClient.h"
#import "MMServerErrorResponseSerializer.h"
#import "MMURLAuthenticatedResponseSerializer.h"
#import "MMHTTPRequestOperation.h"
#import "MMJSONRequestSerializer.h"


@interface MMAPIClient ()
@property (nonatomic, assign, readwrite) MMAPIClientOptions options;
@end

@implementation MMAPIClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }

    NSArray *responseSerializers = @[[MMServerErrorResponseSerializer serializer],
                             [AFJSONResponseSerializer serializer],
                             [AFImageResponseSerializer serializer],
                             [AFHTTPResponseSerializer serializer]];
    
    self.responseSerializer = [MMURLAuthenticatedResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];
    self.requestSerializer = [MMJSONRequestSerializer serializer];
    
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url options:(MMAPIClientOptions)options
{
    self = [self initWithBaseURL:url];
    if (self) {
        self.options = options;
    }
    return self;
}

#pragma mark - Headers
- (id)defaultValueForHeader:(NSString *)key
{
    NSDictionary *headerFields = [self.requestSerializer HTTPRequestHeaders];
    return headerFields[key];
}

- (void)setDefaultValue:(id)value forHeader:(NSString *)key
{
    [self.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    MMHTTPRequestOperation *operation = [[MMHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    operation.requestOperationDelegate = self;
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    return operation;
}

-(NSString*)sessionToken
{
    return [self.sessionDelegate sessionToken];
}

-(AFHTTPRequestOperation *)refreshSessionWithCompletionBlock:(void(^)(BOOL success))completionBlock
{
    __block AFHTTPRequestOperation *operation = nil;
    [self.operationQueue setSuspended:YES];
    if (self.sessionDelegate) {
        operation = [self.sessionDelegate refreshSessionWithCompletionBlock:^(BOOL success) {
            if (completionBlock) {
                completionBlock(success);
            }
        }];
    } else {
#warning no sessionDelegate but refreshSessionWithCompletionBlock is called.
        if (completionBlock) {
            completionBlock(NO);
        }
    }

    [self.operationQueue setSuspended:NO];
	return operation;
}

-(AFHTTPRequestOperation *)requeueRequest:(NSMutableURLRequest*) request
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
																	  success:success
																	  failure:failure];
	
    operation.queuePriority = NSOperationQueuePriorityHigh;
    [self.operationQueue addOperation:operation];
    return operation;
}



-(NSDictionary*)queryParametersForRequest:(NSURLRequest*)request
{
    NSString* query = request.URL.query;
    if(!query)
    {
        return nil;
    }
    NSArray *parameterPairs = [query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
    
    for (NSString *currentPair in parameterPairs) {
        NSArray *pairComponents = [currentPair componentsSeparatedByString:@"="];
        
        NSString *key = ([pairComponents count] >= 1 ? [pairComponents objectAtIndex:0] : nil);
        if (key == nil) continue;
        
        NSString *value = ([pairComponents count] >= 2 ? [pairComponents objectAtIndex:1] : [NSNull null]);
        [parameters setObject:value forKey:key];
    }
    
    return parameters;
}



-(AFHTTPRequestOperation*)requestWithAPIKey:(NSString *)key
                                  URIParams:(NSDictionary *)uriParams
                                     params: (NSDictionary *)params
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self requestWithAPIKey:key headerParams:nil URIParams:uriParams params:params httpBody:nil success:success failure:failure];
}

-(AFHTTPRequestOperation*)requestWithAPIKey:(NSString *)key
                               headerParams:(NSDictionary *)headerParam
                                  URIParams:(NSDictionary *)uriParams
                                     params: (NSDictionary *)params
                                   httpBody:(NSData *)body
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [(MMJSONRequestSerializer *)self.requestSerializer createRequestWithAPIKey:key
                                                                                                 baseClientURL:self.baseURL
                                                                                                     URIParams:uriParams
                                                                                                        params:params];
    for (NSString *key in headerParam) {
        [request setValue:[headerParam objectForKey:key] forHTTPHeaderField:key];
    }
    
    if (body) {
        [request setHTTPBody:body];
    }
    
    //    MM_LOG(@"allHeaderFields : %@", [request allHTTPHeaderFields]);
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    if ([operation isKindOfClass:[MMHTTPRequestOperation class]]) {
        MMHTTPRequestOperation *mmOperation = (MMHTTPRequestOperation *)operation;
        mmOperation.useRetry = [(MMJSONRequestSerializer *)self.requestSerializer useAutoReloginForAPIKey:key];
    }
    [self.operationQueue addOperation:operation];
    return operation;
}

#pragma mark - Cancel request by requestID

-(void)cancelRequest:(id)requestID
{
    if ([requestID isKindOfClass:[AFHTTPRequestOperation class]] == NO) {
//        MM_LOG(@"Invalid request ID : %@", requestID);
        return;
    }
    
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)requestID;
    
    if ([self.operationQueue.operations containsObject:operation] == NO) {
//        MM_LOG(@"operation(%@) is not in operation queue", requestID);
        return;
    }
    
    if (operation.isFinished) {
//        MM_LOG(@"operation(%@) is already finished", requestID);
        return;
    }
    
    [operation cancel];
}

@end

