//
//  FeedViewController.m
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FeedViewController.h"
#import "BrandsGrid.h"
#import "CollectionGrid.h"
#import "SSUtility.h"
#import "BrowseByCategoryViewController.h"
//#import <Google/Analytics.h>
#import "FyndAnalytics.h"
#import "TabBarViewController.h"
#import "FyndBlankPage.h"
#import "DeepLinkerHandler.h"

@interface FeedViewController ()<GridViewDelegate>
{
    CGSize productAspectRatioSize;
    SearchViewController *theSearchViewController;
    
    BOOL hideBars;
    BOOL isScrolling;
}
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSInteger frameCount;
@property (nonatomic,strong) FyndBlankPage *feedBlankPage;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    // This code will work in iOS 7.0 and below:
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    
    pageNumber = 1;
    isFetching = false;
    parsedDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationView = [self configureNavigationView:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] capitalizedString]];
    self.navigationItem.titleView = self.navigationView;
    
    self.feedRquestHandler = [[HomeRequestHandler alloc] init];
        [super viewDidLoad];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];

    [self.navigationController.view setBackgroundColor:[UIColor clearColor]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];

    feedGrdidView = [[GridView alloc] initWithFrame:CGRectMake(0, RelativeSize(3, 320), self.view.frame.size.width, self.view.frame.size.height - 64)];
    feedGrdidView.delegate = self;

    indicator = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [indicator setCenter:CGPointMake(feedGrdidView.frame.size.width/2, feedGrdidView.frame.size.height/2 - 30)];

    
    [self getData];
    
    searchButton = [[UIBarButtonItem alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"SearchBrowse"]];
    [searchButton setTarget:self];
    [searchButton setAction:@selector(beginSearch)];
    
    self.navigationItem.rightBarButtonItems = @[searchButton];

    notificationIcon = [[UIBarButtonItem alloc] init];
    [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
    [notificationIcon setTarget:self];
    [notificationIcon setAction:@selector(showNotifications)];
    

    self.navigationItem.leftBarButtonItem = notificationIcon;
}

