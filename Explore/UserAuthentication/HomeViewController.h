//
//  HomeViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FacebookDetailsViewController.h"
#import "UserAuthenticationHandler.h"
#import "FyndUser.h"

#import <CoreLocation/CoreLocation.h>
#import "OBBrandSelectionViewController.h"
#import "PopOverlayHandler.h"
#import "LocationSearchViewController.h"
#import "SCGIFImageView.h"

@interface HomeViewController : UIViewController<UIScrollViewDelegate, FacebookLoginDelegate, CLLocationManagerDelegate, LocationSearchDelegate, UIApplicationDelegate>{
    
    UIScrollView *playerContainer;
//    UIView *buttonsContainer;
    NSMutableArray *playerArray;
    AVPlayer *currentPlayer;
    int totalPages;
    int currentPage;
    CGFloat buttonsHeight;
    UserAuthenticationHandler *authenticationRequestHandler;
//    FyndUser *userData;
    NSMutableDictionary *fbDataDict;
    
    BOOL showFBDetailPage;
    UIPageControl *pageControl;
    
    UIView *facebookButtonView;
    UIImageView *fbImage;
    UILabel *fbLabel;
    UITapGestureRecognizer *fbTapped;
    
    CLLocationManager *locationManager;
    CLLocation *location;
    UIAlertView *locationAlert;
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
    UIView                  *gifContainerView;
    SCGIFImageView         *gifContainer;
    FyndActivityIndicator *homeLoader;
    bool isFirstLoad;
    
}

@property (nonatomic, strong) UIButton *haveOTPButton;
@property (strong, nonatomic)  UIButton *facebookLogin;
@property (strong, nonatomic)  UIButton *login;
@property (strong, nonatomic)  UIButton *signUp;
@property (nonatomic,strong) FyndUser *userData;
@property (nonatomic, strong) FyndUser *fbUser;
@property (nonatomic,strong) PopOverlayHandler  *overlayHandler;


-(void)pushTabBar;
-(void)pushOnBoarding;
-(void)signUpNewUser;

//@property (strong, nonatomic) IBOutlet UIButton *FacebookLogin;
//@property (strong, nonatomic) IBOutlet UIButton *login;
//@property (strong, nonatomic) IBOutlet UIButton *signUp;
@end
