//
//  LocationSearchViewController.m
//  
//
//  Created by Rahul on 6/30/15.
//
//

#import "LocationSearchViewController.h"


@implementation SearchItemModel

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if(self){
        self.displayName =dictionary[@"name"];
        self.itemType = dictionary[@"pincode"];
        self.itemValue = dictionary[@"value"];
        self.latitude = dictionary[@"latitude"];
        self.longitude = dictionary[@"longitude"];
        self.dataID = dictionary[@"id"];
        self.city = dictionary[@"city"];
    }
    return self;
}

@end

@interface LocationSearchViewController (){
    UIActivityIndicatorView *theSearchIndicator;
    BOOL isDataLoaded;
}

@end
CGFloat keyBoardHeight = 0;
@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setHidesBackButton:YES];
    
//    [self setupLocationSearch];

    locationSearchLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [locationSearchLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    requestHandler = [[SSBaseRequestHandler alloc] init];

//    if (!self.isPincodeView) {
//        autoDetectView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, self.view.frame.size.width, 50)];
//        [autoDetectView setBackgroundColor:[UIColor clearColor]];
//        autoDetectView.clipsToBounds = YES;
//
//        [self.view addSubview:autoDetectView];
//    
//        hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, autoDetectView.frame.size.width, autoDetectView.frame.size.height)];
//        [hiddenButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
//        [hiddenButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
//        [hiddenButton addTarget:self action:@selector(detectMyLocation) forControlEvents:UIControlEventTouchUpInside];
//        [autoDetectView addSubview:hiddenButton];
//        
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Auto-detect My Location" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14]}];
//        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(autoDetectView.frame.size.width/2 - rect.size.width/2, autoDetectView.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height)];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setAttributedText:str];
//        [autoDetectView addSubview:label];
//        
//        UIImage *image = [UIImage imageNamed:@"AutoDetect"];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x - image.size.width - 15, autoDetectView.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
//        [imageView setImage: image];
//        [autoDetectView addSubview:imageView];
//    }
    
//    UIView *headearView = [self tableHeaderView];
//    if(!_isPincodeView){
//        suggestionListView = [[UITableView alloc] initWithFrame:CGRectMake(autoDetectView.frame.origin.x, autoDetectView.frame.origin.y + autoDetectView.frame.size.height, autoDetectView.frame.size.width, self.view.frame.size.height - (autoDetectView.frame.origin.y + autoDetectView.frame.size.height))];
//    }else{
//        suggestionListView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height))];
//    }
//
//    suggestionListView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    suggestionListView.delegate = self;
//    suggestionListView.dataSource = self;
//    [suggestionListView setTableHeaderView:headearView];
//    [self.view addSubview:suggestionListView];
//    
//    [suggestionListView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [suggestionListView setSeparatorColor:UIColorFromRGB(KTextFieldBorderColor)];
//    [suggestionListView setBackgroundColor:[UIColor clearColor]];
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    if (_isPincodeView) {
        [urlString appendString:@"get-pincodes/?"];
    }else{
        [urlString appendString:@"get-location/?"];
    }

    searchURL =[NSString stringWithFormat:@"%@",urlString];

    [self deRegisterForKeyboardNotifications];
    if(!_isPincodeView){
        if(dataTask){
            [dataTask cancel];
        }
//        [self.view addSubview:locationSearchLoader];
//        [locationSearchLoader startAnimating];

        [self getLocationsForString:@""];
        [dataTask resume];
    }
}


#pragma Mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHide:) name: UIKeyboardDidHideNotification object:nil];
}

-(void)deRegisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification {
    keyBoardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if(!self.isPincodeView){
        [suggestionListView setFrame:CGRectMake(suggestionListView.frame.origin.x, suggestionListView.frame.origin.y , suggestionListView.frame.size.width, self.view.frame.size.height - (autoDetectView.frame.origin.y + autoDetectView.frame.size.height) - keyBoardHeight)];
        
    }else{
    [suggestionListView setFrame:CGRectMake(suggestionListView.frame.origin.x, suggestionListView.frame.origin.y , suggestionListView.frame.size.width, self.view.frame.size.height - (searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height) - keyBoardHeight)];
    }

    
}

