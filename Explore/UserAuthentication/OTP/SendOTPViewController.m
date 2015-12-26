//
//  SendOTPViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SendOTPViewController.h"
#import "VerifyOTPViewController.h"
static int otpSentCount = 1;
@interface SendOTPViewController (){
//    AccountDetailType accType;

}
@end

@implementation SendOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

    userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
    containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerView.delegate = self;
    [self.view addSubview:containerView];
    [self setupParallax];
    [self setupSendOTPScreen];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];    
    [self setBackButton];
    otpSentCount = 1;
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
+(int)getStaticCount{
    return otpSentCount;
}

-(void)viewWillAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    if(self.sourceOption == OTPNavigatedFromSignUp || self.sourceOption == OTPNavigatedFromFacebook){
        MixPanelSuperProperties *theSuperProps = [[MixPanelSuperProperties alloc] init];
        theSuperProps.gender = self.userData.gender;
        if (self.sourceOption == OTPNavigatedFromFacebook) {
            theSuperProps.signUpMethod = @"facebook";
        }else
            theSuperProps.signUpMethod = @"normal";
        theSuperProps.mobileNumber = self.userData.mobileNumber;
        
        theSuperProps.firstName = self.userData.firstName;
        theSuperProps.lastName = self.userData.lastName;
        theSuperProps.emailId = self.userData.emailId;

        [FyndAnalytics registerSuperPropertiesForSignUp:theSuperProps];
        
    }
    if(sendOTPLoader){
        [sendOTPLoader removeFromSuperview];
        sendOTPLoader = nil;
    }
    sendOTPLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [sendOTPLoader setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2 - 44)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupParallax{
    if (self.sourceOption ==OTPNavigatedFromChangePassword) {
        NSString *str1 =@"   You are changing your password";
        NSString *str2 =@"Please confirm your mobile number";
        NSString *thePasswordAlertMessage = [NSString stringWithFormat:@"%@ \r %@",str1,str2];
        UIFont *theFnt = [UIFont fontWithName:kMontserrat_Light size:12.0f];
        CGSize addressSize = [SSUtility getDynamicSizeWithSpacing:thePasswordAlertMessage withFont:theFnt withSize:CGSizeMake(250, MAXFLOAT) spacing:3.0];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3.0f;
        
        NSDictionary *tempDict = @{NSFontAttributeName:theFnt
                                   ,NSParagraphStyleAttributeName:paragraphStyle};
        
        UILabel *thePasswordAlert = [SSUtility generateLabel:thePasswordAlertMessage withRect:CGRectMake(self.view.frame.size.width/2 - addressSize.width/2, 0, addressSize.width, addressSize.height) withFont:theFnt];
        [thePasswordAlert setNumberOfLines:0];
        [thePasswordAlert setTextAlignment:NSTextAlignmentLeft];
        [thePasswordAlert setFont:theFnt];
        [thePasswordAlert setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
        thePasswordAlert.attributedText = [[NSAttributedString alloc]initWithString:thePasswordAlertMessage attributes:tempDict];
        
        [thePasswordAlert setCenter:CGPointMake(containerView.frame.size.width/2, 44)];
        
        [containerView addSubview:thePasswordAlert];
    }else{

        [containerView setParallaxHeaderView:nil mode:VGParallaxHeaderModeFill height:0];
    }
}

-(void)setupSendOTPScreen{
    
    mobileNumberInput = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"MobileError" andSelectedImage:@"MobileSelected" andUnSelectedImage:@"Mobile"];
    mobileNumberInput.textFieldType = TextFieldTypeMobile;
    mobileNumberInput.theTextField.placeholder = @"Mobile Number";
    mobileNumberInput.theTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.sourceOption == OTPNavigatedFromChangePassword) {
        [mobileNumberInput setCenter:CGPointMake(self.view.frame.size.width/2, 120)];
    }else{
          [mobileNumberInput setCenter:CGPointMake(self.view.frame.size.width/2, RelativeSizeHeight(buttonMargin, 667) + mobileNumberInput.frame.size.height/2)];
    }

    mobileNumberInput.isreturnTypeDone = TRUE;
    __weak SendOTPViewController *weakSelf = self;
    mobileNumberInput.callBackBlock = ^{
        [weakSelf sendOTP];
    };
    
    [containerView addSubview:mobileNumberInput];
    
    NSAttributedString *sendString = [[NSAttributedString alloc] initWithString:@"REQUEST OTP" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    sendOTPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width - RelativeSize(2 * buttonMargin, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [sendOTPButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [sendOTPButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    sendOTPButton.layer.cornerRadius = 3.0;
    sendOTPButton.clipsToBounds = YES;
    [sendOTPButton setAttributedTitle:sendString forState:UIControlStateNormal];
    [sendOTPButton addTarget:self action:@selector(sendOTP) forControlEvents:UIControlEventTouchUpInside];
    [sendOTPButton setCenter:CGPointMake(containerView.frame.size.width/2, mobileNumberInput.frame.origin.y + mobileNumberInput.frame.size.height + sendOTPButton.frame.size.height/2 + 30)
     ];
    [containerView addSubview:sendOTPButton];
    
    contentSizeToBeIncreased = sendOTPButton.frame.origin.y + sendOTPButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
    if(contentSizeToBeIncreased < 0){
        contentSizeToBeIncreased = 0;
    }
    
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.7];

}

-(void)showKeyboard{
    [mobileNumberInput.theTextField becomeFirstResponder];
}

#pragma mark - Keyboard Handling

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

-(void)sendOTP{
    [self requestForOTP];
}

- (void) buttonHighlight:(id)highlighted {
    sendOTPButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}


-(void)requestForOTP{
    if([mobileNumberInput validate]){
        if([mobileNumberInput.theTextField isFirstResponder]){
            [mobileNumberInput.theTextField resignFirstResponder];
        }
        [containerView addSubview:sendOTPLoader];
        [sendOTPLoader startAnimating];
        
        //MixPanel
        if (otpSentCount > 1) {
            otpSentCount ++;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *dateString = [formatter stringFromDate:now];
        
//        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                              dateStyle:NSDateFormatterShortStyle
//                                                              timeStyle:NSDateFormatterFullStyle];
        [FyndAnalytics trackOTPRequestWithTime:dateString andRequestCount:otpSentCount];
        
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        
        if(self.userData){
            self.userData.mobileNumber = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        }else{
            self.userData = [FyndUser sharedMySingleton];
            self.userData.mobileNumber = [[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject];
        }
        [paramDict setObject:self.userData.mobileNumber forKey:@"mobile"];

        if(self.sourceOption == OTPNavigatedFromSignUp){
            [paramDict setObject:self.userData.firstName forKey:@"first_name"];
            [paramDict setObject:self.userData.lastName forKey:@"last_name"];
            [paramDict setObject:self.userData.emailId forKey:@"email"];
            [paramDict setObject:self.userData.password forKey:@"password"];
            [paramDict setObject:self.userData.gender forKey:@"gender"];
            
            [userAuthenticationHandler createNewUserAccount:paramDict withCompletionHandler:^(id responseData, NSError *error) {
                [sendOTPLoader stopAnimating];
                [sendOTPLoader removeFromSuperview];
                if(!error){
                    if([responseData isKindOfClass:[NSDictionary class]]){

                        if([responseData objectForKey:@"otp_sent"] && [[responseData objectForKey:@"otp_sent"] boolValue]){
                            [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
                        }else{
                            if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showErrorMessages:[responseData objectForKey:@"message"]];
                                });
                                if([responseData objectForKey:@"user_exists"] && [[responseData objectForKey:@"user_exists"] boolValue]){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self showLoginButton];
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
                [sendOTPLoader stopAnimating];
                [sendOTPLoader removeFromSuperview];

                if(!error){
                    if([[responseData objectForKey:@"otp_sent"] boolValue]){
                        [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showErrorMessages:[responseData objectForKey:@"message"]];
                            });
                        }
                    }
                }
            }];
        }else if(self.sourceOption == OTPNavigatedFromFacebook){
            [self.fbUserDataDictionary setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
            [userAuthenticationHandler loginUsingFacebook:self.fbUserDataDictionary withComppletionHandler:^(id responseData, NSError *error) {
                [sendOTPLoader stopAnimating];
                [sendOTPLoader removeFromSuperview];

                if(!error){
                    if([[responseData objectForKey:@"otp_sent"] boolValue]){
                        [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
                    }else{
                        if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showErrorMessages:[responseData objectForKey:@"message"]];
                            });
                            if([responseData objectForKey:@"user_exists"] && [[responseData objectForKey:@"user_exists"] boolValue]){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showLoginButton];
                                });
                            }
                        }
                    }
                }
            }];
        }
        else if (self.sourceOption == OTPNavigatedFromChangePassword) {
        [paramDict setObject:[[mobileNumberInput.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
        [userAuthenticationHandler sendOTP:paramDict withComppletionHandler:^(id responseData, NSError *error) {
            [sendOTPLoader stopAnimating];
            [sendOTPLoader removeFromSuperview];

            if(!error){
                if([[responseData objectForKey:@"mobile_exists"] boolValue] && [[responseData objectForKey:@"otp_sent"] boolValue]){
                    [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
                }else{
                    if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showErrorMessages:[responseData objectForKey:@"message"]];
                        });
                    }
                }
            }
        }];
    }

    }
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
    [errorMessageLabel setCenter:CGPointMake(containerView.frame.size.width/2, mobileNumberInput.frame.origin.y + mobileNumberInput.frame.size.height + 10)];
    [errorMessageLabel setHidden:TRUE];
    
    [UIView animateWithDuration:0.4 animations:^{
        [sendOTPButton setCenter:CGPointMake(sendOTPButton.center.x, errorMessageLabel.center.y + errorMessageLabel.frame.size.height + sendOTPButton.frame.size.height/2 + 10)];


    } completion:^(BOOL finished) {
        contentSizeToBeIncreased = sendOTPButton.frame.origin.y + sendOTPButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;

        [errorMessageLabel setHidden:FALSE];
    }];
}


