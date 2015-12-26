//
//  AppDelegate.h
//  Explore
//
//  Created by Rahul on 6/29/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HomeViewController.h"
#import "TabBarViewController.h"
#import "FacebookDetailsViewController.h"

//#import <Google/Analytics.h>

#import "UserAuthenticationHandler.h"
#import "FyndUser.h"
#import "LocationSearchViewController.h"

#import <SDImageCache.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>{
    CLLocationManager *locationManager;
    CLLocation *location;
    UINavigationController *baseNavController;
    
    UserAuthenticationHandler *authenticationHandler;
    UIAlertView *locationAlert;
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FyndUser *userData;


@end

