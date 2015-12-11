//
//  _BUFBaseJSONObject.h
//
//  Created by MetaJSONParser.
//  Copyright (c) 2015 SinnerSchrader Mobile. All rights reserved.

#import <Foundation/Foundation.h>

@class BUFBaseJSONObject;

@interface _BUFBaseJSONObject : NSObject <NSCoding>



+ (BUFBaseJSONObject *)baseWithDictionary:(NSDictionary *)dic withError:(NSError **)error;
- (id)initWithDictionary:(NSDictionary *)dic withError:(NSError **)error;
- (NSDictionary *)propertyDictionary;

@end

