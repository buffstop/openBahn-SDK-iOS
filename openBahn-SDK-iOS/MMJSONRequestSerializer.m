//
//  MMJSONRequestSerializer.m
//
//
//  Copyright (c) 2013 SinnerSchrader Mobile. All rights reserved.
//

#import "MMJSONRequestSerializer.h"

#ifndef USER_AGENT_APPLICATION_ID
#define USER_AGENT_APPLICATION_ID [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]
#endif

@interface MMJSONRequestSerializer ()
@property (nonatomic, weak) id localeUpdateObserver;
@property (nonatomic, strong, readwrite) NSDictionary *apiDescriptions;
@end

@implementation MMJSONRequestSerializer


-(id)init
{
    self = [super init];
    if (self) {
        // load api descriptions
        //////////////////////////////////////////////////////////////////////////////////////////////////
        NSString *dicPath = [[NSBundle mainBundle] pathForResource:@"MMAPIDescription" ofType:@"plist"];
        NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
        self.apiDescriptions = [infoDic objectForKey:@"API_INFO"];
        //////////////////////////////////////////////////////////////////////////////////////////////////
        
        __weak __typeof(self)weakSelf = self;
        self.localeUpdateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf setAcceptLanguageHeader];
        }];
        
        [self setAcceptLanguageHeader];
        [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [self setValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
        [self setUserAgentHeader];
    }
    return self;
}

- (void)setUserAgentHeader
{
    NSString *userAgent = nil;
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", USER_AGENT_APPLICATION_ID,
                 (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, kCFStringTransformToLatin, false);
            userAgent = mutableUserAgent;
        }
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
}

- (void)setAcceptLanguageHeader
{
    NSLocale* locale = [NSLocale autoupdatingCurrentLocale];
    NSString* languageCode  = [locale objectForKey:NSLocaleLanguageCode];
    NSString* countryCode  = [locale objectForKey:NSLocaleCountryCode];
    [self setValue:[NSString stringWithFormat:@"%@_%@", languageCode, countryCode] forHTTPHeaderField:@"Accept-Language"];
    
}

-(void)dealloc
{
    self.localeUpdateObserver = nil;
    self.apiDescriptions = nil;
}

#pragma mark - Accessors

- (void)setLocaleUpdateObserver:(id)localeUpdateObserver
{
    if (_localeUpdateObserver != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:_localeUpdateObserver];
    }
    _localeUpdateObserver = localeUpdateObserver;
}

#pragma mark - Generic request by api description

- (NSURL *)baseURLWith:(NSString *)baseURL
{
    NSString *tmpURLString = [baseURL copy];
    tmpURLString = [tmpURLString lowercaseString];
    if ([tmpURLString isEqualToString:@"main_bundle"]) {
        return [[NSBundle mainBundle] bundleURL];
    } else if ([tmpURLString isEqualToString:@"document_folder"]) {
        NSString *baseURLPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        return [NSURL fileURLWithPath:baseURLPath];
    } else if ([tmpURLString isEqualToString:@"cache_folder"]) {
        NSString *baseURLPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        return [NSURL fileURLWithPath:baseURLPath];
    } else if ([tmpURLString hasPrefix:@"http"]) {
        return [NSURL URLWithString:baseURL];
    } else {
        NSBundle *tmpBundle = [NSBundle bundleWithPath:baseURL];
        return [tmpBundle bundleURL];
    }
    return [NSURL URLWithString:baseURL];
}


- (NSString *)createURIWithURIPath:(NSString *)uriPath uriParameter:(NSDictionary *)uriParams pathParameter:(NSDictionary *)pathParams
{
    
    NSInteger uriParamIndex = 0;
    
    for (NSString *uriParam in pathParams)
    {
        NSString *paramString = [uriParams objectForKey:uriParam];
        if (paramString == nil || paramString.length == 0)
        {
//            MM_LOG(@"URI value for %@ is Missing", uriParam);
            continue;
        }
        
        NSString *targetString = [NSString stringWithFormat:@"{param_%ld}", (long)uriParamIndex];
        uriPath = [uriPath stringByReplacingOccurrencesOfString:targetString withString:paramString];
        
        uriParamIndex++;
    }
    
    static NSString* kPrefixToRemove = @"/";
    if ([uriPath hasPrefix:kPrefixToRemove])
    {
        // rebuilt a string by only using the substring after the prefix
        uriPath = [uriPath substringFromIndex:kPrefixToRemove.length];
    }
    
    return uriPath;
}


