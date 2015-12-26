//
//  ThirdViewController.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ProfileViewController.h"
#import "SSUtility.h"
#import "SSLine.h"
#import "GenderHeaderView.h"
#import "CustomViewForCategory.h"
#import "MyAccountView.h"
#import "GridView.h"
#import "HomeRequestHandler.h"
#import "GenderHeaderModel.h"
#import "MyAccountDetailViewController.h"
#import "BrandsVIewController.h"
#import "CollectionsViewController.h"
#import "SendOTPViewController.h"
#import "PopHeaderView.h"
#import "UIImage+ImageEffects.h"
#import "ShippingAddressListViewController.h"

#import "FyndBlankPage.h"
#import "PaymentController.h"
#import "ReturnReasons.h"
@interface ProfileViewController ()<UIScrollViewDelegate,MyAccountViewDelegate,PopOverlayHandlerDelegate,MyAccountDetailViewDelegate>
- (void)configureProfileHeader;
- (void)configureProfileParallax;
- (void)configureProfileArcWithLogo;
- (UIView *)configureProfileHeaderDetail;
- (void)configureGenderTab;
- (void)configureProfileTabScrollView;
- (MyAccountView *)populateTabViewForIndex:(NSInteger)index;

//- (void)dummyWishListCall;
//- (UIView *)createWishListContainer;

- (UIView *)generateProfileFooter;

@property (nonatomic,strong) UIImageView        *profileHeaderImage;
@property (nonatomic,strong) UIScrollView       *profileScrollView;
@property (nonatomic,strong) UIView             *profileHeaderDetail;
@property (nonatomic,strong) GenderHeaderView   *profileGenderView;
@property (nonatomic,strong) UIScrollView       *profileTabScrollView;
@property (nonatomic,strong) MyAccountView      *accountView;
@property (nonatomic,strong) GridView           *wishListGridView;
@property (nonatomic,strong) NSArray *theDataArray;
@property (nonatomic,strong) WishListView *myWishListView;
@property (nonatomic,strong) OrdersView *myOrdersView;
@property (nonatomic,strong) MyAccountView *acctView;
@property (nonatomic,strong) UIView         *profileFooter;
@property (nonatomic,strong) UILabel        *userName;
@property (nonatomic,assign) NSInteger      headerHeight;
@property (nonatomic,assign) CGRect profileOptionsFrame;
//@property (nonatomic,strong) UIActivityIndicatorView *imageActivityIndicator;
@property (nonatomic,strong) NSURLSessionDataTask *profileDataTask;
@property (nonatomic,strong) UIImageView *profileLogoImage;
@property (nonatomic,strong) PopOverlayHandler *profileOverlay;
@property (nonatomic,strong) MFMailComposeViewController *mail;
@property  (nonatomic,copy) NSString *cancelOrderID;
@property  (nonatomic,copy) NSString *myOrderID;

@property (nonatomic, strong) NSString *cancelCost;
@property (nonatomic,strong) FyndBlankPage   *profileBlankPage;

@property (nonatomic,strong) UIButton *editButton;

@property (nonatomic,strong)NSArray *returnReasonsArray;
@property (nonatomic,strong)ShipmentItem *myOrderShipmentItem;
@property (nonatomic,strong)     ProductSize *theSizeModel;
@end

