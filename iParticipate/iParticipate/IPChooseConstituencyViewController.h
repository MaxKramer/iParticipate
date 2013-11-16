//
//  IPChooseConstituencyViewController.h
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IPChooseConstituencyViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *constituencyLabel;
@property (nonatomic, weak) IBOutlet IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction) tappedButton:(id)sender;

@end