-(void)showNotifications{
    NotificationViewController *notificationController = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationController animated:YES];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (UIView *)configureNavigationView:(NSString *)optionString{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 200, 40)];
    [navigationView setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchLocation)];
    [navigationView addGestureRecognizer:gesture];
    CGSize aSize = [SSUtility getLabelDynamicSize:optionString withFont:[UIFont fontWithName:kMontserrat_Light size:16.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *navigationViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationView.frame.size.width/2 - aSize.width/2,navigationView.frame.size.height/2 - aSize.height/2 , aSize.width, aSize.height)];
    [navigationViewLabel setBackgroundColor:[UIColor clearColor]];
    [navigationViewLabel setText:optionString];
    [navigationViewLabel setFont:[UIFont fontWithName:kMontserrat_Light size:16.0]];
    [navigationViewLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationViewLabel setTextColor:UIColorFromRGB(kSignUpColor)];
    [navigationView addSubview:navigationViewLabel];
    
    UIImage *image = [UIImage imageNamed:@"Down"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(navigationViewLabel.frame.origin.x + navigationViewLabel.frame.size.width, navigationViewLabel.frame.size.height - image.size.height/2, image.size.width, image.size.height)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(imageView.center.x, navigationView.frame.size.height/2)];
    [navigationView addSubview:imageView];
    
    return navigationView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];

   
    [self updateNotificationIcon];
    
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];

    if(![[city lowercaseString] isEqualToString:[[userDefaults objectForKey:@"city"] lowercaseString]])
    {
        latitude = [[userDefaults objectForKey:@"latitude"] stringValue];
        longitude = [[userDefaults objectForKey:@"longitude"] stringValue];
        city = [[userDefaults objectForKey:@"city"] lowercaseString];
        [self getNewFeedDataWithOrderID:nil];
    }
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults valueForKey:@"isLaunchedFromOtherApp"]){
        NSString *url = [userDefaults objectForKey:@"openingURL"];
        if([userDefaults objectForKey:@"suppressGender"]){
            self.suppressGender = [[userDefaults objectForKey:@"suppressGender"] boolValue];
        }
        if([[userDefaults objectForKey:@"shouldShow"] isEqualToString:@"Product"]){
            [self showPDPScreen:url];
        }else if([[userDefaults objectForKey:@"shouldShow"] isEqualToString:@"Brand"]){
            [self showBrowseByBrandPage:url];
        }else if([[userDefaults objectForKey:@"shouldShow"] isEqualToString:@"Collection"]){
            [self showBrowseByCollectionPage:url];
        }
        [userDefaults removeObjectForKey:@"isLaunchedFromOtherApp"];
        [userDefaults removeObjectForKey:@"openingURL"];
        [userDefaults removeObjectForKey:@"suppressGender"];
        [userDefaults removeObjectForKey:@"shouldShow"];
    }
    else if([userDefaults boolForKey:@"isLaunchedFrom3DTouch"]){

        NSInteger tag = [[userDefaults objectForKey:@"3DTouchOptionType"] integerValue];
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        int controlCount =(int)[[(UINavigationController *)window.rootViewController viewControllers] count];
        if (controlCount >=2)
        {
            NSArray *viewControllersArray = [(UINavigationController *)[window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];
            
            [tabController setSelectedIndex:tag];
            UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:tag];
            [navBarController popToRootViewControllerAnimated:NO];
        }
    
        [userDefaults setBool:NO forKey:@"isLaunchedFrom3DTouch"];
    }
    
    if([[userDefaults objectForKey:@"loggedOutUserClickBranchLink"] boolValue]){
        [DeepLinkerHandler sharedSingleton];
        [DeepLinkerHandler navigateViaParams:[userDefaults objectForKey:@"BranchServiceResponse"]];
    }
    /*
    else if([userDefaults valueForKey:@"isLaunchedViaBranch"]){
        
//        NSLog(@"Branch Deep Link Url (Feed ViewWillAppear)......   %@",[userDefaults valueForKey:@"BranchDeepLinkUrl"]);
//        
//        [DeepLinkerHandler sharedSingleton];
//        BranchScreenType type =  [DeepLinkerHandler brandModuleType:[userDefaults valueForKey:@"BranchDeepLinkUrl"]];
//        
//        if(type == BranchScreenCollections){
//            [self showCollectionsScreen:nil];
//        }else if(type == BranchScreenBrands){
//            [self showBrandsScreen:nil];
//        }
//        else if(type == BranchScreenBrandPage){
//            
//
             NSMutableString *paramsString = [[NSMutableString alloc] init];
             NSArray *params  = [userDefaults objectForKey:@"BranchParameters"];
             for(NSInteger counter=0; counter < [params count]; counter++){
             NSDictionary *dict = [params objectAtIndex:counter];
             NSString *key = [[dict allKeys] objectAtIndex:0];
             [paramsString appendString:key];
             [paramsString appendString:@"="];
             [paramsString appendString:[dict objectForKey:key]];
             if(counter != ([params count]-1))
             [paramsString appendString:@"&"];
             }
             NSLog(@"... paramsString ....   %@",paramsString);
             
             NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
             [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?%@",paramsString]];
             [self showBrowseByBrandPage:theURL];
//
//        }
        
    }
     */
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:TRUE];
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self resetBars];
}

-(void)getData{
    
    if([userDefaults valueForKey:@"latitude"] && [userDefaults valueForKey:@"longitude"]){
        latitude = [[userDefaults valueForKey:@"latitude"] stringValue];
        longitude = [[userDefaults valueForKey:@"longitude"] stringValue];
        city = [[userDefaults valueForKey:@"city"] lowercaseString];
    }
    
    [self.view addSubview:indicator];
    [indicator startAnimating];
    if(self.feedBlankPage){
        [self.feedBlankPage removeFromSuperview];
        self.feedBlankPage = nil;
    }
    [self.feedRquestHandler fetchFeedDataWithParams:@{@"page":@"1"} withCompletionHandler:^(id responseData, NSError *error) {
        NSMutableDictionary *json = nil;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kShowWelcomeCard])
        {
            NSDictionary *theJSON = responseData;
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:kShowWelcomeCard];
            NSMutableDictionary *welcomeCard = [[NSMutableDictionary alloc] init];
            [welcomeCard setObject:@"welcome" forKey:@"tile_type"];
            [welcomeCard setObject:[NSNumber numberWithBool:FALSE] forKey:@"isOrderCard"];
            [welcomeCard setObject:[NSNumber numberWithInt:2] forKey:@"tile_size"];
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[theJSON objectForKey:@"items"]];
            [array insertObject:welcomeCard atIndex:0];
            
            NSMutableDictionary *mutableJson = [[NSMutableDictionary alloc] initWithDictionary:theJSON];
            [mutableJson setObject:array forKey:@"items"];
            json = mutableJson;
        }
        else{
            json = responseData;
            
            
            BOOL newOffers = [responseData[@"new_offers"] boolValue];

            if(newOffers){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:newOffers forKey:kNewNotificationKey];
            }
            [self updateNotificationIcon];
            
            
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"Feed.json" ofType:nil];
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            NSDictionary *tempJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//            json = [tempJson mutableCopy];
        }
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        
        if(!error){

            if(json!=nil && [json count] > 0){
                hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
                if(!hasNext){
                    feedGrdidView.shouldHideLoaderSection = YES;
                }else{
                    feedGrdidView.shouldHideLoaderSection = NO;
                }
                [feedGrdidView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:feedGrdidView]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.view addSubview:feedGrdidView];
                    [feedGrdidView addCollectionView];
                    isFetching = false;
                    
                });
            }else{
                [self showBlankPage];
            }
        }else{
            [self showBlankPage];
        }
    }];
}

