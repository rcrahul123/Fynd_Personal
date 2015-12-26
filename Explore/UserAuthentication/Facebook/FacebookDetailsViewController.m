//
//  FacebookDetailsViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FacebookDetailsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookDetailsViewController ()

@end

@implementation FacebookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelFacebookLogin)];
    [cancelButton setTintColor:UIColorFromRGB(kTurquoiseColor)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
    
    detailView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    detailView.delegate = self;
    [detailView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:detailView];
    [detailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];

    [self setupHeader];
    [self setupDetailView];
    [self showUserDetails];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otpVerfiedSuccessfully) name:@"fbOTPVerified" object:nil];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
}


-(void)otpVerfiedSuccessfully{
        [self dismissViewControllerAnimated:NO completion:^{
            if([self.delegate respondsToSelector:@selector(facebookAccountCreated)]){
                [self.delegate facebookAccountCreated];
            }
        }];
}

-(void)showUserDetails{
    if(!self.userModel){
        self.userModel = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    }
    if(self.userModel){

        if([self.fbDataDictionary objectForKey:@"first_name"])
            firstName.theTextField.text = [self.fbDataDictionary objectForKey:@"first_name"];
        
        if([self.fbDataDictionary objectForKey:@"last_name"])
            lastName.theTextField.text = [self.fbDataDictionary objectForKey:@"last_name"];
        
        if([self.fbDataDictionary objectForKey:@"profile_pic_url"]){
            NSString *imageStringOfLoginUser = [self.fbDataDictionary objectForKey:@"profile_pic_url"];
            NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            [profileImage setImage:[UIImage imageWithData:imageData]];
        }
        
        NSString *gender = [self.fbDataDictionary objectForKey:@"gender"];

        if([gender.uppercaseString isEqualToString:@"MALE"]){
            [genderSwitch setSelectedSegmentIndex:1];

        }else if([gender.uppercaseString isEqualToString:@"FEMALE"]){
            [genderSwitch setSelectedSegmentIndex:0];
        }

        if([self.fbDataDictionary objectForKey:@"email"])
            emailIDTextField.theTextField.text= [self.fbDataDictionary objectForKey:@"email"];
        [emailIDTextField becomeFirstResponder];
    }
    
    [firstName validate];
    [lastName validate];
    [emailIDTextField validate];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = FALSE;
    self.navigationItem.hidesBackButton = TRUE;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(kLightGreyColor)];
    self.navigationItem.title = @"Facebook Connect";
    
    [self registerForKeyboardNotifications];
}


-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupHeader{
    headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    [detailView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeFill height:0];
}

