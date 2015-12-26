//
//  SignUpViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "TextFieldWithImage.h"

#import "FyndUser.h"
#import "SSUtility.h"
#import "SendOTPViewController.h"

@interface SignUpViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>{
    UIScrollView *containerScrollView;
    
    UIImageView *userImageView ;
    TextFieldWithImage *firstName;
    TextFieldWithImage *lastName;
    TextFieldWithImage *emailIDTextField;
    TextFieldWithImage *passwordTextField;
    UISegmentedControl *genderSwitch;
    
    UIButton *createAccountButton;
    FyndUser *userModel;
    
    CGPoint offset;
    TextFieldWithImage *activeTextField;
    UILabel *genderErrorLabel;
    
    CGFloat contentSizeToBeIncreased;
}

@end
