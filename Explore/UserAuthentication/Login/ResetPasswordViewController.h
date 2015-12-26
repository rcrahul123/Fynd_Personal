//
//  ResetPasswordViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldWithImage.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "UserAuthenticationHandler.h"
#import "SSUtility.h"
#import "FyndUser.h"
#import "LocationSearchViewController.h"


@interface ResetPasswordViewController : UIViewController<UIScrollViewDelegate, LocationSearchDelegate>{
    
    UIScrollView *containerScrollView;
    UIImageView *userImageView ;
    TextFieldWithImage *passwordTextField;
    UIButton *setPasswordButton;
    UserAuthenticationHandler *userAuthenticationHandler;
    FyndUser *userData;
    UILabel *errorMessageLabel;
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
    
    FyndActivityIndicator *resetPasswordLoader;
}

@property (nonatomic) OTPNavigationOption sourceOption;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *otp;


@end

