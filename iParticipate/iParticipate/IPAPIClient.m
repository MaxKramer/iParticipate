//
//  IPAPIClient.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPAPIClient.h"
#import "JSONModelLib.h"
#import "IPModel.h"
#import <objc/runtime.h>

@interface IPAPIClient ()
{
	NSURL *_baseURL;
}

@end
//JSONHTTPClient.requestHeaders[@"Authorization"]
@implementation IPAPIClient

+ (instancetype) sharedClient {
    static IPAPIClient *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[IPAPIClient alloc] initWithBaseURL:IPBaseURL];
    });
    return _shared;
}

- (id)init
{
	// Method is marked as unavailable - but just in case
	[NSException raise:NSGenericException
                format:@"Unavailable - use initWithBaseURL:"];
    
	return nil;
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
	if (self = [super init])
	{
		_baseURL = baseURL;
        
		NSString *absolute = _baseURL.absoluteString;
        
		if (![absolute hasSuffix:@"/"])
			_baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/", absolute]];
        
		if (![_baseURL.scheme isEqualToString:@"https"])
			NSLog(@"IPAPIClient instantiated with a non-HTTPS URL - %@", _baseURL.absoluteString);
        
		// set JSONHTTPClient defaults
		JSONHTTPClient.controlsNetworkIndicator = true;
		JSONHTTPClient.requestContentType = kContentTypeJSON;
		JSONHTTPClient.cachingPolicy = NSURLRequestReloadIgnoringCacheData;
		JSONHTTPClient.timeoutInSeconds = 30;
	}
    
	return self;
}

- (void)performRequest:(IPAPIRequest *)request
              forModel:(Class)model
               success:(void(^)(id object))success
               failure:(void(^)(id error))failure
{
	[self performRequest:request forArray:false ofModel:model success:success failure:failure];
}

- (void)performRequest:(IPAPIRequest *)request
       forArrayOfModel:(Class)model
               success:(void(^)(NSArray *array))success
               failure:(void(^)(id error))failure
{
	[self performRequest:request forArray:true ofModel:model success:success failure:failure];
}

- (void)performRequest:(IPAPIRequest *)request
              forArray:(BOOL)array
               ofModel:(Class)model
               success:(void(^)(id object))success
               failure:(void(^)(id error))failure
{
	if (model != nil && ![self class:model descendsFromClass:IPModel.class])
		[NSException raise:@"InvalidModelClass" format:@"Model must inherit from BSModel"];
    
	// avoid changing request object, so copy
	NSString *path = [request.path copy];
    
	// prevents problems with absolute URLs on base URLs.
	// there may be more than one / at the start.
	// prefixing with a . works - ./ is relative to current dir
	if ([path hasPrefix:@"/"])
		path = [@"." stringByAppendingString:path];
    
	NSURL *url = [NSURL URLWithString:path relativeToURL:_baseURL];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:IPAccessTokenKey];
    if (token) {
        NSString *auth = [@"Bearer " stringByAppendingString:token];
        JSONHTTPClient.requestHeaders[@"Authorization"] = auth;
    }

    [self makeRequestForModel:model
                      asArray:array
                withURLString:url.absoluteString
                       method:request.verb
                         data:request.data
                      headers:request.headers
                      success:success
                      failure:failure];
}

- (void)makeRequestForModel:(Class)model
                    asArray:(BOOL)array
              withURLString:(NSString *)urlString
                     method:(NSString *)method
                       data:(NSData *)data
                    headers:(NSDictionary *)headers
                    success:(void(^)(id object))success
                    failure:(void(^)(id error))failure
{
	// if callbacks are unspecified
	// swallow the result & do nothing
	if (success == nil)
		success = ^(id object) {};
    
	if (failure == nil)
		failure = ^(id error) {};
    
	[JSONHTTPClient JSONFromURLWithString:urlString
                                   method:method
                                   params:nil
                               orBodyData:data
                                  headers:headers
                               completion:^(id json, JSONModelError *err)
     {
         if (err)
         {
             failure(err);
             return;
         }
         
         if (model == nil)
         {
             success(nil);
             return;
         }
         
         if (array)
         {
             if (![json isKindOfClass:NSArray.class])
             {
                 failure([NSError errorWithDomain:@"NonMatchingType" code:0 userInfo:nil]);
                 return;
             }
             
             NSArray *obj = [model arrayOfModelsFromDictionaries:json];
             success(obj);
         }
         else
         {
             if (![json isKindOfClass:NSDictionary.class])
             {
                 failure([NSError errorWithDomain:@"NonMatchingType" code:0 userInfo:nil]);
                 return;
             }
             
             NSDictionary *obj = [[model alloc] initWithDictionary:json error:&err];
             
             if (err)
                 failure(err);
             
             else
                 success(obj);
         }
     }];
}

// Helper
- (BOOL) class:(Class)classA descendsFromClass:(Class)classB
{
	while (1)
	{
		if (classA == classB) return true;
		id superClass = class_getSuperclass(classA);
		if (classA == superClass) return (superClass == classB);
		classA = superClass;
	}
}

@end
