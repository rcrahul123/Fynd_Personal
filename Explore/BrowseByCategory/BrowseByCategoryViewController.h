//
//  CategoryViewController.h
//  Explore
//
//  Created by Amboj Goyal on 8/3/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "PDPViewController.h"
#import "BrowseByBrandViewController.h"
#import "BrowseByCollectionViewController.h"
#import "FilterViewController.h"
#import "FyndBlankPage.h"
#import "SortViewController.h"
#import "SSBaseRequestHandler.h"

typedef enum BrwoseType{
    BrowseTypeSearch,
    BrowseTypeBrwose
}BrowseType;

@interface BrowseByCategoryViewController : UIViewController<GridViewDelegate,FilterViewDelegates, SortDelegate>{
    NSString *hostUrl;
    NSArray *urlContainer;
    NSMutableArray *modelArray;
    NSMutableArray *parsedDataArray;
    int pageNumber;
    bool isFetching;
    BOOL inseringItems;
    GridView *feedGrdidView;
    NSMutableString *feedURL;
    UIBarButtonItem *searchButton;
    UIBarButtonItem *locationButton;
    UIBarButtonItem *notificationIcon;

    FilterViewController *filterView;
    UINavigationController *filterNav;

    SortViewController *sortView;
    UINavigationController *sortNav;
    NSString *sortParam;
    NSArray *filterArray;
    NSArray *sortArray;
    NSMutableDictionary *paramDictionary;

    
    SSBaseRequestHandler *requestHandler;
    
    NSMutableDictionary *defaultParamDictionary;
    NSMutableArray *paramArray;


    FyndActivityIndicator *browseByCategotyLoader;
    
    NSMutableArray *defaultParamDictionaryArray;
}
@property (nonatomic,strong)NSString *theProductURL;
@property (nonatomic,strong)NSString *theCategory;
@property (nonatomic,strong) FyndBlankPage   *blankPage;
@property (nonatomic,strong)NSString *theTotalItemsCount;
@property (nonatomic) BrowseType screenType;

@end
