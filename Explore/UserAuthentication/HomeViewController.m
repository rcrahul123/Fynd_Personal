//
//  HomeViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "HomeViewController.h"
#import "SSUtility.h"
//#import <Google/Analytics.h>
#import "FyndAnalytics.h"
#import "FyndErrorInfoView.h"

@interface HomeViewController ()
@property (nonatomic,strong) UIView *errorView;
@property (nonatomic,strong) FyndErrorInfoView *fyndErrorView;
@property (nonatomic,strong)     UIView *overlayView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    homeLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [homeLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self addCustomSplash];
}


- (void)addCustomSplash{
    [self checkSessionValid];

    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    CGRect bound = self.view.bounds;
    
    gifContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bound.size.width,bound.size.height)];
    [gifContainerView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *filePath;
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLoad"] boolValue]){
        isFirstLoad = true;
        filePath = [[NSBundle mainBundle] pathForResource:@"Splash screen.gif" ofType:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLoad"];
        
        NSData* imageData = [NSData dataWithContentsOfFile:filePath];
        
        gifContainer = [[SCGIFImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -245/2, self.view.frame.size.height/2 - 260/2 , 245, 260)];
        gifContainer.animationDuration = 0.05;
        [gifContainer setData:imageData];
        [gifContainerView addSubview:gifContainer];
        [self.view addSubview:gifContainerView];

        [self performSelector:@selector(removeSplash) withObject:nil afterDelay:3.6f];

    }else{
        isFirstLoad = false;
        UIImage *image = [UIImage imageNamed:@"StaticSplash"];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        [gifContainerView addSubview:imgView];
        [imgView setCenter:CGPointMake(gifContainerView.frame.size.width/2, gifContainerView.frame.size.height/2)];
        [self.view addSubview:gifContainerView];

    }
}

- (void)removeSplash{

    if(gifContainerView){
        if(gifContainer){
            [gifContainer removeFromSuperview];
            gifContainer = nil;
        }
        [UIView animateWithDuration:0.3 animations:^{
            gifContainerView.alpha = 0;
        } completion:^(BOOL finished) {
            [gifContainerView removeFromSuperview];
            gifContainerView = nil;
            [self doHomeScreenSetUp];

        }];
    }
}


- (void)doHomeScreenSetUp{
    [self setupHomeScreen];
}


-(void)checkSessionValid{
    authenticationRequestHandler = [[UserAuthenticationHandler alloc] init];
    [authenticationRequestHandler checkUserAlreadyloggedInWithCompletionHandler:^(id responseData, NSError *error) {
            if(!isFirstLoad){
                [self removeSplash];
            }
        BOOL responseFlag = FALSE;
        
        if(!error){
            if(responseData[@"update_required"] && [responseData[@"update_required"] boolValue]){

                [self.view setUserInteractionEnabled:false];
                [self performSelector:@selector(showMustUpdatePopup) withObject:nil afterDelay:1.5];
//                [[NSUserDefaults standardUserDefaults] setBool:[NSNumber numberWithBool:TRUE] forKey:@"validateSession"];
//                [[NSNotificationCenter defaultCenter] addObserver:self
//                                                         selector:@selector(checkSessionValid)
//                                                             name:@"validateSessionObserver"
//                                                           object:nil];


            }else{
//                [[NSNotificationCenter defaultCenter] removeObserver:@"validateSessionObserver"];
//                [[NSUserDefaults standardUserDefaults] setBool:[NSNumber numberWithBool:FALSE] forKey:@"validateSession"];
                if (self.overlayView) {
                    [self.overlayView removeFromSuperview];
                    self.overlayView = nil;
                }
                if(responseData[@"cities"]){
                    NSArray *citiesArray = responseData[@"cities"];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:citiesArray forKey:@"availableCities"];
                }
                responseFlag = [[responseData objectForKey:@"is_valid_session"] boolValue];
                if(responseFlag){
                    //Set the total items count of Cart.
                    //                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    //                [userDefaults setObject:[NSNumber numberWithInt:1] forKey:kHasItemInBag];
                    //                if([userDefaults boolForKey:@"showSignupDirectly"]){
                    //                    [userDefaults setBool:false forKey:@"showSignupDirectly"];
                    //                }
                    
                    
                    self.userData = [SSUtility loadUserObjectWithKey:kFyndUserKey];
                    if(!self.userData){
                        self.userData = [[FyndUser alloc] init];
                    }
                    
                    self.userData.isOnboarded = [[responseData objectForKey:@"is_onboarded"] boolValue];
                    self.userData.gender = [responseData objectForKey:@"gender"];
                    
                    [SSUtility saveCustomObject:self.userData];
                    
                    [FyndAnalytics startSessionTracking];
                    
                    if(self.userData.isOnboarded){
                        [self getLocation];
                    }else{
                        [self performSegueWithIdentifier:@"HomeToLocation" sender:nil];
                    }
                    
                }else{
                    //                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    //                if([userDefaults boolForKey:@"showSignupDirectly"]){
                    //                    [self signUpNewUser];
                    //                    [userDefaults setBool:false forKey:@"showSignupDirectly"];
                    //                }
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setBool:NO forKey:@"isLaunchedFrom3DTouch"];
                    [userDefaults setObject:[NSNumber numberWithInteger:-1] forKey:@"3DTouchOptionType"];
                    
                    [userDefaults setBool:NO forKey:@"isLaunchedFromOtherApp"];
                    if([userDefaults objectForKey:@"openingURL"]){
                        [userDefaults removeObjectForKey:@"openingURL"];
                    }
                    if([userDefaults objectForKey:@"shouldShow"]){
                        [userDefaults removeObjectForKey:@"shouldShow"];
                    }
                    [userDefaults setBool:NO forKey:@"suppressGender"];
                    
                }
            }
        }else{
            [self generateAddCartInfoView:error];
        }
    }];

}



