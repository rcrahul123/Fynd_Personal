//
//  BrowseByBrandViewController.h
//  
//
//  Created by Rahul on 7/6/15.
//
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "SSUtility.h"
#import "SortViewController.h"
#import "GridView.h"
#import "FilterViewController.h"
#import "PDPViewController.h"

#import "BrowseByBrandRequestHandler.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BrowseByBrandViewController : UIViewController<UIScrollViewDelegate, FilterViewDelegates, GridViewDelegate, SortDelegate>{
    UIImageView *headerView;
    UIActivityIndicatorView *headerActivityIndicator;
    
    UIView *brandDetailContainerView;
    UIImageView *arcImage;
    
    UIImageView *brandLogoImage;
    UILabel *brandName;
    UILabel *nearestStoreLabel;
    UILabel *numberOfStoresLabel;
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
    BrandTileModel *brandModel;
    
    NSDictionary *brandDataDictionary;
    
    UIActivityIndicatorView *imageActivityIndicator;
    UIActivityIndicatorView *brandDetailActivityIndicator;
    
    FilterViewController *filterView;
    UINavigationController *filterNav;

    NSArray *defaultFilters;
    BOOL fetching;
    int pages;
    
    NSAttributedString *followButtonText;
    NSTimer *followTimer;
    
    NSMutableString *brandURL;
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
    
    FyndActivityIndicator *browseByBrandLoader;
    
    BOOL isParsedDataArrayOBserverAdded;
    BOOL isHeaderLabelObserverAdded;
    BOOL isCollectionContentSizeObserverAdded;
    
    BOOL isNavBarVisible;
    
    NSMutableArray *defaultParamDictionaryArray;
}
@property (nonatomic, strong) NSString *userGender;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PDPViewController *pdpController;
@property (nonatomic, strong) BrowseByBrandRequestHandler *browseByBrandRequestHandler;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) BOOL isProfileBrand;

-(void)parseURL:(NSString *)url;
@end
