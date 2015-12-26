//
//  LocationAccessViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "LocationAccessViewController.h"
#import "UINavigationBar+Transparency.h"
//#import <Mixpanel/MPTweakInline.h>
#import "UserAuthenticationHandler.h"


@interface LocationAccessViewController ()

@end

@implementation LocationAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allowLocationLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [allowLocationLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-40)];
    
    UIImage *bgImage = [UIImage imageNamed:@"LocationAccessBackground"];
    UIImage *locationIconImage = [UIImage imageNamed:@"LocationIcon"];

    if(kDeviceHeight == 480){
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, RelativeSizeHeight(55, 667), self.view.frame.size.width, bgImage.size.height)];
        
        locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - locationIconImage
                                                                     .size.width/2, RelativeSizeHeight(45, 667), locationIconImage
                                                                     .size.width, locationIconImage.size.height)];

    }else{
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, RelativeSizeHeight(77, 667), self.view.frame.size.width, bgImage.size.height)];
        
        locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - locationIconImage
                                                                     .size.width/2, RelativeSizeHeight(65, 667), locationIconImage
                                                                     .size.width, locationIconImage.size.height)];

    }
    
    [backgroundImageView setImage:bgImage];
    self.edgesForExtendedLayout=UIRectEdgeNone;

    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backgroundImageView];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    [locationIcon setImage:locationIconImage];
    [self.view addSubview:locationIcon];
    
    [self setupDetailView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    self.navigationItem.hidesBackButton = TRUE;
}


