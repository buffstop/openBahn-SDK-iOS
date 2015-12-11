//
//  _BUFStationJSONObject.m
//
//  Created by MetaJSONParser.
//  Copyright (c) 2015 SinnerSchrader Mobile. All rights reserved.

#import "BUFAPIParser.h"
#import "NSString+RegExValidation.h"
#import "BUFStationJSONObject.h"


@implementation _BUFStationJSONObject

#pragma mark - factory

+ (BUFStationJSONObject *)stationWithDictionary:(NSDictionary *)dic withError:(NSError **)error {
    return [[BUFStationJSONObject alloc] initWithDictionary:dic withError:error];
}


#pragma mark - initialize
- (id)initWithDictionary:(NSDictionary *)dic  withError:(NSError **)error {
    self = [super initWithDictionary:dic withError:error];
    if (self) {
        self._id = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"_id" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.nahverkehr = [BUFAPIParser numberFromResponseDictionary:dic forKey:@"nahverkehr" acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.fernverkehr = [BUFAPIParser numberFromResponseDictionary:dic forKey:@"fernverkehr" acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.verkehrsVerb = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"verkehrsVerb" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.aufgabentraeger = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"aufgabentraeger" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.ort = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"ort" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.plz = [BUFAPIParser numberFromResponseDictionary:dic forKey:@"plz" acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.strasse = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"strasse" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.katVst = [BUFAPIParser numberFromResponseDictionary:dic forKey:@"katVst" acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.bm = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"bm" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.bundesland = [BUFAPIParser stringFromResponseDictionary:dic forKey:@"bundesland" acceptNumber:NO acceptNil:YES error:error];
        if (*error) {
            return self;
        }
        self.bfNr = [BUFAPIParser numberFromResponseDictionary:dic forKey:@"bfNr" acceptNil:YES error:error];
        if (*error) {
            return self;
        }
    }
    return self;
}


#pragma mark - getter

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder*)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self._id forKey:@"_id"];
    [coder encodeObject:self.nahverkehr forKey:@"nahverkehr"];
    [coder encodeObject:self.fernverkehr forKey:@"fernverkehr"];
    [coder encodeObject:self.verkehrsVerb forKey:@"verkehrsVerb"];
    [coder encodeObject:self.aufgabentraeger forKey:@"aufgabentraeger"];
    [coder encodeObject:self.ort forKey:@"ort"];
    [coder encodeObject:self.plz forKey:@"plz"];
    [coder encodeObject:self.strasse forKey:@"strasse"];
    [coder encodeObject:self.katVst forKey:@"katVst"];
    [coder encodeObject:self.bm forKey:@"bm"];
    [coder encodeObject:self.bundesland forKey:@"bundesland"];
    [coder encodeObject:self.bfNr forKey:@"bfNr"];
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    self._id = [coder decodeObjectForKey:@"_id"];
    self.nahverkehr = [coder decodeObjectForKey:@"nahverkehr"];
    self.fernverkehr = [coder decodeObjectForKey:@"fernverkehr"];
    self.verkehrsVerb = [coder decodeObjectForKey:@"verkehrsVerb"];
    self.aufgabentraeger = [coder decodeObjectForKey:@"aufgabentraeger"];
    self.ort = [coder decodeObjectForKey:@"ort"];
    self.plz = [coder decodeObjectForKey:@"plz"];
    self.strasse = [coder decodeObjectForKey:@"strasse"];
    self.katVst = [coder decodeObjectForKey:@"katVst"];
    self.bm = [coder decodeObjectForKey:@"bm"];
    self.bundesland = [coder decodeObjectForKey:@"bundesland"];
    self.bfNr = [coder decodeObjectForKey:@"bfNr"];
    return self;
}

#pragma mark - Object Info
- (NSDictionary *)propertyDictionary {
    NSDictionary *parentDic = [super propertyDictionary];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parentDic];
    if (self._id) {
        [dic setObject:self._id forKey:@"_id"];
    }
    if (self.nahverkehr) {
        [dic setObject:self.nahverkehr forKey:@"nahverkehr"];
    }
    if (self.fernverkehr) {
        [dic setObject:self.fernverkehr forKey:@"fernverkehr"];
    }
    if (self.verkehrsVerb) {
        [dic setObject:self.verkehrsVerb forKey:@"verkehrsVerb"];
    }
    if (self.aufgabentraeger) {
        [dic setObject:self.aufgabentraeger forKey:@"aufgabentraeger"];
    }
    if (self.ort) {
        [dic setObject:self.ort forKey:@"ort"];
    }
    if (self.plz) {
        [dic setObject:self.plz forKey:@"plz"];
    }
    if (self.strasse) {
        [dic setObject:self.strasse forKey:@"strasse"];
    }
    if (self.katVst) {
        [dic setObject:self.katVst forKey:@"katVst"];
    }
    if (self.bm) {
        [dic setObject:self.bm forKey:@"bm"];
    }
    if (self.bundesland) {
        [dic setObject:self.bundesland forKey:@"bundesland"];
    }
    if (self.bfNr) {
        [dic setObject:self.bfNr forKey:@"bfNr"];
    }
    return dic;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@",[self propertyDictionary]];
}

@end