-(void)keyboardHide:(NSNotification *)notification {
    keyBoardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [suggestionListView setFrame:CGRectMake(suggestionListView.frame.origin.x, suggestionListView.frame.origin.y , suggestionListView.frame.size.width, self.view.frame.size.height - (autoDetectView.frame.origin.y + autoDetectView.frame.size.height))];

    [self showAutoDetectTab:YES];
}


#pragma mark - location methods

-(void)detectMyLocation{
   
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = 600;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
        } else {
            [self.view.window addSubview:locationSearchLoader];
            [locationSearchLoader startAnimating];
            
            [locationManager startUpdatingLocation];
        }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        }
            break;
            
        case kCLAuthorizationStatusDenied: {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                           message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                          delegate:self
                                                 cancelButtonTitle:@"Settings"
                                                 otherButtonTitles:@"Select Manually", nil];
                locationAlert.tag = 1;
            }else{
                locationAlert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                           message:@"Please go to Settings and turn on Location Service for Fynd or Select location manually."
                                                          delegate:self
                                                 cancelButtonTitle:@"Select Manually"
                                                 otherButtonTitles:nil];
                locationAlert.tag = 2;
                
            }
            [locationAlert show];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            [self.view.window addSubview:locationSearchLoader];
            [locationSearchLoader startAnimating];
            [locationManager startUpdatingLocation];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.view.window addSubview:locationSearchLoader];
            [locationSearchLoader startAnimating];
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
            break;
            
        default:
            break;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    
    
    location = [locations objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];

        if([SSUtility checkIfUserInAllowedCities:[placemark.locality lowercaseString]]){

            if([userDefaults objectForKey:@"city"] && user.isOnboarded){
                if(!self.isPincodeView)
                    [FyndAnalytics trackLocationChange:[placemark.locality lowercaseString] locationAccessMethod:@"auto" prevLocation:[userDefaults objectForKey:@"city"]];
            }
            
            [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
            [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
            [userDefaults setObject:[NSString stringWithFormat:@"%@, %@", [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0], [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:1]] forKey:@"city"];
            
            [userDefaults setObject:[placemark.locality lowercaseString] forKey:@"city"];
            
            if(!self.isPincodeView){
                    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                if(!user.isOnboarded){
                    [userDefaults setObject:@"auto" forKey:@"onboardingAccessType"];
                    [userDefaults setObject:[placemark.locality lowercaseString] forKey:@"onboardingLocation"];

                }
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectLocation)]){
                [locationSearchLoader stopAnimating];
                [locationSearchLoader removeFromSuperview];

                [self.delegate didSelectLocation];
            }
        }else{
            [locationSearchLoader stopAnimating];
            [locationSearchLoader removeFromSuperview];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [locationSearchLoader stopAnimating];
    [locationSearchLoader removeFromSuperview];
    
    [manager stopUpdatingLocation];

    locationManager.delegate = nil;
    locationManager = nil;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Auto-detect Location" message:@"Could not detect your location. Please select your location manually." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if(alertView.tag ==3){
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
        if(alertView.tag == 2){
        }else{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }else{
        
    }
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    [self setupLocationSearch];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:TRUE];
    
}
-(void)setupLocationSearch{
    
//    if(!self.isPincodeView){
//        magnifierImage = [UIImage imageNamed:@"SearchBrowse"];
//    UIButton *searchImage = [[UIButton alloc] initWithFrame:CGRectMake(10, 6.5, 30, 30)];
//    [searchImage setBackgroundImage:magnifierImage forState:UIControlStateNormal];
//    [searchImage addTarget:self action:@selector(enableSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [searchImage setHidden:FALSE];
//    [self.navigationController.navigationBar addSubview:searchImage];
//    
//    
//    //Adding the Placeholder
//    UIButton *searchPlaceholder = [[UIButton alloc] initWithFrame:CGRectMake(searchImage.frame.size.width + searchImage.frame.origin.x+10, self.navigationController.navigationBar.frame.size.height/2 - 14.5, 200, 25)];
//    if(!self.isPincodeView){
//        [searchPlaceholder setTitle:@"Search by Pincode or Area" forState:UIControlStateNormal];
//
//    }else{
//        [searchPlaceholder setTitle:@"Search by Pincode" forState:UIControlStateNormal];
//
//    }
//    [searchPlaceholder setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
//    [searchPlaceholder addTarget:self action:@selector(enableSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [searchPlaceholder setHidden:FALSE];
//    [searchPlaceholder.titleLabel setFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
//    searchPlaceholder.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self.navigationController.navigationBar addSubview:searchPlaceholder];
//
//
//    if(!_isPincodeView){
//        pincodeSearchBar.returnKeyType = UIReturnKeyDefault;
//        pincodeSearchBar.autocorrectionType = UITextAutocapitalizationTypeNone;
//    }else{
//        
//        [pincodeSearchBar setKeyboardType:UIKeyboardTypeDecimalPad];
//        [pincodeSearchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
//    }
//    
//    [pincodeSearchBar setDelegate:self];
//    [pincodeSearchBar setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
//    [pincodeSearchBar setTintColor:UIColorFromRGB(kDarkPurpleColor)];
//    [self.navigationController.navigationBar addSubview:pincodeSearchBar];
//    
//    
//    if(!self.shouldHideCancel){
//
//        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - 40, self.navigationController.navigationBar.frame.size.height/2 - 16, 32, 32)];
//        [cancelButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(dismissLocationSearch) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.navigationBar addSubview:cancelButton];
//    }
//    
//    }else{
//        [self enableSearch:nil];
//    }
    
    [self addSearchBar];
    
    
    
    
    if (!self.isPincodeView) {
        autoDetectView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, self.view.frame.size.width, 50)];
        [autoDetectView setBackgroundColor:[UIColor clearColor]];
        autoDetectView.clipsToBounds = YES;
        
        [self.view addSubview:autoDetectView];
        
        hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, autoDetectView.frame.size.width, autoDetectView.frame.size.height)];
        [hiddenButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
        [hiddenButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
        [hiddenButton addTarget:self action:@selector(detectMyLocation) forControlEvents:UIControlEventTouchUpInside];
        [autoDetectView addSubview:hiddenButton];
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Auto-detect My Location" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14]}];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(autoDetectView.frame.size.width/2 - rect.size.width/2, autoDetectView.frame.size.height/2 - rect.size.height/2, rect.size.width, rect.size.height)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setAttributedText:str];
        [autoDetectView addSubview:label];
        
        UIImage *image = [UIImage imageNamed:@"AutoDetect"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x - image.size.width - 15, autoDetectView.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
        [imageView setImage: image];
        [autoDetectView addSubview:imageView];
    }else{
//        [pincodeSearchBar becomeFirstResponder];
        [pincodeSearchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
    }
    
    
    
    //
    UIView *headearView = [self tableHeaderView];
    if(!_isPincodeView){
        suggestionListView = [[UITableView alloc] initWithFrame:CGRectMake(autoDetectView.frame.origin.x, autoDetectView.frame.origin.y + autoDetectView.frame.size.height, autoDetectView.frame.size.width, self.view.frame.size.height - (autoDetectView.frame.origin.y + autoDetectView.frame.size.height))];
    }else{
        suggestionListView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height))];
    }
    
    suggestionListView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    suggestionListView.delegate = self;
    suggestionListView.dataSource = self;
    [suggestionListView setTableHeaderView:headearView];
    [self.view addSubview:suggestionListView];
    
        //Adding activity Indicator
    
