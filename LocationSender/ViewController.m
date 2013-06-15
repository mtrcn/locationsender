//
//  ViewController.m
//  LocationSender
//
//  Created by Mete Pakdil on 5/5/13.
//  Copyright (c) 2013 Mete Ercan Pakdil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CLLocationManager *locationManager;
    CLLocation* location;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    location = [locations lastObject];
    _lblLocation.text = [NSString stringWithFormat:@"%.6f, %.6f",location.coordinate.latitude, location.coordinate.longitude];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    [_map setRegion:viewRegion animated:YES];
    [_map removeAnnotations:[_map annotations]];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location.coordinate];
    [annotation setTitle:@"You\'re Here"];
    [_map addAnnotation:annotation];
    
}

- (IBAction)sendLocation:(id)sender {
    
    NSString* username = [_txtUsername text];
    NSString* message = [_txtMessage text];
    if ([username length] > 0 && [message length] > 0 && location != nil){
        _btnSend.enabled = FALSE;
        NSURL *url = [NSURL URLWithString:@"http://locationcatcher.eu01.aws.af.cm"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient setParameterEncoding:AFJSONParameterEncoding];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", message, @"message", [NSNumber numberWithDouble:location.coordinate.latitude], @"lat", [NSNumber numberWithDouble:location.coordinate.longitude], @"lng", nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/rest/catch"
                                                          parameters:params];
        [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:@"Your message successfully sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            _btnSend.enabled = TRUE;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"%@", [error userInfo]);
            NSDictionary *dictionary = [response allHeaderFields];
            NSLog(@"%@", [dictionary description]);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"An error happened. Code %d", response.statusCode] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            _btnSend.enabled = TRUE;
        }];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [operation start];
        _btnSend.enabled = TRUE;

    }else{ //username or message is empty
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"Location, Sent By or Message cannot be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end
