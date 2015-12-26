//
//  CollectionsViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 29/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Transparency.h"
#import "BrowseByCollectionViewController.h"
#import "PaginationData.h"
#import "LocationAccessViewController.h"
#import "NotificationViewController.h"

@interface CollectionsViewController : UIViewController<LocationSearchDelegate>{
    UIBarButtonItem *searchButton;
    UIBarButtonItem *locationButton;
    UIBarButtonItem *notificationIcon;
    BOOL    collectionServiceInProgress;
    NSInteger   initialCollectionCount;
    NSInteger   newCollectionCount;
    
    PaginationData  *collectionPagination;
    int collectionPageNumber;
    BOOL            isGenderViewVisible;
    
    LocationSearchViewController *searchViewController;
    UINavigationController *navController;
    
    NSUserDefaults *userDefaults;
    NSString *latitude;
    NSString *longitude;
    NSString *city;
    
    FyndActivityIndicator *collectionLoader;
    
}
@property (nonatomic,assign) BOOL isProfileCollection;

@end
