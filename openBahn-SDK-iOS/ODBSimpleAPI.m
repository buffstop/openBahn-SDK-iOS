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

- (void)testCallonSuccess:(void (^)(NSArray *stations))successBlock
                  onError:(void (^)(NSError* error))errorBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://54.93.120.139/api/station"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (errorBlock) { errorBlock(error); }
        }
        if (data) {
            NSError *error;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (successBlock) {
                successBlock(json);
            }
        }
        NSAssert(false, @"nix");
    }];
    //
    //    self.baseUrl = "http://54.93.120.139/api";
    //    self.responseData = [NSMutableData new];
    //
    //    NSURL *url = [NSURL URLWithString:self.baseUrl];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    //
    ////    NSData *requestData = [@"name=testname&suggestion=testing123" dataUsingEncoding:NSUTF8StringEncoding];
    ////
    ////    [request setHTTPMethod:@"POST"];
    ////    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    ////    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    ////    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    ////    [request setHTTPBody: requestData];
    //
    //    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseUrl = @"http://54.93.120.139/api";
    }
    return self;
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
    }
    return self;
}

@end
