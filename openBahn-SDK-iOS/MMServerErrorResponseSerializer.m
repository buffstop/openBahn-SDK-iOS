//
//  MMServerErrorResponseSerializer.m
//  
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMServerErrorResponseSerializer.h"
#import "MMServerError.h"

#define RESPONSE_ERRORCODE_STRING_KEY SERVERERROR_CODE_STRING_KEY
#define RESPONSE_MESSAGE_KEY SERVERERROR_MESSAGE_KEY
#define RESPONSE_LOCALIZED_MESSAGE_KEY SERVERERROR_LOCALIZED_MESSAGE_KEY
#define RESPONSE_PROPERTY_KEY SERVERERROR_PROPERTY_KEY

#define SERVER_RESPONSE_ERROR_NO_CODE_STRING @"WARNING - Server Error Response doesn't contain ERRORCODE_STRING"
#define SERVER_RESPONSE_ERROR_NO_MESSAGE @"WARNING - Server Error Response doesn't contain MESSAGE"
#define SERVER_RESPONSE_ERROR_NO_LOCALIZED_MESSAGE @"WARNING - Server Error Response doesn't contain LOCALIZED_MESSAGE"
#define SERVER_RESPONSE_ERROR_NO_PROPERTY @"WARNING - Server Error Response doesn't contain PROPERTY"

@implementation MMServerErrorResponseSerializer

#pragma mark -

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *__autoreleasing *)error
{
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]
            && self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]]) {
            return YES;
        }
    }
    
    return [super validateResponse:response data:data error:error];
}


- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *responseDic = [super responseObjectForResponse:response data:data error:error];
    if (responseDic && [responseDic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *serverErrorDic = [responseDic mutableCopy];
        [serverErrorDic setObject:(responseDic[RESPONSE_ERRORCODE_STRING_KEY]? : SERVER_RESPONSE_ERROR_NO_CODE_STRING)
                           forKey:SERVERERROR_CODE_STRING_KEY];
        [serverErrorDic setObject:(responseDic[RESPONSE_MESSAGE_KEY]? : SERVER_RESPONSE_ERROR_NO_MESSAGE)
                           forKey:SERVERERROR_MESSAGE_KEY];
        [serverErrorDic setObject:(responseDic[RESPONSE_LOCALIZED_MESSAGE_KEY]? : SERVER_RESPONSE_ERROR_NO_LOCALIZED_MESSAGE)
                           forKey:SERVERERROR_LOCALIZED_MESSAGE_KEY];
        [serverErrorDic setObject:(responseDic[RESPONSE_PROPERTY_KEY]? : SERVER_RESPONSE_ERROR_NO_PROPERTY)
                           forKey:SERVERERROR_PROPERTY_KEY];
        responseDic = serverErrorDic;
    }
    return responseDic;
}

@end