-(void)updateNotificationIcon{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL newNotifications = [defaults boolForKey:kNewNotificationKey];
    if(newNotifications){
        [notificationIcon setImage:[[UIImage imageNamed:@"NotificationActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }else{
        [notificationIcon setImage:[UIImage imageNamed:@"Notification"]];
    }
}


- (void)tapOnRetry{
    if(self.feedBlankPage){
        [self.feedBlankPage removeFromSuperview];
        self.feedBlankPage = nil;
    }
    
    [self getData];
}

- (void)showBlankPage{
    
    if(self.feedBlankPage){
        [self.feedBlankPage removeFromSuperview];
        self.feedBlankPage = nil;
    }
    self.feedBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20 -44 -64) blankPageType:ErrorSystemDown];
    [self.feedBlankPage setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.feedBlankPage];
    FeedViewController *feedScreen = self;
    self.feedBlankPage.blankPageBlock=^(){
        [feedScreen tapOnRetry];
    };
}


#pragma mark GridView Delegate Method


-(void)gridViewDidScroll:(UIScrollView *)scrollView{
  
    [self manageBarsWithScroll:scrollView forGridView:feedGrdidView];
//    if([feedGrdidView.parsedDataArray count] > 0){
//        if([[[feedGrdidView.parsedDataArray objectAtIndex:0] objectForKey:@"height"] floatValue] < scrollView.contentOffset.y){
//            if([[[feedGrdidView.parsedDataArray objectAtIndex:0] objectForKey:@"values"] isKindOfClass:[HTMLTileModel class]]){
//                HTMLTileModel *htmlModel = (HTMLTileModel *)[[feedGrdidView.parsedDataArray objectAtIndex:0] objectForKey:@"values"];
//                if(htmlModel.toBeRemoved){
//                    [feedGrdidView deleteCellAt:[NSIndexPath indexPathForRow:0 inSection:0] withAnimation:FALSE];
//                }
//            }
//        }
//    }
}

-(void)manageBarsWithScroll:(UIScrollView *)scrollView forGridView:(GridView *)theGrdidView{
    
    hideBars = TRUE;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f){
        return;
    }
    
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGFloat navSize = navFrame.size.height - 20;
    
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGFloat tabHeight = tabBarFrame.size.height;
    
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        navFrame.origin.y = -navSize;
        
        tabBarFrame.origin.y = kDeviceHeight + tabHeight;
        hideBars = TRUE;
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        navFrame.origin.y = 20;
        tabBarFrame.origin.y = kDeviceHeight - tabHeight;
        hideBars = FALSE;
    }
    
    if(!isScrolling){
        isScrolling = TRUE;
        
        [UIView animateWithDuration:0.1 animations:^{
            if (hideBars) {
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                [theGrdidView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - tabBarFrame.size.height)];
                [theGrdidView.collectionView setFrame:CGRectMake(theGrdidView.collectionView.frame.origin.x, theGrdidView.collectionView.frame.origin.y, theGrdidView.collectionView.frame.size.width, theGrdidView.frame.size.height)];
            }
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                if(!hideBars){
                    [self.navigationController.navigationBar setAlpha:1.0];
                    
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, navFrame.origin.y + navFrame.size.height, self.view.frame.size.width, tabBarFrame.origin.y - 20)];
                [theGrdidView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [theGrdidView.collectionView setFrame:CGRectMake(theGrdidView.collectionView.frame.origin.x, theGrdidView.collectionView.frame.origin.y, theGrdidView.collectionView.frame.size.width, theGrdidView.frame.size.height)];
                }
                [self.navigationController.navigationBar setFrame:navFrame];
                [self.tabBarController.tabBar setFrame:tabBarFrame];
                
            } completion:^(BOOL finished) {
                if(hideBars){
                    self.navigationController.view.backgroundColor = [UIColor whiteColor];
                    self.navigationController.navigationBar.alpha = 0.0;
                }
                isScrolling = FALSE;
            }];

        }];
    }
}

