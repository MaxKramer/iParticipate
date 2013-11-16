//
//  IPAPIClient.h
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "IPAPIRequest.h"

@interface IPAPIClient : NSObject

+ (instancetype) sharedClient;

- (id)init __attribute__((unavailable("use initWithBaseURL:")));
- (id)initWithBaseURL:(NSURL *)baseURL;

- (void)performRequest:(IPAPIRequest *)request
              forModel:(Class)model
               success:(void(^)(id object))success
               failure:(void(^)(id error))failure;

- (void)performRequest:(IPAPIRequest *)request
       forArrayOfModel:(Class)model
               success:(void(^)(NSArray *array))success
               failure:(void(^)(id error))failure;


@end
