//
//  CartData.m
//  Explore
//
//  Created by Pranav on 06/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CartData.h"
#import "CartItem.h"

@implementation CartData
@synthesize cardList;

-(CartData *)initWithDictionary:(NSDictionary *)dataDict{
    
    self = [super init];
    if(self){
        
        NSArray *cartItems = [dataDict objectForKey:@"items"];
        if(cartItems && [cartItems count]>0){
            self.cartItems = [[NSMutableArray alloc] initWithCapacity:0];
        }
        for(NSInteger itemsCounter=0; itemsCounter < [cartItems count]; itemsCounter++){
            NSDictionary *cartDict = [cartItems objectAtIndex:itemsCounter];
            CartItem *cartItem = [[CartItem alloc] initWithCartItemDictionary:cartDict];

            [self.cartItems addObject:cartItem];
        }
        
        self.cartId = dataDict[@"cart_id"];
        self.isValid = [dataDict[@"is_valid"] boolValue];
        NSArray *breakUpValues = [dataDict objectForKey:@"breakup_values"];
        if(breakUpValues){
            self.cartBreakUpValues = [[NSMutableArray alloc] initWithCapacity:0];
        }

        for(NSInteger counter=0; counter < [breakUpValues count]; counter++){

            NSDictionary *paymentDict = [breakUpValues objectAtIndex:counter];
            NSString *paymentKey = [paymentDict objectForKey:@"key"];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[paymentDict objectForKey:@"value"]],paymentKey, nil];
            [self.cartBreakUpValues addObject:dict];
        }
        
        NSDictionary *coupanDetailDict = [dataDict objectForKey:@"coupon_details"];
        if(coupanDetailDict){
            self.coupanDetails = [[CoupanDetails alloc] init];
            self.coupanDetails.couponCode = [coupanDetailDict objectForKey:@"coupon_code"];
            self.coupanDetails.isCoupanValid = [[coupanDetailDict objectForKey:@"is_valid"] boolValue];
            self.coupanDetails.isCoupanApplied = [[coupanDetailDict objectForKey:@"is_applied"] boolValue];
            self.coupanDetails.coupanStatus = [coupanDetailDict objectForKey:@"coupon_status"];
         }
        
        NSDictionary *paymentOptionDictionary = dataDict[@"payment_options"];
        if([paymentOptionDictionary isKindOfClass:[NSDictionary class]] && [[paymentOptionDictionary allKeys] count] > 0){
            [self parsePaymentModes:paymentOptionDictionary];
        
        
            if(paymentOptionDictionary[@"default"]){
                self.defaultPaymentOption = [self getDefaultPaymentMethod:paymentOptionDictionary[@"default"]];
            }
        }
        
        if(dataDict[@"delivery_slots"]){
            self.timeSlotsArray = [self parseTimeSlots:dataDict[@"delivery_slots"]];
        }
        
        if(dataDict[@"delivery_address"]){
            self.addressArray = [self parseShippingData:dataDict[@"delivery_address"]];
        }
        if([self.addressArray count] > 0){
            self.defaultAddress = [self.addressArray objectAtIndex:0];
        }
        
        self.orderId = dataDict[@"order_id"];
    }
    return self;
}



-(NSDictionary *)getDefaultPaymentMethod:(NSDictionary *)dataDictionary{
    
    NSDictionary *defaultOptionDictionary;
    
    NSString *mode = dataDictionary[@"mode"];
    NSDictionary *dictionary = dataDictionary[@"data"];
    if([[mode uppercaseString] isEqualToString:@"CARD"]){
        CardModel *card = [[CardModel alloc] initWithDictionary:dictionary];
        defaultOptionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:mode, @"mode", card, @"data", nil];
        
    }else if([[mode uppercaseString] isEqualToString:@"NB"]){
        NetBankingModel *bank = [[NetBankingModel alloc] initWithDictionary:dictionary];
        defaultOptionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:mode, @"mode", bank, @"data", nil];
    }
    return defaultOptionDictionary;
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

-(void)parsePaymentModes:(NSDictionary *)dict{
    _parsedPaymentModes = [[NSMutableArray alloc] initWithCapacity:0];
    
    cardList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *paymentOptionsArray = [dict objectForKey:@"payment_option"];
    
    for(int i = 0; i < [paymentOptionsArray count]; i++){
        PaymentModes *mode = [[PaymentModes alloc] initWithDictionary:[paymentOptionsArray objectAtIndex:i]];


        if([[mode.paymentName uppercaseString] isEqualToString:@"CARD"]){
            [cardList addObjectsFromArray:mode.optionsArray];
        }else{
            [_parsedPaymentModes addObject:mode];
        }
    }
}


