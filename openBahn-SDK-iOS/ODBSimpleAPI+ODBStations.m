//
//  ODBSimpleAPI+ODBStations.m
//  openBahn-SDK-iOS
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import "ODBSimpleAPI+ODBStations.h"

static NSString * const module = @"station";

@implementation ODBSimpleAPI (ODBStations)

- (void)getAllStationsWithFilter:(NSDictionary *)filter
                         success:(void (^)(NSArray *stations))successBlock
                  onError:(void (^)(NSError* error))errorBlock;
{
    [self callModule:module filter:filter success:^(NSArray *results) {
        NSError *error = nil;
        NSMutableArray *stations = [NSMutableArray new];
        for (NSDictionary *stationDict in results) {
            [stations addObject:[[BUFStationJSONObject alloc] initWithDictionary:stationDict withError:&error]];
        }
        if (successBlock) {
            successBlock(stations);
        }
    } onError:errorBlock];
}

@end
