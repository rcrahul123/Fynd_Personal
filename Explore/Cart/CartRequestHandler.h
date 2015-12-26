//
//  CartRequestHandler.h
//  Explore
//
//  Created by Pranav on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"

typedef void (^CartRequestCompletionHandler)(id responseData,
                                               NSError *error);

@interface CartRequestHandler : SSBaseRequestHandler


- (void)addItemIntoCart:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)getCartItems:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)deleteCartItem:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)getItemAvailableSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)getCartItemFyndAFitSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;

-(void)fetchShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler;
-(void)addShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler;
-(void)deleteShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler;
-(void)updateShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler;

- (void)updateCartItemSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)applyCoupanCode:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)removeCoupanCode:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;

-(void)fetchTimeSlotsWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
-(void)fetchPaymentModesWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
- (void)validateCart:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
-(void)addOrderPaymentModeWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;


-(void)fetchReturnDataWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
-(void)returnItemWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;

-(void)fetchExchangeDataWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
-(void)exchangeItemWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;

-(void)cartCheckoutWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;

-(void)validateCartOnAddressSelect:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler;
@end
