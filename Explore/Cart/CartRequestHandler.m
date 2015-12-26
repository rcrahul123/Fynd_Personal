//
//  CartRequestHandler.m
//  Explore
//
//  Created by Pranav on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CartRequestHandler.h"
#import "ShippingAddressModel.h"
#import "DeliveryTimeSlotModel.h"
#import "PaymentModes.h"
#import "ReturnReasons.h"
#import "PDPModel.h"

@implementation CartRequestHandler

- (void)addItemIntoCart:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kAddItemIntoCart];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


- (void)getCartItems:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
   
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kGetCartItems];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
    
}





- (void)deleteCartItem:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kDeleteItemFromCart];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}

- (void)getItemAvailableSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
 
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kCartItemSizes];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


- (void)getCartItemFyndAFitSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kFynaAFitSizesURL];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}

#pragma mark - Address Related Methods

-(void)fetchShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kGetDeliveryAddress];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler([self parseShippingData:responseData],nil);
            }
        }
    }];
    
}

-(void)addShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kAddDeliveryAddress];
    
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
    
}

-(void)deleteShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kDeleteDeliveryAddress];
    
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(void)updateShippingAdress:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kUpdateDeliveryAddress];
    
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(NSMutableArray *)parseShippingData:(id)response{
    NSMutableArray *theShippingDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *responseArray = response[@"address"];
    for(NSInteger counter=0; counter < [responseArray count]; counter++){
        ShippingAddressModel *addressModel = [[ShippingAddressModel alloc] initWithDictionary:[responseArray objectAtIndex:counter]];
        [theShippingDataArray addObject:addressModel];
    }
    return theShippingDataArray;
}

- (void)updateCartItemSizes:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kUpdateCartItemSize];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


- (void)applyCoupanCode:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kCartApplyCoupon];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}

- (void)removeCoupanCode:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kCartRemoveCoupon];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


- (void)validateCart:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kValidateCart];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
    
}

-(void)validateCartOnAddressSelect:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:[NSString stringWithFormat:@"%@?",kAddressSelect]];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


#pragma mark - Time Slot Service Call

-(void)fetchTimeSlotsWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:KGetTimeSlots];

    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler([self parseTimeSlots:responseData],nil);
            }
        }
    }];

}

-(NSMutableArray *)parseTimeSlots:(id)response{
    NSMutableArray *timeSlotsArray = [[NSMutableArray alloc] init];

    if ([response isKindOfClass:[NSArray class]]) {
        NSArray *responseArray = (NSArray *)response;
    
        if ([responseArray count]>0) {
            for (int iSlot = 0; iSlot<[responseArray count]; iSlot ++) {
                DeliveryTimeSlotModel *theModel = [[DeliveryTimeSlotModel alloc] initWithData:[responseArray objectAtIndex:iSlot]];
                [timeSlotsArray addObject:theModel];
            }
        }
    }
    return timeSlotsArray;
}

#pragma mark - Payment Modes Service

-(void)fetchPaymentModesWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kGetPaymentModes];
    [self sendHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler([self parsePaymentMode:responseData],nil);
            }
        }
    }];
    
}

-(NSMutableArray *)parsePaymentMode:(id)response{
    NSMutableArray *paymentModeArray = [[NSMutableArray alloc] init];
    
    NSArray *responseArray = (NSArray *)response;
    for (int iSlot = 0; iSlot<[responseArray count]; iSlot ++) {
        
        PaymentModes *theModel = [[PaymentModes alloc] initWithDictionary:[responseArray objectAtIndex:iSlot]];
        [paymentModeArray addObject:theModel];
    }
    return paymentModeArray;
}

-(void)addOrderPaymentModeWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kAddOrderPaymentMode];

    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}

#pragma mark - Orders API Calls

-(void)fetchReturnDataWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kReturnItem];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler([self parseReturnItemData:responseData],nil);
            }
        }
    }];
}

-(NSMutableDictionary *)parseReturnItemData:(id)response{
    NSMutableDictionary *theReturnDataDic = [[NSMutableDictionary alloc] init];
    if(response[@"success"]){

        NSMutableArray *timeSlots = [self parseTimeSlots:response[@"delivery_slots"]];
        [theReturnDataDic setObject:timeSlots forKey:@"delivery_slots"];
        
        NSMutableArray *returnReasons = [self parseReasons:response[@"return_reasons"]];
        [theReturnDataDic setObject:returnReasons forKey:@"return_reasons"];
       

        NSMutableArray *addressData = [self parseShippingDataForReturnOrder:response];
        [theReturnDataDic setObject:addressData forKey:@"order_address"];
        
    }else{
        theReturnDataDic = nil;
    }
    return theReturnDataDic;
}

-(void)returnItemWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kReturnItemConfirmation];
    
    [self sendJSONPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


-(NSMutableArray *)parseReasons:(id)response{
    NSMutableArray *reasonsArray = [[NSMutableArray alloc] init];
    
    NSArray *responseArray = (NSArray *)response;
    for (int iSlot = 0; iSlot<[responseArray count]; iSlot ++) {
        
        ReturnReasons *theModel = [[ReturnReasons alloc] initWithData:[responseArray objectAtIndex:iSlot]];
        [reasonsArray addObject:theModel];
    }
    return reasonsArray;

}

-(NSMutableArray *)parseShippingDataForReturnOrder:(id)response{
    NSMutableArray *shippingArray = [[NSMutableArray alloc] init];
    ShippingAddressModel *addressModel = [[ShippingAddressModel alloc] initWithDictionary:response[@"order_address"]];
    [shippingArray addObject:addressModel];
    return shippingArray;
    
}


-(void)cartCheckoutWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"cart-checkout/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


#pragma mark - Fetching the Exchange Items Data

-(void)fetchExchangeDataWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kExchangeItem];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler([self parseExchangeItemData:responseData],nil);
            }
        }
    }];
}

-(NSMutableDictionary *)parseExchangeItemData:(id)response{
    NSMutableDictionary *theReturnDataDic = [[NSMutableDictionary alloc] init];
//    if(response[@"success"]){
    
        NSMutableArray *timeSlots = [self parseTimeSlots:response[@"delivery_slots"]];
        [theReturnDataDic setObject:timeSlots forKey:@"delivery_slots"];
        
        //TODO - Need to get the Sizes.
        
        NSArray *anArray  = response[@"sizes"];
        NSMutableArray *sizeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSInteger sizeCounter=0; sizeCounter < [anArray count]; sizeCounter++){
            NSDictionary *sizeDict = [anArray objectAtIndex:sizeCounter];
            ProductSize *size = [[ProductSize alloc] initWithDictionary:sizeDict];
            [sizeArray addObject:size];
        }
        [theReturnDataDic setObject:sizeArray forKey:@"sizes"];
        
        NSMutableArray *addressData = [self parseShippingDataForReturnOrder:response];
        [theReturnDataDic setObject:addressData forKey:@"order_address"];
        
    return theReturnDataDic;
}


-(void)exchangeItemWithParams:(NSDictionary *)params withCompletionHandler:(CartRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kExchangeItemConfirm];
    
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


@end
