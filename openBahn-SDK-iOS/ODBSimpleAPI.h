//
//  ODBSimpleAPI.h
//  openBahn-SDK-iOS
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBSimpleAPI : NSObject

- (void)testCallonSuccess:(void (^)(NSArray *stations))successBlock
                  onError:(void (^)(NSError* error))errorBlock;
@end
