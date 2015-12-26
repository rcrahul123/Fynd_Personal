//
//  TabBarViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUtility.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserAuthenticationHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "FeedViewController.h"

@interface TabBarViewController : UITabBarController<CLLocationManagerDelegate, UITabBarControllerDelegate>{
    UserAuthenticationHandler *userAuthenticationHandler;
    CLLocationManager *locationManager;
    CLLocation *location;
    
    UIAlertView *locationAlert;

}
@property (nonatomic,assign)BOOL isLoadingOrderID;
@end
