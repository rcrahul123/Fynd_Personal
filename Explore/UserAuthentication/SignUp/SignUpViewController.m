//
//  SignUpViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xF2F2F2)];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];    
    containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    containerScrollView.delegate = self;
    [containerScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:containerScrollView];
    
    [containerScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self setupParallax];
    [self setupUserDetailView];
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
    [self registerForKeyboardNotifications];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupParallax{
    UIImageView *headerView = [[UIImageView alloc] init];
    [headerView setBackgroundColor:[UIColor grayColor]];
    [containerScrollView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeFill height:0];
}

-(void)setupUserDetailView{

    firstName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(RelativeSize(buttonMargin, 375), RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:@"NameError" andSelectedImage:@"NameSelected" andUnSelectedImage:@"Name"];
    firstName.textFieldType = TextFieldTypeFirstName;
    firstName.theMessage = @"Invalid First Name";
    [firstName.theTextField setPlaceholder:@"First Name"];
    [firstName.theTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [containerScrollView addSubview:firstName];
    
    lastName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + RelativeSize(5, 375), RelativeSizeHeight(buttonMargin, 667), self.view.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    lastName.textFieldType = TextFieldTypeLastName;
    lastName.theMessage = @"Invalid Last Name";
    [lastName.theTextField setPlaceholder:@"Last Name"];
    lastName.theTextField.keyboardType = UIKeyboardTypeAlphabet;
    [containerScrollView addSubview:lastName];
    
    emailIDTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"EmailError" andSelectedImage:@"EmailSelected" andUnSelectedImage:@"Email"];
    emailIDTextField.textFieldType = TextFieldTypeEmail;
    [emailIDTextField.theTextField setPlaceholder:@"Email"];
    emailIDTextField.theTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailIDTextField setCenter:CGPointMake(containerScrollView.frame.size.width/2, firstName.frame.origin.y + firstName.frame.size.height + emailIDTextField.frame.size.height/2 + 11)];

    [containerScrollView addSubview:emailIDTextField];
    
    passwordTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"PasswordError" andSelectedImage:@"PasswordSelected" andUnSelectedImage:@"Password"];
    passwordTextField.textFieldType = TextFieldTypePassword;
    [passwordTextField.theTextField setPlaceholder:@"Password (min 6 characters)"];
    passwordTextField.theTextField.secureTextEntry = YES;

    [passwordTextField setCenter:CGPointMake(containerScrollView.frame.size.width/2, emailIDTextField.frame.origin.y + emailIDTextField.frame.size.height + passwordTextField.frame.size.height/2 + 11)];
    passwordTextField.isreturnTypeDone = TRUE;
    [passwordTextField updateRightImageFor:passwordTextField.theTextField withImage:kPasswordEyeImage];
    
    __weak SignUpViewController *weakRef = self;
    passwordTextField.callBackBlock = ^(){
        [weakRef createAccount];
    };

    [containerScrollView addSubview:passwordTextField];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Regular size:14], NSFontAttributeName,
                                nil];
    
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          UIColorFromRGB(kLightGreyColor), NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Light size:14], NSFontAttributeName,
                                nil];
    
    genderSwitch = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, containerScrollView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 40)];
    [genderSwitch insertSegmentWithTitle:@"Female" atIndex:0 animated:NO];
    [genderSwitch insertSegmentWithTitle:@"Male" atIndex:1 animated:NO];
    [genderSwitch setCenter:CGPointMake(containerScrollView.frame.size.width/2, passwordTextField.frame.origin.y + passwordTextField.frame.size.height + genderSwitch.frame.size.height/2 + 11)];
    [genderSwitch setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [genderSwitch setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [genderSwitch addTarget:self action:@selector(genderSelected) forControlEvents:UIControlEventValueChanged];
    [genderSwitch setTintColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [containerScrollView addSubview:genderSwitch];
    
    genderErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderSwitch.frame.origin.x, genderSwitch.frame.origin.y + genderSwitch.frame.size.height + 8, genderSwitch.frame.size.width, 14)];
    [genderErrorLabel setBackgroundColor:[UIColor clearColor]];
    [genderErrorLabel setText:@"Please select Gender"];
    [genderErrorLabel setTextColor:UIColorFromRGB(kRedColor)];
    [genderErrorLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [genderErrorLabel setHidden:TRUE];
    [containerScrollView addSubview:genderErrorLabel];
    
    NSAttributedString *createAccountString = [[NSAttributedString alloc] initWithString:@"CREATE ACCOUNT" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    createAccountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, containerScrollView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 50)];
    [createAccountButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [createAccountButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    createAccountButton.layer.cornerRadius = 3.0;
    createAccountButton.clipsToBounds = YES;
    [createAccountButton setAttributedTitle:createAccountString forState:UIControlStateNormal];
    [createAccountButton addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    [createAccountButton setCenter:CGPointMake(containerScrollView.frame.size.width/2, genderErrorLabel.frame.origin.y + genderErrorLabel.frame.size.height + createAccountButton.frame.size.height/2 + 11)];
    
    [containerScrollView addSubview:createAccountButton];
    
    firstName.theTextField.nextTextField = lastName.theTextField;
    lastName.theTextField.nextTextField = emailIDTextField.theTextField;
    emailIDTextField.theTextField.nextTextField = passwordTextField.theTextField;
    
    
    
    contentSizeToBeIncreased = createAccountButton.frame.origin.y + createAccountButton.frame.size.height + 20 + kKeyboardHeight - kDeviceHeight;
    if(contentSizeToBeIncreased < 0){
        contentSizeToBeIncreased = 0;
    }
    
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.7];
}

-(void)showKeyboard{
    [firstName.theTextField becomeFirstResponder];
}

-(void)genderSelected{
    [genderErrorLabel setHidden:TRUE];
    [self dismissKeyboard];
}

- (void) buttonHighlight:(id)highlighted {
    createAccountButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}
-(void)dismissKeyboard{
    if([firstName.theTextField isFirstResponder]){
        [firstName.theTextField resignFirstResponder];
    }else if([lastName.theTextField isFirstResponder]){
        [lastName.theTextField resignFirstResponder];
    }else if([emailIDTextField.theTextField isFirstResponder]){
        [emailIDTextField.theTextField resignFirstResponder];
    }else if([passwordTextField.theTextField isFirstResponder]){
        [passwordTextField.theTextField resignFirstResponder];
    }
}

-(void)createAccount{
    
    if([firstName validate] && [lastName validate] && [emailIDTextField validate] && [passwordTextField validate]){
        
        if(!(genderSwitch.selectedSegmentIndex >= 0)){
            [genderErrorLabel setHidden:FALSE];
            
        }else{
            userModel = [FyndUser sharedMySingleton];
            userModel.firstName = firstName.theTextField.text;
            userModel.lastName = lastName.theTextField.text;
            userModel.emailId = emailIDTextField.theTextField.text;
            userModel.password = passwordTextField.theTextField.text;
            
            if(genderSwitch.selectedSegmentIndex == 0){
                userModel.gender = @"women";
            }else{
                userModel.gender = @"men";
            }
            [self performSegueWithIdentifier:@"SignUpToOTP" sender:nil];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SignUpToOTP"]){
        SendOTPViewController *destination = (SendOTPViewController *)segue.destinationViewController;
        destination.userData = userModel;
        destination.sourceOption = OTPNavigatedFromSignUp;
    }
}


#pragma Mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notif {

    [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, containerScrollView.frame.size.height + contentSizeToBeIncreased)];
}

-(void) keyboardWillHide: (NSNotification *)notif {
    [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width, containerScrollView.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [containerScrollView shouldPositionParallaxHeader];
}


-(BOOL)validateTextFields{
    int count = 0;
    if(firstName.theTextField.text.length >0 && lastName.theTextField.text.length>0){
        count ++;
    }
    if (emailIDTextField.theTextField.text.length>0 && [self validateEmailWithString:emailIDTextField.theTextField.text]) {
        count ++;
    }
    if (passwordTextField.theTextField.text.length+1>5) {
        count ++;
    }
    if (genderSwitch.selectedSegmentIndex == 0 || genderSwitch.selectedSegmentIndex == 1) {
        count++;
    }
    if (count == 4) {
        return YES;
    }
    return NO;
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
