//
//  ODBSimpleAPI.m
//  openBahn-SDK-iOS
//
//  Created by Andreas Buff on 11/12/15.
//  Copyright © 2015 Andreas Buff. All rights reserved.
//

#import "ODBSimpleAPI.h"

@interface ODBSimpleAPI()
@property (strong, nonatomic) NSString *baseUrl;
@end

@implementation ODBSimpleAPI

#pragma mark - Public

- (void)callModule:(NSString*)module
            filter:(NSDictionary *)filter
           success:(void (^)(NSArray *results))successBlock
           onError:(void (^)(NSError* error))errorBlock;
{
    NSParameterAssert(module);
    
    NSString *urlBuilder = [self.baseUrl stringByAppendingString:module];
    
    NSMutableString *filterBuilder = [NSMutableString new];
    if (filter && filter.count > 0) {
        [filterBuilder appendString:@"?"];
        for (NSString *filterKey in filter) {
            if (filterBuilder.length > 1) {
                [filterBuilder appendString:@"&"];
            }
            [filterBuilder appendString:filterKey];
            [filterBuilder appendString:filter[filterKey]];
        }
        urlBuilder = [urlBuilder stringByAppendingString:filterBuilder];
    }
    [self callUrl:urlBuilder success:successBlock onError:errorBlock];
}

#pragma mark - Server Calls

- (void)callUrl:(NSString *)url
        success:(void(^)(NSArray *results))successBlock
        onError:(void(^)(NSError *error))errorBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (errorBlock) { errorBlock(error); }
            return;
        }
        if (data) {
            NSError *error;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (successBlock) {
                successBlock(json);
            }
            return;
        }
    }];
}

#pragma mark - Life Cycle

- (instancetype)init;
{
    self = [super init];
    if (self) {
        self.baseUrl = @"http://54.93.120.139/api/";
    }
    return self;
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;
{
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
    }
    return self;
}

@end