-(void)showMustUpdatePopup{
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [self.view addSubview:_overlayView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _overlayView.frame.size.width - 30, 100)];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    [_overlayView addSubview:containerView];
    
    UIImage *image = [UIImage imageNamed:@"MustUpdatePopup"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(containerView.frame.size.width/2 - image.size.width/2, 20, image.size.width, image.size.height)];
    [imageView setImage:image];
    
    [containerView addSubview:imageView];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 10, 300, 20)];
    [headerLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0]];
    [headerLabel setText:@"New version available!"];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setTextColor: UIColorFromRGB(kDarkPurpleColor)];
    [containerView addSubview:headerLabel];
    [headerLabel sizeToFit];
    [headerLabel setCenter:CGPointMake(containerView.frame.size.width/2, headerLabel.center.y)];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *str = @"You are using an older version of the app which is no longer supported. Please update to the latest version to continue using Fynd.";
    CGRect rect = [str boundingRectWithSize:CGSizeMake(containerView.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSForegroundColorAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0]} context:NULL];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, headerLabel.frame.origin.y + headerLabel.frame.size.height + 15, rect.size.width, rect.size.height + 40)];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:kMontserrat_Light size:14.0]];
    [label setText:str];
    [label setTextColor:UIColorFromRGB(kLightGreyColor)];
    [containerView addSubview:label];
    [label sizeToFit];
    [label setCenter:CGPointMake(containerView.frame.size.width/2, label.center.y)];
    
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"UPDATE APP" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height + 15, containerView.frame.size.width - 20, 50)];
    [updateButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [updateButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [updateButton.layer setCornerRadius:3.0];
    [updateButton setClipsToBounds:YES];
    [updateButton setAttributedTitle:title forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(openAppStore) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:updateButton];
    [updateButton setCenter:CGPointMake(containerView.frame.size.width/2, updateButton.center.y)];
    [self.view setUserInteractionEnabled:TRUE];
    
    [containerView setFrame:CGRectMake(0, 0, containerView.frame.size.width, updateButton.frame.origin.y + updateButton.frame.size.height + 10)];
    [containerView setCenter:CGPointMake(_overlayView.frame.size.width/2, _overlayView.frame.size.height/2)];
    
    containerView.clipsToBounds = YES;
    [containerView.layer setCornerRadius:3.0];
    
    
    [containerView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.3 animations:^{
        [containerView setTransform:CGAffineTransformMakeScale(1, 1)];
    } completion:^(BOOL finished) {
        
//        [UIView animateWithDuration:0.2 animations:^{
//            [containerView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                    [self.view setUserInteractionEnabled:true];
//            }];
//        }];
    }];

}


-(void)openAppStore{
    NSString *iTunesLink = kAppStoreAppLink;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

CGPoint point;
- (void)generateAddCartInfoView:(NSError *)error{
    
    self.fyndErrorView = [[FyndErrorInfoView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50, self.view.frame.size.width, 50)];
    [self.fyndErrorView showErrorView:[error.userInfo objectForKey:@"message"] withRect:self.view.frame];
    __weak HomeViewController *homeContrl = self;
    self.fyndErrorView.errorAnimationBlock = ^(){
        if(homeContrl.fyndErrorView){
            [homeContrl.fyndErrorView removeFromSuperview];
            homeContrl.fyndErrorView = nil;
        }
    };
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}



-(void)setupHomeScreen{
    
    CGFloat buttoonContainerHeight = RelativeSizeHeight(170, 667);
    buttonsHeight = RelativeSize(80, 667);
    
    playerContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - buttoonContainerHeight)];
    playerContainer.showsHorizontalScrollIndicator = false;
    [playerContainer setContentSize:CGSizeMake(playerContainer.frame.size.width * 3, playerContainer.frame.size.height)];
    playerContainer.pagingEnabled = true;
    playerContainer.delegate = self;
    playerContainer.bounces = false;
    [playerContainer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:playerContainer];
    
    totalPages = 3;
    
    pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    
    [self addButtons];
    [self setupScrollView];

}


