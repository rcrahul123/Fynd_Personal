//
//  ShippingAddressDetailViewController.m
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ShippingAddressDetailViewController.h"
#import "TextFieldWithImage.h"
#import "SSLine.h"
#import "LocationSearchViewController.h"
#import "CartRequestHandler.h"

@interface ShippingAddressDetailViewController ()<UITextFieldDelegate>{
    UIView *userInfoView;
    TextFieldWithImage *firstName;
    TextFieldWithImage *lastName;
    TextFieldWithImage *email;
    TextFieldWithImage *mobileNo;
    
    UIView *deliveryAddressView;
    UIImageView *deliveryImageView;
    UILabel *deliveryAddressLabel;
    TextFieldWithImage *flatNBuildingName;
    TextFieldWithImage *streetName;
    TextFieldWithImage *pincode;
    TextFieldWithImage *areaName;
    TextFieldWithImage *stateName;
    UIButton *confirmBtn;
    UIView *bottomButtonsView;
    
    UIView *addresstypeView;
    UILabel *addressType;
   
    CGPoint offset;
    CGFloat contentSizeHeight;
    BOOL isEditing;
    ShippingAddressModel *theModel;
    NSArray *pickerViewData;
     CGRect visibleRect;
    UISegmentedControl *addressTypeSegment;
    CartRequestHandler *theCartHandler;
    LocationSearchViewController *searchViewController;
    UINavigationController *navController;
}
@property (nonatomic,strong) UIScrollView *theDetailScrollView;
@property (nonatomic,strong) UITextField *activeTextField;
@end
CGFloat OriginX = 15.0f;
CGFloat PaddingY = 10.0f;
CGFloat screenWidth = 0.0f;
CGFloat calculatedWidth = 0.0f;

@implementation ShippingAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setHidesBottomBarWhenPushed:TRUE];
    pickerViewData = [NSArray arrayWithObjects:@"Home",@"Office", nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    editAddressLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [editAddressLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [self setBackButton];
}
-(void)setBackButton{
    UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, kBackButtonImageInset, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:TRUE];
}
-(void)viewWillAppear:(BOOL)animated{
    [self registerForKeyboardNotifications];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
    [self dismissKeyboard];
    
    
}
-(void)dismissKeyboard{
    if([firstName.theTextField isFirstResponder]){
        [firstName.theTextField resignFirstResponder];
    }else if([lastName.theTextField isFirstResponder]){
        [lastName.theTextField resignFirstResponder];
    }else if([flatNBuildingName.theTextField isFirstResponder]){
        [flatNBuildingName.theTextField resignFirstResponder];
    }else if([streetName.theTextField isFirstResponder]){
        [streetName.theTextField resignFirstResponder];
    }
}
-(void)configureDetailScreenWithData:(ShippingAddressModel *)theDataArray{

        screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(theDataArray == nil){
        theModel = [[ShippingAddressModel alloc] init];
        [self.navigationItem setTitle:@"Add New Address"];
        isEditing = FALSE;
    }else{
        isEditing = TRUE;
        theModel = theDataArray;
        [self.navigationItem setTitle:@"Edit Address"];
    }
    
    self.theDetailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10,self.view.frame.size.height - 64)];//114
    [self.theDetailScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.theDetailScrollView.layer setCornerRadius:2.0f];
    [self.theDetailScrollView setTag:987];
    [self.theDetailScrollView setScrollEnabled:TRUE];
    [self.theDetailScrollView setShowsVerticalScrollIndicator:FALSE];
    [self.view addSubview:self.theDetailScrollView];
      [self configureAddressType];
    [self configureUserDetails];
    [self configureAddressDetails];
  
    [self configureBottomButtons];
    
    if (isEditing) {
        [self populateScreenUI];
    }
}

-(void)populateScreenUI{
    firstName.theTextField.text = theModel.theFirstName;
    mobileNo.theTextField.text = [NSString stringWithFormat:@"+91 %@",theModel.theMobileNo];
    flatNBuildingName.theTextField.text = theModel.theFlatNBuildingName;
    streetName.theTextField.text = theModel.theStreetName;
    pincode.theTextField.text = theModel.thePincode;
    
    if ([[theModel.theAddressType uppercaseString] isEqualToString:@"OFFICE"]) {
        [addressTypeSegment setSelectedSegmentIndex:1];
    }else{
        [addressTypeSegment setSelectedSegmentIndex:0];
    }
}

