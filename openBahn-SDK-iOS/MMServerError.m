//
//
//  Created by Uli Luckas
//  Copyright (c) 2012 SinnerSchrader Mobile. All rights reserved.
//

#import "MMServerError.h"
#import "AFHTTPRequestOperation.h"

NSString * const kMMErrorDomain_server = @"MMServer";

@implementation MMServerError


-(NSError*)underlyingError {
    return [self.userInfo objectForKey:NSUnderlyingErrorKey];
}

-(NSInteger)statusCode {
    return self.operation.response.statusCode;
}

-(NSString*)alertTitleString
{
    return nil;
}

-(NSString*)alertButtonString
{
    return @"OK";
}


-(NSString*)errorMessage {
    return [self serverMessage];
}

-(NSString*)serverMessage {
    NSString *serverMessage = self.userInfo[SERVERERROR_LOCALIZED_MESSAGE_KEY];
    return serverMessage ? serverMessage : @"";
}

-(NSString*)MMErrorCode {
    NSString *errorCode = self.userInfo[SERVERERROR_CODE_STRING_KEY];
    return errorCode ? errorCode : @"";
}

-(id)errorProperty {
    return self.userInfo[SERVERERROR_PROPERTY_KEY];
}

#pragma mark - Lifecycle

+(instancetype)serverErrorWithError:(NSError*)error
                        httpStatusCode:(NSInteger)code
                              userInfo:(NSDictionary*)userInfo
							 operation:(AFHTTPRequestOperation*)operation {
    if (!userInfo) {
        userInfo = [NSMutableDictionary dictionary];
    } else if (![userInfo isKindOfClass:[NSMutableDictionary class]]) {
        if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
            userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        }else{
            userInfo = [NSMutableDictionary dictionary];
        }
    }
    [userInfo setValue:error forKey:NSUnderlyingErrorKey];
    MMServerError *serverError = [self errorWithDomain:kMMErrorDomain_server code:code userInfo:userInfo];
    serverError.operation = operation;
    return serverError;
}

-(void)dealloc {
    self.operation = nil;
}

@end