-(void)setupScrollView{
    
    pageControl.frame = CGRectMake(0, 0, RelativeSize(100, 375), RelativeSizeHeight(20, 667));
    [pageControl setCenter:CGPointMake(self.view.frame.size.width/2, self.haveOTPButton.frame.origin.y - pageControl.frame.size.height/2 - RelativeSizeHeight(15, 667))];
    
    if ([pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        pageControl.currentPageIndicatorTintColor = UIColorFromRGB(kTurquoiseColor);
        pageControl.pageIndicatorTintColor = UIColorFromRGB(kLightGreyColor);
    }
    pageControl.numberOfPages = totalPages;
    pageControl.currentPage = 0;
    
    NSArray *headerTextArray = @[@"DISCOVER FASHION", @"FYND A FIT", @"SUPERFAST DELIVERY"];
    
    NSMutableAttributedString *discoverStringBrand = [[NSMutableAttributedString alloc] initWithString:@"Brands" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSBaselineOffsetAttributeName : @-3}];
    NSMutableAttributedString *discoverStringCollection = [[NSMutableAttributedString alloc] initWithString:@"Collections" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSBaselineOffsetAttributeName : @-3}];
    NSMutableAttributedString *discoverStringTrends = [[NSMutableAttributedString alloc] initWithString:@"Trends" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSBaselineOffsetAttributeName : @-3}];
    NSMutableAttributedString *discoverStringDot = [[NSMutableAttributedString alloc] initWithString:@" . " attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:35], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSBaselineOffsetAttributeName : @0}];
    
    [discoverStringBrand appendAttributedString:discoverStringDot];
    [discoverStringBrand appendAttributedString:discoverStringCollection];
    [discoverStringBrand appendAttributedString:discoverStringDot];
    [discoverStringBrand appendAttributedString:discoverStringTrends];
    
    NSMutableAttributedString *fyndFitString = [[NSMutableAttributedString alloc] initWithString:@"Try Multiple Sizes for Perfect Fit" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16]}];
    
    NSMutableAttributedString *superfastString = [[NSMutableAttributedString alloc] initWithString:@"Get what you like fast...Superfast!" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16]}];
    
    NSArray *stringArray = @[discoverStringBrand, fyndFitString, superfastString];

    for(int i = 0; i < totalPages; i++){

        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"ScrollView%d", i+1]];
        float aspRatio = img.size.width/img.size.height;
        float height = kDeviceHeight * img.size.height/(667);
        float width = aspRatio * height;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imgView setImage:img];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setCenter:CGPointMake(i*playerContainer.frame.size.width + playerContainer.frame.size.width/2, RelativeSizeHeight(160, 667) + imgView.frame.size.height/2)];

        [playerContainer addSubview:imgView];
        
        if(i == 0){
            UIImage *topImage = [UIImage imageNamed:[NSString stringWithFormat:@"TopLeft1%d", i+1]];
            CGSize lftImageSize = CGSizeMake(topImage.size.width * kDeviceHeight * 0.32 / topImage.size.height , kDeviceHeight * 0.32);
            
            UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * playerContainer.frame.size.width, 0, lftImageSize.width, lftImageSize.height)];
            [topImageView setImage:topImage];
            [playerContainer addSubview:topImageView];
        }
        
        UIImage *topImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"TopRight1%d", i+1]];
        CGSize rightImageSize = CGSizeMake(topImage1.size.width * kDeviceHeight * 0.32 / topImage1.size.height , kDeviceHeight * 0.32);
        UIImageView *topImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)* playerContainer.frame.size.width - rightImageSize.width/2, 0, rightImageSize.width, rightImageSize.height)];

        if(i == 2){
            [topImageView1 setFrame:CGRectMake((i+1)* playerContainer.frame.size.width - rightImageSize.width, 0, rightImageSize.width, rightImageSize.height)];
        }

        [topImageView1 setImage:topImage1];
        [playerContainer addSubview:topImageView1];
        
        CGRect stringRect = [[stringArray objectAtIndex:i] boundingRectWithSize:CGSizeMake(playerContainer.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        UILabel *infoTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pageControl.frame.origin.y - RelativeSizeHeight(30, 667) - stringRect.size.height, stringRect.size.width, stringRect.size.height)];
        [infoTextLabel setBackgroundColor:[UIColor clearColor]];
        [infoTextLabel setAttributedText:[stringArray objectAtIndex:i]];
        [infoTextLabel setCenter:CGPointMake(playerContainer.frame.size.width * i + playerContainer.frame.size.width/2, infoTextLabel.center.y)];
        [playerContainer addSubview:infoTextLabel];
        
        CGSize headerRect = [SSUtility getLabelDynamicSize:[headerTextArray objectAtIndex:i] withFont:[UIFont variableFontWithName:kMontserrat_Bold size:18] withSize:CGSizeMake(playerContainer.frame.size.width, MAXFLOAT)];
        UILabel *infoHeaderTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerRect.width, headerRect.height)];
        [infoHeaderTextLabel setBackgroundColor:[UIColor clearColor]];
        [infoHeaderTextLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
        [infoHeaderTextLabel setText:[headerTextArray objectAtIndex:i]];
        [infoHeaderTextLabel setFont:[UIFont variableFontWithName:kMontserrat_Bold size:18]];
        [infoHeaderTextLabel setCenter:CGPointMake(playerContainer.frame.size.width * i + playerContainer.frame.size.width/2, pageControl.frame.origin.y - RelativeSizeHeight(60, 667) - headerRect.height/2)];
        [playerContainer addSubview:infoHeaderTextLabel];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)addButtons{
    
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];

    NSAttributedString *signUpString = [[NSAttributedString alloc] initWithString:@"SIGN UP" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:16.0]}];
    NSAttributedString *signUpStringTouch = [[NSAttributedString alloc] initWithString:@"SIGN UP" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:16.0]}];

    self.signUp = [[UIButton alloc] initWithFrame:CGRectMake(RelativeSize(20, 375), self.view.frame.size.height - RelativeSizeHeight(20, 667) - RelativeSizeHeight(50, 667), self.view.frame.size.width/2- RelativeSize(27, 375), [SSUtility getMinimumButtonHeight:50 relatedToHeight:667])];
    
    [self.signUp setBackgroundColor:[UIColor clearColor]];
    [self.signUp setAttributedTitle:signUpString forState:UIControlStateNormal];
    [self.signUp setAttributedTitle:signUpStringTouch forState:UIControlStateHighlighted];
    [self.signUp addTarget:self action:@selector(signUpNewUser) forControlEvents:UIControlEventTouchUpInside];
    [self.signUp.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
    [self.signUp.layer setBorderWidth:1.0];
    [self.signUp.layer setCornerRadius:3.0];
    [self.view addSubview:self.signUp];
    
    NSAttributedString *loginString = [[NSAttributedString alloc] initWithString:@"LOGIN" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:16.0]}];
    NSAttributedString *loginStringTouch = [[NSAttributedString alloc] initWithString:@"LOGIN" attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(kSignUpTouchColor), NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:16.0]}];

    self.login = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + RelativeSize(7, 375), self.signUp.frame.origin.y, self.view.frame.size.width/2 - RelativeSize(27, 375), self.signUp.frame.size.height)];

    [self.login setBackgroundColor:[UIColor clearColor]];
    [self.login addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.login setAttributedTitle:loginString forState:UIControlStateNormal];
    [self.login setAttributedTitle:loginStringTouch forState:UIControlStateHighlighted];
    [self.login.layer setBorderColor:UIColorFromRGB(kSignUpColor).CGColor];
    [self.login.layer setBorderWidth:1.0];
    [self.login.layer setCornerRadius:3.0];
    [self.view addSubview:self.login];
    
    NSMutableAttributedString *f = [[NSMutableAttributedString alloc] initWithString:@"f" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Bold size:20.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    NSAttributedString *facebookButtonString = [[NSAttributedString alloc] initWithString:@"     Continue with Facebook" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor], NSBaselineOffsetAttributeName : @2}];
    
    [f appendAttributedString:facebookButtonString];
    
    self.facebookLogin = [[UIButton alloc] initWithFrame:CGRectMake(RelativeSize(20, 375), self.signUp.frame.origin.y - RelativeSizeHeight(14, 667) - self.signUp.frame.size.height, self.view.frame.size.width - RelativeSize(40, 375), self.signUp.frame.size.height)];

    self.facebookLogin.clipsToBounds = YES;
    self.facebookLogin.layer.cornerRadius = 3.0;
    [self.facebookLogin setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kFBButtonColor)] forState:UIControlStateNormal];
    [self.facebookLogin setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kFBButtonTouchColor)] forState:UIControlStateHighlighted];
    [self.facebookLogin setAttributedTitle:f forState:UIControlStateNormal];

    [self.facebookLogin addTarget:self action:@selector(initiateFBLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.facebookLogin];
    
    NSAttributedString *havOTPTitle = [[NSAttributedString alloc] initWithString:@"Already have an OTP" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(KPurpleColor)}];
    
    NSAttributedString *havOTPTitleTouch = [[NSAttributedString alloc] initWithString:@"Already have an OTP" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Regular size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightPurpleColor)}];

    self.haveOTPButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, RelativeSizeHeight(20, 667))];

    [self.haveOTPButton setBackgroundColor:[UIColor clearColor]];
    [self.haveOTPButton setAttributedTitle:havOTPTitle forState:UIControlStateNormal];
    [self.haveOTPButton setAttributedTitle:havOTPTitleTouch forState:UIControlStateHighlighted];
    [self.haveOTPButton setCenter:CGPointMake(self.view.frame.size.width/2, self.facebookLogin.frame.origin.y - RelativeSizeHeight(20, 667) - self.haveOTPButton.frame.size.height/2)];

    [self.haveOTPButton addTarget:self action:@selector(navigateToVerifyOTP) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.haveOTPButton];
    [self.haveOTPButton setHidden:TRUE];
    if(user){
        if(user.shouldShowHaveOTP){
            [self.haveOTPButton setHidden:FALSE];
            }
        }
}

