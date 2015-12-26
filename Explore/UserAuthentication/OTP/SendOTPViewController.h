//
//  SendOTPViewController.h
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
#import "VerifyOTPViewController.h"

@interface SendOTPViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>{
    
    UIScrollView *containerView;
    UIImageView *userImageView;
    TextFieldWithImage *mobileNumberInput;
    UIButton *sendOTPButton;
    
    UILabel *staticTextLabel;
    UserAuthenticationHandler *userAuthenticationHandler;
//    FyndUser *userModel;
    
    UILabel *errorMessageLabel;
    UILabel *userExists;
    UIButton *login;
    
    CGFloat contentSizeToBeIncreased;
    
    FyndActivityIndicator *sendOTPLoader;
}

@property (nonatomic,strong) NSString           *mobileNumber;
@property (nonatomic,strong) NSDictionary       *updateProfileDict;
@property (nonatomic) OTPNavigationOption sourceOption;

@property (nonatomic, strong) FyndUser *userData;

@property (nonatomic, strong) NSMutableDictionary *fbUserDataDictionary;

+(int)getStaticCount;

@end