@implementation ProfileViewController
NSInteger footerHeight = 90.0f;
NSInteger bottomBarHeight = 44.0f;
#define kProfilePadding 10.0f
- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [profileLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
    
    userAuthenticationHandler = [[UserAuthenticationHandler alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    notificationIcon = [[UIBarButtonItem alloc] init];
    [notificationIcon setImage:[UIImage imageNamed:@"NotificationWhite"]];
    [notificationIcon setTarget:self];
    [notificationIcon setAction:@selector(showNotifications)];
    self.navigationItem.leftBarButtonItem = notificationIcon;
    
    [self fetchProfileData];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma MyAccountDetailViewDelegate Method

//- (void)fetchUpdatedData
- (void)fetchUpdatedData:(BOOL)aBool andProfileString:(NSString *)imageUrl
{
    
    if(profileLoader){
        [profileLoader removeFromSuperview];
        profileLoader = nil;
    }
    profileLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [profileLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
    
    profileHandler = [[ProfileRequestHandler alloc] init];
    [profileHandler fetchProfileData:nil withCompletionHandler:^(NSError *error) {
        [profileLoader stopAnimating];
        [profileLoader removeFromSuperview];
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:TRUE];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    [self updateNotificationIcon];
    
//    [self.navigationController.navigationBar changeNavigationBarToTransparent:TRUE];
    if(!isNavBarVisible){
        
        [self.navigationController.navigationBar changeNavigationBarToTransparent:TRUE];
    }else{
        [self.navigationController.navigationBar changeNavigationBarToTransparent:false];
        [self.navigationController.navigationBar setTranslucent:YES];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self changeTab];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];//Amboj 29Sep
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//    self.profileScrollView.contentOffset = CGPointMake(0, 0 - self.profileScrollView.contentInset.top);
    
    if(isOrderViewOberverAdded){
        @try{
            [self removeObserver:self forKeyPath:@"self.myOrdersView.frame" context:NULL];
            isOrderViewOberverAdded = false;
        }@catch(id anException){
            
        }
    }
    if(isWishListViewObserverAdded){
        @try{
            [self removeObserver:self forKeyPath:@"self.myWishListView.frame" context:NULL];
            isWishListViewObserverAdded = false;
        }@catch(id anException){
            
        }
    }
}


-(void)showNotifications{
    NotificationViewController *notificationController = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationController animated:FALSE];
}

-(void)updateNotificationIcon{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL newNotifications = [defaults boolForKey:kNewNotificationKey];
    if(newNotifications){
        if(self.profileScrollView.contentOffset.y > 0){
            [notificationIcon setImage:[[UIImage imageNamed:@"NotificationActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        }else{
            [notificationIcon setImage:[[UIImage imageNamed:@"NotificationWhiteActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        }
        
        
    }else{
        if(self.profileScrollView.contentOffset.y > 0){
            [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
        }else{
            [notificationIcon setImage:[UIImage imageNamed:@"NotificationWhite"]];

        }
    }
}

- (void)fetchProfileData{
    profileHandler = [[ProfileRequestHandler alloc] init];
    [profileHandler fetchProfileData:nil withCompletionHandler:^(NSError *error) {
        if(!error){
            [profileLoader stopAnimating];
            [profileLoader removeFromSuperview];
            [self configureProfileScreen];
            
            NSString *profilePicUrl = [[SSUtility loadUserObjectWithKey:kFyndUserKey] profilePicUrl];
            [self downloadProfileCover:profilePicUrl];
        }else{
            [self showBlankPage];
        }
    }];
}




- (void)tapOnRetry{
    if(self.profileBlankPage){
        [self.profileBlankPage removeFromSuperview];
        self.profileBlankPage = nil;
    }
    
    [self fetchProfileData];
}

- (void)showBlankPage{
    
    if(self.profileBlankPage){
        [self.profileBlankPage removeFromSuperview];
        self.profileBlankPage = nil;
    }
    self.profileBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - (20+self.tabBarController.tabBar.frame.size.height)) blankPageType:ErrorSystemDown];
    [self.profileBlankPage setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.profileBlankPage];
    ProfileViewController *profileScreen = self;
    self.profileBlankPage.blankPageBlock=^(){
        [profileScreen tapOnRetry];
    };
}


- (void)configureProfileScreen{
    [self configureProfileHeader];
    [self configureProfileParallax];
    [self configureProfileArcWithLogo];
    
    self.profileHeaderDetail = [self configureProfileHeaderDetail];
    
    [self.profileHeaderDetail setBackgroundColor:[UIColor whiteColor]];
    [self.profileScrollView addSubview:self.profileHeaderDetail];
    
    [self configureGenderTab];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        NSArray *params =  [userDefaults objectForKey:@"BranchParameters"];
        if(params && [params count] > 0){
        NSString *profileTagString = [[params objectAtIndex:0] objectForKey:@"screen_name"];
        
        /*
        // If no paramter is set then by default show wishlist
        if(profileTagString && profileTagString!=nil){
            NSInteger profileTabTag =[profileTagString integerValue];
            if(profileTabTag == 0){
                 [_profileTabs setSelectedSegmentIndex:0];
            }else if(profileTabTag == 1){
                 [_profileTabs setSelectedSegmentIndex:1];
            }else if(profileTabTag == 2){
                 [_profileTabs setSelectedSegmentIndex:2];
            }
          }
        }else{
            [_profileTabs setSelectedSegmentIndex:1];
        }
         */
            
            
            if(profileTagString && profileTagString!=nil){
                if([[profileTagString uppercaseString] isEqualToString:@"ORDERS"]){
                    [_profileTabs setSelectedSegmentIndex:0];
                }else if([[profileTagString uppercaseString] isEqualToString:@"WISHLIST"]){
                    [_profileTabs setSelectedSegmentIndex:1];
                }else if([[profileTagString uppercaseString] isEqualToString:@"ACCOUNT"]){
                    [_profileTabs setSelectedSegmentIndex:2];
                }
            }
            }else{
              [_profileTabs setSelectedSegmentIndex:1];
            }
            
    }
    
    [self configureProfileTabScrollView];
    [self.profileScrollView bringSubviewToFront:self.profileLogoImage];

}

- (void)configureProfileHeader{
    self.profileHeaderImage = [[UIImageView alloc] init];
    [self.profileHeaderImage setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.profileHeaderImage setContentMode:UIViewContentModeScaleAspectFill];
}


- (void)configureProfileParallax{
    self.profileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 -self.headerHeight+15)];
    [self.profileScrollView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.view addSubview:self.profileScrollView];
    self.profileScrollView.delegate = self;
    [self.profileScrollView setShowsVerticalScrollIndicator:FALSE];
    //    [self.profileScrollView setParallaxHeaderView:self.profileHeaderImage mode:VGParallaxHeaderModeFill height:200];
    
    self.headerHeight = RelativeSizeHeight(80, 480);
    [self.profileScrollView setParallaxHeaderView:self.profileHeaderImage mode:VGParallaxHeaderModeFill height:self.headerHeight];
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
    
    [self.profileLogoImage setImage:[UIImage imageNamed:@"default_dp"]];
    [self.profileHeaderImage setImage:[[UIImage imageNamed:@"default_cover"] applyFyndBlurEffect]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    self.profileDataTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataURL]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){

        NSHTTPURLResponse *theURLResponse = (NSHTTPURLResponse *)response;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *downloadedImage= nil;
            
            if ([theURLResponse statusCode] == 200) {
                downloadedImage = [UIImage imageWithData:data];
                [self.profileLogoImage setImage:downloadedImage];
                [self.profileHeaderImage setImage:[downloadedImage applyFyndBlurEffect]];
            }

            

            
            gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, DeviceWidth, self.profileHeaderImage.frame.size.height)];
            gradientView.alpha = 0.8;
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = gradientView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(kSignUpColor) CGColor], (id)[[UIColor clearColor] CGColor], nil];
            [gradientView.layer insertSublayer:gradient atIndex:0];
            [self.profileHeaderImage addSubview:gradientView];
            [self.profileHeaderImage bringSubviewToFront:gradientView];
            
            [UIView animateWithDuration:0.4 animations:^{
                [self.profileHeaderImage setAlpha:1.0];
            }];
        });
        
    }];
    [self.profileDataTask resume];
}

