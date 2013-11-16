//
//  IPModel.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPModel.h"

@implementation IPModel

+ (JSONKeyMapper *)keyMapper
{
	return JSONKeyMapper.mapperFromUnderscoreCaseToCamelCase;
}

@end
