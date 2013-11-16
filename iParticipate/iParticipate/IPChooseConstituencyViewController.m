//
//  IPChooseConstituencyViewController.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPChooseConstituencyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "IPLocationManager.h"

@implementation IPChooseConstituencyViewController

- (void)viewDidLoad {
    [self.mapView setShowsUserLocation:YES];
    [super viewDidLoad];
}

- (id <MKAnnotation>) userAnnotation {
    return [[self.mapView annotations] firstObject];
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [mapView setRegion:mapRegion animated:YES];
    [self.mapView selectAnnotation:[self userAnnotation] animated:YES];
    [self geocodeUserLocation:userLocation];
}

- (void) geocodeUserLocation:(MKUserLocation *) userLocation {
    [[IPLocationManager sharedLocationManager] reverseGeocodeLocation:userLocation.location withCallback:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            [self makeUserEnterPostcode];
        }
        else {
            CLPlacemark *placemark = [placemarks firstObject];
            if ([[placemark ISOcountryCode] isEqualToString:@"GB"]) {
                
            }
            else {
                [self makeUserEnterPostcode];
            }
        }
    }];
}

- (void) makeUserEnterPostcode {
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *ReuseIdentifier = @"ReuseIdentifier";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
    }
    
    [annotationView setAnnotation:annotation];
    [annotationView setCanShowCallout:YES];
    
    return annotationView;
}

@end