-(void)configureProfileArcWithLogo{
    
    UIImage *img = [UIImage imageNamed:@"ArcImage"];
    UIImageView *arcImage = [[UIImageView alloc] init];
    CGFloat height = img.size.height * self.profileScrollView.frame.size.width/img.size.width;
    [arcImage setFrame:CGRectMake(0, -height, self.profileScrollView.frame.size.width, height)];
    [arcImage setImage:img];
    [self.profileScrollView addSubview:arcImage];
    
    self.profileLogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLogoWidth, kLogoWidth)];
    [self.profileLogoImage setCenter:CGPointMake(arcImage.center.x, arcImage.center.y)];
    [self.profileLogoImage setBackgroundColor:[UIColor clearColor]];
    //    [self.profileLogoImage setImage:[UIImage imageNamed:@"Logo4.png"]];
//    [self.profileLogoImage.layer setShadowColor:UIColorFromRGB(kShadowColor).CGColor];
//    [self.profileLogoImage.layer setShadowOpacity:0.8];
//    [self.profileLogoImage.layer setShadowRadius:2.0];
//        [self.profileLogoImage.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    self.profileLogoImage.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
    self.profileLogoImage.layer.cornerRadius = 3.0f;
    self.profileLogoImage.layer.borderWidth =2.0f;
    self.profileLogoImage.clipsToBounds = TRUE;
    [self.profileScrollView addSubview:self.profileLogoImage];
}



- (UIView *)configureProfileHeaderDetail{
    UIView *detail = [[UIView alloc] initWithFrame:CGRectMake(self.profileScrollView.frame.origin.x, 0, self.profileScrollView.frame.size.width, 50)];
    CGSize aSize = CGSizeZero;
    
    FyndUser *fyndUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    NSString *nameString = [NSString stringWithFormat:@"%@ %@",[fyndUser.firstName capitalizedString],[fyndUser.lastName capitalizedString]];
    aSize = [SSUtility getLabelDynamicSize:nameString withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.userName = [SSUtility generateLabel:nameString withRect:CGRectMake(self.profileScrollView.frame.size.width/2 - aSize.width/2, self.profileLogoImage.frame.origin.y + self.profileLogoImage.frame.size.height + 10, aSize.width, aSize.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [self.userName setTextColor:UIColorFromRGB(kSignUpColor)];
    [detail addSubview:self.userName];
    
//    NSString *joiningDate = fyndUser.joiningDate;
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"dd LLLL yyyy"];
//    NSDate *date = [format dateFromString:joiningDate];
//    [format setDateFormat:@"dd MMM, yyyy"];
//    joiningDate = [format stringFromDate:date];
//    NSString *joinedString = [NSString stringWithFormat:@"Joined %@", joiningDate];
//
//    aSize = [SSUtility getLabelDynamicSize:joinedString withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    UILabel *joined = [SSUtility generateLabel:joinedString withRect:CGRectMake(self.profileScrollView.frame.size.width/2 - aSize.width/2, self.userName.frame.origin.y + self.userName.frame.size.height + 5, aSize.width, aSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
//    [joined setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
//    [detail addSubview:joined];
//    [detail setFrame:CGRectMake(detail.frame.origin.x, detail.frame.origin.y, detail.frame.size.width, joined.frame.origin.y + joined.frame.size.height +15)];
    
//    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(detail.frame.origin.x, detail.frame.size.height -2, detail.frame.size.width, 1)];
//    [detail addSubview:line];
    [detail setBackgroundColor:[UIColor whiteColor]];
//    detail setFrame:CGRectMake(detail.frame.origin.x, detail.frame.origin.y,detail.frame.size.width , self.userName.frame.size.height + )
    
    
    //adding the edit icon
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.userName.frame.origin.x + self.userName.frame.size.width + 10, self.userName.frame.origin.y, 20, 20)];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"BagEdit"] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"BagEditTouch"] forState:UIControlStateHighlighted];
    [self.editButton addTarget:self action:@selector(handleEditTap) forControlEvents:UIControlEventTouchUpInside];
    [detail addSubview:self.editButton];
    
    return detail;
}

