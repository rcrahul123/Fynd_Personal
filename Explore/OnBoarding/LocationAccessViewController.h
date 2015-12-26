//
//  LocationAccessViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "LocationSearchViewController.h"

@interface LocationAccessViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate, LocationSearchDelegate>{
    UIImageView *backgroundImageView;
    UIImageView *locationIcon;
    
    UILabel *personalizedLabel;
    UILabel *staticHeaderLabel;
    UILabel *staticTextLabel;
    UIButton *allowAccessButton;
    UIButton *skipButton;
    
    CLLocationManager *locationManager;
    CLLocation *location;
    
    UIAlertView *locationAlert;
    
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
    
    FyndActivityIndicator *allowLocationLoader;
}

@end