//    theSearchIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-12, 80, 24, 24)];
//    theSearchIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    theSearchIndicator.hidesWhenStopped = TRUE;
//    if (_isPincodeView){
//        [self.view addSubview:theSearchIndicator];
//    }else{
    
    
//    }
    
    [suggestionListView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [suggestionListView setSeparatorColor:UIColorFromRGB(KTextFieldBorderColor)];


    //
    
    
    
    
    if(_isPincodeView){
        if(blankPincodeView){
            [blankPincodeView removeFromSuperview];
            blankPincodeView = nil;
        }
        
        UIImage *image = [UIImage imageNamed:@"EmptyPincode"];
        blankPincodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0,searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height, image.size.width, image.size.height)];
        blankPincodeView.image = image;
        [blankPincodeView setCenter:CGPointMake(self.view.frame.size.width/2, RelativeSizeHeight(200, 667 - (searchBarContainerView.frame.origin.y + searchBarContainerView.frame.size.height-64)))];
        [self.view addSubview:blankPincodeView];
    }else{
        if (!isDataLoaded) {
            [self.view addSubview:locationSearchLoader];
            [locationSearchLoader startAnimating];
        }
    }
    
}


-(void)addSearchBar{
    searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
//    [self.navigationController.navigationBar addSubview:searchBarContainerView];
    [searchBarContainerView setAlpha:1.0];


    pincodeSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBarContainerView.frame.size.width , 44)];
    pincodeSearchBar.delegate = self;
    [pincodeSearchBar setUserInteractionEnabled:YES];
    if(self.isPincodeView){
//        [pincodeSearchBar becomeFirstResponder];
    }
    [searchBarContainerView addSubview:pincodeSearchBar];
    [self.view addSubview:searchBarContainerView];
    
    if(!_isPincodeView){
        pincodeSearchBar.returnKeyType = UIReturnKeyDefault;
        pincodeSearchBar.autocorrectionType = UITextAutocapitalizationTypeNone;
    }else{
        
        [pincodeSearchBar setKeyboardType:UIKeyboardTypeDecimalPad];
        [pincodeSearchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    
//    [pincodeSearchBar setDelegate:self];
    [pincodeSearchBar setTintColor:UIColorFromRGB(kButtonPurpleColor)];
    
    if(!self.isPincodeView){
        placeholderString = @"Search by Pincode or Area";
//        [searchPlaceholder setTitle:@"Search by Pincode or Area" forState:UIControlStateNormal];
        
    }else{
        placeholderString = @"Search by Pincode";
//        [searchPlaceholder setTitle:@"Search by Pincode" forState:UIControlStateNormal];
    }

    pincodeSearchBar.placeholder = placeholderString;

    for ( UIView * subview in [[[pincodeSearchBar subviews] firstObject] subviews])
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] ){
            subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] ){
            subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField") ] ){
            UITextField *textField = (UITextField *)subview;
            [textField setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
            //            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            //            [imgView setImage:magnifierImage];
            //            textField.leftView = imgView;
            [textField setBackgroundColor:UIColorFromRGB(0xE8E8E8)];
            
            // get the font attribute
            NSDictionary *attr = textField.defaultTextAttributes;
            // define a max size
            CGSize maxSize = CGSizeMake(textField.superview.bounds.size.width - 90, 40);
            // get the size of the text
            CGFloat widthText = [placeholderString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
            
            // get the size of one space
            CGFloat widthSpace = [@" " boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
            
            int spaces = floor((maxSize.width - widthText) / widthSpace);
            
            // add the spaces
            NSMutableString *newText = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",placeholderString]];
            for(int i = 0 ; i < spaces; i ++){
                [newText appendString:@" "];
            }
            textField.placeholder = newText;
        }
        if([subview isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subview;
            [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14]}] forState:UIControlStateNormal];
        }
    }
    if(!self.isPincodeView){
        if(!self.shouldHideCancel){
            [pincodeSearchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 44)];

            cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 42 - 16, 32, 32)];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"CrossGrey"] forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(dismissLocationSearch) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancelButton];
        }
    }
}