-(void)configureAddressType{
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Regular size:14], NSFontAttributeName,
                                        nil];
    
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          UIColorFromRGB(kLightGreyColor), NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Light size:14], NSFontAttributeName,
                                          nil];
    
    addresstypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.theDetailScrollView.frame.size.width, 60)];
    [addresstypeView setBackgroundColor:[UIColor clearColor]];
    
    addressTypeSegment = [[UISegmentedControl alloc] initWithItems:pickerViewData];
    [addressTypeSegment setFrame:CGRectMake(OriginX, 10, self.theDetailScrollView.frame.size.width-2*OriginX,35)];
    [addressTypeSegment setSelectedSegmentIndex:0];
    [addressTypeSegment setTintColor:UIColorFromRGB(kLightGreyColor)];
    [addressTypeSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [addressTypeSegment setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [addresstypeView addSubview:addressTypeSegment];
    
    [self.theDetailScrollView addSubview:addresstypeView];
    
}


-(void)configureUserDetails{
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    __weak ShippingAddressDetailViewController *theWeakSelf = self;
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, addresstypeView.frame.origin.y + addresstypeView.frame.size.height, self.theDetailScrollView.frame.size.width, 120)];//-55
    [userInfoView setBackgroundColor:[UIColor clearColor]];
    
    calculatedWidth = (screenWidth - 45);
    firstName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(OriginX, 10, calculatedWidth, 55) withErrorImage:@"NameError" andSelectedImage:@"NameSelected" andUnSelectedImage:@"Name"];
    [firstName.theTextField setPlaceholder:@"Name"];
    firstName.theMessage = @"Please enter the name.";
    firstName.updateBlock = ^(UITextField *theTextField){
        theWeakSelf.activeTextField = theTextField;
    };
    firstName.textFieldType = TextFieldTypeUserName;
    
    [userInfoView addSubview:firstName];
    
    if(user.firstName || user.lastName){
        NSMutableString *name = [[NSMutableString alloc] init];
        
        if(user.firstName && user.firstName.length > 0){
            [name appendString:user.firstName];
        }
        if(user.lastName && user.lastName.length > 0){
            if(name.length > 0){
                [name appendString:@" "];
            }
            [name appendString:user.lastName];
        }
        firstName.theTextField.text = [NSString stringWithFormat:@"%@", name];
    }

    mobileNo = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(OriginX, firstName.frame.origin.y + firstName.frame.size.height+5 , calculatedWidth, 55) withErrorImage:@"MobileError" andSelectedImage:@"MobileSelected" andUnSelectedImage:@"Mobile"];
    mobileNo.theTextField.keyboardType = UIKeyboardTypeNumberPad;
    [mobileNo.theTextField setPlaceholder:@"Mobile"];
    mobileNo.updateBlock = ^(UITextField *theText){
        theWeakSelf.activeTextField = theText;
    };
    mobileNo.textFieldType = TextFieldTypeMobile;
    [userInfoView addSubview:mobileNo];
    
    if(user.mobileNumber){
        mobileNo.theTextField.text = [NSString stringWithFormat:@"+91 %@", user.mobileNumber];
    }
    
    CGRect userInfoRect = userInfoView.frame;
    userInfoRect.size.height = mobileNo.frame.origin.y + mobileNo.frame.size.height + 10;
    
    userInfoView.frame = userInfoRect;
    
    [self.theDetailScrollView addSubview:userInfoView];
    
    firstName.theTextField.nextTextField = mobileNo.theTextField;
    
}

