//
//  PaymentCartRequestHandler.h
//  Explore
//
//  Created by Pranav on 01/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"


typedef void (^SSPaymentCartRequestCompletionHandler)(id responseData,
                                                  NSError *error);

@interface PaymentCartRequestHandler : SSBaseRequestHandler


- (void)fetchBankCards:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler;
- (void)addBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler;
- (void)removeBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler;
- (void)editBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler;

-(void)fetchTransactionParamsFromJustPay:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler;

@end
