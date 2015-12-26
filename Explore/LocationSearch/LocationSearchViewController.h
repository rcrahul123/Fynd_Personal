//
//  LocationSearchViewController.h
//  
//
//  Created by Rahul on 6/30/15.
//
//

#import <UIKit/UIKit.h>
#import "SSUtility.h"
#import "SSBaseRequestHandler.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchItemModel : NSObject{

}

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *itemType;
@property (nonatomic, strong) NSString *itemValue;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *dataID;
@property (nonatomic, strong) NSString *city;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end

@protocol LocationSearchDelegate <NSObject>

@optional
-(void)didSelectLocation;

@end


@interface LocationSearchViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>{
    UIImageView *searchIcon;
    UITextField *searchTextField;
    UIButton *cancelButton;
    
    UISearchBar *pincodeSearchBar;
    UIView *searchBarContainerView;
    
    UIView *autoDetectView;
    UIButton *hiddenButton;
    UITapGestureRecognizer *detectLocationTap;
    UITableView *suggestionListView;
    
    NSMutableArray *suggestionArray;
    
    NSURLSessionDataTask *dataTask;
    NSMutableDictionary *paramDictionary;
    SSBaseRequestHandler *requestHandler;
    
    CLLocationManager *locationManager;
    UIAlertView *locationAlert;
    CLLocation *location;
    
    NSArray *defaultLocations;
    NSString *searchURL;
    
    FyndActivityIndicator *locationSearchLoader;
    
    UIAlertView *alert;
    
    NSString *finalString;
    
    UIImageView *blankPincodeView;
    
//    NSTimer *timer;
    
    UIImage *magnifierImage;
    
    NSString *placeholderString;
    UIButton *searchCancelButton;
}

@property id<LocationSearchDelegate> delegate;
@property (nonatomic, assign) bool shouldHideCancel;
@property (nonatomic,assign) BOOL isPincodeView;
@property (nonatomic,strong) NSTimer *timer;
-(void)dismissLocationSearch;

@end
