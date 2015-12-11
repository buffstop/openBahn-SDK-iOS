//
//  Tests.m
//  Tests
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ODBSimpleAPI.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)testExample {
    XCTestExpectation *expectationExistingUsersUsernameExists = [self expectationWithDescription:@"success!"];
    ODBSimpleAPI *http = [ODBSimpleAPI new];
    [http testCallonSuccess:^(NSArray *stations) {
        //
        NSLog([stations ]);
        [expectationExistingUsersUsernameExists fulfill];
    } onError:^(NSError *error) {        //
        NSLog(error);
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}


@end