- (void) buttonHighlight:(id)sender {
    UIButton *tappedButton = (UIButton *)sender;
    tappedButton.backgroundColor = UIColorFromRGB(kBackgroundGreyColor);
}

-(void)navigateToVerifyOTP{
    [self performSegueWithIdentifier:@"HomeToVerifyOTP" sender:nil];
}


-(void)addVideos{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    playerArray = [[NSMutableArray alloc] initWithCapacity:totalPages];
    for(int i = 0; i < totalPages; i++){
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"boarding_%d", i+2] ofType:@"m4v"];

        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
        
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        [layer setFrame:CGRectMake(playerContainer.frame.size.width * i, 0, playerContainer.frame.size.width, playerContainer.frame.size.height)];
        [playerContainer.layer addSublayer:layer];
        [playerArray addObject:player];
    }
    currentPlayer = (AVPlayer *)[playerArray objectAtIndex:0];
    [currentPlayer play];
    currentPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float xPos = scrollView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    pageControl.currentPage = (int)xPos/scrollView.frame.size.width;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self playNextFile];
}


-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    if(currentPage + 1 < totalPages){
        [playerContainer setContentOffset:CGPointMake(playerContainer.contentOffset.x + playerContainer.frame.size.width, playerContainer.contentOffset.y) animated:YES];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self playNextFile];
}