-(void)resetBars{
    [self.navigationController.navigationBar setAlpha:1.0];
    CGRect navFrame = self.navigationController.navigationBar.frame;
    navFrame.origin.y = 20;
    [self.navigationController.navigationBar setFrame:navFrame];
    
    //Resetting the tab bar data
    
    CGRect tabFrame = self.tabBarController.tabBar.frame;
    tabFrame.origin.y = kDeviceHeight - tabFrame.size.height;
    [self.tabBarController.tabBar setFrame:tabFrame];

}

#pragma GridView Delegate Methods

- (void)showBrandProductPDP:(NSString *)pdpUrl{
    [self showPDPScreen:pdpUrl];
}

- (void)showCollectionProductPDP:(NSString *)collectionURL{
    [self showPDPScreen:collectionURL];
}

-(void)openCart{
    [self.tabBarController setSelectedIndex:4];
}
-(void)openBrand{
    [self.tabBarController setSelectedIndex:1];
}
-(void)openOrders{
    //set the orders as default tab.
    UINavigationController *navControl = [[self.tabBarController viewControllers] objectAtIndex:3];
    [navControl popToRootViewControllerAnimated:NO];
    if([[[navControl viewControllers] objectAtIndex:0] isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *profileController = [[(UINavigationController *)navControl viewControllers] objectAtIndex:0];
        [profileController.profileTabs setSelectedSegmentIndex:0];
    }
    
    
    [self.tabBarController setSelectedIndex:3];
}
-(void)didScrollToEndOfLastPage{

    pageNumber++;
    
    NSDictionary *paramDict = @{@"page":[NSString stringWithFormat:@"%d", pageNumber]};
    NSInteger prevLastIndex = [feedGrdidView.parsedDataArray count] - 1;
    __block NSInteger newLastIndex = 0;
    
    if(hasNext){
        [self.feedRquestHandler fetchFeedDataWithParams:paramDict withCompletionHandler:^(id responseData, NSError *error) {
            [feedGrdidView.parsedDataArray addObjectsFromArray:[SSUtility parseJSON:[responseData objectForKey:@"items"] forGridView:feedGrdidView]];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithFloat:feedGrdidView.frame.size.width] forKey:@"width"];
            [dict setObject:[NSNumber numberWithFloat:80] forKey:@"height"];
            newLastIndex = [feedGrdidView.parsedDataArray count] - 1;
            NSMutableArray *indexSetArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(int i = 0; i < newLastIndex - prevLastIndex; i++){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+prevLastIndex +1 inSection:0];
                [indexSetArray addObject:indexPath];
            }
            hasNext = [[[responseData objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
            if(!hasNext){
                feedGrdidView.shouldHideLoaderSection = true;
            }else{
                feedGrdidView.shouldHideLoaderSection = false;
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [feedGrdidView reloadCollectionView:indexSetArray];
            });
        }];
    }
}



- (void)showPDPScreen:(NSString *)url{
    if(self.pdpController){
        self.pdpController = nil;
    }
    self.pdpController = [[PDPViewController alloc] init];
    self.pdpController.productURL = url;
    [self.navigationController pushViewController:self.pdpController animated:YES];
}

- (void)showBrowseByBrandPage:(NSString *)url{
    if(self.browseByBrandController){
        self.browseByBrandController = nil;
    }
    self.browseByBrandController = [[BrowseByBrandViewController alloc] init];
    if(self.suppressGender){
        self.browseByBrandController.isProfileBrand = true;
    }
    [self.browseByBrandController parseURL:url];
    [self.navigationController pushViewController:self.browseByBrandController animated:YES];
}

-(void)showBrowseByCollectionPage:(NSString *)url{
    if(self.browseByCollectionController){
        self.browseByCollectionController = nil;
    }
    self.browseByCollectionController = [[BrowseByCollectionViewController alloc] init];
    if(self.suppressGender){
        self.browseByCollectionController.isProfileCollection = true;
    }
    [self.browseByCollectionController parseURL:url];
    [self.navigationController pushViewController:self.browseByCollectionController animated:YES];
}


