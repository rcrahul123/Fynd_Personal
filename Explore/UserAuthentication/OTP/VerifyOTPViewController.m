//
//  VerifyOTPViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "VerifyOTPViewController.h"
#import "ResetPasswordViewController.h"
#import "ProfileRequestHandler.h"
#import "SendOTPViewController.h"
static int verifyStaticCount = 0;
@interface VerifyOTPViewController (){

}
@property (nonatomic,strong) ProfileRequestHandler *profileHandler;
@end

@implementation VerifyOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];    
    self.navigationController.navigationBarHidden = false;
    userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
//    userData = [SSUtility loadUserObjectWithKey:kFyndUserKey];

    verifyOTPLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [verifyOTPLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.delegate = self;
    [self.view addSubview:containerView];
    [self setupParallax];
    [self setupSendOTPScreen];
    [self setBackButton];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)viewWillAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

-(void)setupParallax{
  if (self.sourceOption != OTPNavigatedFromChangePassword) {
  }
}

-(void)setupSendOTPScreen{
    
    mobileNumberInput = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"MobileError" andSelectedImage:@"MobileSelected" andUnSelectedImage:@"Mobile"];
    mobileNumberInput.theTextField.placeholder = @"Mobile Number";
    mobileNumberInput.textFieldType = TextFieldTypeMobile;
    mobileNumberInput.theTextField.keyboardType = UIKeyboardTypeNumberPad;
    if (self.sourceOption == OTPNavigatedFromChangePassword) {
        [mobileNumberInput setCenter:CGPointMake(self.view.frame.size.width/2, 80)];
    }else
        [mobileNumberInput setCenter:CGPointMake(self.view.frame.size.width/2, mobileNumberInput.center.y)];
    
    [mobileNumberInput.theTextField setReturnKeyType:UIReturnKeyNext];
    [containerView addSubview:mobileNumberInput];
    
    if(!self.isMobileEditable){
        mobileNumberInput.theTextField.enabled = FALSE;
        [mobileNumberInput setAlpha:0.6];
    }else{
        mobileNumberInput.theTextField.text = @"";
    }
    OTPInput = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"OTPError" andSelectedImage:@"OTPSelected" andUnSelectedImage:@"OTP"];
    OTPInput.textFieldType = TextfielTypeOTP;
    OTPInput.theTextField.placeholder = @"Enter OTP";
    [OTPInput.theTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [OTPInput becomeFirstResponder];
//    [OTPInput.theTextField setReturnKeyType:UIReturnKeyDone];
    
    OTPInput.isreturnTypeDone = TRUE;
    __weak VerifyOTPViewController *weakRef = self;
    OTPInput.callBackBlock = ^(){
        [weakRef verifyOTP];
    };
    [OTPInput setCenter:CGPointMake(containerView.frame.size.width/2, mobileNumberInput.frame.origin.y + mobileNumberInput.frame.size.height + OTPInput.frame.size.height/2 + 15)];
    [containerView addSubview:OTPInput];
    
    if(self.userModel.mobileNumber || (self.mobileNumber && self.sourceOption == OTPNavigatedFromEditProfile)){
        if(self.userModel.mobileNumber){
            mobileNumberInput.theTextField.text = [@"+91 " stringByAppendingString:self.userModel.mobileNumber];
        }else{
            mobileNumberInput.theTextField.text = [@"+91 " stringByAppendingString:self.mobileNumber];
        }
//        [OTPInput.theTextField becomeFirstResponder];
        [OTPInput.theTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
    }else{
//        [mobileNumberInput.theTextField becomeFirstResponder];
        mobileNumberInput.theTextField.enabled = TRUE;

        [mobileNumberInput.theTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
    }
    
    NSAttributedString *verifyString = [[NSAttributedString alloc] initWithString:@"CONFIRM OTP" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    veriyfOTPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 50)];
    veriyfOTPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width - RelativeSize(2 * buttonMargin, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [veriyfOTPButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [veriyfOTPButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    veriyfOTPButton.layer.cornerRadius = 3.0;
    veriyfOTPButton.clipsToBounds = YES;
    [veriyfOTPButton setAttributedTitle:verifyString forState:UIControlStateNormal];
    [veriyfOTPButton addTarget:self action:@selector(verifyOTP) forControlEvents:UIControlEventTouchUpInside];
    [veriyfOTPButton setCenter:CGPointMake(containerView.frame.size.width/2, OTPInput.frame.origin.y + OTPInput.frame.size.height + veriyfOTPButton.frame.size.height/2 + 25)];
//    [veriyfOTPButton addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [containerView addSubview:veriyfOTPButton];


    NSString *infoMsg = @"In case you didn’t receive the OTP, please ";
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 32)];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setTextColor:[UIColor lightGrayColor]];
    [infoLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0]];
    [infoLabel setText:infoMsg];
    [infoLabel sizeToFit];
    [infoLabel setCenter:CGPointMake(containerView.frame.size.width/2, veriyfOTPButton.frame.origin.y + veriyfOTPButton.frame.size.height + infoLabel.frame.size.height/2 + 20)];
    [containerView addSubview:infoLabel];

    NSAttributedString *resetText = [[NSAttributedString alloc] initWithString:@"Resend OTP" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];
    NSAttributedString *resetTextTouch = [[NSAttributedString alloc] initWithString:@"Resend OTP" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];
    resendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(30, 320), 14)];
    [resendButton setAttributedTitle:resetText forState:UIControlStateNormal];
    [resendButton setAttributedTitle:resetTextTouch forState:UIControlStateHighlighted];
    [resendButton setCenter:CGPointMake(containerView.frame.size.width/2, infoLabel.frame.origin.y + infoLabel.frame.size.height + resendButton.frame.size.height/2 + 8)];
    [resendButton addTarget:self action:@selector(resendOTP) forControlEvents:UIControlEventTouchUpInside];
    [containerView  addSubview:resendButton];
    
    mobileNumberInput.theTextField.nextTextField = OTPInput.theTextField;
    
    contentSizeToBeIncreased = infoLabel.frame.origin.y + infoLabel.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
    if(contentSizeToBeIncreased < 0){
        contentSizeToBeIncreased = 0;
    }
}

