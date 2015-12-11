//
//  _BUFStationJSONObject.h
//
//  Created by MetaJSONParser.
//  Copyright (c) 2015 SinnerSchrader Mobile. All rights reserved.

#import <Foundation/Foundation.h>
#import "BUFBaseJSONObject.h"

@class BUFStationJSONObject;

@interface _BUFStationJSONObject : BUFBaseJSONObject


@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSNumber *nahverkehr;
@property (nonatomic, strong) NSNumber *fernverkehr;
@property (nonatomic, strong) NSString *verkehrsVerb;
@property (nonatomic, strong) NSString *aufgabentraeger;
@property (nonatomic, strong) NSString *ort;
@property (nonatomic, strong) NSNumber *plz;
@property (nonatomic, strong) NSString *strasse;
@property (nonatomic, strong) NSNumber *katVst;
@property (nonatomic, strong) NSString *bm;
@property (nonatomic, strong) NSString *bundesland;
@property (nonatomic, strong) NSNumber *bfNr;

+ (BUFStationJSONObject *)stationWithDictionary:(NSDictionary *)dic withError:(NSError **)error;
- (id)initWithDictionary:(NSDictionary *)dic withError:(NSError **)error;
- (NSDictionary *)propertyDictionary;

@end