-(void)playNextFile{
    int pageNumber = playerContainer.contentOffset.x/playerContainer.frame.size.width;
    if(currentPage != pageNumber){
        currentPage = pageNumber;
        [currentPlayer pause];
        [currentPlayer seekToTime:CMTimeMake(0, 5)];
        currentPlayer = (AVPlayer *)[playerArray objectAtIndex:pageNumber];
        [currentPlayer play];
    }
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

- (void)showActivityOverlay{
    
    if(self.overlayHandler== nil){
        self.overlayHandler = [[PopOverlayHandler alloc] init];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInt:ActivityIndicatorOverlay] forKey:@"PopUpType"];
    [self.overlayHandler presentOverlay:ActivityIndicatorOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
}


-(void)initiateFBLogin{

    [self.view addSubview:homeLoader];
    [homeLoader startAnimating];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [homeLoader stopAnimating];
        [homeLoader removeFromSuperview];
        if(error){
            
        }else if (result.isCancelled){

            
        }else{
            if(result.token){
                [self getUserFBData];
            }
        }
    }];
}


-(void)getUserFBData{
    [self.view addSubview:homeLoader];
    [homeLoader startAnimating];
    
    showFBDetailPage = FALSE;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id, name, first_name, email, last_name, gender, picture.width(400).height(400)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            self.fbUser = [FyndUser sharedMySingleton];
            self.fbUser.firstName = [result valueForKey:@"first_name"];
            self.fbUser.lastName = [result valueForKey:@"last_name"];
            
            if([[[result valueForKey:@"gender"] uppercaseString] isEqualToString:@"FEMALE"]){
                self.fbUser.gender = @"women";

            }else if([[[result valueForKey:@"gender"] uppercaseString] isEqualToString:@"MALE"]){
                self.fbUser.gender = @"men";
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSString *dateString = [dateFormatter stringFromDate:[[FBSDKAccessToken currentAccessToken] expirationDate]];
            
            self.fbUser.tokenExpiryDateString = dateString;
            self.fbUser.fbID = [[FBSDKAccessToken currentAccessToken] userID];
            self.fbUser.tokenString = [[FBSDKAccessToken currentAccessToken] tokenString];
            self.fbUser.profilePicUrl = [[[result objectForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
            
            if([result objectForKey: @"email"]){
                self.fbUser.emailId = [result valueForKey:@"email"];
            }
            [self doFacebookLogin];
        }];
    }
}


-(void)doFacebookLogin{

    showFBDetailPage = false;
    fbDataDict = [[NSMutableDictionary alloc] init];
    
    if(self.fbUser.fbID)
        [fbDataDict setObject:self.fbUser.fbID forKey:@"fb_id"];
    if(self.fbUser.tokenExpiryDateString)
        [fbDataDict setObject:self.fbUser.tokenExpiryDateString forKey:@"expires_on"];
    if(self.fbUser.profilePicUrl)
        [fbDataDict setObject:self.fbUser.profilePicUrl forKey:@"profile_pic_url"];
    if(self.fbUser.tokenString)
        [fbDataDict setObject:self.fbUser.tokenString forKey:@"access_token"];

    
    [authenticationRequestHandler loginUsingFacebook:fbDataDict withComppletionHandler:^(id responseData, NSError *error) {
        if(!error){
            if(responseData){
                if([[responseData objectForKey:@"is_logged_in"] boolValue]){

                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *string = [formatter stringFromDate:now];
                    [self parseUserData:responseData];

                    [FyndAnalytics trackLoginWithLoginType:@"facebook" andLoginDate:string];
                    int totalCartItems = [[responseData objectForKey:kTotalCartItemsKey] intValue];
                    //Added total count of items in cart.
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalCartItems] forKey:kHasItemInBag];
                    
                    if([[responseData objectForKey:@"is_onboarded"] boolValue]){
                        [self getLocation];
                    }else{
                        [self performSegueWithIdentifier:@"HomeToLocation" sender:nil];
                    }
                }else{
                    
                    if(self.fbUser.firstName){
                        [fbDataDict setObject:self.fbUser.firstName forKey:@"first_name"];
                    }else{
                        showFBDetailPage = TRUE;
                    }
                    if(self.fbUser.lastName){
                        [fbDataDict setObject:self.fbUser.lastName forKey:@"last_name"];
                    }else{
                        showFBDetailPage = TRUE;
                    }
                    if(self.fbUser.gender){
                        [fbDataDict setObject:self.fbUser.gender forKey:@"gender"];
                    }else{
                        showFBDetailPage = TRUE;
                    }
                    if(self.fbUser.emailId){
                        [fbDataDict setObject:self.fbUser.emailId forKey:@"email"];
                    }else{
                        showFBDetailPage = TRUE;
                    }

                    if(showFBDetailPage){
                        [self performSegueWithIdentifier:@"facebookDetailFetch" sender:nil];
                    }else{
                        [self performSegueWithIdentifier:@"HomeToSendOTP" sender:nil];
                    }
                }
            }
        }
        
        [homeLoader stopAnimating];
        [homeLoader removeFromSuperview];
        
    }];
}


