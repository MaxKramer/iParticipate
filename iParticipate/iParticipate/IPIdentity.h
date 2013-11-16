//
//  IPIdentity.h
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPModel.h"

@protocol IPIdentity @end

@interface IPIdentity : IPModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString *token;

@end
