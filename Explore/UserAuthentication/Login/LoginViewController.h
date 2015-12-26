//
//  LoginViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldWithImage.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "UserAuthenticationHandler.h"
#import "SendOTPViewController.h"

#import "FyndUser.h"
#import "SSUtility.h"

#import <CoreLocation/CoreLocation.h>
#import "LocationSearchViewController.h"


@interface LoginViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, LocationSearchDelegate>{
    
    UIScrollView *containerScrollView;
    UIImageView *userImageView ;
    TextFieldWithImage *mobileNumberTextField;
    TextFieldWithImage *passwordTextField;
    UIButton *loginButton;
    UIButton *resetButton;
//    UILabel *errorLabel;
    
    UILabel *errorMessageLabel;
    
    
    UserAuthenticationHandler *userAuthenticationHandler;
    
    CLLocationManager *locationManager;
    UIAlertView *locationAlert;
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
    
    CGFloat contentSizeToBeIncreased;
    FyndActivityIndicator *loginLoader;
}

@property (nonatomic, strong) FyndUser *userModel;

@end
