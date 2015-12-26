//
//  FirstViewController.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationSearchViewController.h"
#import "SearchViewController.h"
#import "BrowseByBrandViewController.h"
#import "PaginationData.h"
#import "NotificationViewController.h"

@interface BrandsVIewController : UIViewController<GridViewDelegate, LocationSearchDelegate>{
    UIBarButtonItem *searchButton;
    UIBarButtonItem *locationButton;
    UIBarButtonItem *notificationIcon;
    
    UILabel *address;
    UILabel *area;
    UILabel *country;
    UILabel *region;
    UILabel *name;
    UILabel *ocean;
    UILabel *postalCode;
    UILabel *subLocality;
    UILabel *location;
    
    UILabel *addressValue;
    UILabel *areaValue;
    UILabel *countryValue;
    UILabel *regionValue;
    UILabel *nameValue;
    UILabel *oceanValue;
    UILabel *postalCodeValue;
    UILabel *subLocalityValue;
    UILabel *locationValue;
    
    BOOL    serviceInProgress;
    NSInteger   initialBrandsCount;
    NSInteger   newBrandsCount;
    
    PaginationData  *brandPagination;
    int brandPageNumber;
    
    LocationSearchViewController *searchViewController;
    UINavigationController *navController;

    NSUserDefaults *userDefaults;
    NSString *latitude;
    NSString *longitude;
    NSString *city;
    
    FyndActivityIndicator *brandsLoader;

}
@property (nonatomic,assign) BOOL isProfileBrand;


@end

