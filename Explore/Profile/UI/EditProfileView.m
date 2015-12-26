//
//  EditProfileView.m
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "EditProfileView.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "TextFieldWithImage.h"
#import "SSUtility.h"
#import "ProfileRequestHandler.h"
#import "UserAuthenticationHandler.h"
#import "UIImage+ImageEffects.h"
#import "PopOverlayHandler.h"
#import "FyndErrorInfoView.h"
#import "SendOTPViewController.h"

@interface EditProfileView ()<UIScrollViewDelegate,PopOverlayHandlerDelegate>{
//    UITextField *activeTextField;
    CGPoint scrollPoint;
    CGFloat contentSizeHeight;
    CGPoint offset;
    CGRect visibleRect;
    UIImage *nonBlurImage;
    UILabel *genderErrorLabel;
    UISegmentedControl *genderSwitch;
}
- (void)configureEditProfileHeader;
- (void)configureEditProfileParallax;
- (void)configureEditProfileArcWithLogo;
- (void)configureEditingView;

@property (nonatomic,strong) UIImageView               *editProfileHeaderImage;
@property (nonatomic,strong) UIImageView               *profileLogoImage;
@property (nonatomic,strong) UIScrollView              *editProfileScrollView;
@property (nonatomic,strong) TextFieldWithImage        *firstNameTextField;
@property (nonatomic,strong) TextFieldWithImage        *lastNameTextField;
@property (nonatomic,strong) TextFieldWithImage        *emailNumberTextField;
@property (nonatomic,strong) TextFieldWithImage        *mobileNumberTextField;
@property (nonatomic,strong) UIView                    *maleFemaleContainer;
@property (nonatomic,strong) UIButton                  *maleButton;
@property (nonatomic,strong) UIButton                  *femaleButton;
@property (nonatomic,strong) UILabel                   *male;
@property (nonatomic,strong) UILabel                   *female;
@property (nonatomic,strong) UIButton                  *cancelButton;
@property (nonatomic,strong) UIButton                  *saveChangesButton;
@property (nonatomic,assign) BOOL                       femaleSelected;
@property (nonatomic,assign) BOOL                       maleSelected;
@property (nonatomic,strong) FyndUser                   *fyndUser;
@property (nonatomic,strong) UIImage                    *userDownloadedImage;
@property (nonatomic,strong) ProfileRequestHandler      *profileHandler;
@property (nonatomic,strong) NSURLSessionDataTask       *headerDataTask;
@property (nonatomic,strong) UIButton                   *changePicture;
@property (nonatomic,strong) UIImage                    *captureImage;
@property (nonatomic,strong) UITextField    *activeTextFieldContainer;
@property (nonatomic,strong) UIButton                  *changePasswordButton;
@property (nonatomic,strong) NSString       *uploadedImageUrl;
@property (nonatomic,strong) PopOverlayHandler          *profileUpdateOverlay;
@property (nonatomic,strong) FyndErrorInfoView          *errorInfoView;
@end

@implementation EditProfileView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)configureEditProfile{
    self.fyndUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    [self configureEditProfileHeader];
    [self configureEditProfileParallax];
    [self configureEditProfileArcWithLogo];
    [self configureEditingView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}


- (void)configureEditProfileHeader{
    
    self.editProfileHeaderImage = [[UIImageView alloc] init];
    [self.editProfileHeaderImage setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    self.editProfileHeaderImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    if(self.fyndUser.profilePicUrl && self.fyndUser.profilePicUrl.length >0)
    {
        [self downloadProfileCover:self.fyndUser.profilePicUrl];
        [self.editProfileHeaderImage setContentMode:UIViewContentModeScaleAspectFill];
    }
}


- (void)downloadProfileCover:(NSString *)imageUrl{
    
    NSString *dataURL =  imageUrl;
    if(!config){
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    if(!cache){
        cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:@"big.urlcache"];
        config.URLCache = cache;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    self.headerDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataURL]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self setBackgroundColor:[UIColor clearColor]];
            /*
            UIImage *downloadedImage = [UIImage imageWithData:data];
            self.userDownloadedImage = downloadedImage;
            UIImage *finalImage = downloadedImage;
             */
            
            UIImage *downloadedImage= nil;
            if (data == nil || data.length <= 0) {
                downloadedImage = [UIImage imageNamed:@"default_dp"];
                [self.editProfileHeaderImage setImage:[[UIImage imageNamed:@"default_cover"] applyFyndBlurEffect]];
                
            }else{
                downloadedImage = [UIImage imageWithData:data];
                [self.editProfileHeaderImage setImage:[downloadedImage applyFyndBlurEffect]];
//                [self.editProfileHeaderImage setImage:[downloadedImage applyFyndBlurEffect]];
            }
            
            
            [self.profileLogoImage setImage:downloadedImage];
//            [self.editProfileHeaderImage setImage:[finalImage applyFyndBlurEffect]];
            
          
            [self.editProfileHeaderImage setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [self.editProfileHeaderImage setAlpha:1.0];
            }];
        });
        
    }];
    [self.headerDataTask resume];
}