- (void)configureGenderTab{
    
    tabContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.profileHeaderDetail.frame.origin.y + self.profileHeaderDetail.frame.size.height, self.view.frame.size.width, 49)];
    [tabContainer setBackgroundColor:[UIColor whiteColor]];
    [self.profileScrollView addSubview:tabContainer];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Regular size:14], NSFontAttributeName,
                                        nil];
    
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          UIColorFromRGB(kLightGreyColor), NSForegroundColorAttributeName, [UIFont fontWithName:kMontserrat_Light size:14], NSFontAttributeName,
                                          nil];
    
    _profileTabs = [[UISegmentedControl alloc] initWithFrame:CGRectMake(8, 5, tabContainer.frame.size.width - 16, 36)];
    [_profileTabs setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [_profileTabs setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    [_profileTabs insertSegmentWithTitle:@"ORDERS" atIndex:0 animated:NO];
    [_profileTabs insertSegmentWithTitle:@"WISHLIST" atIndex:1 animated:NO];
    [_profileTabs insertSegmentWithTitle:@"ACCOUNT" atIndex:2 animated:NO];
    [_profileTabs setBackgroundColor:[UIColor whiteColor]];
    [_profileTabs setSelectedSegmentIndex:0];
    [_profileTabs setTintColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [_profileTabs addTarget:self action:@selector(changeTab) forControlEvents:UIControlEventValueChanged];
    [tabContainer addSubview:_profileTabs];
    
    self.profileOptionsFrame = tabContainer.frame;
    
}


- (void)configureProfileTabScrollView{
    
    
    CGFloat startY = self.headerHeight+self.profileHeaderDetail.frame.size.height + tabContainer.frame.size.height;
    
    self.profileTabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, tabContainer.frame.origin.y + tabContainer.frame.size.height, self.view.frame.size.width,self.view.frame.size.height - (startY+ bottomBarHeight))];

    self.profileTabScrollView.scrollEnabled = FALSE;
    self.profileTabScrollView.delegate = self;
    [self.profileTabScrollView setTag:200];
    [self.profileTabScrollView setShowsVerticalScrollIndicator:FALSE];
    [self.profileTabScrollView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    
    self.profileTabScrollView.pagingEnabled = TRUE;
    
    for(NSInteger counter=0; counter < 3; counter++){
        
        if(counter ==2){
            self.acctView = [self populateTabViewForIndex:counter];
            [self.profileTabScrollView addSubview:self.acctView];
            
            self.profileFooter = [self generateProfileFooter];
            [self.profileTabScrollView addSubview:self.profileFooter];
            
        }else if(counter == 1){
            [self createWishListContainer];
        }else{
            __weak ProfileViewController *weakSelf = self;
            [self.profileTabScrollView setContentSize:CGSizeMake(3*self.view.frame.size.width, self.profileTabScrollView.frame.size.height)];
            
//            self.myOrdersView = [[OrdersView alloc] initWithFrame:CGRectMake(6, kProfilePadding, self.view.frame.size.width-2*6, self.view.frame.size.height -(self.headerHeight + self.profileHeaderDetail.frame.size.height + tabContainer.frame.size.height + bottomBarHeight+3*kProfilePadding))];
            
            self.myOrdersView = [[OrdersView alloc] initWithFrame:CGRectMake(6, kProfilePadding, self.view.frame.size.width-2*6, 300)];
//            self.myOrdersView = [[OrdersView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - (self.headerHeight + self.profileHeaderDetail.frame.size.height + tabContainer.frame.size.height + bottomBarHeight+3*kProfilePadding))];


            
            self.myOrdersView.orderViewDelegate = self;
            [self.myOrdersView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

            [self.profileTabScrollView addSubview:self.myOrdersView];
            if(!isOrderViewOberverAdded){
                [self addObserver:self forKeyPath:@"self.myOrdersView.frame" options:NSKeyValueObservingOptionOld context:NULL];
                isOrderViewOberverAdded = true;
            }
            
            if(isWishListViewObserverAdded){
                @try{
                    [self removeObserver:self forKeyPath:@"self.myWishListView.frame" context:NULL];
                    isWishListViewObserverAdded = false;

                }@catch(id anException){
                    //do nothing, obviously it wasn't attached because an exception was thrown
                }
            }
            
            self.myOrdersView.theExchangeBlock= ^(NSString *theOrderId, ShipmentItem *theExchangeItem, NSDictionary *theExchangeDic){
                //TODO - Get the Address and show the Pop UP
                
                weakSelf.myOrderID = [NSString stringWithFormat:@"%@",theOrderId];
                weakSelf.myOrderShipmentItem = theExchangeItem;
//                   NSMutableArray * itemSizes = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *sizeArray = [theExchangeDic objectForKey:@"sizes"];
                if ([sizeArray count] == 0) {
                    [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process exchange" andColor:UIColorFromRGB(kRedColor)];
                }else{
//                    for(NSInteger counter=0; counter < [sizeArray count]; counter++){
//                        NSDictionary *sizeDict = [sizeArray objectAtIndex:counter];
//                        ProductSize *size = [[ProductSize alloc] initWithDictionary:sizeDict];
//                        [itemSizes addObject:size];
//                    }
                    
                    [weakSelf showItemSizesPopUp:[sizeArray mutableCopy] forExchange:TRUE];
                }

                
                
//                theAddressView.totalAmount = [NSString stringWithFormat:@"%@",theExchangeItem.price];
//                theAddressView.theShipmentItem = theExchangeItem;
//                theAddressView.cartMetaDictionary = theExchangeDic;
//                theAddressView.theShippingModel = [theExchangeDic[@"order_address"] objectAtIndex:0];
//                theAddressView.theAddressEnum = AddressTimeScreenTypeExchange;
//                theAddressView.orderId = theOrderId;
//                [weakSelf.navigationController pushViewController:theAddressView animated:TRUE];
            };

            self.myOrdersView.theReturnBlock = ^(NSString *orderID,ShipmentItem *theReturnItem, NSDictionary *theDic, NSString *cost){

                weakSelf.myOrderID = [NSString stringWithFormat:@"%@",orderID];
                weakSelf.myOrderShipmentItem = theReturnItem;
                
                NSMutableArray *reasonsArray = [theDic objectForKey:@"return_reasons"];
                if ([reasonsArray count] == 0) {
                    [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process return" andColor:UIColorFromRGB(kRedColor)];
                }else{
                    [weakSelf showItemSizesPopUp:reasonsArray forExchange:FALSE];
                }

                
                
                
//                theAddressView.totalAmount = [NSString stringWithFormat:@"%@",theReturnItem.price];
//                //TODO - set the address here.
//                theAddressView.theShipmentItem = theReturnItem;
//                theAddressView.cartMetaDictionary = theDic;
//                theAddressView.theShippingModel = [theDic[@"order_address"] objectAtIndex:0];
//                theAddressView.orderId = orderID;
//                theAddressView.theAddressEnum = AddressTimeScreenTypeReturn;
//                theAddressView.itemCost = cost;
//                [weakSelf.navigationController pushViewController:theAddressView animated:TRUE];
            };
            ProfileViewController *profileCtrl = self;
            self.myOrdersView.theCancelBlock = ^(NSString *orderID, NSString *cost){
                weakSelf.cancelOrderID = orderID;
                weakSelf.cancelCost = cost;

                if(self.profileOverlay == nil)
                    profileCtrl.profileOverlay = [[PopOverlayHandler alloc] init];
                
                profileCtrl.profileOverlay.overlayDelegate = profileCtrl;
                
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"Cancel Order" forKey:@"Alert Title"];
                [parameters setObject:@"NO" forKey:@"LeftButtonTitle"];
                [parameters setObject:@"YES" forKey:@"RightButtonTitle"];
                [parameters setObject:[NSNumber numberWithInt:CustomAlertCancelOrder] forKey:@"PopUpType"];
                [parameters setObject:@"Are you sure you want to cancel this order?" forKey:@"Alert Message"];
                [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
                [profileCtrl.profileOverlay presentOverlay:CustomAlertCancelOrder rootView:profileCtrl.view enableAutodismissal:TRUE withUserInfo:parameters];
            };

            self.myOrdersView.theCallBlock = ^(){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",@"+918767087087"]]];
                
            };
            
        }
    }
    [self.profileScrollView addSubview:self.profileTabScrollView];
}


//-(void)changeCategory:(id)sender{
-(void)changeTab{

    if(isWishListViewObserverAdded){
        @try{
            [self removeObserver:self forKeyPath:@"self.myWishListView.frame" context:NULL];
            isWishListViewObserverAdded = false;
        }@catch(id anException){
        }
    }
    
    if(_profileTabs.selectedSegmentIndex == 0){
        [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.contentSize.width, self.myOrdersView.frame.origin.y + self.myOrdersView.frame.size.height)];
        
        if(self.myOrdersView){
            [self.myOrdersView getData];
        }
        
        if(!isOrderViewOberverAdded){
            [self addObserver:self forKeyPath:@"self.myOrdersView.frame" options:NSKeyValueObservingOptionOld context:NULL];
            isOrderViewOberverAdded = true;
        }
        if(isWishListViewObserverAdded){
            @try{
                [self removeObserver:self forKeyPath:@"self.myWishListView.frame" context:NULL];
                isWishListViewObserverAdded = false;
            }@catch(id anException){
            }
        }
        
    }else if (_profileTabs.selectedSegmentIndex == 1){

        [self.profileScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.myWishListView.wishListGridView.collectionView.frame.size.height +footerHeight)];
        
        if (self.myWishListView) {
            [self.myWishListView configureWishList];
            if(!isWishListViewObserverAdded){
                [self addObserver:self forKeyPath:@"self.myWishListView.frame" options:NSKeyValueObservingOptionOld context:NULL];
                isWishListViewObserverAdded = true;
            }
            if(isOrderViewOberverAdded){
                @try{
                    [self removeObserver:self forKeyPath:@"self.myOrdersView.frame" context:NULL];
                    isOrderViewOberverAdded = false;
                }@catch(id anException){
                }
            }
        }

    }else if (_profileTabs.selectedSegmentIndex == 2){
        [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.profileFooter.frame.origin.y + self.profileFooter.frame.size.height + kProfilePadding)];
        [self.profileScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.profileTabScrollView.frame.size.height + footerHeight + kProfilePadding)];
    }
    
    [self.profileTabScrollView scrollRectToVisible:CGRectMake(self.profileTabScrollView.frame.size.width * _profileTabs.selectedSegmentIndex, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.profileTabScrollView.frame.size.height) animated:NO];
}