-(void)configureAddressDetails{
     __weak ShippingAddressDetailViewController *theWeakSelf = self;
    deliveryAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, userInfoView.frame.origin.y + userInfoView.frame.size.height, self.theDetailScrollView.frame.size.width, 160)];
    [deliveryAddressView setBackgroundColor:[UIColor clearColor]];
    
    flatNBuildingName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(OriginX, 10, calculatedWidth, 55) withErrorImage:@"ShippingAddress" andSelectedImage:@"ShippingAddress" andUnSelectedImage:@"ShippingAddress"];
    [flatNBuildingName.theTextField setPlaceholder:@"Flat No & Building Name"];
    [flatNBuildingName setBackgroundColor:[UIColor clearColor]];
    flatNBuildingName.theMessage = @"Please enter the Flat/Building Name.";
    flatNBuildingName.textFieldType = TextFieldTypeAddress;
    flatNBuildingName.updateBlock = ^(UITextField *theText){
        theWeakSelf.activeTextField = theText;
    };

    [deliveryAddressView addSubview:flatNBuildingName];
    
    streetName = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(OriginX, flatNBuildingName.frame.origin.y + flatNBuildingName.frame.size.height, calculatedWidth, 55) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    [streetName.theTextField setPlaceholder:@"Street & Locality"];
    streetName.theMessage = @"Please enter the Street/Locality Name.";
    [streetName setBackgroundColor:[UIColor clearColor]];
    streetName.textFieldType = TextFieldTypeAddress;
    streetName.updateBlock = ^(UITextField *theText){
        theWeakSelf.activeTextField = theText;
    };

    [deliveryAddressView addSubview:streetName];
    
    pincode = [[TextFieldWithImage alloc] initWithFrame:CGRectMake(OriginX, streetName.frame.origin.y + streetName.frame.size.height , calculatedWidth, 55) withErrorImage:nil andSelectedImage:nil andUnSelectedImage:nil];
    [pincode.theTextField setPlaceholder:@"Pincode"];
    [pincode setBackgroundColor:[UIColor clearColor]];
    pincode.updateBlock = ^(UITextField *textField){
//        theWeakSelf.activeTextField = textField;
        [theWeakSelf showPincodePopUp];
    };

    pincode.textFieldType = TextFieldTypePinCode;

    pincode.callBackBlock = ^(){
        [theWeakSelf saveChanges:nil];
    };

    [deliveryAddressView addSubview:pincode];
    
    
    CGRect deliveryAddressViewRect = deliveryAddressView.frame;
    deliveryAddressViewRect.size.height = pincode.frame.origin.y + pincode.frame.size.height + 10;
    
    deliveryAddressView.frame = deliveryAddressViewRect;
    
    [self.theDetailScrollView addSubview:deliveryAddressView];
    
    mobileNo.theTextField.nextTextField = flatNBuildingName.theTextField;
    flatNBuildingName.theTextField.nextTextField = streetName.theTextField;
//    streetName.theTextField.nextTextField = pincode.theTextField;
}

-(void)showPincodePopUp{

    if([firstName.theTextField isFirstResponder]){
        [firstName.theTextField resignFirstResponder];
    }
    if([mobileNo.theTextField isFirstResponder]){
        [mobileNo.theTextField resignFirstResponder];
    }
    if([flatNBuildingName.theTextField isFirstResponder]){
        [flatNBuildingName.theTextField resignFirstResponder];
    }
    if([streetName.theTextField isFirstResponder]){
        [streetName.theTextField resignFirstResponder];
    }
        if(searchViewController){
            searchViewController.delegate = nil;
            searchViewController = nil;
        }
        
        searchViewController = [[LocationSearchViewController alloc] init];
        searchViewController.isPincodeView = TRUE;
        searchViewController.delegate = self;
//        navController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
//        
//        [self presentViewController:navController
//                           animated:YES
//                         completion:^{
//                             
//                         }];

        [self presentViewController:searchViewController animated:YES completion:nil];

    
    

}