-(void)getLocation{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *locality = [defaults objectForKey:@"city"];
    if(locality == nil ||  ![SSUtility checkIfUserInAllowedCities:[[defaults valueForKey:@"city"] lowercaseString]]){
        [self declineLocationAcces];
    }else{
        [self performSegueWithIdentifier:@"HomeToTab" sender:nil];

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
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [locationManager startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
            break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [homeLoader stopAnimating];
    [homeLoader removeFromSuperview];
    
    [locationManager stopUpdatingLocation];
    
    location = [locations objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    [userDefaults setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        [userDefaults setObject:[NSString stringWithFormat:@"%@, %@", [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0], [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:1]] forKey:@"city"];
        if([SSUtility checkIfUserInAllowedCities:[placemark.locality lowercaseString]]){
            [self performSegueWithIdentifier:@"HomeToTab" sender:nil];
        }else{
            [self declineLocationAcces];
        }
    }];
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
        [self performSegueWithIdentifier:@"HomeToTab" sender:nil];
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"facebookDetailFetch"])
    {
        UINavigationController *nav  = segue.destinationViewController;
        FacebookDetailsViewController *customViewController = [nav.viewControllers objectAtIndex:0];
        customViewController.fbDataDictionary = fbDataDict;
        customViewController.userModel = self.fbUser;
        customViewController.delegate = self;
        
    }else if ([[segue identifier] isEqualToString:@"HomeToSendOTP"]){
        SendOTPViewController *otpController = (SendOTPViewController *)[segue destinationViewController];
        otpController.sourceOption = OTPNavigatedFromFacebook;
        otpController.userData = self.fbUser;
        otpController.fbUserDataDictionary = fbDataDict;
        
    }else if ([[segue identifier] isEqualToString:@"HomeToVerifyOTP"]){
        VerifyOTPViewController *verifyController = (VerifyOTPViewController *)[segue destinationViewController];
        verifyController.sourceOption = (OTPNavigationOption)[[NSUserDefaults standardUserDefaults] integerForKey:@"OTPNavOption"];
        if(verifyController.sourceOption == OTPNavigatedFromFacebook){
            verifyController.fbUserDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbUserData"];
        }
        verifyController.userModel = [SSUtility loadUserObjectWithKey:kFyndUserKey];

    }
    [homeLoader stopAnimating];
    [homeLoader removeFromSuperview];
}



