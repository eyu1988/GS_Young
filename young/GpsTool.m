//
//  GpsTool.m
//  young
//
//  Created by z Apple on 15/6/15.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "GpsTool.h"

@interface GpsTool()<CLLocationManagerDelegate>

@end

@implementation GpsTool


-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeOther;
        [self startTrackingLocation];
        [self.locationManager stopUpdatingLocation ];

    }
    
    return _locationManager;
}



#pragma mark CLLocationManagerDelegate Methods
- (void)startTrackingLocation {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse
             || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Got authorization, start tracking location");
            [self startTrackingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Pass location updates to the map view.
    [locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        NSLog(@"Location (Floor %@): %@", location.floor, location.description);
        
        [self stopGps];
    }];
}

-(void)stopGps
{
    [self.locationManager stopUpdatingLocation ];
}


@end