- (void)configureBottomButtons{
    bottomButtonsView = [[UIView alloc] initWithFrame:CGRectMake(0, deliveryAddressView.frame.origin.y + deliveryAddressView.frame.size.height+10, self.theDetailScrollView.frame.size.width,50)];
    [bottomButtonsView setUserInteractionEnabled:TRUE];
    [bottomButtonsView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat buttonWidth = (bottomButtonsView.frame.size.width - (2*(RelativeSize(10, 320)) - 10))/2-10;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn.layer setCornerRadius:3.0];
    [cancelBtn setClipsToBounds:YES];
    [cancelBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D4D5)] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];

    [cancelBtn setFrame:CGRectMake(RelativeSize(10, 320), 5,buttonWidth, 40)];
    [cancelBtn setTitleColor:UIColorFromRGB(kGenderSelectorTintColor) forState:UIControlStateNormal];
    if (isEditing) {
        [cancelBtn setTitle:@"REMOVE" forState:UIControlStateNormal];
    }else{
        [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    }
    

    [cancelBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [cancelBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonsView addSubview:cancelBtn];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn.layer setCornerRadius:3.0];
    [confirmBtn setClipsToBounds:YES];
    
    [confirmBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [confirmBtn setFrame:CGRectMake(cancelBtn.frame.origin.x + cancelBtn.frame.size.width +10, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
    if (isEditing) {
        [confirmBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
    }else{
        [confirmBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    }

    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [confirmBtn addTarget:self action:@selector(saveChanges:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButtonsView addSubview:confirmBtn];
    
    [self.theDetailScrollView addSubview:bottomButtonsView];
    [self.theDetailScrollView setContentSize:CGSizeMake(self.theDetailScrollView.frame.size.width, bottomButtonsView.frame.size.height + bottomButtonsView.frame.origin.y + 20)];
    contentSizeHeight = self.theDetailScrollView.contentSize.height;
}

#pragma mark - Button Action Buttons

-(void)dismissView:(id)sender{
    if (isEditing) {
        [self deleteTheAddressWithAddressId:theModel.theAddressID];
    }else{
        [self.navigationController popViewControllerAnimated:TRUE];
    }

}

-(void)deleteTheAddressWithAddressId:(NSString *)addressID{
    
    //    [SSUtility showActivityOverlay:self.view];
    [self.view addSubview:editAddressLoader];
    [editAddressLoader startAnimating];
    
    if(theCartHandler == nil)
        theCartHandler = [[CartRequestHandler alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:addressID forKey:@"address_id"];
    
    [theCartHandler deleteShippingAdress:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        if (responseData) {
            if([[responseData valueForKey:@"is_deleted"] boolValue]){
                if (self.theDeleteBlock) {
                    self.theDeleteBlock(theModel);
                }
            }else{
                if (self.theDeleteBlock) {
                    self.theDeleteBlock(nil);
                }
            }
            
        }else{
            if (self.theDeleteBlock) {
                self.theDeleteBlock(nil);
            }
        }
        
        [self.navigationController popViewControllerAnimated:TRUE];
        [editAddressLoader removeFromSuperview];
        [editAddressLoader stopAnimating];
    }];
}

-(void)saveChanges:(id)sender{

    if ([firstName validate] && [mobileNo validate] && [flatNBuildingName validate] && [streetName validate] && [pincode validate]) {
        
        if ([firstName.theTextField isFirstResponder]) {
            [firstName.theTextField resignFirstResponder];
        }else if ([mobileNo.theTextField isFirstResponder]){
            [mobileNo.theTextField resignFirstResponder];
        }else if ([flatNBuildingName.theTextField isFirstResponder]){
            [flatNBuildingName.theTextField resignFirstResponder];
        }else if ([streetName.theTextField isFirstResponder]){
            [streetName.theTextField resignFirstResponder];
        }
        
        [self.view addSubview:editAddressLoader];
        [editAddressLoader startAnimating];
    
    theModel.theFirstName = firstName.theTextField.text;
    theModel.theMobileNo = [[mobileNo.theTextField.text componentsSeparatedByString:@" "] lastObject];
    theModel.theFlatNBuildingName = flatNBuildingName.theTextField.text;
    theModel.theStreetName = streetName.theTextField.text;
    theModel.thePincode = pincode.theTextField.text;
    if (addressTypeSegment.selectedSegmentIndex == 0) {
        theModel.theAddressType =@"home";
    }else{
        theModel.theAddressType =@"office";
    }
    NSString *isDefaultString = theModel.isDefaultAddress ? @"true":@"false";
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:theModel.theFirstName forKey:@"name"];
    [paramsDic setObject:theModel.theFlatNBuildingName forKey:@"address"];
    [paramsDic setObject:theModel.theStreetName forKey:@"area"];
    [paramsDic setObject:theModel.theMobileNo forKey:@"phone"];
    [paramsDic setObject:theModel.thePincode forKey:@"pincode"];
    [paramsDic setObject:isDefaultString forKey:@"is_default_address"];
    [paramsDic setObject:theModel.theAddressType forKey:@"address_type"];
    
    __weak ShippingAddressDetailViewController *weakSelf = self;
    __weak ShippingAddressModel *theWeakModel = theModel;
    __weak FyndActivityIndicator *weakLoader = editAddressLoader;
    if (theCartHandler == nil) {
        theCartHandler = [[CartRequestHandler alloc] init];
    }
    
    if (isEditing) {
        [paramsDic setObject:theModel.theAddressID forKey:@"address_id"];
        [theCartHandler updateShippingAdress:paramsDic withCompletionHandler:^(id responseData, NSError *error) {
            if (!error) {
                if ([responseData[@"is_updated"] boolValue]) {
                    
                    NSString *theAddressID = [NSString stringWithFormat:@"%@",responseData[@"address_id"]];
                    BOOL isDefaultAdd = [responseData[@"is_default_address"] boolValue];
                    theWeakModel.theAddressID = theAddressID;
                    theWeakModel.isDefaultAddress = isDefaultAdd;
                    
                    if (weakSelf.theSaveBlock) {
                        weakSelf.theSaveBlock(theWeakModel,TRUE);
                    }
                }

            }else{
                if (weakSelf.theSaveBlock) {
                    weakSelf.theSaveBlock(nil,TRUE);
                }
            }
            [editAddressLoader stopAnimating];
            [editAddressLoader removeFromSuperview];
            
            [weakSelf.navigationController popViewControllerAnimated:TRUE];

        }];
    }else{
        if(self.isComingFromCart){
            
            [self.view addSubview:editAddressLoader];
            [editAddressLoader startAnimating];
            
            [paramsDic setObject:@"true" forKey:@"validate"];
            [theCartHandler addShippingAdress:paramsDic withCompletionHandler:^(id responseData, NSError *error) {
                [weakLoader stopAnimating];
                [weakLoader removeFromSuperview];
                if (!error) {
                    if(responseData){
                        BOOL isCartValid = [responseData[@"is_valid"] boolValue];
                        if(isCartValid){
                            CartData *cartData = [[CartData alloc] initWithDictionary:responseData];
                            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(newAddressAdded:)]){
                                [weakSelf.delegate newAddressAdded:cartData];
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }else{
                            NSString *errorMessage = responseData[@"message"];
                            if(errorMessage && errorMessage.length > 0){
                                [SSUtility showOverlayViewWithMessage:errorMessage andColor:UIColorFromRGB(kRedColor)];
                            }else{
                                [weakSelf showErrorView:@"Some items not deliverable to this address"];
                            }
                        }
                    }else{
                        [weakSelf showErrorView:@"Some items not deliverable to this address"];
                        
                    }
                }
            }];
        }else{
            [theCartHandler addShippingAdress:paramsDic withCompletionHandler:^(id responseData, NSError *error) {
                if (!error) {
                    
                    NSString *theAddressID = [NSString stringWithFormat:@"%@",responseData[@"address_id"]];
                    BOOL isDefaultAdd = [responseData[@"is_default_address"] boolValue];
                    theWeakModel.theAddressID = theAddressID;
                    theWeakModel.isDefaultAddress = isDefaultAdd;
                    
                    if (weakSelf.theSaveBlock) {
                        weakSelf.theSaveBlock(theWeakModel,FALSE);
                    }
                }else{
                    if (weakSelf.theSaveBlock) {
                        weakSelf.theSaveBlock(nil,FALSE);
                    }
                }
                [weakLoader stopAnimating];
                [weakLoader removeFromSuperview];                
                [weakSelf.navigationController popViewControllerAnimated:TRUE];
                
            }];
        }
    }
    
  }
}


-(void)showErrorView:(NSString *)errorMessage{
    if(self.errorView){
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    __weak ShippingAddressDetailViewController *weakSelf = self;

    self.errorView = [[FyndErrorInfoView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-64, self.view.frame.size.width, 64)];
    [self.errorView showErrorView:errorMessage withRect:self.view.frame];
    
    self.errorView.errorAnimationBlock = ^(){
        if(weakSelf.errorView){
            [weakSelf.errorView removeFromSuperview];
            weakSelf.errorView = nil;
        }
    };
}


#pragma mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notif {
    
     NSDictionary* info = [notif userInfo];
     CGRect keyPadFrame=[[UIApplication sharedApplication].keyWindow convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:self.view];
//     CGSize kbSize =keyPadFrame.size;
//     CGRect activeRect=[self.view convertRect:_activeTextField.superview.superview.frame fromView:self.theDetailScrollView];
//     CGRect aRect = self.view.bounds;
//     aRect.size.height -= (kbSize.height);
//    offset = self.theDetailScrollView.contentOffset;
//     CGPoint origin = activeRect.origin;
//     origin.y -= self.theDetailScrollView.contentOffset.y;
//    self.theDetailScrollView.frame = aRect;
//    if (!CGRectContainsPoint(aRect, origin)) {
//         CGPoint scrollPoint = CGPointMake(0.0,CGRectGetMaxY(activeRect)-(aRect.size.height));
//         [self.theDetailScrollView setContentOffset:scrollPoint animated:YES];
//     }
    
  
    CGPoint scrollPoint = CGPointMake(0, _activeTextField.superview.superview.frame.origin.y);
    [self.theDetailScrollView setContentOffset:scrollPoint animated:YES];
    
    [self.theDetailScrollView setContentSize:CGSizeMake(self.theDetailScrollView.contentSize.width, bottomButtonsView.frame.origin.y + bottomButtonsView.frame.size.height + keyPadFrame.size.height +20)];
    
}

-(void) keyboardWillHide: (NSNotification *)notif {
    self.theDetailScrollView.frame = CGRectMake(5, 5, self.theDetailScrollView.frame.size.width, (self.view.frame.size.height));
    self.theDetailScrollView.contentOffset = offset;
    
}
-(void)didSelectLocation{
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *thePinCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pincode"]];
        pincode.theTextField.text =thePinCode;
    }];
}

@end
