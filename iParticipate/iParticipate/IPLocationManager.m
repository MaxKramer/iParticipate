//
//  IPLocationManager.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPLocationManager.h"

@interface IPLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation IPLocationManager

#pragma mark Singleton

+ (instancetype) sharedLocationManager {
    static IPLocationManager *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[IPLocationManager alloc] init];
    });
    return _shared;
}

#pragma mark Initializer

- (id) init {
    if ((self = [super init])) {
        _authorizationStatus = kCLAuthorizationStatusNotDetermined;
    }
    return self;
}

#pragma mark CLLocationManager

- (CLLocationManager *) locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [_locationManager setPurpose:@"Enable this to allow us to find your constituency"];
        [_locationManager startMonitoringSignificantLocationChanges];
    }
    return _locationManager;
}

#pragma mark CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    _authorizationStatus = status;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.didUpdateLocation) {
        self.didUpdateLocation(locations);
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.didFailWithError) {
        self.didFailWithError(error);
    }
}

#pragma mark Geocoder Init

- (CLGeocoder *) geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark Geocoding

- (void) reverseGeocodeLocation:(CLLocation *) location withCallback:(void (^) (NSArray *placemarks, NSError *error)) callback {
    [[self geocoder] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(placemarks, error);
        });
    }];
}


- (void) geocodeLocationString:(NSString *) locationString withCallback:(void (^) (NSArray *placemarks, NSError *error)) callback {
    [[self geocoder] geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(placemarks, error);
        });
    }];
}

@end