- (void) buttonHighlight:(id)highlighted {
    veriyfOTPButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}

-(void)verifyOTP{
    
    [self dismissKeyboard];

    if([OTPInput validate]){
        
        [self.view addSubview:verifyOTPLoader];
        [verifyOTPLoader startAnimating];

        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
        [paramDict setObject:OTPInput.theTextField.text forKey:@"otp"];
            
        self.userModel.mobileNumber = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        self.userModel.otp = OTPInput.theTextField.text;
        
        [SSUtility saveCustomObject:self.userModel];
        
        if(self.sourceOption == OTPNavigatedFromSignUp){
            [userAuthenticationHandler verifyOTP:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                if(!error){
                    if([responseData objectForKey:@"profile"] && [[responseData objectForKey:@"profile"] objectForKey:@"user_id"]){
                        if([[responseData objectForKey:@"profile"] objectForKey:@"user_id"]){
                            FyndUser *user = [FyndUser sharedMySingleton];
                            user.userId = [[responseData objectForKey:@"profile"] objectForKey:@"user_id"];
                            [SSUtility saveCustomObject:user];
                            [FyndAnalytics createAlias];
                        }

                    }
                    if([[responseData objectForKey:@"is_verified"] boolValue]){
                        [self parseUserData:responseData];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                        NSDate *now = [NSDate date];
                        NSString *dateString = [formatter stringFromDate:now];
                        
//                        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                                              dateStyle:NSDateFormatterShortStyle
//                                                                              timeStyle:NSDateFormatterFullStyle];

                        [FyndAnalytics trackOTPConfirmationWithMobile:self.userModel.mobileNumber andDate:dateString andUserID:self.userModel.userId];
                        [FyndAnalytics startSessionTracking];
                        int totalCartItems = 0;

                        if ([responseData objectForKey:kTotalCartItemsKey]) {
                            totalCartItems = [[responseData objectForKey:kTotalCartItemsKey] intValue];
                        }
                        
                        //Added total count of items in cart.
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalCartItems] forKey:kHasItemInBag];

                        if(![[responseData objectForKey:@"is_onboarded"] boolValue]){
                            [self performSegueWithIdentifier:@"otpToOnBoard" sender:nil];
                        }else{
                            [self getLocation];
                        }
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:[responseData objectForKey:@"message"]];
                        }
                    }
                }else{
                }
            }];
        }else if(self.sourceOption == OTPNavigatedFromForgotPassword || self.sourceOption == OTPNavigatedFromChangePassword){
            [verifyOTPLoader stopAnimating];
            [verifyOTPLoader removeFromSuperview];
            
            [userAuthenticationHandler verifyOTPForResetPassword:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                if(!error){
                    if([[responseData objectForKey:@"is_verified"] boolValue]){
                            [self performSegueWithIdentifier:@"otpToNewPassword" sender:nil];
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:[responseData objectForKey:@"message"]];
                        }
                    }
                }else{
                }
            }];
        }else if (self.sourceOption == OTPNavigatedFromFacebook){
            [userAuthenticationHandler verifyOTP:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                
                if(!error){
                    if([[responseData objectForKey:@"is_verified"] boolValue]){
                        [self parseUserData:responseData];
                        [FyndAnalytics createAlias];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                        NSDate *now = [NSDate date];
                        NSString *dateString = [formatter stringFromDate:now];
                        
//                        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                                              dateStyle:NSDateFormatterShortStyle
//                                                                              timeStyle:NSDateFormatterFullStyle];
                        
                        [FyndAnalytics trackOTPConfirmationWithMobile:self.userModel.mobileNumber andDate:dateString andUserID:self.userModel.userId];
                        [FyndAnalytics startSessionTracking];

                        int totalCartItems = 0;
                        
                        if ([responseData objectForKey:kTotalCartItemsKey]) {
                            totalCartItems = [[responseData objectForKey:kTotalCartItemsKey] intValue];
                        }
                        
                        //Added total count of items in cart.
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalCartItems] forKey:kHasItemInBag];
                        
                        if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                            [self getLocation];
                        }else{
                            [self performSegueWithIdentifier:@"otpToOnBoard" sender:nil];
                        }

                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:[responseData objectForKey:@"message"]];
                        }
                    }

                }else{
                }
            }];

        }
        else if(self.sourceOption == OTPNavigatedFromEditProfile){
            if(self.profileHandler == nil){
                self.profileHandler = [[ProfileRequestHandler alloc] init];
                FyndUser  *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                NSMutableDictionary *actualDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.firstName,@"first_name",user.lastName,@"last_name",user.emailId,@"email",user.gender,@"gender",nil];
                [actualDict setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
                [actualDict setObject:OTPInput.theTextField.text forKey:@"otp"];
                
                [self.profileHandler uploadProfileData:actualDict withCompletionHandler:^(id responseData, NSError *error) {
                    [verifyOTPLoader stopAnimating];
                    [verifyOTPLoader removeFromSuperview];
                    
                    if([[responseData objectForKey:@"message"] isEqualToString:@"Profile updated successfully"]){
                        /* //Previous Implementation
                         FyndUser  *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                         user.firstName = [actualDict objectForKey:@"first_name"];
                         user.lastName = [actualDict objectForKey:@"last_name"];
                         user.mobileNumber = [actualDict objectForKey:@"mobile"];
                         user.emailId = [actualDict objectForKey:@"email"];
                         [SSUtility saveCustomObject:user];
                         */
                        
                        NSDictionary *profileData = [responseData objectForKey:@"profile"];
                        FyndUser  *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                        user.firstName = [profileData objectForKey:@"first_name"];
                        user.lastName = [profileData objectForKey:@"last_name"];
                        user.mobileNumber = [profileData objectForKey:@"mobile"];
                        user.emailId = [profileData objectForKey:@"email"];
                        user.gender = [profileData objectForKey:@"gender"];
                        [SSUtility saveCustomObject:user];
                        
                        
                         [self.navigationController popToRootViewControllerAnimated:TRUE];
                    }else{
                        [self showErrorMessages:[responseData objectForKey:@"message"]];
                    }
                }];
            }
        }
    }
}


