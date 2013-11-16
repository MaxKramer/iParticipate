//
//  IPLocationManager.h
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IPLocationManager : NSObject

+ (instancetype) sharedLocationManager;

- (void) reverseGeocodeLocation:(CLLocation *) location withCallback:(void (^) (NSArray *placemarks, NSError *error)) callback;
- (void) geocodeLocationString:(NSString *) locationString withCallback:(void (^) (NSArray *placemarks, NSError *error)) callback;

@property (nonatomic, assign, readonly) CLAuthorizationStatus authorizationStatus;
@property (nonatomic, copy, readwrite) void (^didFailWithError)(NSError *error);
@property (nonatomic, copy, readwrite) void (^didUpdateLocation)(NSArray *locations);

@end