/*
-(void)enableSearch:(id)sender{

    //SEARCHBAR
    searchBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.navigationController.navigationBar.frame.size.height)];
    [searchBarContainerView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];

    [searchBarContainerView setAlpha:1.0];
    pincodeSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 0, DeviceWidth - 100, self.navigationController.navigationBar.frame.size.height)];
    pincodeSearchBar.delegate = self;
    [pincodeSearchBar becomeFirstResponder];
    [pincodeSearchBar setUserInteractionEnabled:YES];
    [searchBarContainerView addSubview:pincodeSearchBar];
    [self.navigationController.navigationBar addSubview:searchBarContainerView];
    [pincodeSearchBar sizeToFit];

    
    if(!_isPincodeView){
        pincodeSearchBar.returnKeyType = UIReturnKeyDefault;
        pincodeSearchBar.autocorrectionType = UITextAutocapitalizationTypeNone;
    }else{
        
        [pincodeSearchBar setKeyboardType:UIKeyboardTypeDecimalPad];
        [pincodeSearchBar setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    
    [pincodeSearchBar setDelegate:self];
    [pincodeSearchBar setTintColor:UIColorFromRGB(kDarkPurpleColor)];
    
    for ( UIView * subview in [[[pincodeSearchBar subviews] firstObject] subviews])
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] ){
            subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] ){
        subview.alpha = 0.0;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField") ] ){
            UITextField *textField = (UITextField *)subview;
            [textField setFont:[UIFont fontWithName:kMontserrat_Light size:15.0]];
            [textField setBackgroundColor:[UIColor clearColor]];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [imgView setContentMode:UIViewContentModeTop];
            [imgView setImage:magnifierImage];
            textField.leftView = imgView;
        }
        if([subview isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subview;
            [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:15]}] forState:UIControlStateNormal];
        }
    }
    [self showAutoDetectTab:false];
}
*/