- (MyAccountView *)populateTabViewForIndex:(NSInteger)index{
    MyAccountView *accountView = [[MyAccountView alloc] initWithFrame:CGRectMake(tabContainer.frame.size.width*index, 10, tabContainer.frame.size.width, 430)];
    accountView.detailDelegate = self;

    [accountView setUpMyAccountOptions];
    
    return accountView;
}

- (UIView *)generateProfileFooter{
    
//    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.acctView.frame.origin.x, self.acctView.frame.origin.y + self.acctView.frame.size.height-RelativeSizeHeight(120, 667), self.view.frame.size.width, footerHeight)];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.acctView.frame.origin.x, self.acctView.frame.origin.y + self.acctView.frame.size.height - footerHeight - 15, self.view.frame.size.width, footerHeight)];

    [aView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    NSString * version = nil;
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (!version) {
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    }
    NSString *appVersionText = [NSString stringWithFormat:@"APP VERSION - %@",version];
    UIFont *verFont = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    CGSize versionSize = [SSUtility getLabelDynamicSize:appVersionText withFont:verFont withSize:CGSizeMake(MAXFLOAT, 40)];
    UILabel *appVersion = [SSUtility generateLabel:appVersionText withRect:CGRectMake(aView.frame.size.width/2 - versionSize.width/2, 0, versionSize.width, 40) withFont:verFont];
    [appVersion setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [aView addSubview:appVersion];
    
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.layer.cornerRadius = 3.0f;
    signOut.layer.borderColor = UIColorFromRGB(kSignUpColor).CGColor;
    signOut.layer.borderWidth = 1.0f;
    [signOut setFrame:CGRectMake(10, appVersion.frame.origin.y + appVersion.frame.size.height + 10, self.view.frame.size.width-20, 40)];
    [signOut addTarget:self action:@selector(logoutUser) forControlEvents:UIControlEventTouchUpInside];
    [signOut setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [signOut setTitle:@"SIGN OUT" forState:UIControlStateNormal];
    [signOut setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D4D5)] forState:UIControlStateHighlighted];
    [signOut setTitleColor:UIColorFromRGB(kSignUpColor) forState:UIControlStateNormal];
    signOut.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:12.0f];
    [aView addSubview:signOut];
    
    return aView;
}

