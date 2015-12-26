//
//  ResetPasswordViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ResetPasswordViewController.h"


@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
    
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    resetPasswordLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [resetPasswordLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 44)];
    
    containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerScrollView.delegate = self;
    [containerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:containerScrollView];
    
    [self setupParallax];
    [self setupLoginView];
    [self setBackButton];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}



-(void)setupParallax{
    UIImageView *headerView = [[UIImageView alloc] init];
    [headerView setBackgroundColor:[UIColor grayColor]];
    [containerScrollView setParallaxHeaderView:nil mode:VGParallaxHeaderModeFill height:0];
}

-(void)setupLoginView{
    
    passwordTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"PasswordError" andSelectedImage:@"PasswordSelected" andUnSelectedImage:@"Password"];
    passwordTextField.textFieldType = TextFieldTypePassword;
    [passwordTextField.theTextField setPlaceholder:@"Password"];
    passwordTextField.theTextField.secureTextEntry = YES;
    [passwordTextField setCenter:CGPointMake(containerScrollView.frame.size.width/2, passwordTextField.center.y)];
    [passwordTextField.theTextField setReturnKeyType:UIReturnKeyDone];
    
    passwordTextField.isreturnTypeDone = TRUE;
    __weak ResetPasswordViewController *weakRef = self;
    passwordTextField.callBackBlock = ^(){
        [weakRef doLogin];
    };
    
    [passwordTextField updateRightImageFor:passwordTextField.theTextField withImage:kPasswordEyeImage];
    [containerScrollView addSubview:passwordTextField];
    [passwordTextField.theTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
    
    
    NSAttributedString *resetString = [[NSAttributedString alloc] initWithString:@"SET PASSWORD & LOGIN" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    setPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerScrollView.frame.size.width - RelativeSize(2 * buttonMargin, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [setPasswordButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [setPasswordButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    setPasswordButton.layer.cornerRadius = 3.0;
    setPasswordButton.clipsToBounds = YES;
    [setPasswordButton setAttributedTitle:resetString forState:UIControlStateNormal];
    [setPasswordButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [setPasswordButton setCenter:CGPointMake(containerScrollView.frame.size.width/2, passwordTextField.frame.origin.y + passwordTextField.frame.size.height + setPasswordButton.frame.size.height/2 + 25)
     ];
    [containerScrollView addSubview:setPasswordButton];
    
}
- (void) buttonHighlight:(id)highlighted {
    setPasswordButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}

-(void)doLogin{

    if([passwordTextField validate]){
        [self.view addSubview:resetPasswordLoader];
        [resetPasswordLoader startAnimating];
        
        userData = [SSUtility loadUserObjectWithKey:kFyndUserKey];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.mobile forKey:@"mobile"];
        [dict setObject:self.otp forKey:@"otp"];
        [dict setObject:passwordTextField.theTextField.text forKey:@"password"];
        
        [userAuthenticationHandler changePassword:dict withComppletionHandler:^(id responseData, NSError *error) {
            [resetPasswordLoader stopAnimating];
            [resetPasswordLoader removeFromSuperview];
            
            
            if(!error){
                if([[responseData objectForKey:@"is_verified"] boolValue]){
                    [self  parseUserData:responseData];
                        if(self.sourceOption == OTPNavigatedFromChangePassword){
                            [SSUtility showOverlayViewWithMessage:@"Profile Updated Successfully" andColor:UIColorFromRGB(kGreenColor)];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else if (self.sourceOption == OTPNavigatedFromForgotPassword){
                            if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                                [self getLocation];
                            }else{
                                [self performSegueWithIdentifier:@"ResetPasswordToOnboarding" sender:nil];
                            }
                        }
                }else{
                    if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                        [self showErrorMessages:([responseData objectForKey:@"message"])];

                    }
                }
            }
        }];
    }
}


-(void)getLocation{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *locality = [defaults objectForKey:@"city"];
    if(locality == nil || ![SSUtility checkIfUserInAllowedCities:[[defaults valueForKey:@"city"] lowercaseString]]){
        [self declineLocationAcces];
    }else{
        [self performSegueWithIdentifier:@"ResetPasswordToTab" sender:nil];
        
    }
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
    locationSearchController.shouldHideCancel = true;
    locationSearchController.delegate = self;
//    navController = [[UINavigationController alloc] initWithRootViewController:locationSearchController];
    
    [self presentViewController:locationSearchController
                       animated:YES
                     completion:^{
                         
                     }];
}


-(void)didSelectLocation{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"ResetPasswordToTab" sender:nil];
    }];
}


-(void)showErrorMessages:(NSString *)message{
    CGRect rect = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0]} context:NULL];
    
    if(!errorMessageLabel)
    {
        errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        [containerScrollView addSubview:errorMessageLabel];
    }else{
        [errorMessageLabel setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    [errorMessageLabel setText:message];
    [errorMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [errorMessageLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
    [errorMessageLabel setBackgroundColor:[UIColor clearColor]];
    [errorMessageLabel setTextColor:UIColorFromRGB(kPinkColor)];
    [errorMessageLabel setCenter:CGPointMake(containerScrollView.frame.size.width/2, passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 10)];
    [errorMessageLabel setHidden:TRUE];
    
    [UIView animateWithDuration:0.4 animations:^{
        [setPasswordButton setCenter:CGPointMake(setPasswordButton.center.x, errorMessageLabel.center.y + errorMessageLabel.frame.size.height + setPasswordButton.frame.size.height/2 + 10)];
    } completion:^(BOOL finished) {
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
        
        FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
        
        if(!user){
            user = [FyndUser sharedMySingleton];
        }
        
        user.firstName = [profileData objectForKey:@"first_name"];
        user.lastName = [profileData objectForKey:@"last_name"];
        user.gender = [profileData objectForKey:@"gender"];
        user.profilePicUrl = [profileData objectForKey:@"profile_image_url"];
        user.mobileNumber = [profileData objectForKey:@"mobile"];
        user.shouldShowHaveOTP = FALSE;
        user.isOnboarded = [[response objectForKey:@"is_onboarded"] boolValue];
        user.joiningDate = [profileData objectForKey:@"joining_date"]; // Need to Confirm with Rahul
        user.userId = [NSString stringWithFormat:@"%@",profileData[@"user_id"]];
        user.emailId = [profileData objectForKey:@"email"];
        [SSUtility saveCustomObject:user];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [containerScrollView shouldPositionParallaxHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
