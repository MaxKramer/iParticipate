//
//  IPAPIRequest.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPAPIRequest.h"

@implementation IPAPIRequest

+ (instancetype)request
{
	return [[self alloc] init];
}

+ (instancetype)requestWithVerb:(NSString *)verb path:(NSString *)path
{
	IPAPIRequest *request = [self request];
    
	request.verb = verb;
	request.path = path;
    
	return request;
}

+ (instancetype)getRequestWithPath:(NSString *)path
{
	return [self requestWithVerb:@"GET" path:path];
}

+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path data:(NSData *)data
{
	IPAPIRequest *request = [self requestWithVerb:verb path:path];
    
	request.data = data;
    
	return request;
}

+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path model:(IPModel *)model
{
	return [self dataRequestWithVerb:verb path:path model:model];
}

+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path model:(IPModel *)model properties:(NSArray *)properties
{
	NSData *data = [[model toJSONString:properties] dataUsingEncoding:NSUTF8StringEncoding];
	return [self dataRequestWithVerb:verb path:path data:data];
}

@end

