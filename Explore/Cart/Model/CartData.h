//
//  CartData.h
//  Explore
//
//  Created by Pranav on 06/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentModes.h"
#import "DeliveryTimeSlotModel.h"
#import "ShippingAddressModel.h"

@interface CoupanDetails : NSObject
@property (nonatomic,strong) NSString   *couponCode;
@property (nonatomic,assign) BOOL       isCoupanValid;
@property (nonatomic,assign) BOOL       isCoupanApplied;
@property (nonatomic,strong) NSString   *coupanStatus;
@end

@interface CartData : NSObject

@property (nonatomic,strong) NSMutableArray *cartBreakUpValues;
@property (nonatomic,strong) NSMutableArray *cartItems;
@property (nonatomic,strong) CoupanDetails  *coupanDetails;
@property (nonatomic,assign) BOOL           isCouponRemoved;
@property (nonatomic,assign) BOOL           isValid;
@property (nonatomic,copy)   NSString       *cartId;
@property (nonatomic, strong) NSMutableArray *parsedPaymentModes;
@property (nonatomic, strong) NSMutableArray *cardList;
@property (nonatomic, strong) NSDictionary *defaultPaymentOption;
@property (nonatomic, strong) NSMutableArray *timeSlotsArray;
@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) ShippingAddressModel *defaultAddress;
@property (nonatomic, strong) NSString *orderId;

- (CartData *)initWithDictionary:(NSDictionary *)dataDict;
- (void)updateCartPaymentSummary:(NSDictionary *)refreshPaymentDict;
- (void)refreshCartDataWithCoupon:(NSDictionary *)newCartData;

- (void)refreshInvalidCartItems:(NSDictionary *)data;
@end
