 //
//  MyAccountDetailViewController.m
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyAccountDetailViewController.h"
#import "EditProfileView.h"
#import "CouponsView.h"
#import "ProfileRequestHandler.h"
#import "NotificationSettings.h"
#import "FreeShipping.h"
#import "TermsOfService.h"

#import "ShippingAddressDetailViewController.h"
#import "ShippingAddressModel.h"
#import "FAQView.h"
#import "PaymentOption.h"
#import "SendOTPViewController.h"   
#import "VerifyOTPViewController.h"
#import "UINavigationBar+Transparency.h"

@interface MyAccountDetailViewController ()
- (void)configureEditProfileView;
//- (void)configureMyBrandView;
//- (void)configureMyCollectionView;
- (void)configureCouponView:(NSArray*)couponDataArray;
- (void)configureNotificationView;
- (void)configureFreeShipping:(NSDictionary *)dict;
- (void)configureTermsOfService;

@property (nonatomic,strong) ProfileRequestHandler *profileHandler;
@property (nonatomic,strong) EditProfileView        *editProfile;
@end

@implementation MyAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.detailTitle;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.automaticallyAdjustsScrollViewInsets = NO; //removing to get the parllax effect on Edit Profile
    
    
    [self populateAppropirateView];
    [self setBackButton];
}

-(BOOL)prefersStatusBarHidden{
    return false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

}


-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}


-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (void)populateAppropirateView{
    switch (self.type) {
        case AccountDetailEditProfile:
            [self configureEditProfileView];
            break;
        case AccountDetailMyBrands:
//            [self configureMyBrandView];
            break;
        case AccountDetailMyCollections:

            break;
        case AccountDetailMyCoupons:
        {
            self.profileHandler = [[ProfileRequestHandler alloc] init];
            [self.profileHandler fetchCouponData:nil withCompletionHandler:^(id responseData, NSError *error)
             {
                 [self configureCouponView:responseData];
             }];
            
        }
            break;
            
        case AccountDetailNotificationSettings:
            [self configureNotificationView];
            break;
        case AccountDetailFreeShopping:
        {
            if(self.profileHandler == nil){
                self.profileHandler = [[ProfileRequestHandler alloc] init];
            }
            [self.profileHandler fetchFreeShipping:nil withCompletionHandler:^(id responseData, NSError *error){
                [self configureFreeShipping:responseData];
            }];
        }
            break;
        case AccountDetailPaymentInformation:
            [self configurePaymentInformation];
            break;
        case AccountDetailFAQ:
            [self configureTermsOfService];
            break;
        case AccountDetailCallUS:
            
            break;
        case AccountDetailRateUS:
            
            break;
        case AccountDetailTermsOfService:
            [self configureTermsOfService];
            break;
      
        case AccountDetailPrivacyPolicy:
            [self configureTermsOfService];
            
            break;
        case AccountDetailChangePassword:
            
            break;
        case AccountDetailReturnPolicy:
            [self configureTermsOfService];
            break;
        default:
            break;
    }
}
#pragma Mark - Configure Methods