- (void)configureEditProfileParallax{
    
    self.editProfileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 0)];
    [self.editProfileScrollView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.editProfileScrollView];
    self.editProfileScrollView.delegate = self;
    self.editProfileScrollView.showsVerticalScrollIndicator = false;

    [self.editProfileScrollView setParallaxHeaderView:self.editProfileHeaderImage mode:VGParallaxHeaderModeFill height:RelativeSizeHeight(100, 480)];
    [self.editProfileScrollView setContentSize:CGSizeMake(self.bounds.size.width, 450)];
    [self registerForKeyboardNotifications];
}

- (void)configureEditProfileArcWithLogo{
    UIImage *img = [UIImage imageNamed:@"ArcImage"];
    UIImageView *arcImage = [[UIImageView alloc] init];
    CGFloat height = img.size.height * self.editProfileScrollView.frame.size.width/img.size.width;
    [arcImage setFrame:CGRectMake(0, -height, self.editProfileScrollView.frame.size.width, height)];
    [arcImage setImage:img];
    [self.editProfileScrollView addSubview:arcImage];
    
//    self.profileLogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 55)];
    self.profileLogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLogoWidth, kLogoWidth)];
    [self.profileLogoImage setCenter:CGPointMake(arcImage.center.x, arcImage.frame.origin.y+15)];
    [self.profileLogoImage setBackgroundColor:[UIColor clearColor]];
    [self.profileLogoImage setImage:self.userDownloadedImage];
    self.profileLogoImage.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
    self.profileLogoImage.layer.cornerRadius = 3.0f;
    self.profileLogoImage.layer.borderWidth =2.0f;
    self.profileLogoImage.clipsToBounds = TRUE;
    [self.editProfileScrollView addSubview:self.profileLogoImage];
    
    self.changePicture = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changePicture setBackgroundColor:[UIColor clearColor]];
    [self.changePicture setFrame:CGRectMake(self.frame.size.width/2 - 50, self.profileLogoImage.frame.origin.y + self.profileLogoImage.frame.size.height+5, 100, 20)];
    [self.changePicture setTitle:@"Change Picture" forState:UIControlStateNormal];
    [self.changePicture.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
    [self.changePicture setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
    //    changePicture.titleLabel.textColor = [UIColor whiteColor]; //UIColorFromRGB(kBlueColor);
    [self.changePicture addTarget:self action:@selector(showGallery:) forControlEvents:UIControlEventTouchUpInside];
    [self.editProfileScrollView addSubview:self.changePicture];
}


- (void)updateProfileImage:(UIImage *)image{
    self.profileLogoImage.image = image;
    UIImage *newImage = [image applyFyndBlurEffect];
    self.editProfileHeaderImage.image = newImage;
    
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 150*150;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    
    self.captureImage = [UIImage imageWithData:imageData];
//    self.saveChangesButton.alpha = 1.0f;
//    [self.saveChangesButton setEnabled:TRUE];
    
//    self.editProfileHeaderImage.image = [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:1.0 alpha:0.5] saturationDeltaFactor:1.8 maskImage:nil];
    //[image applyTintEffectWithColor:[UIColor colorWithWhite:0.6 alpha:0.5]];
}


- (void)updateCaptureImage:(UIImage *)image{
   
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 150*150;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    self.captureImage = [UIImage imageWithData:imageData];
}

-(void)configureEditingView{

//    self.firstNameTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.editProfileHeaderImage.frame.origin.x + 10, self.changePicture.frame.origin.y + self.changePicture.frame.size.height+30, self.frame.size.width/2-10, 55) withErrorImage:@"Name_error" andSelectedImage:@"Name_selected" andUnSelectedImage:@"Name"];
    
    self.firstNameTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(RelativeSize(buttonMargin, 375),self.changePicture.frame.origin.y + self.changePicture.frame.size.height+ RelativeSizeHeight(buttonMargin, 667), self.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:@"NameError" andSelectedImage:@"NameSelected" andUnSelectedImage:@"Name"];
    
    
    self.firstNameTextField.textFieldType = TextFieldTypeFirstName;
    self.firstNameTextField.theMessage = @"Invalid First Name";
    [self.firstNameTextField setBackgroundColor:[UIColor clearColor]];

    [self.firstNameTextField.theTextField setPlaceholder:@"First Name"];
    [self.firstNameTextField.theTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.firstNameTextField.theTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    self.firstNameTextField.theTextField.keyboardType = UIKeyboardTypeAlphabet;

    
    __weak EditProfileView *profileView = self;
    NSString *string = self.fyndUser.firstName;
    self.firstNameTextField.updateBlock= ^(UITextField *textField){

        profileView.activeTextFieldContainer = textField;
        [profileView enableSaveButton:string inputField:textField];
    };
    
    [self.firstNameTextField.theTextField setText:self.fyndUser.firstName];
//    [self.firstNameTextField.theTextField becomeFirstResponder];
    [self.firstNameTextField.theTextField setReturnKeyType:UIReturnKeyNext];
    [self.editProfileScrollView addSubview:self.firstNameTextField];
    
    

//    self.lastNameTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.firstNameTextField.frame.origin.x + self.firstNameTextField.frame.size.width+10, self.firstNameTextField.frame.origin.y, 200, self.firstNameTextField.frame.size.height) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    
    self.lastNameTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + RelativeSize(5, 375), self.firstNameTextField.frame.origin.y, self.frame.size.width/2 - RelativeSize(buttonMargin, 375) - RelativeSize(5, 375), 55) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    
    self.lastNameTextField.textFieldType = TextFieldTypeLastName;
    self.lastNameTextField.theMessage = @"Invalid Last Name";
    [self.lastNameTextField setBackgroundColor:[UIColor clearColor]];
    //    self.lastNameTextField.leftImageWillDisplay = FALSE;
    self.lastNameTextField.theTextField.keyboardType = UIKeyboardTypeAlphabet;
    NSString *lastNameString = self.fyndUser.firstName;
    self.lastNameTextField.updateBlock= ^(UITextField *textField){

        profileView.activeTextFieldContainer = textField;
//        [profileView enableSaveButton:textField];
        [profileView enableSaveButton:lastNameString inputField:textField];
    };
    [self.lastNameTextField.theTextField setPlaceholder:@"Last Name"];
    [self.lastNameTextField.theTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.lastNameTextField.theTextField setText:self.fyndUser.lastName];
    [self.lastNameTextField.theTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.lastNameTextField.theTextField setReturnKeyType:UIReturnKeyNext];
    [self.editProfileScrollView addSubview:self.lastNameTextField];
    
    
//    self.emailNumberTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(self.firstNameTextField.frame.origin.x, self.firstNameTextField.frame.origin.y + self.firstNameTextField.frame.size.height+11, self.frame.size.width-20, self.firstNameTextField.frame.size.height) withErrorImage:@"email_error" andSelectedImage:@"email_selected" andUnSelectedImage:@"email"];
    self.emailNumberTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"EmailError" andSelectedImage:@"EmailSelected" andUnSelectedImage:@"Email"];
    self.emailNumberTextField.textFieldType = TextFieldTypeEmail;
    [self.emailNumberTextField setBackgroundColor:[UIColor clearColor]];
    //    self.emailNumberTextField.leftImageWillDisplay = TRUE;
    NSString *emailString = self.fyndUser.firstName;
    self.emailNumberTextField.updateBlock= ^(UITextField *textField){

        profileView.activeTextFieldContainer = textField;
//        [profileView enableSaveButton:textField];
        [profileView enableSaveButton:emailString inputField:textField];
    };
    [self.emailNumberTextField.theTextField setPlaceholder:@"Email"];
    [self.emailNumberTextField.theTextField setText:self.fyndUser.emailId];
    [self.emailNumberTextField.theTextField setReturnKeyType:UIReturnKeyNext];
//Added Seperately
    [self.emailNumberTextField setCenter:CGPointMake(self.editProfileScrollView.frame.size.width/2, self.firstNameTextField.frame.origin.y + self.firstNameTextField.frame.size.height + self.emailNumberTextField.frame.size.height/2 + 11)];
    
    self.emailNumberTextField.theTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.emailNumberTextField.theTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.emailNumberTextField.theTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.editProfileScrollView addSubview:self.emailNumberTextField];
    
    
    self.mobileNumberTextField = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - RelativeSize(2 * buttonMargin, 375), 55) withErrorImage:@"MobileError" andSelectedImage:@"MobileSelected" andUnSelectedImage:@"Mobile"];
    self.mobileNumberTextField.textFieldType = TextFieldTypeMobile;
    NSString *mobileString = self.fyndUser.firstName;
    self.mobileNumberTextField.updateBlock= ^(UITextField *textField){

        profileView.activeTextFieldContainer = textField;
//        [profileView enableSaveButton:textField];
        [profileView enableSaveButton:mobileString inputField:textField];
    };
    [self.mobileNumberTextField setBackgroundColor:[UIColor clearColor]];
    self.mobileNumberTextField.theTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.mobileNumberTextField.theTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [self.mobileNumberTextField.theTextField setReturnKeyType:UIReturnKeyNext];
    [self.mobileNumberTextField.theTextField setPlaceholder:@"Mobile Number"];
    if(self.fyndUser.mobileNumber && self.fyndUser.mobileNumber.length > 0){
        [self.mobileNumberTextField.theTextField setText:[@"+91 " stringByAppendingString:self.fyndUser.mobileNumber]];
    }
    [self.mobileNumberTextField setCenter:CGPointMake(self.editProfileScrollView.frame.size.width/2, self.emailNumberTextField.frame.origin.y + self.emailNumberTextField.frame.size.height + self.mobileNumberTextField.frame.size.height/2 + 11)];
    
