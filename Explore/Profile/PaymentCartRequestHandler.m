//
//  PaymentCartRequestHandler.m
//  Explore
//
//  Created by Pranav on 01/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PaymentCartRequestHandler.h"

@implementation PaymentCartRequestHandler


- (void)fetchBankCards:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:@"list-cards/?"];
    
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
    
}


- (void)removeBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:@"delete-card/"];
    
    [self sendJustPayAddRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


- (void)editBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:@"edit-card/"];

    [self sendJustPayAddRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
    
}

//Add Card Service
- (void)addBankCard:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler{
   
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://api.juspay.in"];
    [urlString appendString:@"/card/add"];
    
    [self sendJustPayAddRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)fetchTransactionParamsFromJustPay:(NSDictionary *)params withCompletionHandler:(SSPaymentCartRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"https://api.juspay.in"];
    [urlString appendString:@"/txns"];
    
    [self sendJusPayPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


@end
