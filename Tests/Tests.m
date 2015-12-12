//
//  Tests.m
//  Tests
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ODBSimpleAPI+ODBStations.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"success!"];
    ODBSimpleAPI *http =[ODBSimpleAPI new];
    [http getAllStationsWithFilter:nil success:^(NSArray *stations){
        [expectation fulfill];
    } onError:^(NSError *error) {
        NSLog([error description]);
    }];

    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}


@end