- (void)createWishListContainer{
    self.myWishListView =[[WishListView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - (self.headerHeight + self.profileHeaderDetail.frame.size.height + tabContainer.frame.size.height + bottomBarHeight+3*kProfilePadding))];
    self.myWishListView.delegate = self;
    __weak ProfileViewController *theWeakSelf = self;
    self.myWishListView.thePDPCallback = ^(NSString *theURL){
        if(theWeakSelf.pdpController){
            theWeakSelf.pdpController = nil;
        }
        theWeakSelf.pdpController = [[PDPViewController alloc] init];
        theWeakSelf.pdpController.productURL = theURL;
        [theWeakSelf.navigationController pushViewController:theWeakSelf.pdpController animated:YES];
    };
    self.myWishListView.wishListViewBlock=^(){
        [theWeakSelf.tabBarController setSelectedIndex:0];
    };
    [self.profileTabScrollView addSubview:self.myWishListView];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"self.myWishListView.frame"]) {

        if(self.profileTabs.selectedSegmentIndex == 1){
            
            [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.myWishListView.frame.origin.y + self.myWishListView.frame.size.height + 10)];
            [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.contentSize.width, self.profileTabScrollView.frame.origin.y + self.profileTabScrollView.frame.size.height)];
        }
        
    }else if([keyPath isEqualToString:@"self.myOrdersView.frame"]) {
        if(self.profileTabs.selectedSegmentIndex == 0){
            [UIView animateWithDuration:0.5 animations:^{
                [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.myOrdersView.frame.origin.y + self.myOrdersView.frame.size.height + 10)];
                [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.contentSize.width, self.profileTabScrollView.frame.origin.y + self.profileTabScrollView.frame.size.height)];
            }];
        }
    }
}



#pragma mark MyAccoutView Delegate
- (void)selectedDetailOption:(MyAccountOptionsData *)optionData{
    if(optionData.optionDetailType == AccountDetailMyBrands){
        BrandsVIewController *brandController = [[BrandsVIewController alloc] init];
        brandController.isProfileBrand = TRUE;
        [self.navigationController pushViewController:brandController animated:FALSE];
    }
    else if(optionData.optionDetailType == AccountDetailMyCollections){
        CollectionsViewController *collectionController = [[CollectionsViewController alloc] init];
        collectionController.isProfileCollection = TRUE;
        [self.navigationController pushViewController:collectionController animated:FALSE];
    }
    else if(optionData.optionDetailType == AccountDetailRateUS){
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[NSNumber numberWithInt:RateUsOverlay] forKey:@"PopUpType"];
        
        self.profileOverlay = [[PopOverlayHandler alloc] init];
        self.profileOverlay.overlayDelegate  = self;
        [self.profileOverlay presentOverlay:RateUsOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
        
    }
    else if (optionData.optionDetailType == AccountDetailChangePassword){
        UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SendOTPViewController *theSendOTP = (SendOTPViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SendOTPViewController"];
        
        theSendOTP.mobileNumber = [(FyndUser *)[SSUtility loadUserObjectWithKey:kFyndUserKey] mobileNumber];
        theSendOTP.sourceOption = OTPNavigatedFromChangePassword;
        //        theSendOTP.changePassword = TRUE;
        [self.navigationController pushViewController:theSendOTP animated:FALSE];
    }
    else if(optionData.optionDetailType == AccountDetailCallUS){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",@"+918767087087"]]];
    }
    else if (optionData.optionDetailType == AccountDetailShippingAddress){
        ShippingAddressListViewController *theAddressList = [[ShippingAddressListViewController alloc] init];
        theAddressList.theShippingEnum = ShippingAddressProfile;
        [self.navigationController pushViewController:theAddressList animated:FALSE];
    }
    else if(optionData  .optionDetailType == AccountDetailPayments){
        PaymentController *paymentController = [[PaymentController alloc] init];
        paymentController.paymentMode = PaymentScreenTypeProfile;
        
        [self.navigationController pushViewController:paymentController animated:FALSE];
    }
    else{
        MyAccountDetailViewController *accountDetailController = [[MyAccountDetailViewController alloc] init];
        accountDetailController.detailTitle = optionData.optionTitle;
        accountDetailController.type = optionData.optionDetailType;
        accountDetailController.profileDetailDelegate = self;

        __weak ProfileViewController *profileController = self;
        accountDetailController.refreshUserImage = ^(NSString *imagePath){
            [profileController downloadUpdatedUserImage:imagePath];
        };
        
        [self.navigationController pushViewController:accountDetailController animated:FALSE];
    }
}

- (void)moreOptionsDisplaying:(BOOL)isMore{

    if(isMore){

        [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.profileTabScrollView.frame.size.height + 176)];

        [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.contentSize.width, self.profileTabScrollView.frame.size.height+176)];
        
        [self.profileFooter setFrame:CGRectMake(self.acctView.frame.origin.x, self.acctView.frame.origin.y + self.acctView.frame.size.height-RelativeSizeHeight(120, 667), self.view.frame.size.width, footerHeight)];
    }else{

        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.profileTabScrollView.frame.size.height - 176)];
        [self.profileScrollView setContentSize:CGSizeMake(self.profileScrollView.contentSize.width, self.profileTabScrollView.frame.size.height+130)];
        [self.profileFooter setFrame:CGRectMake(self.acctView.frame.origin.x, self.acctView.frame.origin.y + self.acctView.frame.size.height-RelativeSizeHeight(120, 667), self.view.frame.size.width, footerHeight)];
    }
    
}



#pragma mark PopOver Delegate
- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
    
    if(tag==-1){ //If user click on cancel then this will execute
        [self.profileOverlay dismissOverlay];
        return;
    }
    switch (type) {
        case CustomAlertSignOut:
            [self.profileOverlay dismissOverlay];
            if(tag == 200){
                [self logOutUser];
            }
            break;
            
        case CustomAlertCancelOrder:
            [self.profileOverlay dismissOverlay];
                if(tag == 200){
                    [self cancelOrder];
                }
                break;
            
            
       case RateUsOverlay:
            
            if ([dictionary[@"action"] isEqualToString:@"email"]) {
                _mail = [[MFMailComposeViewController alloc] init];
                _mail.mailComposeDelegate = self;
                
                
                [_mail setToRecipients:@[kFeedbackEmailAddress]];
                
                [self presentViewController:_mail animated:YES completion:NULL];
                
            }else{
                NSString *iTunesLink = kAppStoreAppLink;
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
            break;
            
        case ExchangeProductOverlay:
            
            _theSizeModel = [dictionary[@"selectedSizeData"] objectAtIndex:0];
            [self processExchange];
            
            break;
            
            
         case ReturnReasonsOverlay:
            if (self.returnReasonsArray == nil) {
                self.returnReasonsArray = [[NSArray alloc] init];
            }
            self.returnReasonsArray = (NSArray *)dictionary[@"reasons"];
            [self proceedToReason];
            
            break;
            
        default:
            break;
            
    }
    
    
}
#pragma mark - Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Thanks for your feedback" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [_mail dismissViewControllerAnimated:TRUE completion:nil];
}