-(void)setupDetailView{
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    NSString *userName;
    if(user.firstName){
        userName = user.firstName;
    }else{
        userName = @"";
    }
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hey %@!", userName] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0]}];
    CGRect labelRect = [nameString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - RelativeSize(30, 320), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    personalizedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelRect.size.width, labelRect.size.height)];
    [personalizedLabel setTextColor:UIColorFromRGB(kPinkColor)];
    [personalizedLabel setNumberOfLines:0];
    personalizedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [personalizedLabel setAttributedText:nameString];
    [personalizedLabel setTextAlignment:NSTextAlignmentCenter];
    [personalizedLabel setCenter:CGPointMake(self.view.frame.size.width/2, backgroundImageView.frame.origin.y + backgroundImageView.frame.size.height + labelRect.size.height/2 + RelativeSizeHeight(17, 667))];
    [self.view addSubview:personalizedLabel];
    
    NSAttributedString *staticDetailString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Allow us to fynd brands, collections and trends around you"] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16.0]}];
    CGRect rect2 = [staticDetailString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - RelativeSize(42, 375), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    staticTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, personalizedLabel.center.y + personalizedLabel.frame.size.height + RelativeSizeHeight(12, 667), rect2.size.width, rect2.size.height)];
    staticTextLabel.numberOfLines = 0;
    staticTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [staticTextLabel setAttributedText:staticDetailString];
    [staticTextLabel setTextAlignment:NSTextAlignmentCenter];
    [staticTextLabel setCenter:CGPointMake(self.view.frame.size.width/2, staticTextLabel.center.y)];
    [self.view addSubview:staticTextLabel];

    NSAttributedString *allowButtonText = [[NSAttributedString alloc] initWithString:@"ALLOW LOCATION ACCESS" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    allowAccessButton = [[UIButton alloc] initWithFrame:CGRectMake(0, staticTextLabel.frame.origin.y + staticTextLabel.frame.size.height + RelativeSizeHeight(40, 667), self.view.frame.size.width - RelativeSize(42, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [allowAccessButton setAttributedTitle:allowButtonText forState:UIControlStateNormal];
    [allowAccessButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [allowAccessButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    allowAccessButton.layer.cornerRadius = 3.0;
    allowAccessButton.clipsToBounds = YES;
    [allowAccessButton setCenter:CGPointMake(self.view.frame.size.width/2, staticTextLabel.center.y + (rect2.size.height/2 + allowAccessButton.frame.size.height/2 + RelativeSizeHeight(25, 667)))];
    [allowAccessButton addTarget:self action:@selector(allowLocatioAccess) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:allowAccessButton];
    
    NSAttributedString *skipButtonText = [[NSAttributedString alloc] initWithString:@"Select Manually" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];
    NSAttributedString *skipButtonTextTouch = [[NSAttributedString alloc] initWithString:@"Select Manually" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];

    skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, allowAccessButton.frame.origin.y + allowAccessButton.frame.size.height + RelativeSizeHeight(22, 667), self.view.frame.size.width - RelativeSize(30, 320), 14)];
    [skipButton setAttributedTitle:skipButtonText forState:UIControlStateNormal];
    [skipButton setAttributedTitle:skipButtonTextTouch forState:UIControlStateHighlighted];
    [skipButton setCenter:CGPointMake(self.view.frame.size.width/2, skipButton.center.y)];
    [skipButton addTarget:self action:@selector(declineLocationAcces) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:skipButton];
}

- (void) buttonHighlight:(id)highlighted {
    allowAccessButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}

-(void)allowLocatioAccess{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
            locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                       message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                      delegate:self
                                             cancelButtonTitle:@"Settings"
                                             otherButtonTitles:@"Select Manually", nil];
            locationAlert.tag = 1;
        }else{
            locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                       message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                      delegate:self
                                             cancelButtonTitle:@"Select Manually"
                                             otherButtonTitles:nil];
            locationAlert.tag = 2;
            
        }
        [locationAlert show];
        
    }else{
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = 600;


        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
        } else {
//            [SSUtility showActivityOverlay:self.view];
            [self.view addSubview:allowLocationLoader];
            [allowLocationLoader startAnimating];
            [locationManager startUpdatingLocation];
        }
    }
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        }
            break;
            
        case kCLAuthorizationStatusDenied: {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                           message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                          delegate:self
                                                 cancelButtonTitle:@"Settings"
                                                 otherButtonTitles:@"Select Manually", nil];
                locationAlert.tag = 1;
            }else{
                locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                           message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                          delegate:self
                                                 cancelButtonTitle:@"Select Manually"
                                                 otherButtonTitles:nil];
                locationAlert.tag = 2;

            }
            [locationAlert show];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.view addSubview:allowLocationLoader];
            [allowLocationLoader startAnimating];
            [locationManager startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.view addSubview:allowLocationLoader];
            [allowLocationLoader startAnimating];
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
            break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    
    location = [locations objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark = [placemarks lastObject];
        [userDefaults setObject:[NSString stringWithFormat:@"%@, %@", [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0], [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:1]] forKey:@"city"];
        
        if([SSUtility checkIfUserInAllowedCities:[placemark.locality lowercaseString]]){
            [userDefaults setObject:[placemark.locality lowercaseString] forKey:@"city"];
//            [FyndAnalytics trackLocationAccessType:@"auto" andLocation:[placemark.locality lowercaseString]];
            [userDefaults setObject:@"auto" forKey:@"onboardingAccessType"];
            [userDefaults setObject:[placemark.locality lowercaseString] forKey:@"onboardingLocation"];

            /*
            if( MPTweakValue(@"SkipOnboarding_Event", YES) ) {
                [self completeOnboarding];
            } else {
                [self performSegueWithIdentifier:@"LocationToOBBrand" sender:nil];
            }
             */
            [self performSegueWithIdentifier:@"LocationToOBBrand" sender:nil];

            [allowLocationLoader stopAnimating];
            [allowLocationLoader removeFromSuperview];
            
        }else{
            [allowLocationLoader stopAnimating];
            [allowLocationLoader removeFromSuperview];
            [self declineLocationAcces];
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if(alertView.tag == 2){
            [self declineLocationAcces];
        }else{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }else{
        [self declineLocationAcces];

    }
}




-(void)declineLocationAcces{
    
    if(locationSearchController){
        locationSearchController = nil;
        navController = nil;
    }
        locationSearchController = [[LocationSearchViewController alloc] init];
        locationSearchController.delegate = self;
//        navController = [[UINavigationController alloc] initWithRootViewController:locationSearchController];
    
    [self presentViewController:locationSearchController
                       animated:YES
                     completion:^{
                         
                     }];
}


-(void)didSelectLocation{
    
    [self dismissViewControllerAnimated:YES completion:^{
    /*
    if( MPTweakValue(@"SkipOnboarding_Event", YES) ) {
            [self completeOnboarding];
            
        } else {
            [self performSegueWithIdentifier:@"LocationToOBBrand" sender:nil];
    }
     */
    [self performSegueWithIdentifier:@"LocationToOBBrand" sender:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)completeOnboarding{
   UserAuthenticationHandler *userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
    [userAuthenticationHandler completeUserOnBoardingWithCompletionHandler:^(id responseData, NSError *error) {
        if(!error){
            FyndUser *theUser = (FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey];
            if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                [theUser setIsOnboarded:TRUE];
                
            }else{
                [theUser setIsOnboarded:FALSE];
            }
            NSArray * _theFollowigBrandData = [NSArray array];
            NSArray * collectionArray = [NSArray array];
            NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:kShowWelcomeCard];
            [FyndAnalytics registerPropertiesForOnBoardingForUser:theUser.userId Location:city withBrandsData:_theFollowigBrandData andCollectionsData:collectionArray];
            
            
            [SSUtility saveCustomObject:theUser];
        }
        [self performSegueWithIdentifier:@"LocationToFeed" sender:nil];
    }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