- (void)showBrowseByCategoryPage:(NSString *)categoryURL{
    if(self.browseByCategoryController){
        self.browseByCategoryController = nil;
    }
    
    NSString *categoryName = [SSUtility getValueForParam:@"q" from:categoryURL];
    
    self.browseByCategoryController = [[BrowseByCategoryViewController alloc] init];
    self.browseByCategoryController.theCategory = categoryName;
    self.browseByCategoryController.theProductURL = categoryURL;
    
    [self.navigationController pushViewController:self.browseByCategoryController animated:TRUE];
}


- (void)showCollectionsScreen:(NSString *)url{
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    NSArray *viewControllersArray = [(UINavigationController *)[window rootViewController] viewControllers];
    __block UITabBarController *tabController;
    
    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TabBarViewController class]]) {
            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
        }
    }];
    
    [tabController setSelectedIndex:2];
    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
    [navBarController popToRootViewControllerAnimated:NO];
}


- (void)showBrandsScreen:(NSString *)url{
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    NSArray *viewControllersArray = [(UINavigationController *)[window rootViewController] viewControllers];
    __block UITabBarController *tabController;
    
    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TabBarViewController class]]) {
            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
         }
    }];
    
    [tabController setSelectedIndex:1];
    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
    [navBarController popToRootViewControllerAnimated:NO];
}

- (void)showBrowseByCategoryScreen:(NSString *)urlString{
    
    BrowseByCategoryViewController *theCategoryView = [[BrowseByCategoryViewController alloc] init];
    theCategoryView.theProductURL = urlString;
    if(self.deepLinkSearchString && self.deepLinkSearchString.length > 0){
        theCategoryView.theCategory = self.deepLinkSearchString;
    }else{
        theCategoryView.theCategory = @"Being Human";
    }
    [self.navigationController pushViewController:theCategoryView animated:TRUE];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginSearch{
    __weak FeedViewController *weakSelf = self;
    theSearchViewController = [[SearchViewController alloc] init];
    theSearchViewController.thePushBlock = ^(NSString *stringParam,NSString *theURLString,NSString *theCatName, NSString *parentCategory, NSString *gender, AutoSuggestModel *searchModel){
        if ([[stringParam uppercaseString] isEqualToString:@"PRODUCT"]) {
            PDPViewController * pdpViewController = [[PDPViewController alloc] init];
            pdpViewController.productURL = theURLString;
            [weakSelf.navigationController pushViewController:pdpViewController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"BRAND"]){
            BrowseByBrandViewController * brandController = [[BrowseByBrandViewController alloc] init];
            brandController.isProfileBrand = TRUE;
            [brandController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:brandController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"COLLECTION"]){
            BrowseByCollectionViewController *theBrowseController = [[BrowseByCollectionViewController alloc] init];
            theBrowseController.isProfileCollection = TRUE;
            [theBrowseController parseURL:theURLString];
            [weakSelf.navigationController pushViewController:theBrowseController animated:TRUE];
            
        }else if ([[stringParam uppercaseString] isEqualToString:@"CATEGORY"] || [[stringParam uppercaseString] isEqualToString:@"FREETEXT"]){
            BrowseByCategoryViewController *theCategoryView = [[BrowseByCategoryViewController alloc] init];
           
            if([[stringParam uppercaseString] isEqualToString:@"FREETEXT"] || !gender || gender == nil){
                theCategoryView.screenType = BrowseTypeSearch;
                if(searchModel && searchModel != nil){
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                    NSDate *now = [NSDate date];
                    NSString *dateString = [formatter stringFromDate:now];
                    
                    [FyndAnalytics trackSearchEventFrom:@"feed" searchString:searchModel.displayName searchDate:dateString];
                }
                
            }else{
                theCategoryView.screenType = BrowseTypeBrwose;
                [FyndAnalytics trackCategoryEvent:gender category:parentCategory subcategory:theCatName];

            }

            theCategoryView.theProductURL = theURLString;
            theCategoryView.theCategory = theCatName;
            [weakSelf.navigationController pushViewController:theCategoryView animated:TRUE];
        }
    };

    [self.navigationController presentViewController:theSearchViewController animated:TRUE completion:nil];
    //    [self.navigationController pushViewController:theSearchViewController animated:YES];
}

#pragma Mark -

-(void)searchLocation{
    
    if(searchViewController){
        searchViewController.delegate = nil;
        searchViewController = nil;
    }
    searchViewController = [[LocationSearchViewController alloc] init];
    searchViewController.delegate = self;
//    navController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
//    [self presentViewController:navController
//                       animated:YES
//                     completion:^{
//                         
//                     }];
    
    [self presentViewController:searchViewController animated:YES completion:^{
        
    }];
}

#pragma Mark - LocationSelector Delegate

-(void)didSelectLocation{
    
    if(self.navigationView){
        [self.navigationView removeFromSuperview];
        self.navigationView = nil;
    }
    if(self.feedBlankPage){
        [self.feedBlankPage removeFromSuperview];
        self.feedBlankPage = nil;
    }
    
    self.navigationView = [self configureNavigationView:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] capitalizedString]];
    self.navigationItem.titleView  = self.navigationView;
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"locality"]){
//        self.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
//        self.navigationController.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"locality"];
    }

    [searchViewController dismissLocationSearch];
    [self getNewFeedDataWithOrderID:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"refreshBrands"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"refreshCollection"];
}