-(UIView *)tableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    
    NSMutableAttributedString *cityString1 = [[NSMutableAttributedString alloc] initWithString:@"We are currently operational in " attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:13], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];
    
    NSArray *cityArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"availableCities"];
    NSString *str = [[NSString alloc] init];
    
    for(int i = 0; i < [cityArray count]; i++){
        str = [str stringByAppendingString:[[cityArray objectAtIndex:i] capitalizedString]];
        if(i < [cityArray count] - 1){
           str = [str stringByAppendingString:@", "];
        }
    }
    
    NSAttributedString *cityString2 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:13], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];

    [cityString1 appendAttributedString:cityString2];
    
    CGRect cityLabelRect = [cityString2 boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cityLabelRect.size.height + 10)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setAttributedText:cityString1];
    [headerView addSubview:label];
    
    [headerView setFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, MAX(headerView.frame.size.height, label.frame.size.height))];
    [label setCenter:CGPointMake(headerView.frame.size.width/2, headerView.frame.size.height/2)];
    
    return headerView;
}

-(void)dismissLocationSearch{

    [pincodeSearchBar removeFromSuperview];
    [cancelButton removeFromSuperview];
    [self deRegisterForKeyboardNotifications];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [pincodeSearchBar removeFromSuperview];
    [cancelButton removeFromSuperview];
}

-(void)showAutoDetectTab:(BOOL)shouldShow{
    [UIView animateWithDuration:0.4 animations:^{
        if(shouldShow){
            [autoDetectView setFrame:CGRectMake(autoDetectView.frame.origin.x, autoDetectView.frame.origin.y, autoDetectView.frame.size.width, 50)];
        }else{
            [autoDetectView setFrame:CGRectMake(autoDetectView.frame.origin.x, autoDetectView.frame.origin.y, autoDetectView.frame.size.width, 0)];
        }
        [suggestionListView setFrame:CGRectMake(autoDetectView.frame.origin.x, autoDetectView.frame.origin.y + autoDetectView.frame.size.height, self.view.frame.size.width,self.view.frame.size.height - (autoDetectView.frame.origin.y + autoDetectView.frame.size.height))];
    }];
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

-(void)cancelSearch{
    [self searchBarCancelButtonClicked:pincodeSearchBar];
}

#pragma mark - UITextField Delegates

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self deRegisterForKeyboardNotifications];
    [self registerForKeyboardNotifications];
    
    if(!self.isPincodeView){
        [self showAutoDetectTab:false];
    }
    NSAttributedString *cancelString = [[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Light size:14], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    NSAttributedString *cancelTapString = [[NSAttributedString alloc] initWithString:@"Cancel" attributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Light size:14], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];

    
    searchCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(searchBarContainerView.frame.size.width, 0, 60, 44)];
    [searchCancelButton setBackgroundColor:[UIColor clearColor]];
    [searchCancelButton setAttributedTitle:cancelString forState:UIControlStateNormal];
    [searchCancelButton setAttributedTitle:cancelTapString forState:UIControlStateHighlighted];
    //    [cancelButtton setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
    //    [cancelButtton setTitleColor:UIColorFromRGB(kSignUpColor) forState:UIControlStateHighlighted];
    [searchCancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBarContainerView addSubview:searchCancelButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, 0, searchBarContainerView.frame.size.width - 80, 44)];
        [searchCancelButton setFrame:CGRectMake(searchBar.frame.origin.x + searchBar.frame.size.width + 5, searchCancelButton.frame.origin.y, searchCancelButton.frame.size.width, searchCancelButton.frame.size.height)];
    }];
    if(cancelButton){
        [cancelButton setHidden:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchBar.text isEqualToString:@""]) {
        [dataTask cancel];
        [suggestionArray removeAllObjects];
        
        if(!_isPincodeView){
            if([suggestionListView isHidden]){
                [suggestionListView setHidden:false];
            }
            suggestionArray = [defaultLocations mutableCopy];
            [suggestionListView reloadData];
            [dataTask resume];
        }else{
            [suggestionArray removeAllObjects];
            [suggestionListView reloadData];
            blankPincodeView.hidden = false;
        }
    }
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self.timer invalidate];
    self.timer = nil;
    
    [dataTask cancel];
    [suggestionArray removeAllObjects];
    [suggestionListView reloadData];
    
    finalString = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
    if(finalString && finalString.length > 1 ){
        self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(startSearch) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
    }else{
        if([suggestionListView isHidden]){
            [suggestionListView setHidden:false];
        }
        [dataTask cancel];
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self showAutoDetectTab:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if(self.isPincodeView){
        [self dismissLocationSearch];
    }else{
//        [searchBarContainerView removeFromSuperview];
//        searchBarContainerView = nil;
        
        
        if(cancelButton){
            [cancelButton setHidden:false];
            cancelButton.alpha = 0.0;

        }
        [UIView animateWithDuration:0.2 animations:^{
            if(!self.shouldHideCancel){
                [pincodeSearchBar setFrame:CGRectMake(5, 0, self.view.frame.size.width - 40, 44)];

            }else{
                [pincodeSearchBar setFrame:CGRectMake(5, 0, self.view.frame.size.width - 0, 44)];
            }
            [searchCancelButton setFrame:CGRectMake(searchBarContainerView.frame.size.width, searchCancelButton.frame.origin.y, searchCancelButton.frame.size.width, searchCancelButton.frame.size.height)];
            cancelButton.alpha = 1.0;
        }];
        
        [searchBar resignFirstResponder];
        //    [searchBar setShowsCancelButton:NO animated:YES];
        
    }
}