-(void)pushTabBar{
    [self performSegueWithIdentifier:@"HomeToTab" sender:nil];;
}

-(void)pushOnBoarding{
    [self performSegueWithIdentifier:@"HomeToLocation" sender:nil];
}


-(void)facebookAccountCreated{
    [self performSegueWithIdentifier:@"HomeToLocation" sender:nil];
}

-(void)signUpNewUser{
    [self performSegueWithIdentifier:@"HomeToSignUp" sender:nil];
}


-(void)goLogin{
    [self performSegueWithIdentifier:@"HomeToLogin" sender:nil];
}


-(void)parseUserData:(id)response{
    NSDictionary *profileData = [response objectForKey:@"profile"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:kFyndUserKey]){
        [defaults removeObjectForKey:kFyndUserKey];
    }
    
    if(profileData){
        self.userData = [FyndUser sharedMySingleton];
        self.userData.firstName = [profileData objectForKey:@"first_name"];
        self.userData.lastName = [profileData objectForKey:@"last_name"];
        self.userData.gender = [profileData objectForKey:@"gender"];
        self.userData.profilePicUrl = [profileData objectForKey:@"profile_image_url"];
        self.userData.mobileNumber = [profileData objectForKey:@"mobile"];
        self.userData.shouldShowHaveOTP = FALSE;
        self.userData.isOnboarded = [[response objectForKey:@"is_onboarded"] boolValue];
        self.userData.joiningDate = [profileData objectForKey:@"joining_date"]; // Need to Confirm with Rahul
        self.userData.userId = [NSString stringWithFormat:@"%@",profileData[@"user_id"]];
        self.userData.emailId = [profileData objectForKey:@"email"];
        [SSUtility saveCustomObject:self.userData];
    }
}

@end
