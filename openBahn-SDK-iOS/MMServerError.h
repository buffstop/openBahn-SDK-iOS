
//
//  Created by Uli Luckas
//  Copyright (c) 2012 SinnerSchrader Mobile. All rights reserved.
//

//#import "NSError+MMErrorHandling.h"
#import "AFHTTPRequestOperation.h"

#define SERVERERROR_CODE_STRING_KEY @"error"
#define SERVERERROR_MESSAGE_KEY @"errorText"
#define SERVERERROR_LOCALIZED_MESSAGE_KEY @"errorText"
#define SERVERERROR_PROPERTY_KEY @"errorProperty"

extern NSString * const kMMErrorDomain_server;


@interface MMServerError : NSError

@property (nonatomic, strong) AFHTTPRequestOperation *operation;

-(NSError*)underlyingError;
-(NSInteger)statusCode;
-(NSString*)serverMessage;
-(id)errorProperty;

#pragma mark - Lifecycle
+(instancetype)serverErrorWithError:(NSError*)error
                        httpStatusCode:(NSInteger)code
							  userInfo:(NSDictionary*)userInfo
							 operation:(AFHTTPRequestOperation*)operation;

@end
