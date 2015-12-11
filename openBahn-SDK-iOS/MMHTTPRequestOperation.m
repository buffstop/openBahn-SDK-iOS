//
//  MMHTTPRequestOperation.m
//  
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMHTTPRequestOperation.h"
#import "MMServerAuthError.h"

#ifndef SESSION_TOKEN_HEADER_KEY
#define SESSION_TOKEN_HEADER_KEY @"Authorization"
#endif

@interface MMHTTPRequestOperation ()
@property (nonatomic, strong) AFHTTPRequestOperation *retryOperation;
@property (copy) void (^successBlock) (AFHTTPRequestOperation *operation, id responseObject);
@property (copy) void (^failureBlock) (AFHTTPRequestOperation *operation, NSError *error);

@end
@implementation MMHTTPRequestOperation


#pragma AFHTTPRequestOperation

-(NSURLRequest *)request
{
    NSURLRequest *origin = [super request];
    NSMutableURLRequest *requestWithAuthentication = [origin mutableCopy];
    
    __block NSString * sessionToken = nil;
	
	// Get the session token
    if ([NSThread isMainThread]) {
        sessionToken = [self.requestOperationDelegate sessionToken];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            sessionToken = [self.requestOperationDelegate sessionToken];
        });
    }
	
    if (sessionToken) {
        [requestWithAuthentication setValue:sessionToken forHTTPHeaderField:SESSION_TOKEN_HEADER_KEY];
    }
    
    return requestWithAuthentication;
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.successBlock = [success copy];
    self.failureBlock = [failure copy];
    
    [super setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         if ([self isCancelled]) {
             return;
         }
         if (success) {
             success(operation, responseObject);
         }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if ([self isCancelled]) {
            return;
        }

        if ([error isKindOfClass:[MMServerError class]]) {
            __block MMServerError *serverError = (MMServerError *)error;
            serverError.operation = self;
            if (self.useRetry && self.requestOperationDelegate
                && [serverError.domain isEqualToString:kMMErrorDomain_auth_server]) {
                
                self.retryOperation = [self.requestOperationDelegate refreshSessionWithCompletionBlock:^(BOOL success) {
                    if (!success && failure) {
                        failure(self, serverError);
                    } else {
                        self.retryOperation = [self.requestOperationDelegate requeueRequest:(NSMutableURLRequest *)[self request]
                                                                                    success:self.successBlock failure:self.failureBlock];
                    }
                }];
                self.completionBlock = nil;
                return;
            }
        }
        
        if (failure) {
            failure(operation, error);
        }
    }];
#pragma clang diagnostic pop
}

#pragma NSOperation
-(void)cancel {
    [super cancel];
    [self.retryOperation cancel];
}

- (void)dealloc {
    self.retryOperation = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
}

@end
