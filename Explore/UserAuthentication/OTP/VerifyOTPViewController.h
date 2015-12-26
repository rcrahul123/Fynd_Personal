//
//  VerifyOTPViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldWithImage.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "UserAuthenticationHandler.h"

#import "FyndUser.h"
#import "SSUtility.h"
#import "ResetPasswordViewController.h"
#import "LocationSearchViewController.h"

@interface VerifyOTPViewController : UIViewController<UIScrollViewDelegate, LocationSearchDelegate>{

    UIScrollView *containerView;
    UIImageView *userImageView;
    TextFieldWithImage *mobileNumberInput;
    TextFieldWithImage *OTPInput;

    UIButton *veriyfOTPButton;
    UILabel *infoLabel;
    UIButton *resendButton;
    UserAuthenticationHandler *userAuthenticationHandler;
    
    CGFloat contentSizeToBeIncreased;
    
    UILabel *errorMessageLabel;
    UIButton *login;
    
    LocationSearchViewController *locationSearchController;
    UINavigationController *navController;
    
    FyndActivityIndicator *verifyOTPLoader;
    
}

@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *otp;
@property (nonatomic) OTPNavigationOption sourceOption;
@property (nonatomic,strong) NSDictionary   *updateProfileDictData;
@property (nonatomic, assign) BOOL isMobileEditable;
@property (nonatomic, strong) FyndUser *userModel;
@property (nonatomic, strong) NSMutableDictionary *fbUserDictionary;
@end