//    self.mobileNumberTextField.theTextField.delegate = self;
    [self.mobileNumberTextField.theTextField setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.mobileNumberTextField.theTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.editProfileScrollView addSubview:self.mobileNumberTextField];
    
    
    self.maleFemaleContainer = [self generateMaleFemaleEntryOptions];
    [self.editProfileScrollView addSubview:self.maleFemaleContainer];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.layer.cornerRadius = 3.0f;
    [self.cancelButton setClipsToBounds:TRUE];
    [self.cancelButton setFrame:CGRectMake(self.mobileNumberTextField.frame.origin.x, self.maleFemaleContainer.frame.origin.y + self.maleFemaleContainer.frame.size.height + RelativeSizeHeight(10, 667), self.mobileNumberTextField.frame.size.width/2-4, 50)];
    
//  [self.cancelButton setCenter:CGPointMake(self.mobileNumberTextField.frame.size.width/2-2, self.maleFemaleContainer.frame.origin.y + self.maleFemaleContainer.frame.size.height + self.cancelButton.frame.size.height/2 + 11)];
    
    
    [self.cancelButton setTitleColor:UIColorFromRGB(kGenderSelectorTintColor) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D4D5)] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [self.cancelButton addTarget:self action:@selector(cancelEditMode:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancelButton setCenter:CGPointMake(self.editProfileScrollView.frame.size.width/2-self.cancelButton.frame.size.width/2-RelativeSize(13, 375)/2, self.maleFemaleContainer.frame.origin.y + self.maleFemaleContainer.frame.size.height + self.cancelButton.frame.size.height/2 + 11)];
    [self.editProfileScrollView addSubview:self.cancelButton];

    
    
    self.saveChangesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveChangesButton.layer.cornerRadius = 3.0f;
    [self.saveChangesButton setClipsToBounds:TRUE];
    [self.saveChangesButton setFrame:CGRectMake(self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width+10,self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, 50)];
    
//    self.saveChangesButton.alpha = 0.3f;
//    [self.saveChangesButton setEnabled:FALSE];
    [self.saveChangesButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [self.saveChangesButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    
    [self.saveChangesButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveChangesButton addTarget:self action:@selector(saveProfileData:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveChangesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveChangesButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];

    NSString *changePswd = @"Change Password";
    
    CGSize pwdSize = [SSUtility getLabelDynamicSize:changePswd withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(200, 40)];
    
    self.changePasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size
                                                                           .width/2 - pwdSize.width/2,
                                                                           self.saveChangesButton.frame.size.height + self.saveChangesButton.frame.origin.y + RelativeSizeHeight(10, 480), pwdSize.width, 40)];
    
    [self.changePasswordButton setTitle:changePswd forState:UIControlStateNormal];
    [self.changePasswordButton setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
    [self.changePasswordButton setTitleColor:UIColorFromRGB(kButtonTouchStateColor) forState:UIControlStateHighlighted];
    [self.changePasswordButton.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [self.changePasswordButton addTarget:self action:@selector(openChangePasswordScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.editProfileScrollView addSubview:self.cancelButton];
    [self.editProfileScrollView addSubview:self.saveChangesButton];
    [self.editProfileScrollView addSubview:self.changePasswordButton];
    
    [self.editProfileScrollView setContentSize:CGSizeMake(self.editProfileScrollView.frame.size.width, self.changePasswordButton.frame.size.height + self.changePasswordButton.frame.origin.y + 70)];
    contentSizeHeight = self.editProfileScrollView.contentSize.height;
    
    self.firstNameTextField.theTextField.nextTextField = self.lastNameTextField.theTextField;
    self.lastNameTextField.theTextField.nextTextField = self.emailNumberTextField.theTextField;
    self.emailNumberTextField.theTextField.nextTextField = self.mobileNumberTextField.theTextField;
    
    
}

-(void)openChangePasswordScreen:(id)sender{
    
    if (self.changePasswordBlock) {
        self.changePasswordBlock();
    }
}

- (UIView *)generateMaleFemaleEntryOptions{
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.mobileNumberTextField.frame.origin.y + self.mobileNumberTextField.frame.size.height+5, self.frame.size.width, 60)];
    [aView setBackgroundColor:[UIColor clearColor]];
    
//    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.femaleButton.tag = 10;
//    [self.femaleButton setBackgroundColor:[UIColor clearColor]];
//    [self.femaleButton setFrame:CGRectMake(70, 15, 30, 30)];
//    if([[self.fyndUser.gender uppercaseString] isEqualToString:@"WOMEN"]){
//        [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
//        [self.female setTextColor:UIColorFromRGB(kGreenColor)];
//        self.femaleSelected = TRUE;
//    }
//    else{
//        [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
//        [self.female setTextColor:UIColorFromRGB(kLightGreyColor)];
//    }
//    [self.femaleButton addTarget:self action:@selector(genderSelected:) forControlEvents:UIControlEventTouchUpInside];
//    [aView addSubview:self.femaleButton];
//    
//    self.female = [SSUtility generateLabel:@"FEMALE" withRect:CGRectMake(self.femaleButton.frame.origin.x+self.femaleButton.frame.size.width, self.femaleButton.frame.origin.y, 80, 30) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
//    [aView addSubview:self.female];
//    
//    
//    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.maleButton.tag = 20;
//    [self.maleButton setBackgroundColor:[UIColor clearColor]];
//    [self.maleButton setFrame:CGRectMake(self.female.frame.origin.x + self.female.frame.size.width +20, 15, 30, 30)];
//    
//    if([[self.fyndUser.gender uppercaseString] isEqualToString:@"MEN"]){
//        [self.maleButton setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
//        [self.male setTextColor:UIColorFromRGB(kGreenColor)];
//        self.maleSelected = TRUE;
//    }else{
//        [self.maleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
//        [self.male setTextColor:UIColorFromRGB(kBackgroundGreyColor)];
//    }
//    
//    [self.maleButton addTarget:self action:@selector(genderSelected:) forControlEvents:UIControlEventTouchUpInside];
//    [aView addSubview:self.maleButton];
//    
//    self.male = [SSUtility generateLabel:@"MALE" withRect:CGRectMake(self.maleButton.frame.origin.x+self.maleButton.frame.size.width, self.maleButton.frame.origin.y, 80, 30) withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
//    [aView addSubview:self.male];
    

    
    
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Regular size:14], NSFontAttributeName,
                                        nil];
    
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          UIColorFromRGB(kLightGreyColor), NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Light size:14], NSFontAttributeName,
                                          nil];
    
   genderSwitch = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, aView.frame.size.width - RelativeSize(2 * buttonMargin, 375), 40)];
    [genderSwitch insertSegmentWithTitle:@"Female" atIndex:0 animated:NO];
    [genderSwitch insertSegmentWithTitle:@"Male" atIndex:1 animated:NO];
    [genderSwitch setCenter:CGPointMake(aView.frame.size.width/2, genderSwitch.frame.size.height/2)];
    //    [genderSwitch addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventValueChanged];
    [genderSwitch setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [genderSwitch setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [genderSwitch addTarget:self action:@selector(genderSelected) forControlEvents:UIControlEventValueChanged];
    //    [genderSwitch setTintColor:UIColorFromRGB(kLightGreyColor)];
    [genderSwitch setTintColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [aView addSubview:genderSwitch];
    
     genderErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderSwitch.frame.origin.x, genderSwitch.frame.origin.y + genderSwitch.frame.size.height + 8, genderSwitch.frame.size.width, 14)];
    [genderErrorLabel setBackgroundColor:[UIColor clearColor]];
    [genderErrorLabel setText:@"Please select Gender"];
    [genderErrorLabel setTextColor:UIColorFromRGB(kRedColor)];
    [genderErrorLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [genderErrorLabel setHidden:TRUE];
    [aView addSubview:genderErrorLabel];
    
    if([[self.fyndUser.gender uppercaseString] isEqualToString:@"MEN"]){
        [genderSwitch setSelectedSegmentIndex:1];
    }else{
        [genderSwitch setSelectedSegmentIndex:0];
    }
    
        return aView;
}

-(void)genderSelected{
    [genderErrorLabel setHidden:TRUE];
    [self dismissKeyboard];
}

-(void)dismissKeyboard{
    if([self.firstNameTextField.theTextField isFirstResponder]){
        [self.firstNameTextField.theTextField resignFirstResponder];
    }else if([self.lastNameTextField.theTextField isFirstResponder]){
        [self.lastNameTextField.theTextField resignFirstResponder];
    }else if([self.emailNumberTextField.theTextField isFirstResponder]){
        [self.emailNumberTextField.theTextField resignFirstResponder];

    }else if([self.mobileNumberTextField.theTextField isFirstResponder]){
        [self.mobileNumberTextField.theTextField resignFirstResponder];
        
    }
}

- (void)genderSelected:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 10){
        self.femaleSelected = !self.femaleSelected;
        
        if(self.femaleSelected){
            [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
            [self.female setTextColor:UIColorFromRGB(kGreenColor)];
            [self.maleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
            [self.male setTextColor:UIColorFromRGB(kLightGreyColor)];
            self.maleSelected = !self.maleSelected;
//            self.fyndUser.gender = @"men";
            
        }else{
            [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
            [self.female setTextColor:UIColorFromRGB(kLightGreyColor)];
            self.fyndUser.gender = nil;
        }
        
    }else{
        self.maleSelected = !self.maleSelected;
        if(self.maleSelected){
            [self.maleButton setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
            [self.male setTextColor:UIColorFromRGB(kGreenColor)];
            [self.femaleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
            [self.female setTextColor:UIColorFromRGB(kLightGreyColor)];
            self.femaleSelected = !self.femaleSelected;
        }else{
            [self.maleButton setBackgroundImage:[UIImage imageNamed:@"filter_unselected"] forState:UIControlStateNormal];
            [self.male setTextColor:UIColorFromRGB(kLightGreyColor)];
            self.fyndUser.gender = nil;
        }
    }
//    self.saveChangesButton.alpha = 1.0f;
//    [self.saveChangesButton setEnabled:TRUE];
   
}

- (void)showGallery:(id)sender{
    if(self.galleryBlock){
        self.galleryBlock();
    }
}

- (void)saveProfileData:(id)sender{
    if([self.firstNameTextField validate] && [self.lastNameTextField validate] && [self.mobileNumberTextField validate] && [self.emailNumberTextField validate]){
        if([self.firstNameTextField.theTextField isFirstResponder]){
            [self.firstNameTextField.theTextField resignFirstResponder];
        }
        if([self.lastNameTextField.theTextField isFirstResponder]){
            [self.lastNameTextField.theTextField resignFirstResponder];
        }
        if([self.mobileNumberTextField.theTextField isFirstResponder]){
            [self.mobileNumberTextField.theTextField resignFirstResponder];
        }
        if([self.emailNumberTextField.theTextField isFirstResponder]){
            [self.emailNumberTextField.theTextField resignFirstResponder];
        }
        [self saveUserData];
    }
}
-(void)cancelEditMode:(id)sender{
    if (self.cancelEditProfileBlock) {
        self.cancelEditProfileBlock();
    }
}


- (void)saveUserData{
    NSDictionary *dict = nil;
    if([self profileNeedToUpdate]){
    
//        [SSUtility showActivityOverlay:self];
        if(editProfileLoader){
            [editProfileLoader removeFromSuperview];
            editProfileLoader = nil;
        }
        editProfileLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [editProfileLoader setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [self addSubview:editProfileLoader];
        [editProfileLoader startAnimating];
        
        if(![self.fyndUser.mobileNumber isEqualToString:[[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject]]){
            dict = [NSDictionary dictionaryWithObjectsAndKeys:[[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject],@"mobile",nil];
            UserAuthenticationHandler *userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
            [userAuthenticationHandler sendOTP:dict withComppletionHandler:^(id responseData, NSError *error) {
                
                if(!error)
                {
//                    [SSUtility dismissActivityOverlay];
                    [editProfileLoader stopAnimating];
                    [editProfileLoader removeFromSuperview];
                    
                    NSDictionary *paramDict  = nil;
                    if(self.captureImage){
                        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:self.fyndUser.firstName,@"first_name",self.fyndUser.lastName,@"last_name",[[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject],@"mobile",nil];
                    }else{
                        paramDict = [NSDictionary dictionaryWithObjectsAndKeys:self.fyndUser.firstName,@"first_name",self.fyndUser.lastName,@"last_name",[[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject],@"mobile",nil];
                    }
//                    if(![[responseData objectForKey:@"mobile_exists"] boolValue] && [[responseData objectForKey:@"otp_sent"] boolValue])
                    if([[responseData objectForKey:@"otp_sent"] boolValue])
                    {
                        self.fyndUser.mobileNumber = [[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject];
                        [SSUtility saveCustomObject:self.fyndUser];
                        self.sendOTPBlock(paramDict);
                    }
                }
            }];
        }
        else{

            /* // M not sure if its required here
            self.fyndUser.emailId = self.emailNumberTextField.theTextField.text;
            [SSUtility saveCustomObject:self.fyndUser];
             */
           
            if(self.captureImage){
                dict = [NSDictionary dictionaryWithObjectsAndKeys:self.fyndUser.firstName,@"first_name",self.fyndUser.lastName,@"last_name",self.fyndUser.emailId,@"email",self.fyndUser.gender,@"gender",self.captureImage,@"profile_pic",nil];
                
                
            }else{
                
                dict = [NSDictionary dictionaryWithObjectsAndKeys:self.fyndUser.firstName,@"first_name",self.fyndUser.lastName,@"last_name",self.fyndUser.emailId,@"email",self.fyndUser.gender,@"gender",nil];
                
            }
            
            if(self.profileHandler == nil){
                self.profileHandler = [[ProfileRequestHandler alloc] init];
            }
            
            [self.profileHandler uploadProfileData:dict withCompletionHandler:^(id responseData, NSError *error) {
                
                if([responseData objectForKey:@"message"]!=nil && [[responseData objectForKey:@"message"] length]>0){
                    self.uploadedImageUrl = [responseData objectForKey:@"profile_pic_url"];
                    [editProfileLoader stopAnimating];
                    [editProfileLoader removeFromSuperview];
                    
                    NSDictionary *profileData = [responseData objectForKey:@"profile"];
                    FyndUser  *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                    user.firstName = [profileData objectForKey:@"first_name"];
                    user.lastName = [profileData objectForKey:@"last_name"];
                    user.mobileNumber = [profileData objectForKey:@"mobile"];
                    user.emailId = [profileData objectForKey:@"email"];
                    user.gender = [profileData objectForKey:@"gender"];
                    user.profilePicUrl = [profileData objectForKey:@"profile_pic_url"];
                    [SSUtility saveCustomObject:user];
                    
                    [self displayUpdateAler:[responseData objectForKey:@"message"]];
                }
                
                else{
                    self.errorInfoView = [[FyndErrorInfoView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-50, self.frame.size.width, 50)];
                    NSString *errorMessage = @"Could not save changes";
                    [editProfileLoader stopAnimating];
                    [editProfileLoader removeFromSuperview];
                    [self.errorInfoView showErrorView:errorMessage withRect:self.frame];
                    __weak EditProfileView *profileView = self;
                    self.errorInfoView.errorAnimationBlock = ^(){
                        if(profileView.errorInfoView){
                            [profileView.errorInfoView removeFromSuperview];
                            profileView.errorInfoView = nil;
                        }
                    };
                }
                
            }];
        
        }
    }else{
        
    }
    
}


- (BOOL)profileNeedToUpdate{
    BOOL isProfileUpdate = FALSE;
    NSString *genderString =nil;
    if ([genderSwitch selectedSegmentIndex] == 0) {
        genderString = @"women";
    }
    if([genderSwitch selectedSegmentIndex] == 1)
        genderString = @"men";
    
    if(![self.fyndUser.firstName isEqualToString:self.firstNameTextField.theTextField.text] ||
       ![self.fyndUser.lastName isEqualToString:self.lastNameTextField.theTextField.text] ||
       ![self.fyndUser.mobileNumber isEqualToString:[[self.mobileNumberTextField.theTextField.text componentsSeparatedByString:@" "] lastObject]] ||
       self.captureImage != nil || ![self.fyndUser.gender isEqualToString:genderString] || ![self.fyndUser.emailId isEqualToString:self.emailNumberTextField.theTextField.text]){
        
         self.fyndUser.firstName = self.firstNameTextField.theTextField.text;
        self.fyndUser.lastName = self.lastNameTextField.theTextField.text;
        self.fyndUser.emailId = self.emailNumberTextField.theTextField.text;
        self.fyndUser.gender = genderString;
        
        isProfileUpdate = TRUE;
    }
    return isProfileUpdate;
}

- (void)displayUpdateAler:(NSString *)statusString{

    /*
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:nil message:statusString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [updateAlert show];
     */
    
    if(self.profileUpdateOverlay == nil)
        self.profileUpdateOverlay = [[PopOverlayHandler alloc] init];
    
    self.profileUpdateOverlay.overlayDelegate = self;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"Profile Update" forKey:@"Alert Title"];
    [parameters setObject:@"OK" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInt:CustomAlertProfileUpdate] forKey:@"PopUpType"];
    [parameters setObject:statusString forKey:@"Alert Message"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
    [self.profileUpdateOverlay presentOverlay:CustomAlertProfileUpdate rootView:self enableAutodismissal:TRUE withUserInfo:parameters];
}



- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
    if(tag==-1){ //If user click on cancel then this will execute
        [self.profileUpdateOverlay dismissOverlay];
        return;
    }
    switch (type) {
        case CustomAlertProfileUpdate:
            [self.profileUpdateOverlay dismissOverlay];
            if(tag == 200){
                
                
                if(self.updateUserImage){
                    self.updateUserImage(self.uploadedImageUrl);
                }
                
                
                /*
                BOOL imageChanged = FALSE;
                if(self.updateUserImage){
                    imageChanged = TRUE;
                }
                if(self.profileUpdateBlock){
                    self.profileUpdateBlock(imageChanged,self.uploadedImageUrl);
                }*/
            }
            break;
            
            default:
            break;
    }
}



#pragma mark UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.editProfileScrollView shouldPositionParallaxHeader];
}


#pragma Mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHide:) name: UIKeyboardWillHideNotification object:nil];
    
}
-(void)deRegisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardShow: (NSNotification *)notif {
    
    NSDictionary* info = [notif userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin = self.activeTextFieldContainer.superview.frame.origin;
    
    CGFloat buttonHeight = self.activeTextFieldContainer.superview.frame.size.height;
    offset = self.editProfileScrollView.contentOffset;

    visibleRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.editProfileScrollView.frame.size.width, (self.frame.size.height));
//    visibleRect.size.height -= keyboardSize.height -50;
        visibleRect.size.height -= keyboardSize.height;
    
    self.editProfileScrollView.frame = visibleRect;
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPt = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.editProfileScrollView setContentOffset:scrollPt animated:YES];
    }
}



-(void) keyboardHide: (NSNotification *)notif {

    self.editProfileScrollView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.editProfileScrollView.frame.size.width, (self.frame.size.height));
    self.editProfileScrollView.contentOffset = offset;
}


- (void)handleTap:(id)sender{
    if([self.firstNameTextField.theTextField isFirstResponder]){
       [self.firstNameTextField.theTextField resignFirstResponder];
    }
    if([self.lastNameTextField.theTextField isFirstResponder]){
      [self.lastNameTextField.theTextField resignFirstResponder];
    }
    if([self.emailNumberTextField.theTextField isFirstResponder]){
        [self.emailNumberTextField.theTextField resignFirstResponder];
    }

    if([self.mobileNumberTextField.theTextField isFirstResponder]){
        [self.mobileNumberTextField.theTextField resignFirstResponder];
    }
    
}

- (void)enableSaveButton:(NSString*)currentValue inputField:(UITextField *)textField{
//    if(![currentValue isEqualToString:textField.text])
    {
//        self.saveChangesButton.alpha = 1.0f;
//        [self.saveChangesButton setEnabled:TRUE];
    }

   
}
-(void)dealloc{
    [self deRegisterForKeyboardNotifications];
}

@end
