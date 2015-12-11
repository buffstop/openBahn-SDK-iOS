//
//  MMURLAuthenticatedResponseSerializer.m
//  
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMURLAuthenticatedResponseSerializer.h"
#import "MMServerAuthError.h"
@interface MMURLAuthenticatedResponseSerializer ()
@property (nonatomic, readonly) NSIndexSet *authErrorCodes;
@end

@implementation MMURLAuthenticatedResponseSerializer

+(NSIndexSet*)authErrorCodes {
	static NSIndexSet *authErrorCodes;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        // configure statusCode for Authorization errors.
		authErrorCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(401, 1)];
	});
	
	return authErrorCodes;
}

-(BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    BOOL isValid = [super validateResponse:response data:data error:error];
    if (*error && !isValid && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSError *responseParseError = nil;
        id responseObject = [super responseObjectForResponse:response data:data error:&responseParseError];
        
        BOOL found = [[[self class] authErrorCodes] containsIndex:(NSUInteger)response.statusCode];
        MMServerError *serverError = nil;
        Class errorClass = [MMServerError class];
        if (found) {
            errorClass = [MMServerAuthError class];
        }
        serverError = [errorClass serverErrorWithError:*error
                                        httpStatusCode:[response statusCode]
                                              userInfo:responseObject operation:nil];
        
        *error = serverError? : *error;
    }
    return isValid;
}

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if ([self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        return [super responseObjectForResponse:response data:data error:error];
    }
    return data;
}
@end
