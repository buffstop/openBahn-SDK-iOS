//
//  _BUFBaseJSONObject.m
//
//  Created by MetaJSONParser.
//  Copyright (c) 2015 SinnerSchrader Mobile. All rights reserved.

#import "BUFAPIParser.h"
#import "NSString+RegExValidation.h"
#import "BUFBaseJSONObject.h"


@implementation _BUFBaseJSONObject

#pragma mark - factory

+ (BUFBaseJSONObject *)baseWithDictionary:(NSDictionary *)dic withError:(NSError **)error {
    return [[BUFBaseJSONObject alloc] initWithDictionary:dic withError:error];
}


#pragma mark - initialize
- (id)initWithDictionary:(NSDictionary *)dic  withError:(NSError **)error {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - getter

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder*)coder {
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    return self;
}

#pragma mark - Object Info
- (NSDictionary *)propertyDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    return dic;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@",[self propertyDictionary]];
}

@end