-(void)resendOTP{
    
    if([mobileNumberInput validate]){
        [self.view addSubview:verifyOTPLoader];
        [verifyOTPLoader startAnimating];
        if (verifyStaticCount == 0) {
            verifyStaticCount += [SendOTPViewController getStaticCount];
        }
        
        verifyStaticCount ++;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *dateString = [formatter stringFromDate:now];
        
//        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                              dateStyle:NSDateFormatterShortStyle
//                                                              timeStyle:NSDateFormatterFullStyle];
        [FyndAnalytics trackOTPRequestWithTime:dateString andRequestCount:verifyStaticCount];
        
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        
        if(self.userModel){
            self.userModel.mobileNumber = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        }else{
            self.userModel = [FyndUser sharedMySingleton];
            self.userModel.mobileNumber = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        }
        [paramDict setObject:self.userModel.mobileNumber forKey:@"mobile"];
        
        if(self.sourceOption == OTPNavigatedFromSignUp){
            [paramDict setObject:self.userModel.firstName forKey:@"first_name"];
            [paramDict setObject:self.userModel.lastName forKey:@"last_name"];
            [paramDict setObject:self.userModel.emailId forKey:@"email"];
            [paramDict setObject:self.userModel.password forKey:@"password"];
            [paramDict setObject:self.userModel.gender forKey:@"gender"];
            
            [userAuthenticationHandler createNewUserAccount:paramDict withCompletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                
                if(!error){
                    if([responseData isKindOfClass:[NSDictionary class]]){
                        if([responseData objectForKey:@"otp_sent"] && [[responseData objectForKey:@"otp_sent"] boolValue]){
                        }else{
                            if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                                if([[responseData objectForKey:@"message"] isEqualToString:@"User already exist"]){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self showErrorMessages:([responseData objectForKey:@"message"])];
                                    });
                                }
                            }
                        }
                    }
                }else if(error){ // This is added temporary . Need to do proper error handling for all handlers
                    
                }
            }];
            
        }else if(self.sourceOption == OTPNavigatedFromForgotPassword){
            [userAuthenticationHandler sendOTPForgetPassword:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                
                if(!error){
                    if([[responseData objectForKey:@"otp_sent"] boolValue]){
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:([responseData objectForKey:@"message"])];
                        }
                    }
                }
            }];
        }else if(self.sourceOption == OTPNavigatedFromFacebook){
            self.fbUserDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"fbUserData"] mutableCopy];
            [self.fbUserDictionary setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
            
            [userAuthenticationHandler loginUsingFacebook:self.fbUserDictionary withComppletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                
                if(!error){
                    if([[responseData objectForKey:@"otp_sent"] boolValue]){
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:([responseData objectForKey:@"message"])];
                        }
                    }
                }
            }];
        }
        else if (self.sourceOption == OTPNavigatedFromChangePassword) {
            [paramDict setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
            [userAuthenticationHandler sendOTP:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                [verifyOTPLoader stopAnimating];
                [verifyOTPLoader removeFromSuperview];
                
                if(!error){
                    if([[responseData objectForKey:@"mobile_exists"] boolValue] && [[responseData objectForKey:@"otp_sent"] boolValue]){
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            [self showErrorMessages:([responseData objectForKey:@"message"])];
                            
                        }
                    }
                }
            }];
            
        }else if (self.sourceOption == OTPNavigatedFromEditProfile){
            [paramDict setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
            
            [userAuthenticationHandler sendOTP:paramDict withComppletionHandler:^(id responseData, NSError *error) {
                
                if(!error)
                {
                    [verifyOTPLoader stopAnimating];
                    [verifyOTPLoader removeFromSuperview];
                    
                    if(!error){
                        if([[responseData objectForKey:@"otp_sent"] boolValue]){
                        }else{
                            if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                                [self showErrorMessages:([responseData objectForKey:@"message"])];
                            }
                        }
                    }
                }
            }];
        }
    }
}