- (NSMutableURLRequest *)createRequestWithAPIKey:(NSString *)key
                                   baseClientURL:(NSURL *)url
                                       URIParams:(NSDictionary *)uriParams
                                          params: (NSDictionary *)params
{
    // use local dummy data by convention _L
    NSString* apiKey = nil;
    NSDictionary *apiDic = nil;
#ifdef FEATURE_USE_LOCAL
    apiKey = [NSString stringWithFormat:@"%@_L",key];
    apiDic = [self.apiDescriptions objectForKey:apiKey];
#endif
    
    if (apiDic == nil) {
        apiKey = key;
        apiDic = [self.apiDescriptions objectForKey:apiKey];
    }
    NSAssert(apiDic != nil, @"declare the apiKey in your plist");
    
    
    NSURL *baseURL = [self baseURLWith:[self baseURLPathForAPIKey:key]];
    
    baseURL = baseURL ? : url;
    
    // build URI
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSString *uriPath = [self createURIWithURIPath:[apiDic objectForKey:@"URI"]
                                      uriParameter:uriParams
                                     pathParameter:[apiDic objectForKey:@"URI_PARAMS"]];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSMutableDictionary *mergedParams = [[NSMutableDictionary alloc] init];
    if (params) {
        [mergedParams setValuesForKeysWithDictionary:params];
    }
    
    NSDictionary *defaultParams = [apiDic objectForKey:@"DEFAULT_PARAMS"];
    if (defaultParams) {
        [mergedParams setValuesForKeysWithDictionary:defaultParams];
    }
    
    NSString *acceptType = [apiDic objectForKey:@"ACCEPT"];

    NSNumber *shouldAutoRelogin = [apiDic objectForKey:@"AUTO_RELOGIN"];
    
    NSMutableURLRequest *request = [self createRequestWithMethod:[apiDic objectForKey:@"METHOD"]
                                                         baseURL:baseURL
                                                            path:uriPath
                                                      acceptType:acceptType
                                                      parameters:mergedParams
                                               shouldAutoRelogin:shouldAutoRelogin.boolValue];
    
//    MM_LOG(@"request : %@\n headers: %@ \n body : %@", request, request.allHTTPHeaderFields, [[request HTTPBody] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
    #warning the log below should be MM_LOG_INFO
    //MM_LOG(@"request : %@\n headers: %@ \n body : %@", request, request.allHTTPHeaderFields, [[request HTTPBody] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);

    return request;
}

- (NSMutableURLRequest *)createRequestWithMethod:(NSString *)method
                                         baseURL:(NSURL *)baseURL
                                            path:(NSString *)path
                                      acceptType:(NSString*)acceptType
                                      parameters:(NSDictionary *)parameters
                               shouldAutoRelogin:(BOOL)shouldAutoRelogin
{
    NSMutableURLRequest* request = [self requestWithMethod:method
                                                   baseURL:baseURL
                                                      path:path
                                                parameters:parameters];
    
    if (acceptType) {
        [request setValue:acceptType forHTTPHeaderField:@"Accept"];
    }
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                   baseURL:(NSURL *)baseURL
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSError *error = nil;
    NSMutableURLRequest *request = [self requestWithMethod:method
                                                 URLString:[[NSURL URLWithString:path relativeToURL:baseURL] absoluteString]
                                                parameters:parameters
                                                     error:&error];
    // unhandled error acceptable?
    if (!request) {
//        MM_LOG_ERROR(error);
    }
    
    return request;
}


#pragma mark - API Description Methods

- (NSString *)baseURLPathForAPIKey:(NSString *)key {
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    NSString *str = [apiDic objectForKey:@"BASE_URL"];
    return str;
}

- (NSDictionary *)URIPathParamsForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    return [apiDic objectForKey:@"URI_PARAMS"];
}

- (NSString *)URIPathForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    return [apiDic objectForKey:@"URI"];
}

- (NSDictionary *)defaultParametersForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    return [apiDic objectForKey:@"DEFAULT_PARAMS"];
}

- (NSString *)requestMethodForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    return [apiDic objectForKey:@"METHOD"];
}

- (NSString *)acceptTypeForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    return [apiDic objectForKey:@"ACCEPT"];
}

- (BOOL)useAutoReloginForAPIKey:(NSString *)key
{
    NSDictionary *apiDic = [self.apiDescriptions objectForKey:key];
    NSNumber *use = [apiDic objectForKey:@"AUTO_RELOGIN"];
    return [use boolValue];
}


@end