#pragma mark - 

-(void)startSearch{
//    if (self.isPincodeView)
//    {
//        [theSearchIndicator startAnimating];
//    }else{
//        [self.view addSubview:locationSearchLoader];
//        [locationSearchLoader startAnimating];
//    }

    [self getLocationsForString:finalString];
    [dataTask resume];
}


-(void)getLocationsForString:(NSString *)str{
    [self.view addSubview:locationSearchLoader];
    [locationSearchLoader startAnimating];
    [suggestionListView setHidden:TRUE];
    paramDictionary = [[NSMutableDictionary alloc] init];
    [paramDictionary setObject:(str ? str : @"") forKey:@"q"];


    dataTask = [requestHandler sendCachedHttpRequestWithURL:searchURL withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        [locationSearchLoader stopAnimating];
        [locationSearchLoader removeFromSuperview];
        if(responseData){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];

            if([[json allKeys] count] > 0){

//                [theSearchIndicator stopAnimating];

                [self parseSuggestionData:json];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [suggestionListView reloadData];
                    [suggestionListView setHidden:false];
                    
                    if(_isPincodeView){
                            blankPincodeView.hidden = true;
                    }
                });
            }else{
//                [theSearchIndicator stopAnimating];

                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [suggestionArray removeAllObjects];
                });
            }
        }else{
//            [theSearchIndicator stopAnimating];
        }
    }];
}

-(void)parseSuggestionData:(NSDictionary *)data{
    isDataLoaded = TRUE;
    NSArray *dataArray = nil;
    if (_isPincodeView) {
       dataArray = [data objectForKey:@"items"];
    }else{
       dataArray = [data objectForKey:@"locations"];
    }
    
    NSInteger count = [dataArray count];
    suggestionArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < count; i++){
        SearchItemModel *model = [[SearchItemModel alloc] initWithDictionary:[dataArray objectAtIndex:i]];
        [suggestionArray addObject:model];
    }
    if(!defaultLocations){
        defaultLocations = [[NSArray alloc] initWithArray:suggestionArray];
    }
}

