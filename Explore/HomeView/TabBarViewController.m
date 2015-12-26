//
//  TabBarViewController.m
//  Explore
//
//  Created by Rahul Chaudhari on 12/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "TabBarViewController.h"

@implementation TabBarViewController

-(void)awakeFromNib{
}

-(void)viewDidLoad{
    
    UITabBarController *tabBarController = self;
    tabBarController.delegate = self;
    
    UITabBar *tabBar = tabBarController.tabBar;
    [tabBar setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]]];

    [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xee478d)];

    UITabBarItem *feedBarItem = [tabBar.items objectAtIndex:0];
    [feedBarItem setImage:[[UIImage imageNamed:@"FeedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [feedBarItem setSelectedImage:[[UIImage imageNamed:@"FeedSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *brandsBarItem = [tabBar.items objectAtIndex:1];
    [brandsBarItem setSelectedImage:[[UIImage imageNamed:@"BrandSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [brandsBarItem setImage:[[UIImage imageNamed:@"BrandTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *collectionsBarItem = [tabBar.items objectAtIndex:2];
    [collectionsBarItem setSelectedImage:[[UIImage imageNamed:@"CollectionSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [collectionsBarItem setImage:[[UIImage imageNamed:@"CollectionTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *meBarItem = [tabBar.items objectAtIndex:3];
    [meBarItem setSelectedImage:[[UIImage imageNamed:@"ProfileSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [meBarItem setImage:[[UIImage imageNamed:@"ProfileTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *cartBarItem = [tabBar.items objectAtIndex:4];
    int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
    if (totalBagItems>0) {
        [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartFilledSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [cartBarItem setImage:[[UIImage imageNamed:@"CartFilledTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [cartBarItem setImage:[[UIImage imageNamed:@"CartTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logoutUser" object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = TRUE;
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if(tabBarController.selectedIndex == 0 )//&& !_isLoadingOrderID) // Need to discuss with Amboj
    {
        if([[[(UINavigationController *)viewController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
            FeedViewController *feedController = [[(UINavigationController *)viewController viewControllers] objectAtIndex:0];
            [feedController getNewFeedDataWithOrderID:nil];
        }
    }
    if(tabBarController.selectedIndex == 4){
        UINavigationController *navController = [self.viewControllers objectAtIndex:4];
        [navController popToRootViewControllerAnimated:NO];

    }
    return TRUE;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if(tabBarController.selectedIndex == 3){
        UINavigationController *navController = [self.viewControllers objectAtIndex:3];
        [navController popToRootViewControllerAnimated:NO];
    }
}

-(void)logout{
    
    FBSDKLoginManager *mngr = [[FBSDKLoginManager alloc] init];
    [mngr logOut];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"loggedIn"];
    [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"onBoard"];
    [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"facebookLoggedIn"];
    [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"signedUP"];
    [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"firstLaunch"];
    [userDefaults setBool:NO forKey:@"isLaunchedFrom3DTouch"];
    [userDefaults setObject:[NSNumber numberWithInteger:-1] forKey:@"3DTouchOptionType"];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
