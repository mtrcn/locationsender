//
//  ViewController.h
//  LocationSender
//
//  Created by Mete Pakdil on 5/5/13.
//  Copyright (c) 2013 Mete Ercan Pakdil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)sendLocation:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
