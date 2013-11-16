//
//  IPAPIRequest.h
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPModel.h"

@interface IPAPIRequest : NSObject

@property (nonatomic, strong) NSString *verb;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSData *data;

+ (instancetype)request;
+ (instancetype)requestWithVerb:(NSString *)verb path:(NSString *)path;
+ (instancetype)getRequestWithPath:(NSString *)path;
+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path data:(NSData *)data;
+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path model:(IPModel *)model;
+ (instancetype)dataRequestWithVerb:(NSString *)verb path:(NSString *)path model:(IPModel *)model properties:(NSArray *)properties;

@end