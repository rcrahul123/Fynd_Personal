//
//  FeedViewController.h
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFlow.h"
#import "BrandCollectionViewCell.h"
#import "ProductTileModel.h"
#import "ProductCell.h"

#import "TipTileModel.h"
#import "TipCollectionViewCell.h"

#import "BrandTileModel.h"

#import "CollectionTileModel.h"
#import "BrowseByBrandViewController.h"
#import "BrowseByCollectionViewController.h"

#import "UINavigationBar+Transparency.h"
#import "GridView.h"
#import "SearchViewController.h"
#import "LocationSearchViewController.h"
#import "PDPViewController.h"
#import "ProfileViewController.h"
#import "NotificationViewController.h"

#import "HomeRequestHandler.h"
#import "BrowseByCategoryViewController.h"

@interface FeedViewController : UIViewController<GridViewDelegate, LocationSearchDelegate,UITabBarControllerDelegate>{

    NSString *hostUrl;
    NSArray *urlContainer;
    NSMutableArray *modelArray;
    NSMutableArray *parsedDataArray;
    int pageNumber;
    bool isFetching;
    BOOL inseringItems;
    GridView *feedGrdidView;
    NSString *feedURL;
    UIBarButtonItem *searchButton;
    UIBarButtonItem *locationButton;
    UIBarButtonItem *notificationIcon;
    BOOL hasNext;

    UIActivityIndicatorView *feedIndicator;
    
    LocationSearchViewController *searchViewController;
    UINavigationController *navController;
    
    NSUserDefaults *userDefaults;
    NSString *latitude;
    NSString *longitude;
    NSString *city;
    
    FyndActivityIndicator *indicator;
}

@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic) NSInteger numberOfDivisions;
@property (nonatomic, strong) NSArray *sizesArray;
@property (nonatomic)CGFloat previousScrollViewYOffset;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic, strong) BrowseByBrandViewController *browseByBrandController;
@property (nonatomic, strong) BrowseByCollectionViewController *browseByCollectionController;
@property (nonatomic, strong) HomeRequestHandler *feedRquestHandler;
@property (nonatomic, assign) BOOL suppressGender;

@property (strong, nonatomic) NSArray *navBarItems;
@property (strong,nonatomic) NSString   *deepLinkSearchString;
@property (nonatomic, strong) BrowseByCategoryViewController *browseByCategoryController;

-(void)getNewFeedDataWithOrderID:(NSString *)orderID;
- (void)showPDPScreen:(NSString *)url;
- (void)showBrowseByCategoryScreen:(NSString *)urlString;
@end