- (void)downloadUpdatedUserImage:(NSString *)imageString{
    FyndUser *userProfile = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    if(self.profileHeaderDetail){
        [self.profileHeaderDetail removeFromSuperview];
        self.profileHeaderDetail = nil;
    }
    self.profileHeaderDetail = [self configureProfileHeaderDetail];
    [self.profileScrollView addSubview:self.profileHeaderDetail];
    [self.profileScrollView bringSubviewToFront:self.profileLogoImage];

    [self downloadProfileCover:imageString];
    userProfile.profilePicUrl = imageString;
    [SSUtility saveCustomObject:userProfile];
}

#pragma mark UIScrollView Delegate Methods

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 300) {
        scrollView.userInteractionEnabled = NO;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.tag != 200){
        
        if(scrollView.contentOffset.y + 44>= self.profileOptionsFrame.origin.y){
            [tabContainer setFrame:CGRectMake(tabContainer.frame.origin.x, scrollView.contentOffset.y + 44, tabContainer.frame.size.width, tabContainer.frame.size.height)];
            [self.profileScrollView bringSubviewToFront:tabContainer];
        }else{
            
            [tabContainer setFrame:CGRectMake(tabContainer.frame.origin.x, self.profileOptionsFrame.origin.y, tabContainer.frame.size.width, tabContainer.frame.size.height)];
        }
        
        if (scrollView.contentOffset.y<=0) {
//            [notificationIcon setImage:[UIImage imageNamed:@"NotificationWhite"]];
            self.navigationItem.title = @"";
            [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            isNavBarVisible = false;
            
        }else {
        FyndUser *userData = [SSUtility loadUserObjectWithKey:kFyndUserKey];
//        [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
            isNavBarVisible = true;
            self.navigationItem.title = [[NSString stringWithFormat:@"%@ %@", userData.firstName, userData.lastName] capitalizedString];
            [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
            [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xF2F2F2)];
//            [self.navigationController.navigationBar changeNavigationBarToTransparent:NO];

        }
        [self updateNotificationIcon];
    }
    
    [self.profileScrollView shouldPositionParallaxHeader];
    
    
    if(scrollView.tag == 200){
        if ([scrollView isDecelerating] && scrollView.tag == 200) {
            CGFloat pageWidth = self.profileTabScrollView.frame.size.width;
            int page = floor((self.profileTabScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            
            if(page ==2){ // this check need to be based on tag
                //        [self.profileTabScrollView setContentSize:CGSizeMake(3*self.view.frame.size.width, 1050)];
                [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, 900+footerHeight)];
                
                [self.profileScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 1050 +footerHeight)];
            }else if(page ==0){
                [self.profileScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.frame.size.height - self.headerHeight)];
            }
            else if(page ==1){
                [self.profileTabScrollView setFrame:CGRectMake(self.profileTabScrollView.frame.origin.x, self.profileTabScrollView.frame.origin.y, self.profileTabScrollView.frame.size.width, self.myWishListView.wishListGridView.collectionView.frame.size.height)];
                [self.profileScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.myWishListView.wishListGridView.collectionView.frame.size.height +footerHeight)];
                
            }
            
        }
    }else{
        if(scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 100 && scrollView.contentOffset.y > 0 && !self.myWishListView.isFetching ){
            if(self.myWishListView.hasNext){
                [self.myWishListView reloadWishList];            }
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    CGFloat pageWidth = self.profileTabScrollView.frame.size.width;
//    int page = floor((self.profileTabScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (scrollView.tag == 300) {
        scrollView.userInteractionEnabled = TRUE;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)logoutUser{
    
    if(self.profileOverlay == nil)
        self.profileOverlay = [[PopOverlayHandler alloc] init];
    
    self.profileOverlay.overlayDelegate = self;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:@"Sign Out" forKey:@"Alert Title"];
    [parameters setObject:@"NO" forKey:@"LeftButtonTitle"];
    [parameters setObject:@"YES" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInt:CustomAlertSignOut] forKey:@"PopUpType"];
    [parameters setObject:@"Are you sure you want to sign out?" forKey:@"Alert Message"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
    
    
    [self.profileOverlay presentOverlay:CustomAlertSignOut rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        if (alertView.tag == 3130) {
            [self cancelOrder];
        }else{
            [self logOutUser];
        }

    }
}

-(void)cancelOrder{
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
    
    if (profileHandler == nil) {
        profileHandler = [[ProfileRequestHandler alloc] init];
    }
    NSMutableDictionary *theParam = [[NSMutableDictionary alloc] init];
    [theParam setObject:self.cancelOrderID forKey:@"order_id"];
    
    [profileHandler cancelOrder:theParam withCompletionHandler:^(id responseData, NSError *error) {
        if (!error) {
            
            
            
            if([responseData[@"success"] boolValue]){
                //refresh the profile
                if (self.myOrdersView) {
                    [self.myOrdersView getData];
                }
            [FyndAnalytics trackCancelOrder:self.cancelCost];
            }else{
                //Some Error to cancel the order.
            }
        }
    }];
    
}