-(NSMutableArray *)parseShippingData:(id)responseArray{
    NSMutableArray *theShippingDataArray = [[NSMutableArray alloc] initWithCapacity:0];
//    NSArray *responseArray = response[@"address"];
    for(NSInteger counter=0; counter < [responseArray count]; counter++){
        ShippingAddressModel *addressModel = [[ShippingAddressModel alloc] initWithDictionary:[responseArray objectAtIndex:counter]];
        [theShippingDataArray addObject:addressModel];
    }
    return theShippingDataArray;
}


- (void)updateCartPaymentSummary:(NSDictionary *)refreshPaymentDict{
    
    if(self.cartBreakUpValues){
        [self.cartBreakUpValues removeAllObjects];
        self.cartBreakUpValues = nil;
    }
    self.cartBreakUpValues = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *breakUpValues = [refreshPaymentDict objectForKey:@"breakup_values"];
    if(breakUpValues){
        self.cartBreakUpValues = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    for(NSInteger counter=0; counter < [breakUpValues count]; counter++){
        
        NSDictionary *paymentDict = [breakUpValues objectAtIndex:counter];
        NSString *paymentKey = [paymentDict objectForKey:@"key"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[paymentDict objectForKey:@"value"]],paymentKey, nil];
        [self.cartBreakUpValues addObject:dict];
    }
    
    
    NSDictionary *coupanDetailDict = [refreshPaymentDict objectForKey:@"coupon_details"];
    if(coupanDetailDict){
        self.coupanDetails = [[CoupanDetails alloc] init];
        self.coupanDetails.couponCode = [coupanDetailDict objectForKey:@"coupon_code"];
        self.coupanDetails.isCoupanValid = [[coupanDetailDict objectForKey:@"is_valid"] boolValue];
        self.coupanDetails.isCoupanApplied = [[coupanDetailDict objectForKey:@"is_applied"] boolValue];
        self.coupanDetails.coupanStatus = [coupanDetailDict objectForKey:@"coupon_status"];
    }
    
    //For Card Removal
    self.isCouponRemoved = [[refreshPaymentDict objectForKey:@"is_removed"] boolValue];
    
    /*
    if(self.coupanDetails){
        self.coupanDetails = nil;
    }
     */
}


- (void)refreshCartDataWithCoupon:(NSDictionary *)newCartData{
    
    NSDictionary *coupanDetailDict = [newCartData objectForKey:@"coupon_details"];
    if(coupanDetailDict){
        if(self.coupanDetails== nil)
            self.coupanDetails = [[CoupanDetails alloc] init];
        
        self.coupanDetails.couponCode = [coupanDetailDict objectForKey:@"coupon_code"];
        self.coupanDetails.isCoupanValid = [[coupanDetailDict objectForKey:@"is_valid"] boolValue];
        self.coupanDetails.isCoupanApplied = [[coupanDetailDict objectForKey:@"is_applied"] boolValue];
        self.coupanDetails.coupanStatus = [coupanDetailDict objectForKey:@"coupon_status"];
    }
    
    NSArray *breakUpValues = [newCartData objectForKey:@"breakup_values"];
    if(breakUpValues){
        self.cartBreakUpValues = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    for(NSInteger counter=0; counter < [breakUpValues count]; counter++){
        
        NSDictionary *paymentDict = [breakUpValues objectAtIndex:counter];
        NSString *paymentKey = [paymentDict objectForKey:@"key"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[paymentDict objectForKey:@"value"]],paymentKey, nil];
        [self.cartBreakUpValues addObject:dict];
    }
}


- (void)refreshInvalidCartItems:(NSDictionary *)data{
    
    if(self.cartItems){
        [self.cartItems removeAllObjects];
        self.cartItems = nil;
    }
    NSArray *cartItems = [data objectForKey:@"items"];
    if(cartItems && [cartItems count]>0){
        self.cartItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    for(NSInteger itemsCounter=0; itemsCounter < [cartItems count]; itemsCounter++){
        NSDictionary *cartDict = [cartItems objectAtIndex:itemsCounter];
        CartItem *cartItem = [[CartItem alloc] initWithCartItemDictionary:cartDict];
        //            cartItem.cartItemIndex = itemsCounter;
        [self.cartItems addObject:cartItem];
    }
    self.isValid = [[data objectForKey:@"is_valid"] boolValue];
    
}

@end

@implementation CoupanDetails
@synthesize couponCode;
@synthesize isCoupanValid;
@synthesize isCoupanApplied;
@synthesize coupanStatus;

@end
