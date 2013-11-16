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
#import "IPAPIRequest.h"
#import "IPAPIClient.h"
#import "IPIdentity.h"
#import "JSONModel.h"

@implementation IPChooseConstituencyViewController

#pragma mark ViewDidLoad

- (void)viewDidLoad {
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:NO];
    [super viewDidLoad];
}

#pragma mark TappedButton

- (IBAction) tappedButton:(id)sender {
    if ([sender isEqual:self.buttons[0]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self makeUserEnterPostcode];
    }
}

#pragma mark User's Annotation
- (id <MKAnnotation>) userAnnotation {
    return [[self.mapView annotations] firstObject];
}

#pragma mark Make sure that we can dismiss the keyboard in code

- (BOOL) disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark Geocoding

- (void) geocodeUserLocation:(MKUserLocation *) userLocation {
    [[IPLocationManager sharedLocationManager] reverseGeocodeLocation:userLocation.location withCallback:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            [self makeUserEnterPostcode];
        }
        else {
            CLPlacemark *placemark = [placemarks firstObject];
            if ([[placemark ISOcountryCode] isEqualToString:@"GB"]) {
                [self performNetworkRequestWithCoordinate:userLocation.location.coordinate];
            }
            else {
                [self makeUserEnterPostcode];
            }
        }
    }];
}

#pragma mark Make the user insert his postcode

- (void) makeUserEnterPostcode {
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.statusLabel setText:@"Unable to find your constituency, please enter your postcode:"];
        [self.constituencyLabel setAlpha:0.0f];
        [self.validateLabel setAlpha:0.0f];
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.buttons[idx] setAlpha:0.0f];
        }];
        [self.textField setHidden:NO];
        
    } completion:^(BOOL finished) {
        [self.constituencyLabel removeFromSuperview];
        [self.validateLabel removeFromSuperview];
        [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.buttons[idx] removeFromSuperview];
        }];
    }];
}

#pragma mark Validation

- (BOOL) postcodeIsValid:(NSString *) postcode {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z]{1,2}[0-9Rr][0-9A-Za-z]? ?[0-9][ABD-HJLNP-UW-Zabd-hjlnp-uw-z]{2}'"] evaluateWithObject:postcode];
}

#pragma mark Network Requests

- (void) performNetworkRequestWithCoordinate:(CLLocationCoordinate2D) coord {
    IPAPIRequest *request = [IPAPIRequest requestWithVerb:@"POST" path:[NSString stringWithFormat:@"identities.json?latitude=%f&longitude=%f", coord.latitude, coord.longitude]];
    [[IPAPIClient sharedClient] performRequest:request forModel:IPIdentity.class success:^(id object) {
        IPIdentity *identity = object;
        NSString *token = [identity token];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:IPAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self retrieveConstituencyFromCoordinate:coord callback:^(NSString *constituency, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"Unable to find a constituency from your location, please enter your post code:"];
                [self makeUserEnterPostcode];
            }
            else {
                // move on...
                [self.constituencyLabel setText:constituency];
            }
        }];
        
    } failure:^(id error) {
        NSLog(@"Fail error: %@", error);
    }];
}

- (void) performNetworkRequestWithPostcode:(NSString *) postcode {
    [[IPLocationManager sharedLocationManager] geocodeLocationString:postcode withCallback:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"Error performing request with postcode"];
            NSLog(@"%@", error);
        }
        else {
            CLPlacemark *placemark = [placemarks firstObject];
            [self performNetworkRequestWithCoordinate:placemark.location.coordinate];
        }
    }];
}

- (void) retrieveConstituencyFromCoordinate:(CLLocationCoordinate2D) coord callback:(void (^) (NSString *constituency, NSError *error)) callback{
//    IPAPIRequest *request = [IPAPIRequest requestWithVerb:@"GET" path:[NSString stringWithFormat:@"identities.json?latitude=%f&longitude=%f", coord.latitude, coord.longitude]];
//    [[IPAPIClient sharedClient] performRequest:request forModel:IPIdentity.class success:^(id object) {
//        IPIdentity *identity = object;
//        NSString *token = [identity token];
//        [[NSUserDefaults standardUserDefaults] setObject:token forKey:IPAccessTokenKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    } failure:^(id error) {
//        NSLog(@"Fail error: %@", error);
//    }];

}

#pragma mark MKMapViewDelegate

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.mapView.selectedAnnotations.count > 0) {
        return;
    }
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [mapView setRegion:mapRegion animated:YES];
    [self.mapView selectAnnotation:[self userAnnotation] animated:YES];
    [self geocodeUserLocation:userLocation];
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

#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    BOOL isValid = [self postcodeIsValid:[textField text]];
    if (isValid) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"The postcode you entered is invalid."];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


@end
