//
//  MMServerAuthError.m
//
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMServerAuthError.h"

NSString * const kMMErrorDomain_auth_server = @"MMServerAuthFail";

@implementation MMServerAuthError
+(instancetype)serverErrorWithError:(NSError*)error
                        httpStatusCode:(NSInteger)code
							  userInfo:(NSDictionary*)userInfo
							 operation:(AFHTTPRequestOperation*)operation
{
    return [super errorWithDomain:kMMErrorDomain_auth_server code:code userInfo:(userInfo?:@{})];
}
@end