-(void)setupDetailView{

    firstName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(buttonMargin, RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:@"NameError" andSelectedImage:@"NameSelected" andUnSelectedImage:@"Name"];
    firstName.textFieldType = TextFieldTypeFirstName;
    [firstName.theTextField setPlaceholder:@"First Name"];
    firstName.theMessage = @"Invalid First Name";
    firstName.theTextField.keyboardType = UIKeyboardTypeAlphabet;
    [detailView addSubview:firstName];
    
    lastName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + RelativeSize(5, 375), RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    lastName.textFieldType = TextFieldTypeLastName;
    [lastName.theTextField setPlaceholder:@"Last Name"];
    lastName.theMessage = @"Invalid Last Name";
    lastName.theTextField.keyboardType = UIKeyboardTypeAlphabet;
    [detailView addSubview:lastName];
    
    emailIDTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, firstName.frame.origin.y + firstName.frame.size.height + 15, detailView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"EmailError" andSelectedImage:@"EmailSelected" andUnSelectedImage:@"Email"];
    emailIDTextField.textFieldType = TextFieldTypeEmail;
    [emailIDTextField setCenter:CGPointMake(detailView.frame.size.width/2, firstName.frame.origin.y + firstName.frame.size.height + emailIDTextField.frame.size.height/2 + 11)];

    emailIDTextField.theTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailIDTextField.theTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0]];
    emailIDTextField.theTextField.placeholder = @"Email";
    
    emailIDTextField.isreturnTypeDone = TRUE;
    __weak FacebookDetailsViewController *weakRef = self;
    emailIDTextField.callBackBlock = ^(){
        [weakRef facebookLoginDone];
    };
    
    
    firstName.theTextField.nextTextField = lastName.theTextField;
    lastName.theTextField.nextTextField = emailIDTextField.theTextField;
    
    [detailView addSubview:emailIDTextField];

    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Regular size:14], NSFontAttributeName,
                                        nil];
    
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          UIColorFromRGB(kLightGreyColor), NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Light size:14], NSFontAttributeName,
                                          nil];
    
    genderSwitch = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, detailView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 44)];
    [genderSwitch insertSegmentWithTitle:@"Female" atIndex:0 animated:NO];
    [genderSwitch insertSegmentWithTitle:@"Male" atIndex:1 animated:NO];
    [genderSwitch setCenter:CGPointMake(detailView.frame.size.width/2, emailIDTextField.frame.origin.y + emailIDTextField.frame.size.height + genderSwitch.frame.size.height/2 + 11)];
    [genderSwitch addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventValueChanged];
    [genderSwitch setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [genderSwitch setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [genderSwitch addTarget:self action:@selector(genderSelected) forControlEvents:UIControlEventValueChanged];
    [genderSwitch setTintColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [detailView addSubview:genderSwitch];
    
    genderErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderSwitch.frame.origin.x, genderSwitch.frame.origin.y + genderSwitch.frame.size.height + 8, genderSwitch.frame.size.width, 14)];
    [genderErrorLabel setBackgroundColor:[UIColor clearColor]];
    [genderErrorLabel setText:@"Please select Gender"];
    [genderErrorLabel setTextColor:UIColorFromRGB(kRedColor)];
    [genderErrorLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [genderErrorLabel setHidden:TRUE];
    [detailView addSubview:genderErrorLabel];
    
    createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, detailView.frame.size.width - RelativeSize(2 * buttonMargin, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    [createAccountButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"CREATE ACCOUNT"
                                                                            attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0],
                                                                                         NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    createAccountButton.layer.cornerRadius = 3.0;
    createAccountButton.clipsToBounds = YES;
    [createAccountButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [createAccountButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [createAccountButton addTarget:self action:@selector(facebookLoginDone) forControlEvents:UIControlEventTouchUpInside];
    [createAccountButton setCenter:CGPointMake(detailView.frame.size.width/2, genderErrorLabel.frame.origin.y + genderErrorLabel.frame.size.height + createAccountButton.frame.size.height/2 + 11)];
    
    [detailView addSubview:createAccountButton];
    
    if([[[self.fbDataDictionary objectForKey:@"gender"] uppercaseString] isEqualToString:@"MEN"]){
        [genderSwitch setSelectedSegmentIndex:1];
    }else if([[[self.fbDataDictionary objectForKey:@"gender"] uppercaseString] isEqualToString:@"WOMEN"]){
        [genderSwitch setSelectedSegmentIndex:0];
    }
    
    contentSizeToBeIncreased = createAccountButton.frame.origin.y + createAccountButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
    if(contentSizeToBeIncreased < 0){
        contentSizeToBeIncreased = 0;
    }
    

}

-(void)genderSelected{
    [genderErrorLabel setHidden:TRUE];
    [self dismissKeyboard];
}

- (void) buttonHighlight:(id)highlighted {
    createAccountButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}
-(void)facebookLoginDone{
    [self dismissKeyboard];
    
    if([firstName validate] && [lastName validate] && [emailIDTextField validate]){
        
        if(!(genderSwitch.selectedSegmentIndex >= 0)){
            [genderErrorLabel setHidden:FALSE];
            
        }else{
            self.userModel.firstName = firstName.theTextField.text;
            self.userModel.lastName = lastName.theTextField.text;
            self.userModel.emailId = emailIDTextField.theTextField.text;
            [self.fbDataDictionary setObject:firstName.theTextField.text forKey:@"first_name"];
            [self.fbDataDictionary setObject:lastName.theTextField.text forKey:@"last_name"];
            [self.fbDataDictionary setObject:emailIDTextField.theTextField.text forKey:@"email"];
            
            if(genderSwitch.selectedSegmentIndex == 0){
                [self.fbDataDictionary setObject:@"women" forKey:@"gender"];
                self.userModel.gender = @"women";
                
            }else if(genderSwitch.selectedSegmentIndex == 0){
                [self.fbDataDictionary setObject:@"men" forKey:@"gender"];
                self.userModel.gender = @"men";
            }
            
            [self performSegueWithIdentifier:@"facebookToOTP" sender:nil];
        }
    }
}

-(void)dismissKeyboard{
    if([firstName.theTextField isFirstResponder]){
        [firstName.theTextField resignFirstResponder];
    }
    if([lastName.theTextField isFirstResponder]){
        [lastName.theTextField resignFirstResponder];
    }
    if([emailIDTextField.theTextField isFirstResponder]){
        [emailIDTextField.theTextField resignFirstResponder];
    }
}


-(void)cancelFacebookLogin{
    
    [self dismissViewControllerAnimated:YES completion:^{
      //do some action to delete FB token and revoke permmissions
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [detailView shouldPositionParallaxHeader];
}

#pragma Mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notif {
    [detailView setContentSize:CGSizeMake(detailView.frame.size.width, detailView.frame.size.height + contentSizeToBeIncreased)];
    
}

-(void) keyboardWillHide: (NSNotification *)notif {
    [detailView setContentSize:CGSizeMake(detailView.frame.size.width, detailView.frame.size.height)];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqual:@"facebookToOTP"]){
        
        SendOTPViewController *otp = (SendOTPViewController *)segue.destinationViewController;
        [self.fbDataDictionary setObject:emailIDTextField.theTextField.text forKey:@"email"];

        otp.userData = self.userModel;
        otp.fbUserDataDictionary = self.fbDataDictionary;
        otp.sourceOption = OTPNavigatedFromFacebook;
        
    }
}


@end