#pragma mark - UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return suggestionArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setFrame:CGRectMake(0, 0, suggestionListView.frame.size.width, cell.frame.size.height)];
    }
    NSString *cellValue = nil;
    
    CGSize pincodeSize = [SSUtility getLabelDynamicSize:@"9999999" withFont:[UIFont fontWithName:kMontserrat_Light size:14.0] withSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, cell.frame.size.width - pincodeSize.width -10  , cell.frame.size.height)];
    [label setTag:1321];
    
    if (_isPincodeView) {
        cellValue = [NSString stringWithFormat:@"  %@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] itemType]];
        
        [label setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [label setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [label setTextAlignment:NSTextAlignmentLeft];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [label setText:cellValue];

    }else{
        cellValue = [NSString stringWithFormat:@"  %@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] displayName]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cellValue attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0f]}];
        if(pincodeSearchBar.text.length > 0){
            NSRange range = [cellValue rangeOfString:pincodeSearchBar.text];
            
            
//            NSRange searchRange = NSMakeRange(0,string.length);
//            NSRange foundRange;
//            while (searchRange.location < string.length) {
//                searchRange.length = string.length-searchRange.location;
//                foundRange = [cellValue rangeOfString:pincodeSearchBar.text options:nil range:searchRange];
//                if (foundRange.location != NSNotFound) {
//                    // found an occurrence of the substring! do stuff here
//                    searchRange.location = foundRange.location+foundRange.length;
//                    
//                    [string addAttributes:@{NSBackgroundColorAttributeName : UIColorFromRGB(0xB2F4FC)} range:foundRange];
//
//                } else {
//                    // no more substring to find
//                    break;
//                }
//            }
            
            if(range.length > 0){
                [string addAttributes:@{NSBackgroundColorAttributeName : UIColorFromRGB(0xB2F4FC)} range:range];
            }
        }
        [label setAttributedText:string];
    }
    
    
    if ([cell.contentView viewWithTag:1321]) {
        UILabel *cellLabel= (UILabel *)[cell.contentView viewWithTag:1321];
        [cellLabel removeFromSuperview];
        cellLabel = nil;
    }

    if ([cell.contentView viewWithTag:1322]) {
        UILabel *cellLabel= (UILabel *)[cell.contentView viewWithTag:1322];
        [cellLabel removeFromSuperview];
        cellLabel = nil;
    }
    
    [label setTextAlignment:NSTextAlignmentLeft];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [cell.contentView addSubview:label];

    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - pincodeSize.width-5, 0, pincodeSize.width, cell.frame.size.height)];
    [detailLabel setTag:1322];
    [detailLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [detailLabel setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [detailLabel setTextAlignment:NSTextAlignmentCenter];

    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (_isPincodeView) {
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] displayName]]];
    }else{
        
        NSString *detailValue = [NSString stringWithFormat:@"%@",[(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] itemType]];
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:detailValue attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0f]}];
        if(pincodeSearchBar.text.length > 0){
            NSRange range = [detailValue rangeOfString:pincodeSearchBar.text];
            if(range.length > 0){
                [string1 addAttributes:@{NSBackgroundColorAttributeName : UIColorFromRGB(0xB2F4FC)} range:range];
            }
        }
        
        [detailLabel setAttributedText:string1];
//        [detailLabel setText:[NSString stringWithFormat:@"%@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] itemType]]];

    }

    [cell.contentView addSubview:detailLabel];
    
    
    
//    if (_isPincodeView) {
////        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] displayName]]];
//    }else{
//        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [(SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row] itemType]]];
//    }
//    [cell.detailTextLabel setBackgroundColor:UIColorFromRGB(kGreenColor)];
//    [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
//    [cell.detailTextLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
//    cell.detailTextLabel.font = [UIFont fontWithName:kMontserrat_Light size:14.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SearchItemModel *model = (SearchItemModel *)[suggestionArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    if([userDefaults objectForKey:@"city"] && user.isOnboarded){
        if(!self.isPincodeView){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"city"]){
                [FyndAnalytics trackLocationChange:[model.city lowercaseString] locationAccessMethod:@"manual" prevLocation:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]];
            }
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.latitude forKey:@"latitude"];
    [defaults setObject:model.longitude forKey:@"longitude"];
    [defaults setObject:model.displayName forKey:@"locality"];
    [defaults setObject:model.city forKey:@"city"];
    [defaults setObject:model.itemType forKey:@"pincode"];
    [defaults synchronize];
    
    if(!self.isPincodeView){
        FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
        if(!user.isOnboarded){
            [defaults setObject:@"manual" forKey:@"onboardingAccessType"];
            [defaults setObject:[model.city lowercaseString] forKey:@"onboardingLocation"];
//            [FyndAnalytics trackLocationAccessType:@"manual" andLocation:model.city];
        }
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectLocation)]){
        [self.delegate didSelectLocation];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}



@end
