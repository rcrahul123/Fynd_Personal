//
//  MyOrderModel.m
//  Explore
//
//  Created by Rahul Chaudhari on 04/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyOrderModel.h"


@implementation ShipmentItem

-(id)initWithDictionary:(NSDictionary *)dataDictionary{
    self = [super init];
    
    
    self.productName = dataDictionary[@"product_name"];
    self.productId = [dataDictionary[@"product_id"] integerValue];
    self.bagId = [dataDictionary[@"bag_id"] integerValue];
    NSDictionary *imageDictionary = dataDictionary[@"product_image"];
    self.productImageURL = imageDictionary[@"url"];
    self.aspectRatio = imageDictionary[@"aspect_ratio"];
    
//    self.action = dataDictionary[@"action"];
    
    self.action = [[ActionModel alloc] initWithDictionary:dataDictionary[@"action"]];
    
    NSDictionary *dict = dataDictionary[@"status"];

    self.deliveryStatus = dict[@"title"];
    self.hexCode = dict[@"hex_code"];

    self.actionTime = dataDictionary[@"last_action_time"];

    if(self.actionTime && self.actionTime.length <= 0){
        self.actionTime = dataDictionary[@"time_slot"];
    }
    
//    self.actionTime = dataDictionary[@"time_slot"];
    
    self.price = dataDictionary[@"price"];
    self.canReturn = [dataDictionary[@"can_return"] boolValue];
    self.canExchange = [dataDictionary[@"can_exchange"] boolValue];
    self.isTryAtHome = [dataDictionary[@"is_try_at_home"] boolValue];
//    self.sizeString = [dataDictionary[@"size"] stringByReplacingOccurrencesOfString:@"," withString:@"/"];
    self.sizeString = dataDictionary[@"size"];
    
    return  self;
}

@end

@implementation MyOrderModel

-(id)initWithDictionary:(NSDictionary *)dataDictionary{
    self = [super init];
    
    self.orderId = dataDictionary[@"order_id"];
    self.isActiveOrder = [dataDictionary[@"is_active"] boolValue];
    self.orderDate = dataDictionary[@"order_date"];

    self.shipmentArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [dataDictionary[@"shipments"] count]; i++){
        ShipmentItem *shipment = [[ShipmentItem alloc] initWithDictionary:[dataDictionary[@"shipments"] objectAtIndex:i]];
        [self.shipmentArray addObject:shipment];
    }
    self.userName = dataDictionary[@"user_name"];
    self.deliveryAddressType = dataDictionary[@"delivery_address_type"];
    self.deliveryAddress = dataDictionary[@"delivery_address"];
    self.totalCost = dataDictionary[@"order_value"];
    self.modeOfPayment = dataDictionary[@"payment_mode"];
    self.canCancel = [dataDictionary[@"can_cancel"] boolValue];
    
    NSString *deliveryTimeSlotString = dataDictionary[@"delivery_time_slot"];
    
    if ([deliveryTimeSlotString rangeOfString:@","].length>0) {
         NSArray *deliveryDateTime = [deliveryTimeSlotString componentsSeparatedByString:@","];
        self.deliveryTime = [deliveryDateTime objectAtIndex:0];
        self.deliveryDate = [deliveryDateTime objectAtIndex:1];
    }
    

    NSDictionary *dict = dataDictionary[@"status"];
    
    self.orderStatus = dict[@"title"];
    self.hexCode = dict[@"hex_code"];

    
    return self;
}

@end