-(void)getLocation{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *locality = [defaults objectForKey:@"city"];
    if(locality == nil || ![SSUtility checkIfUserInAllowedCities:[[defaults valueForKey:@"city"] lowercaseString]]){
        [self declineLocationAcces];
    }else{
        [self performSegueWithIdentifier:@"otpToTabBar" sender:nil];
        
    }
}


-(void)declineLocationAcces{
    
    if(locationSearchController){
        locationSearchController = nil;
        navController = nil;
    }
    locationSearchController = [[LocationSearchViewController alloc] init];
    locationSearchController.shouldHideCancel = YES;
    locationSearchController.delegate = self;
//    navController = [[UINavigationController alloc] initWithRootViewController:locationSearchController];
    
    [self presentViewController:locationSearchController
                       animated:YES
                     completion:^{
                         
                     }];
}


-(void)didSelectLocation{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"otpToTabBar" sender:nil];
    }];
}



-(void)showErrorMessages:(NSString *)message{
    CGRect rect = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0]} context:NULL];
    
    if(!errorMessageLabel)
    {
        errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        [containerView addSubview:errorMessageLabel];
    }else{
        [errorMessageLabel setFrame:CGRectMake(errorMessageLabel.frame.origin.x, errorMessageLabel.frame.origin.y, rect.size.width, rect.size.height)];
    }
    [errorMessageLabel setText:message];
    [errorMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [errorMessageLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
    [errorMessageLabel setBackgroundColor:[UIColor clearColor]];
    [errorMessageLabel setTextColor:UIColorFromRGB(kPinkColor)];
    [errorMessageLabel setCenter:CGPointMake(containerView.frame.size.width/2, OTPInput.frame.origin.y + OTPInput.frame.size.height + veriyfOTPButton.frame.size.height/2 + 10)];
    [errorMessageLabel setHidden:TRUE];
    
    [UIView animateWithDuration:0.4 animations:^{
        [veriyfOTPButton setCenter:CGPointMake(veriyfOTPButton.center.x, errorMessageLabel.center.y + errorMessageLabel.frame.size.height + veriyfOTPButton.frame.size.height/2 + 10)];
        [infoLabel setCenter:CGPointMake(containerView.frame.size.width/2, veriyfOTPButton.frame.origin.y + veriyfOTPButton.frame.size.height + infoLabel.frame.size.height/2 + 20)];
        [resendButton setCenter:CGPointMake(containerView.frame.size.width/2, infoLabel.frame.origin.y + infoLabel.frame.size.height + resendButton.frame.size.height/2 + 8)];
        
        
    } completion:^(BOOL finished) {
        contentSizeToBeIncreased = infoLabel.frame.origin.y + infoLabel.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;

        if(contentSizeToBeIncreased < 0){
            contentSizeToBeIncreased = 0;
        }
        [errorMessageLabel setHidden:FALSE];
    }];
}


-(void)parseUserData:(id)response{
    NSDictionary *profileData = [response objectForKey:@"profile"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kFyndUserKey]){
        [defaults removeObjectForKey:kFyndUserKey];
    }
    
    if(profileData){
        self.userModel = [FyndUser sharedMySingleton];
        self.userModel.firstName = [profileData objectForKey:@"first_name"];
        self.userModel.lastName = [profileData objectForKey:@"last_name"];
        self.userModel.gender = [profileData objectForKey:@"gender"];
        self.userModel.profilePicUrl = [profileData objectForKey:@"profile_image_url"];
        self.userModel.mobileNumber = [profileData objectForKey:@"mobile"];
        self.userModel.shouldShowHaveOTP = FALSE;
        self.userModel.isOnboarded = [[response objectForKey:@"is_onboarded"] boolValue];
        self.userModel.joiningDate = [profileData objectForKey:@"joining_date"];
        self.userModel.userId = [NSString stringWithFormat:@"%@",profileData[@"user_id"]];
        self.userModel.emailId = [profileData objectForKey:@"email"];

        [SSUtility saveCustomObject:self.userModel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [containerView shouldPositionParallaxHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard{
    
    if([mobileNumberInput.theTextField isFirstResponder]){
        [mobileNumberInput.theTextField resignFirstResponder];
    }
    
    if([OTPInput.theTextField isFirstResponder]){
        [OTPInput.theTextField resignFirstResponder];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notif {
    
    [containerView setContentSize:CGSizeMake(containerView.frame.size.width, containerView.frame.size.height + contentSizeToBeIncreased)];
}

-(void) keyboardWillHide: (NSNotification *)notif {
    [containerView setContentSize:CGSizeMake(containerView.frame.size.width, containerView.frame.size.height)];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.userModel.shouldShowHaveOTP = FALSE;
    [SSUtility saveCustomObject:self.userModel];
    
    [SSUtility dismissActivityOverlay];
    if([segue.identifier isEqualToString:@"otpToNewPassword"]){
        ResetPasswordViewController *cntrlr = (ResetPasswordViewController *)segue.destinationViewController;
        cntrlr.mobile = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        cntrlr.otp = OTPInput.theTextField.text;
        
        if (self.sourceOption == OTPNavigatedFromChangePassword) {
            cntrlr.sourceOption = OTPNavigatedFromChangePassword;
        }else if(self.sourceOption == OTPNavigatedFromForgotPassword){
            cntrlr.sourceOption = OTPNavigatedFromForgotPassword;
        }
    }
}

@end
