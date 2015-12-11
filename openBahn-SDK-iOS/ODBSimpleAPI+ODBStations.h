//
//  ODBSimpleAPI+ODBStations.h
//  openBahn-SDK-iOS
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import "ODBSimpleAPI.h"

#import "BUFStationJSONObject.h"

@interface ODBSimpleAPI (ODBStations)

- (void)getAllStationsWithFilter:(NSDictionary *)filter
                         success:(void (^)(NSArray *stations))successBlock
                         onError:(void (^)(NSError* error))errorBlock;

@end