- (void)logOutUser{
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
    
    [userAuthenticationHandler logoutUserWithCompletionHandler:^(id responseData, NSError *error) {
        if(!error){
            [profileLoader stopAnimating];
            [profileLoader removeFromSuperview];
            if([[[responseData objectForKey:@"message"] uppercaseString] isEqualToString:@"SUCCESS"]){
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                NSDate *now = [NSDate date];
                NSString *string = [formatter stringFromDate:now];

                [FyndAnalytics endSessionTracking:string];
                [FyndAnalytics trackLogoutEvent:string];
                
                Mixpanel *instance = [Mixpanel sharedInstance];
                [instance flushWithCompletion:^{
                    [instance reset];
                }];
                
                [SSUtility deleteUserDataForKey:kFyndUserKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutUser" object:nil];
            }else{
            }
        }
    }];
}


-(void)showLoader{
    [profileLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 80)];
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
}


-(void)dismissLoader{
    [profileLoader stopAnimating];
    [profileLoader removeFromSuperview];
}

#pragma mark - orderView delegate
-(void)productTileTapped:(NSString *)actionURL{
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = actionURL;
    [self.navigationController pushViewController:self.pdpController animated:YES];
}

- (void)handleOrderlBlankPageAction{
    [self.tabBarController setSelectedIndex:0];
}

-(void)handleEditTap{
    MyAccountOptionsData *data = [[MyAccountOptionsData alloc] init];
    data.optionTitle = @"Edit Profile";
    data.optionImageName = @"EditProfile";
    data.optionDetailType = AccountDetailEditProfile;
    
    [self selectedDetailOption:data];
}

-(void)dealloc{
    if(self.myOrdersView){
        [self.myOrdersView releaseResources];
    }
}


#pragma mark - Show ExchangePop Up

- (void)showItemSizesPopUp:(NSMutableArray *)array forExchange:(BOOL)isExchange{
    
    if(self.profileOverlay){
        self.profileOverlay.overlayDelegate = nil;
        self.profileOverlay = nil;
    }
    self.profileOverlay = [[PopOverlayHandler alloc] init];
    self.profileOverlay.overlayDelegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    
    [parameters setObject:[NSNumber numberWithBool:isTryAtHomeFirstTime] forKey:@"TryAtHomeModuleType"];
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"maxSizeSelection"];
    
    if (isExchange) {
        [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
        [parameters setObject:@"EXCHANGE" forKey:@"RightButtonTitle"];
        [parameters setObject:array forKey:@"PopUpData"];
        [parameters setObject:[NSNumber numberWithInt:ExchangeProductOverlay] forKey:@"PopUpType"];
        
    }else{
        [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
        [parameters setObject:@"RETURN" forKey:@"RightButtonTitle"];
        [parameters setObject:array forKey:@"ResponseData"];
        [parameters setObject:[NSNumber numberWithInt:ReturnReasonsOverlay] forKey:@"PopUpType"];
    }

    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
    

    if(isExchange)
        [self.profileOverlay presentOverlay:SizeGuideOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
    else{
        [self.profileOverlay presentOverlay:ReturnReasonsOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
        
    }
}

-(void)processExchange{
    if (theCartHandler == nil) {
        theCartHandler = [[CartRequestHandler alloc] init];
    }
    [self.profileOverlay dismissOverlay];
    [self.view addSubview:profileLoader];
    [profileLoader startAnimating];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:self.myOrderID forKey:@"order_id"];
    [params setObject:[NSString stringWithFormat:@"%d",(int)self.myOrderShipmentItem.bagId] forKey:@"bag_id"];
    [params setObject:[NSString stringWithFormat:@"%@",_theSizeModel.articleId] forKey:@"article_id"];

    [theCartHandler exchangeItemWithParams:params withCompletionHandler:^(id responseData, NSError *error) {
        if (!error) {
            [profileLoader removeFromSuperview];
            [profileLoader stopAnimating];
            if ([responseData[@"success"] boolValue]) {
                [FyndAnalytics trackExchangeOrder];

                [self changeTab];
            }else{
                [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process exchange." andColor:UIColorFromRGB(kRedColor)];
            }
        }else{
            [profileLoader removeFromSuperview];
            [profileLoader stopAnimating];
            [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process exchange." andColor:UIColorFromRGB(kRedColor)];
            
        }
    }];
}

-(void)proceedToReason{
    NSMutableArray *reasonArray = [[NSMutableArray alloc] init];
    
    if ([self.returnReasonsArray count]>0) {
        
        NSMutableArray *reasonsID = [[NSMutableArray alloc] init];
        
        [self.returnReasonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ReturnReasons *theReason = (ReturnReasons *)obj;
            [reasonsID addObject:theReason.reasonId];
            [reasonArray addObject:theReason.reason];
        }];
        
        if (theCartHandler == nil) {
            theCartHandler = [[CartRequestHandler alloc] init];
        }

        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:self.myOrderID forKey:@"order_id"];
        [params setObject:[NSString stringWithFormat:@"%d",(int)self.myOrderShipmentItem.bagId] forKey:@"bag_id"];
        [params setObject:reasonsID forKey:@"reasons"];

        [self.profileOverlay dismissOverlay];
        
        [self.view addSubview:profileLoader];
        [profileLoader startAnimating];
        
        [theCartHandler returnItemWithParams:params withCompletionHandler:^(id responseData, NSError *error) {
            if (!error) {
                
                [profileLoader removeFromSuperview];
                [profileLoader stopAnimating];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                NSDate *now = [NSDate date];
                NSString *string = [formatter stringFromDate:now];
                
                if ([responseData[@"success"] boolValue]) {
                    
                    [FyndAnalytics trackReturnBag:@{@"value" : self.myOrderShipmentItem.price, @"reason": reasonArray, @"last_return_date":string}];

                    [self changeTab];
                    
                }
            }else{
                [profileLoader removeFromSuperview];
                [profileLoader stopAnimating];
                //TODO - Show Error
                [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process return." andColor:UIColorFromRGB(kRedColor)];
            }
        }];
    }else{
        //TODO - Show Error
        [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process return" andColor:UIColorFromRGB(kRedColor)];
    }
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