-(void)showLoginButton{
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Please Login" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Please Login" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor)}];
    
    CGRect rect1 = [str1 boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 20)  options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    if(!login){
        login = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect1.size.width, rect1.size.height)];
    }

    [login setAttributedTitle:str1 forState:UIControlStateNormal];
    [login setAttributedTitle:str2 forState:UIControlStateHighlighted];
    [login setBackgroundColor:[UIColor clearColor]];
    [login setCenter:CGPointMake(errorMessageLabel.center.x, errorMessageLabel.frame.origin.y + errorMessageLabel.frame.size.height + rect1.size.height + 5)];
    [login addTarget:self action:@selector(navigateToLogin) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:login];
    [login setHidden:TRUE];
    
    [UIView animateWithDuration:0.4 animations:^{
        [sendOTPButton setCenter:CGPointMake(sendOTPButton.center.x, login.center.y + login.frame.size.height + sendOTPButton.frame.size.height/2 + 10)];
        
    } completion:^(BOOL finished) {
        contentSizeToBeIncreased = sendOTPButton.frame.origin.y + sendOTPButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
        [login setHidden:FALSE];
    }];
}


-(void)navigateToLogin{
    [self performSegueWithIdentifier:@"OTPToLogin" sender:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:TRUE];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [containerView shouldPositionParallaxHeader];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"VerifyOTP"]){
        self.userData.shouldShowHaveOTP = TRUE;
        [[NSUserDefaults standardUserDefaults] setObject:@(self.sourceOption) forKey:@"OTPNavOption"];
        if(self.sourceOption == OTPNavigatedFromFacebook){
            [[NSUserDefaults standardUserDefaults] setObject:self.fbUserDataDictionary forKey:@"fbUserData"];
        }

        [SSUtility saveCustomObject:self.userData];
        
        VerifyOTPViewController *destination = segue.destinationViewController;
        
        destination.userModel = self.userData;
        destination.mobileNumber = self.userData.mobileNumber;
        destination.sourceOption = self.sourceOption;
    }

}


@end
