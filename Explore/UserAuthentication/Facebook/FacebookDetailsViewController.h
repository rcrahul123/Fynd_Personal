//
//  FacebookDetailsViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextFieldWIthImage.h"
#import "FyndUser.h"
#import "SSUtility.h"
#import "SendOTPViewController.h"
#import "UIScrollView+VGParallaxHeader.h"

@protocol FacebookLoginDelegate <NSObject>

-(void)facebookAccountCreated;

@end
@interface FacebookDetailsViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate>{
    UIView *headerView;
    UIScrollView *detailView;
    
    UIImageView *profileImage;
    
    TextFieldWithImage *firstName;
    TextFieldWithImage *lastName;
    
    TextFieldWithImage *emailIDTextField;
    UISegmentedControl *genderSwitch;
    UIButton *createAccountButton;
    UIActivityIndicatorView *userDetailActivityIndicator;
    NSMutableDictionary *fbDataDict;
    UILabel *genderErrorLabel;

    
    CGFloat contentSizeToBeIncreased;
}

@property (nonatomic, strong) id<FacebookLoginDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *fbDataDictionary;
@property (nonatomic, strong) FyndUser *userModel;
@end
