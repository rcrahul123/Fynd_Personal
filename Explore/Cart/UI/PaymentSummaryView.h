//
//  PaymentSummaryView.h
//  Explore
//
//  Created by Rahul Chaudhari on 02/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PullableView.h"
#import "UIFont+FontWithNameAndSize.h"
#import "PaymentModes.h"
#import "ShippingAddressModel.h"
#import "DeliveryTimeSlotModel.h"
#import "CartRequestHandler.h"
#import "TextFieldWithImage.h"
#import "CartData.h"


@protocol PaymentSummaryDelegate <NSObject>

-(void)addNewAddress;
-(void)changeTimeSlot;
-(void)addPaymentMode;

-(void)couponAppliedSuccessfully:(NSString *)message;
-(void)failedToApplyCoupon:(NSString *)message;

@end

@interface PaymentSummaryView : PullableView<UITextFieldDelegate>{
    UIView *swipeIndicatorView;
    UIImage *indicatorBarImage;
    UIImage *indicatorUpArrowImage;
    UIImage *indicatorDownArrowImage;

    UIImageView *indicatorImageView;
    UILabel *paymentDetailLabel;
    
    UIView *payButtonContainer;
    UIButton *payButton;
    
    UIView *topViewContainer;
    UIView *bottomViewContainer;
    
    UIImageView *addressImageView;
    UIView *addAddressView;
    UILabel *addressLabel;
    UIImage *addressPlusImage;
    UIImageView *addressPlusImageView;
    
    UIImageView *paymentImageView;
    UIView *addPaymentOptionView;
    UILabel *paymentLabel;
    UIImage *paymentPlusImage;
    UIImageView *paymentPlusImageView;
    
    UIView *enterCouponCodeView;
    UITextField *couponTextField;
    UIButton *applyCouponButton;
    UIImageView *couponImageView;
    
    UILabel *viewDetailLabel;
    UITableView *paymentDetailTable;
    
    UILabel *addressTypeLabel;
    UILabel *addressName;
    
    UIView *timeSlotContainer;
    UILabel *timeSlotHeader;
    UILabel *timeSlotLabel;
    UILabel *timeSlotErrorLabel;
    
    UIView *overLayView;
    
    UITapGestureRecognizer *addAddressTapGesture;
    UITapGestureRecognizer *changeTimeSlotGesture;
    UITapGestureRecognizer *changePaymentOptionGesture;
    
    FyndActivityIndicator *couponLoader;
    UILabel *couponValueLabel;
    
    NSAttributedString *couponButtonString;
    BOOL isCouponApplied;
    
    CartRequestHandler *requestHandler;
    UIScrollView *scrollView;
    
    BOOL isCouponRemoved;
    
    UIButton *hiddenAddressButton;
    UIButton *hiddenTimeSlotButton;
    UIButton *hiddenPaymentOptionBtton;
}

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, strong) UIView *swipeIndicatorView;
@property (nonatomic, strong) UIView *payButtonContainer;
@property (nonatomic, strong) NSMutableArray *cartBreakupDetails;
@property (nonatomic, strong) id<PaymentSummaryDelegate> paymentDelegate;
@property (nonatomic, strong) UITextField *couponTextField;

@property (nonatomic, strong) NSDictionary *paymentModeDictionary;
@property (nonatomic, strong) ShippingAddressModel *defaultShippingAddress;
@property (nonatomic, strong) DeliveryTimeSlotModel *defaultTimeSlot;
@property (nonatomic, assign) CGPoint anchoredCenter;

@property (nonatomic, strong)  UIImage *indicatorBarImage;
@property (nonatomic, strong)  UIImage *indicatorUpArrowImage;
@property (nonatomic, strong)  UIImage *indicatorDownArrowImage;
@property (nonatomic, strong)  UIImageView *indicatorImageView;
@property (nonatomic, strong) CoupanDetails *couponData;
@property (nonatomic, assign) CGFloat viewDetailBottom;

-(void)drawUIComponents;
-(void)changeArrowDirection;

-(void)updateAddress;
-(void)updateTimeSlot;
-(void)updatePaymentMode;

-(void)showAddressErrorState;
-(void)showPaymentErrorState;
@end
