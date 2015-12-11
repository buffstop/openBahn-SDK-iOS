//
//  ODBSimpleAPI.h
//  openBahn-SDK-iOS
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BUFAPIParser.h"

@interface ODBSimpleAPI : NSObject

- (void)callModule:(NSString*)module filter:(NSDictionary *)filter
               success:(void (^)(NSArray *result))successBlock
               onError:(void (^)(NSError* error))errorBlock;

#pragma mark - Life Cycle

- (instancetype)init;
- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

@end
