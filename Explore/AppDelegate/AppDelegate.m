//
//  AppDelegate.m
//  Explore
//
//  Created by Rahul on 6/29/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "AppDelegate.h"
#import "FyndAnalytics.h"
#import "PDPViewController.h"

#import <NewRelicAgent/NewRelic.h>
#import "Branch.h"
#import "DeepLinkerHandler.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [NewRelicAgent startWithApplicationToken:@"AA2f6d9641d69ad4a1d7ec32ba7502cf29e2e193b4"];
    
    //Configuring the MixPanel
//    [Mixpanel sharedInstanceWithToken:FYND_MIXPANEL_DEVELOPMENT_TOKEN launchOptions:launchOptions];
//      [Mixpanel sharedInstanceWithToken:FYND_MIXPANEL_QC_TOKEN launchOptions:launchOptions];
    [Mixpanel sharedInstanceWithToken:FYND_MIXPANEL_PRODUCTION_TOKEN launchOptions:launchOptions];


    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache setMaxCacheSize:500*1024*1024];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:FALSE forKey:@"refreshCollection"];
    [userDefaults setBool:FALSE forKey:@"refreshBrands"];
    
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    baseNavController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"BaseNavController"];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [baseNavController.view setBackgroundColor:[UIColor whiteColor]];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:mixpanel.distinctId];
    Branch *branch = [Branch getInstance];
//    [branch setDebug];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            
            if([[params objectForKey:@"+clicked_branch_link"] boolValue])
            {
                if([[params objectForKey:@"+is_first_session"] boolValue]){
                    [FyndAnalytics sharedMySingleton];
                    [FyndAnalytics registerSuperPropertiesForBranchInstall:params];
                }
                
                //Track the Deep linked clicked
                
//                [FyndAnalytics trackDeeplinkEventWithMarketingCampaign:[params objectForKey:@"~campaign"] andChannel:[params objectForKey:@"~channel"]];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"isLaunchedViaBranch"];
                [userDefaults setObject:[params objectForKey:@"$ios_url"] forKey:@"BranchDeepLinkUrl"];
                [userDefaults setObject:params forKey:@"BranchServiceResponse"];
                
                [userDefaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"BranchDeepLinkEventFired"];
                
                [DeepLinkerHandler sharedSingleton];
                [DeepLinkerHandler navigateViaParams:params];
            }else{
                if([[params objectForKey:@"+is_first_session"] boolValue]){
                    [FyndAnalytics sharedMySingleton];
                    [FyndAnalytics registerSuperPropertiesForBranchInstall:params];
                }
                
                [SSUtility removeBranchStoredData];
            }
         }
    }];
    
    [mixpanel track:@"$app_open"];

    
    BOOL fbDidFinish = [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    //check if app is launched from share url
    if(launchOptions){

        if([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey]){
            NSString *urlString = [[launchOptions objectForKey:UIApplicationLaunchOptionsURLKey] absoluteString];
            
            if ([urlString rangeOfString:@"gofynd://"].length>0) {
                NSString *incomingString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                if([incomingString rangeOfString:@"gofynd://fyndi.ng/signup"].length > 0){
                    
//                    NSUserDefaults *userDafaults = [NSUserDefaults standardUserDefaults];
//                    [userDafaults setBool:YES forKey:@"showSignupDirectly"];
                    
                }else{
                    NSString *jsonString = [[incomingString componentsSeparatedByString:@"://"] objectAtIndex:1];
                    
                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *finalDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                    
                    NSString *actionType = finalDictionary[@"type"];
                    NSString *idForAction = finalDictionary[@"value"];
                    
                    if ([[actionType uppercaseString] isEqualToString:@"PRODUCT"]) {
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        
                        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                        [theURL appendString:[NSString stringWithFormat:@"get-product/?product_id=%@",idForAction]];
                        [userDefaults setBool:YES forKey:@"isLaunchedFromOtherApp"];
                        [userDefaults setObject:theURL forKey:@"openingURL"];
                        [userDefaults setObject:@"Product" forKey:@"shouldShow"];
                        
                    }else if ([[actionType uppercaseString] isEqualToString:@"BRAND"]) {
                                NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                                if(finalDictionary[@"gender"]){
                                    [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?brand=%@&items=True&filters=True&headers=True&gender=%@",idForAction, finalDictionary[@"gender"]]];
                                }else{
                                    [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?brand=%@&items=True&filters=True&headers=True",idForAction]];
                                }
                        
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setBool:YES forKey:@"isLaunchedFromOtherApp"];
                            [userDefaults setObject:theURL forKey:@"openingURL"];
                            [userDefaults setObject:@"Brand" forKey:@"shouldShow"];
                            [userDefaults setBool:YES forKey:@"suppressGender"];
                        
                    }else if ([[actionType uppercaseString] isEqualToString:@"COLLECTION"]) {
                        
                                NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                                if(finalDictionary[@"gender"]){
                                    [theURL appendString:[NSString stringWithFormat:@"browse-by-collection/?collection_id=%@&items=True&filters=True&headers=True&gender=%@",idForAction, finalDictionary[@"gender"]]];
                                }else{
                                    [theURL appendString:[NSString stringWithFormat:@"browse-by-collection/?collection_id=%@&items=True&filters=True&headers=True",idForAction]];
                                }
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setBool:YES forKey:@"isLaunchedFromOtherApp"];
                            [userDefaults setObject:theURL forKey:@"openingURL"];
                            [userDefaults setObject:@"Collection" forKey:@"shouldShow"];
                            [userDefaults setBool:YES forKey:@"suppressGender"];
//                                [feedController showBrowseByCollectionPage:theURL];
//                            }
//                        }
                    }
                }
            }
        }
        else if([launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey]){
            
            UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
            if(shortcutItem){
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:YES forKey:@"isLaunchedFrom3DTouch"];
                [self navigateAndLaunchViaShortCutItem:shortcutItem.type];
            }
            
        }
    }
    [self.window makeKeyAndVisible];
    return fbDidFinish;
}



- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    [self navigateByShortCutItem:shortcutItem.type];
    
}

- (void)navigateByShortCutItem:(NSString *)shortcutType{
    
    NSInteger optionType = -1;
    if([shortcutType isEqualToString:@"Feed Type"]){
        //ACTION HERE
        
        optionType = 1;
        
        int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
        if (controlCount >=2) {
            NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];
            
            [tabController setSelectedIndex:0];
            UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
            [navBarController popToRootViewControllerAnimated:NO];
         
        }
        
    }else if([shortcutType isEqualToString:@"Brand Type"]){
        
        optionType = 2;
        
        int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
        if (controlCount >=2) {
            NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];
            
            [tabController setSelectedIndex:1];
            UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:1];
            [navBarController popToRootViewControllerAnimated:NO];
         }
        
    }
    
    else if([shortcutType isEqualToString:@"Collection Type"]){
        
        optionType = 3;
        
        int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
        if (controlCount >=2) {
            NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];
            
            [tabController setSelectedIndex:2];
            UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:2];
            [navBarController popToRootViewControllerAnimated:NO];
        }
        
        
    }
    else if([shortcutType isEqualToString:@"Bag Type"]){
        optionType = 4;
        int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
        if (controlCount >=2)
        {
            NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
            
            __block UITabBarController *tabController;
            
            [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[TabBarViewController class]]) {
                    tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                }
            }];
            
            [tabController setSelectedIndex:4];
            UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:4];
            [navBarController popToRootViewControllerAnimated:NO];
        }
        
    }

    
}


- (void)navigateAndLaunchViaShortCutItem:(NSString *)shortcutType{
    
    NSInteger optionType = -1;
    if([shortcutType isEqualToString:@"Feed Type"]){
        optionType = 0;
    }else if([shortcutType isEqualToString:@"Brand Type"]){
        optionType = 1;
    }
    else if([shortcutType isEqualToString:@"Collection Type"]){
        optionType = 2;
    }
    else if([shortcutType isEqualToString:@"Bag Type"]){
        optionType = 4;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithInteger:optionType] forKey:@"3DTouchOptionType"];
}


- (void)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem  {
    [self navigateByShortCutItem:shortcutItem.type];
}





- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[Branch getInstance] handleDeepLink:url];
    
    // This need to be test for deep linking
    if([[url absoluteString] rangeOfString:@"open?link_click_id"].length>0){
        return TRUE;
    }
    
    
    if ([[url absoluteString] rangeOfString:@"gofynd://"].length>0) {
        NSString *incomingString = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if([incomingString rangeOfString:@"gofynd://fyndi.ng/signup"].length > 0){
            int controlCount = (int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
            if (controlCount >=2) {
                //              UITabBarController *tabController = (UITabBarController *)[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1];
                NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                
                __block UITabBarController *tabController;
                
                [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[TabBarViewController class]]) {
                        tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                    }
                }];
                
                if(tabController != nil){
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                    if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
                        
                        [navBarController popToRootViewControllerAnimated:NO];
                        //                    FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
                        //
                        //                    NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                        //                    [theURL appendString:[NSString stringWithFormat:@"get-product/?product_id=%@",idForAction]];
                        //                    [feedController showPDPScreen:theURL];
                        
                    }
                }else{
                    UINavigationController *rootNavController = (UINavigationController *)[self.window rootViewController];
                    [rootNavController popToRootViewControllerAnimated:NO];
                    
//                    HomeViewController *homeController = (HomeViewController *)[[rootNavController viewControllers] objectAtIndex:0];
//                    [homeController signUpNewUser];
                }
            }
            
            
        }else{
            
            NSString *jsonString = [[incomingString componentsSeparatedByString:@"://"] objectAtIndex:1];
            
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *finalDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            NSString *actionType = finalDictionary[@"type"];
            NSString *idForAction = finalDictionary[@"value"];
            
            
            if ([[actionType uppercaseString] isEqualToString:@"PRODUCT"]) {
                
                int controlCount = (int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
                if (controlCount >=2) {
                    //              UITabBarController *tabController = (UITabBarController *)[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1];
                    NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                    
                    __block UITabBarController *tabController;
                    
                    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[TabBarViewController class]]) {
                            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                        }
                    }];
                    
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                    if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
                        
                        FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
                        
                        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                        [theURL appendString:[NSString stringWithFormat:@"get-product/?product_id=%@",idForAction]];
                        [feedController showPDPScreen:theURL];
                        
                    }
                }
            }else if ([[actionType uppercaseString] isEqualToString:@"FEED"]){
                int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
                if (controlCount >=2) {
                    //                UITabBarController *tabController = (UITabBarController *)[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1];
                    NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                    
                    __block UITabBarController *tabController;
                    
                    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[TabBarViewController class]]) {
                            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                        }
                    }];
                    
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                }
            }else if ([[actionType uppercaseString] isEqualToString:@"BRAND"]) {
                
                int controlCount = (int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
                if (controlCount >=2) {
                    //              UITabBarController *tabController = (UITabBarController *)[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1];
                    NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                    
                    __block UITabBarController *tabController;
                    
                    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[TabBarViewController class]]) {
                            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                        }
                    }];
                    
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                    if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
                        
                        FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
                        feedController.suppressGender = TRUE;
                        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                        if(finalDictionary[@"gender"]){
                            [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?brand=%@&items=True&filters=True&headers=True&gender=%@",idForAction, finalDictionary[@"gender"]]];
                        }else{
                            [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?brand=%@&items=True&filters=True&headers=True",idForAction]];
                        }
                        
                        [feedController showBrowseByBrandPage:theURL];
                        
                    }
                }
            }else if ([[actionType uppercaseString] isEqualToString:@"COLLECTION"]) {
                
                int controlCount = (int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
                if (controlCount >=2) {
                    //              UITabBarController *tabController = (UITabBarController *)[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1];
                    NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                    
                    __block UITabBarController *tabController;
                    
                    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[TabBarViewController class]]) {
                            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                        }
                    }];
                    
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                    if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
                        
                        FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
                        feedController.suppressGender = TRUE;
                        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
                        if(finalDictionary[@"gender"]){
                            [theURL appendString:[NSString stringWithFormat:@"browse-by-collection/?collection_id=%@&items=True&filters=True&headers=True&gender=%@",idForAction, finalDictionary[@"gender"]]];
                        }else{
                            [theURL appendString:[NSString stringWithFormat:@"browse-by-collection/?collection_id=%@&items=True&filters=True&headers=True",idForAction]];
                        }
                        [feedController showBrowseByCollectionPage:theURL];
                    }
                }
            }else{
                int controlCount =(int)[[(UINavigationController *)self.window.rootViewController viewControllers] count];
                if (controlCount >=2) {
                    NSArray *viewControllersArray = [(UINavigationController *)[self.window rootViewController] viewControllers];
                    
                    __block UITabBarController *tabController;
                    
                    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[TabBarViewController class]]) {
                            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
                        }
                    }];
                    
                    [tabController setSelectedIndex:0];
                    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
                    [navBarController popToRootViewControllerAnimated:NO];
                }
            }
            
        }
        
        return YES;
    }
    else{
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    
}


#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[Mixpanel sharedInstance] trackPushNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0){
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"validateSession"] boolValue]) {
//        [[NSUserDefaults standardUserDefaults] setBool:[NSNumber numberWithBool:FALSE] forKey:@"validateSession"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"validateSessionObserver" object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:@"validateSessionObserver"];

//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:kFyndUserKey]){
//        NSDate *date = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//        NSString *string = [dateFormatter stringFromDate:date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *string = [formatter stringFromDate:now];
        [FyndAnalytics endSessionTracking:string];
    }
}



//#pragma AppsFlyerTrackerDelegate methods
//- (void) onConversionDataReceived:(NSDictionary*) installData{
//    id status = [installData objectForKey:@"af_status"];
//    if([status isEqualToString:@"Non-organic"]) {
//        id sourceID = [installData objectForKey:@"media_source"];
//        id campaign = [installData objectForKey:@"campaign"];
//        NSLog(@"This is a none organic install.");
//    } else if([status isEqualToString:@"Organic"]) {
//        NSLog(@"This is an organic install.");
//    }
//}
//
//- (void) onConversionDataRequestFailure:(NSError *)error{
//    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
//}


@end
