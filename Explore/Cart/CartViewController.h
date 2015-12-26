//
//  CartViewController.h
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Transparency.h"

#import "PaymentSummaryView.h"
#import "SSLine.h"
#import "PaymentCartRequestHandler.h"
#import "PaymentWebViewController.h"
#import "PaymentController.h"
#import "ShippingAddressListViewController.h"
#import "PopOverlayHandler.h"
#import "FeedViewController.h"
#import "TabBarViewController.h"
#import "CardAuthenticationViewController.h"
#import "FyndErrorInfoView.h"

@interface CartViewController : UIViewController<UIGestureRecognizerDelegate,PullableViewDelegate, PaymentSummaryDelegate,PaymentControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, ShippingAddressDetailViewDelegate, ShippingAddressListViewDelegate,PaymentTransactionDelegate,CardAuthenticationViewDelegate,PaymentTransactionDelegate>
{
    NSMutableArray *itemSizes;
    CartScreenNavigationType screenType;
    FyndActivityIndicator *cartLoader;
    

    PaymentSummaryView *paymentSummaryView;
    
    
    CGFloat swipeDiff;
    
    PaymentWebViewController *paymentWebViewController;
    UIView *payButtonContainer;
    UIButton *payButton;
    UIView *payOverlayView;
    BOOL isObserverAdded;
    CGFloat slidingRange;
    UIView *overlayView;
    CGFloat overlayMaxAlpha;
    
    SSLine *pickerSeperator;
    UIView *pickerViewContainer;

    
    UITapGestureRecognizer *tapGestureToCloseDetailView;
    
    PullableState previousState;
    PaymentController *paymentController;
}

@property (nonatomic,strong) PaymentSummaryView *paymentSummaryView;
@property (nonatomic, strong) ShippingAddressListViewController *addressController;
@property (nonatomic,strong) PopOverlayHandler *paymentOverlay;
@property (nonatomic,copy) NSString * orderId;



-(void)selectedNetbankingOption:(NSDictionary *)netBankingData;
@end
