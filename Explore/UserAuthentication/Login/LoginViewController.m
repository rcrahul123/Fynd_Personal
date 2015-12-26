//
//  LoginViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 14/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#define kLoginParallaxHeaderHeight 0

#import "LoginViewController.h"
@interface LoginViewController (){
    BOOL isHighlighted;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    loginLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [loginLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];

    containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerScrollView.delegate = self;
    [containerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:containerScrollView];
    [containerScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];

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


-(void)viewWillAppear:(BOOL)animated{
    

    [super viewWillAppear:FALSE];
    
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBarHidden = false;
    
    self.navigationItem.title = @"Login";
    [self registerForKeyboardNotifications];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setupParallax{
    UIImageView *headerView = [[UIImageView alloc] init];
    [headerView setBackgroundColor:[UIColor grayColor]];
    [containerScrollView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeFill height:kLoginParallaxHeaderHeight];
}

-(void)setupLoginView{
    
    mobileNumberTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"MobileError" andSelectedImage:@"MobileSelected" andUnSelectedImage:@"Mobile"];
    mobileNumberTextField.textFieldType = TextFieldTypeMobile;
    [mobileNumberTextField.theTextField setPlaceholder:@"Mobile Number"];
    mobileNumberTextField.theTextField.keyboardType = UIKeyboardTypeNumberPad;
    [mobileNumberTextField setCenter:CGPointMake(containerScrollView.frame.size.width/2, RelativeSizeHeight(buttonMargin, 667) + mobileNumberTextField.frame.size.height/2)];
    
    [containerScrollView addSubview:mobileNumberTextField];
    
    passwordTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"PasswordError" andSelectedImage:@"PasswordSelected" andUnSelectedImage:@"Password"];
    passwordTextField.textFieldType = TextFieldTypePassword;
    [passwordTextField.theTextField setPlaceholder:@"Password"];
    passwordTextField.theTextField.secureTextEntry = YES;
    [passwordTextField setCenter:CGPointMake(containerScrollView.frame.size.width/2, mobileNumberTextField.frame.origin.y + mobileNumberTextField.frame.size.height + passwordTextField.frame.size.height/2 + 11)];
    [passwordTextField updateRightImageFor:passwordTextField.theTextField withImage:kPasswordEyeImage];
    passwordTextField.isreturnTypeDone = TRUE;
    __weak LoginViewController *weakRef = self;
    passwordTextField.callBackBlock = ^(){
        [weakRef doLogin];
    };
    
    mobileNumberTextField.theTextField.nextTextField = passwordTextField.theTextField;

    [containerScrollView addSubview:passwordTextField];
    
    
    NSAttributedString *createAccountString = [[NSAttributedString alloc] initWithString:@"LOGIN" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];

    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerScrollView.frame.size.width - RelativeSize(2 * buttonMargin, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [loginButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    loginButton.layer.cornerRadius = 3.0;
    loginButton.clipsToBounds = YES;
    [loginButton setAttributedTitle:createAccountString forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setCenter:CGPointMake(containerScrollView.frame.size.width/2, passwordTextField.frame.origin.y + passwordTextField.frame.size.height + loginButton.frame.size.height/2 + 20)
     ];

    [loginButton setHighlighted:TRUE];
    [containerScrollView addSubview:loginButton];
    
    NSAttributedString *resetText = [[NSAttributedString alloc] initWithString:@"Forgot Password" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];
    NSAttributedString *resetTextTouch = [[NSAttributedString alloc] initWithString:@"Forgot Password" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor), NSBackgroundColorAttributeName: [UIColor clearColor]}];

    resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(30, 320), 20)];
    [resetButton setAttributedTitle:resetText forState:UIControlStateNormal];
    [resetButton setAttributedTitle:resetTextTouch forState:UIControlStateHighlighted];
    [resetButton setCenter:CGPointMake(containerScrollView.frame.size.width/2, loginButton.frame.origin.y + loginButton.frame.size.height + resetButton.frame.size.height/2 + 20)];
    [resetButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [containerScrollView  addSubview:resetButton];
    
    contentSizeToBeIncreased = resetButton.frame.origin.y + resetButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
    if(contentSizeToBeIncreased < 0){
        contentSizeToBeIncreased = 0;
    }

    [mobileNumberTextField.theTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
}

-(void)showKeyboard{
    [mobileNumberTextField.theTextField becomeFirstResponder];
}

- (void) buttonHighlight:(id)highlighted {
    loginButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}

-(void)doLogin{
    [self dismissKeyboard];
    if([mobileNumberTextField validate] && [passwordTextField validate]){

        [self.view addSubview:loginLoader];
        [loginLoader startAnimating];
        
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setObject:[[mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject] forKey:@"mobile"];
        [paramDict setObject:passwordTextField.theTextField.text forKey:@"password"];
        
        [userAuthenticationHandler loginUser:paramDict withCompletionHandler:^(id responseData, NSError *error) {

            [loginLoader stopAnimating];
            [loginLoader removeFromSuperview];
            
            if(!error){
                if([[responseData objectForKey:@"is_logged_in"] boolValue]){
                    int totalCartItems = [[responseData objectForKey:kTotalCartItemsKey] intValue];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *string = [formatter stringFromDate:now];
                    
                    [self parseUserData:responseData];

                    [FyndAnalytics trackLoginWithLoginType:@"normal" andLoginDate:string];

                    //Added total count of items in cart.
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalCartItems] forKey:kHasItemInBag];
                    if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                        [self getLocation];
                    }else{
                        [self performSegueWithIdentifier:@"LoginToOnBoard" sender:nil];
                    }
                }else{
                    if([responseData objectForKey:@"message"] && [(NSString *)[responseData objectForKey:@"message"] length] > 0){
                        [self showErrorMessages:([responseData objectForKey:@"message"])];
                    }
                }
            }else{
                
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
        [self performSegueWithIdentifier:@"LoginToTabBar" sender:nil];
        
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
    
//    [self presentViewController:locationSearchController
//                       animated:YES
//                     completion:^{
//                         
//                     }];
    
    [self presentViewController:locationSearchController animated:YES completion:^{
        
    }];
    
}


-(void)didSelectLocation{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"LoginToTabBar" sender:nil];
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
        [loginButton setCenter:CGPointMake(loginButton.center.x, errorMessageLabel.center.y + errorMessageLabel.frame.size.height + loginButton.frame.size.height/2 + 10)];
    } completion:^(BOOL finished) {
        [errorMessageLabel setHidden:FALSE];
    }];
}

-(void)resetPassword{
    self.navigationController.navigationBar.backItem.title = @"";

    [self performSegueWithIdentifier:@"LoginToOTP" sender:nil];
}
     
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [containerScrollView shouldPositionParallaxHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dismissKeyboard{
    if([mobileNumberTextField.theTextField isFirstResponder]){
        [mobileNumberTextField.theTextField resignFirstResponder];
    }
    
    if([passwordTextField.theTextField isFirstResponder]){
        [passwordTextField.theTextField resignFirstResponder];
    }
}

-(void)parseUserData:(id)response{
    NSDictionary *profileData = [response objectForKey:@"profile"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kFyndUserKey]){
        [defaults removeObjectForKey:kFyndUserKey];
    }
    
    if(profileData){
        self.userModel = [[FyndUser alloc] init];
        self.userModel.firstName = [profileData objectForKey:@"first_name"];
        self.userModel.lastName = [profileData objectForKey:@"last_name"];
        self.userModel.gender = [profileData objectForKey:@"gender"];
        self.userModel.profilePicUrl = [profileData objectForKey:@"profile_image_url"];
        self.userModel.mobileNumber = [profileData objectForKey:@"mobile"];
        self.userModel.shouldShowHaveOTP = FALSE;
        self.userModel.isOnboarded = [[response objectForKey:@"is_onboarded"] boolValue];
        self.userModel.joiningDate = [profileData objectForKey:@"joining_date"]; // Done changes for joining date
        self.userModel.userId = [NSString stringWithFormat:@"%@",profileData[@"user_id"]];
        self.userModel.emailId = [profileData objectForKey:@"email"];
        [SSUtility saveCustomObject:self.userModel];
    }
}

#pragma Mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notif {
    
    [UIView animateWithDuration:0.0 animations:^{
    } completion:^(BOOL finished) {
        [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, containerScrollView.frame.size.height + contentSizeToBeIncreased)];
    }];
}

-(void) keyboardWillHide: (NSNotification *)notif {
    [UIView animateWithDuration:0.0 animations:^{

    } completion:^(BOOL finished) {
        [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, containerScrollView.frame.size.height - kLoginParallaxHeaderHeight)];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"LoginToOTP"]){
        SendOTPViewController *controller = (SendOTPViewController *)segue.destinationViewController;
        
        controller.sourceOption = OTPNavigatedFromForgotPassword;
    }
}

#pragma mark - UITextField Delegates


-(BOOL)validateTextFields{
    
    if(mobileNumberTextField.theTextField.text.length ==10 && passwordTextField.theTextField.text.length+1 >7){
        return YES;
    }
    return NO;
}

@end
