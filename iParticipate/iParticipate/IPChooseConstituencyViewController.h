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

@interface IPChooseConstituencyViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *constituencyLabel, *statusLabel, *validateLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction) tappedButton:(id)sender;

@end
