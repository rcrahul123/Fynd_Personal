//
//  ThirdViewController.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "PDPViewController.h"
#import "UserAuthenticationHandler.h"
#import "ProfileRequestHandler.h"
#import "PDPViewController.h"
#import "OrdersView.h"
#import <MessageUI/MessageUI.h>
#import "WishListView.h"
#import "CartRequestHandler.h"

@interface ProfileViewController : UIViewController<OrderViewDelegate,MFMailComposeViewControllerDelegate, WishlistDelegate>{
    UserAuthenticationHandler *userAuthenticationHandler;
    ProfileRequestHandler     *profileHandler;
    NSURLSessionConfiguration *config;
    NSURLCache *cache;
    FyndUser *user;
    UIBarButtonItem *notificationIcon;
    UIView *gradientView;
    
    
    UIView *tabContainer;
//    UISegmentedControl *profileTabs;
    
    BOOL isOrderViewOberverAdded;
    bool isWishListViewObserverAdded;
    
    FyndActivityIndicator *profileLoader;
    BOOL isNavBarVisible;
    CartRequestHandler *theCartHandler;
}
@property(nonatomic,strong)UISegmentedControl *profileTabs;
@property(nonatomic,strong)PDPViewController *pdpController;
-(void)changeTab;
@end

