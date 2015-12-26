//
//  RPWOverlayHandler.h
//  OverlayAnimation
//
//

//#import "RPWOverlayActionButton.h"

#import <UIKit/UIKit.h>

#define kRPWOverlayPresentNotification @"kRPWOverlayPresentNotification"
#define kRPWOverlayDismissNotification @"kRPWOverlayDismissNotification"
//#import "LocationFootFallView.h"

@protocol PopOverlayHandlerDelegate;
@interface PopOverlayHandler : NSObject <UIWebViewDelegate,UIGestureRecognizerDelegate>

/*!
 @property	RPWOverlayType
 @abstract	indicates the overlay type.
 */


typedef NS_OPTIONS(NSUInteger, RPWOverlayType) {
    /*
	RPWFilterResultsOverlay = 0,
	RPWStartOverOverlay,
    MyTCSLocationDetailsOverlay,
    MyTCSHROverlay,
    MyTCSSearchDetailsOverlay,
    MaleFemaleComparisonOverlay
     */
    SizeGuideOverlay = 0,
    NearestStoreOverlay,
    PinCodeOverlay,
    PickAtStoreOverlay,
    RateUsOverlay,
    TryAtHomeFirstTimeOverlay,
    ExchangeProductOverlay,
    TryAtHomeOverlay,
    CartEditSizeOverlay,
    AddCartInBagOverlay,
    ProductInformationOveraly,
    ActivityIndicatorOverlay,
    InvalidCartOverlay,
    CustomAlertDeleteCartItem,
    CustomAlertCancelOrder,
    CustomAlertPayment,
    CustomAlertPaymentFailed,
    CustomAlertSignOut,
    CustomAlertShippingAddress,
    CustomAlertProfileUpdate,
    RPWFilterResultsOverlay,
    RPWStartOverOverlay,
    MyTCSLocationDetailsOverlay,
    MyTCSHROverlay,
    MyTCSSearchDetailsOverlay,
    MaleFemaleComparisonOverlay,
    ReturnReasonsOverlay,
    ADDCartOverlay,
    
};




typedef void (^RPWOverlayButtonTap)();

/*!
 @property	overlayView
 @abstract	contains the overlayview
 */
@property (nonatomic,assign) id <PopOverlayHandlerDelegate> overlayDelegate;
@property (nonatomic, strong) UIView *overlayView;

/*!
 @property	contentView
 @abstract	contains the contentView
 */
@property (nonatomic, strong) UIView *contentView;


@property (nonatomic, strong) UIImageView *dummyView;

//@property (nonatomic,strong) LocationFootFallView *footfallView;


/*!
 @property	buttonTitles
 @abstract	contains the titles for the buttons.Takes only two titles for this release, fistobject being from left most button.
 */
@property (nonatomic, strong) NSArray *buttonTitles;

/*!
 @property	didTapOnOverlayButton
 @abstract	It will be called when user taps on any of the button, this block will be called soon after the overlay is removed. and overlay will be removed for both the button taps.
 */
@property (nonatomic, copy) RPWOverlayButtonTap didTapOnOverlaybutton;



/*!
 @method     presentAlert: rootView:
 @abstract   presents the overlay for each type with its respective layout.This method initialises the overlay with the title,message and buttons if required.
 @param      iOverlayType - overlay type
 @param      iRootView - presents the root view.
 */
//- (void)presentAlert:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView;
- (void)presentAlert:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView withInfo:(NSDictionary *)aDict;

/*!
 @method     presentAlert: rootView:enableAutodismissal:
 @abstract   presents the overlay for each type with its respective layout.This method initialises the overlay with the title,message and buttons if required.
 @param      iOverlayType - overlay type
 @param      iRootView - presents the root view.
 @param		 iEnabled - If this bool is true then the overlay will be auto dismissed after some time.
 */
- (void)presentAlert:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView enableAutodismissal:(BOOL)iEnabled;

- (void)presentAlert:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView enableAutodismissal:(BOOL)iEnabled withUserInfo:(NSDictionary *)iInfo;



- (void)presentOverlay:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView enableAutodismissal:(BOOL)iEnabled withUserInfo:(NSDictionary *)iInfo;
- (void)dismissOverlay;

@end

@protocol PopOverlayHandlerDelegate <NSObject>
@optional
- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary;
@end
