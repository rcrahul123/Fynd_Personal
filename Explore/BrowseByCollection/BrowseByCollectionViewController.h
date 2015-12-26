//
//  BrowseByCollectionViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 29/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "SSUtility.h"
#import "SortViewController.h"
#import "GridView.h"
#import "FilterViewController.h"
#import "PDPViewController.h"
#import "BrowseByCollectionRequestHandler.h"

@interface BrowseByCollectionViewController : UIViewController<UIScrollViewDelegate, FilterViewDelegates, GridViewDelegate, SortDelegate>{
    UIImageView *headerView;
    UIActivityIndicatorView *headerActivityIndicator;
    
    UIView *collectionDetailContainerView;
    UIImageView *arcImage;
    
    UIImageView *collectionLogoImage;
    UILabel *collectionName;
    UILabel *lastUpdatedLabel;
    UILabel *numberOfProductsLabel;
    UIButton *followButton;
    UILabel *numberOfFollowersButton;
    
    UIView *buttonsContainer;

    UIImageView *sortIcon;
    UILabel *sortLabel;
    UIView *sortButtonContainer;
    UITapGestureRecognizer *tapToSortGesture;
    
    UIImageView *filterIcon;
    UILabel *filterLabel;
    UIView *filterButtonContainer;
    UITapGestureRecognizer *tapToFilterGesture;
    
    UIView *moreProductsContainer;
    UILabel *moreProductsHeaderLabel;
    GridView *moreProductsList;
    CollectionTileModel *collectionModel;
    
    NSDictionary *collectionDataDictionary;
    
    UIActivityIndicatorView *imageActivityIndicator;
    UIActivityIndicatorView *collectionDetailActivityIndicator;
    
    FilterViewController *filterView;
    UINavigationController *filterNav;

    NSArray *defaultFilters;
    BOOL fetching;
    int pages;
    
    NSAttributedString *followButtonText;
    NSTimer *followTimer;
    
    NSMutableString *collectionURL;
    CGRect buttonContainerOriginalFrame;
    
    NSString *paginationURL;
    BOOL hasNext;
    
    UIActivityIndicatorView *applyFilterLoader;
    
    NSMutableDictionary *paramDictionary;
    NSMutableAttributedString *followersText1;
    NSMutableAttributedString *followersText2;
    CGRect followerFrame;
    
    SortViewController *sortView;
    UINavigationController *sortNav;

    NSString *sortParam;
    NSArray *filterArray;
    NSArray *sortArray;

    UILabel *errorLabel;
    
    NSString *backButtonImageName;
    UIView *gradientView;
    
    NSMutableDictionary *defaultParamDictionary;
    NSMutableArray *paramArray;
    BOOL isScrolling;
    FyndActivityIndicator *browseByCollectionLoader;
    
    BOOL isParsedDataArrayOBserverAdded;
    BOOL isHeaderLabelObserverAdded;
    BOOL isCollectionContentSizeObserverAdded;
    
    BOOL isNavBarVisible;
    
    NSMutableArray *defaultParamDictionaryArray;
}

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSString *collectionURL;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic, strong) BrowseByCollectionRequestHandler *browseByCollectionRequestHandler;
@property (nonatomic,assign) BOOL isProfileCollection;
@property (nonatomic, strong) NSString *gender;

-(void)parseURL:(NSString *)url;


@end