-(void)getNewFeedDataWithOrderID:(NSString *)orderID{

    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    [feedGrdidView setHidden:TRUE];
    [feedGrdidView.collectionView setContentOffset:feedGrdidView.collectionView.contentOffset animated:NO];
    if(self.feedBlankPage){
        [self.feedBlankPage removeFromSuperview];
        self.feedBlankPage = nil;
    }
    
    NSDictionary *theDataArrayDic = [feedGrdidView.parsedDataArray objectAtIndex:0];
    if ([[theDataArrayDic valueForKey:@"tile_type"] isEqualToString:@"welcome"]) {
        [feedGrdidView.parsedDataArray removeObjectAtIndex:0];
    }

    
    NSMutableDictionary *theDic = [[NSMutableDictionary alloc] init];
    [theDic setObject:@"1" forKey:@"page"];
    if (orderID) {
//        [theDic setObject:[NSString stringWithFormat:@"%@",orderID] forKey:@"order_id"];
        TabBarViewController *theTab = (TabBarViewController *)self.tabBarController;
        theTab.isLoadingOrderID = FALSE;
    }
    
    [self.feedRquestHandler fetchFeedDataWithParams:theDic withCompletionHandler:^(id responseData, NSError *error) {
        
        NSMutableDictionary *json = nil;
        
        if (orderID) {
            NSDictionary *theJSON = responseData;
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:kShowWelcomeCard];
            NSMutableDictionary *welcomeCard = [[NSMutableDictionary alloc] init];
            [welcomeCard setObject:@"welcome" forKey:@"tile_type"];
            [welcomeCard setObject:[NSNumber numberWithBool:TRUE] forKey:@"isOrderCard"];
            [welcomeCard setObject:[NSNumber numberWithInt:2] forKey:@"tile_size"];
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[theJSON objectForKey:@"items"]];
            [array insertObject:welcomeCard atIndex:0];
            
            NSMutableDictionary *mutableJson = [[NSMutableDictionary alloc] initWithDictionary:theJSON];
            [mutableJson setObject:array forKey:@"items"];
            json = mutableJson;
        }
        else{
            json = responseData;
        }

        
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        
        if(!error){
            if(json!=nil && [json count] > 0){
                [feedGrdidView.parsedDataArray removeAllObjects];
                feedGrdidView.parsedDataArray =[SSUtility parseJSON:[json objectForKey:@"items"] forGridView:feedGrdidView];
                hasNext = [[[json objectForKey:@"page"] objectForKey:@"has_next"] boolValue];
                if(!hasNext){
                    feedGrdidView.shouldHideLoaderSection = true;
                }else{
                    feedGrdidView.shouldHideLoaderSection = false;
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [feedGrdidView setHidden:false];
                    [feedGrdidView reloadCollectionView];
                    isFetching = false;
                });
            }else{
               [self showBlankPage];     
            }
        }else{
            [self showBlankPage];
        }
    }];
}


- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.startTime = CACurrentMediaTime();
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

// This handler will update a label on the screen with the frame rate once per second

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    self.frameCount++;
    
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - self.startTime;
    
    if (elapsed >= 1.0) {
        CGFloat frameRate = self.frameCount / elapsed;
        
        // either, like below, update a label that you've added to the view or just log the rate to the console
        if(frameRate <40.0f){
        }
        
        
        self.frameCount = 0;
        self.startTime = now;
    }
}

@end