- (void)configureEditProfileView{
    self.editProfile = [[EditProfileView alloc] initWithFrame:self.view.frame];

    [self.editProfile configureEditProfile];
    [self.editProfile setBackgroundColor:[UIColor whiteColor]];
    __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    __weak UIImagePickerController *weakSelf1 = picker;

    __weak MyAccountDetailViewController *weakSelf = self;
    self.editProfile.galleryBlock = ^(){
        
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [weakSelf presentViewController:weakSelf1 animated:YES completion:NULL];
    };


    self.editProfile.sendOTPBlock = ^(NSDictionary *dict){

        UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyOTPViewController *verifyController = (VerifyOTPViewController *)[storyboard instantiateViewControllerWithIdentifier:@"VerifyOTPViewController"];

        verifyController.updateProfileDictData  = dict;
        verifyController.userModel  = [SSUtility loadUserObjectWithKey:kFyndUserKey];
        verifyController.mobileNumber = [dict objectForKey:@"mobile"];
        verifyController.sourceOption = OTPNavigatedFromEditProfile;
        [weakSelf.navigationController pushViewController:verifyController animated:TRUE];

    };
    
    self.editProfile.cancelEditProfileBlock = ^(){
        [weakSelf.navigationController popViewControllerAnimated:TRUE];
    };
    
    
        __weak MyAccountDetailViewController *detaiController = self;
    
    self.editProfile.changePasswordBlock = ^(){
        UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SendOTPViewController *theSendOTP = (SendOTPViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SendOTPViewController"];
        
        theSendOTP.mobileNumber = [(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] mobileNumber];
        theSendOTP.sourceOption = OTPNavigatedFromChangePassword;
        //        theSendOTP.changePassword = TRUE;
        
        [detaiController.navigationController pushViewController:theSendOTP animated:FALSE];

    };
    
    

    
    
    // Commented on 6 Oct
    self.editProfile.updateUserImage= ^(NSString *str){
        if(detaiController.refreshUserImage){
            
             // Commented on 6 Oct
            detaiController.refreshUserImage(str);
     
            
//            if([detaiController.profileDetailDelegate respondsToSelector:@selector(fetchUpdatedData)]){
//                [detaiController.profileDetailDelegate fetchUpdatedData];
//            }
            
            [weakSelf.navigationController popViewControllerAnimated:TRUE];
        }
    };
     
    
    /*
    self.editProfile.profileUpdateBlock = ^(BOOL imageUpdate,NSString *imageString){
        
        if([detaiController.profileDetailDelegate respondsToSelector:@selector(fetchUpdatedData:andProfileString:)]){
            [detaiController.profileDetailDelegate fetchUpdatedData:imageUpdate andProfileString:imageString];
        }
        
        [weakSelf.navigationController popViewControllerAnimated:TRUE];
    };
    */
    
    [self.view addSubview:self.editProfile];
}


#pragma mark UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSData* jpgdata = UIImageJPEGRepresentation (chosenImage,1.0);
    UIImage* img = [UIImage imageWithData:jpgdata];
     [self.editProfile updateProfileImage:img];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.editProfile updateCaptureImage:nil];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}


- (void)configureCouponView:(NSArray*)couponDataArray{
    CouponsView *couponView = [[CouponsView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-10, self.view.frame.size.height-10) andCouponData:couponDataArray];
    [couponView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:couponView];
}

- (void)configureNotificationView{
    NotificationSettings *notification = [[NotificationSettings alloc] initWithFrame:self.view.frame];
    [self.view addSubview:notification];
}

-(void)configureFAQ{
    FAQView *theFAQView = [[FAQView alloc] initWithFrame:self.view.frame dataDictionary:nil];
    [self.view addSubview:theFAQView];
}
- (void)configureFreeShipping:(NSDictionary *)dict{
    FreeShipping *freeShipping = [[FreeShipping alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    freeShipping.shippingDataDict = dict;
    [freeShipping configureFreeShipping];
    [self.view addSubview:freeShipping];
}


- (void)configureTermsOfService{
//    TermsOfService *termsView = [[TermsOfService alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    TermsOfService *termsView = [[TermsOfService alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];

    [termsView setBackgroundColor:[UIColor whiteColor]];
    //http://www.obcuro-staging.gofynd.com/web/
    
    
//    http://obscuro-staging.gofynd.com/web/faqs.html?mobile_app=true
    
    if (self.type == AccountDetailReturnPolicy) {
        termsView.urlString = @"http://www.gofynd.com/faqs.html?mobile_app=true#returns_n_exchange";
        termsView.titleValue = @"Return Policy";
    }else if (self.type == AccountDetailTermsOfService){
        termsView.urlString = @"http://www.gofynd.com/terms.html?mobile_app=true";
    }else if (self.type == AccountDetailPrivacyPolicy){
        termsView.urlString = @"http://www.gofynd.com/privacy.html?mobile_app=true";
    }else if (self.type == AccountDetailFAQ){
        termsView.urlString = @"http://www.gofynd.com/faqs.html?mobile_app=true";
    }
    [termsView setUpTermsOfServiceView];
    [self.view addSubview:termsView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurePaymentInformation{
    PaymentOption *thePaymentView = [[PaymentOption alloc] initWithFrame:self.view.frame dataDictionary:nil];
    [self.view addSubview:thePaymentView];
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
