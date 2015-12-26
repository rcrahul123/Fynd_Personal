//
//  DeliveryTimeSlotModel.m
//  Explore
//
//  Created by Amboj Goyal on 9/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "DeliveryTimeSlotModel.h"

@implementation DeliveryTimeSlotModel

-(DeliveryTimeSlotModel *)initWithData:(NSDictionary *)theDataDictionary{
    self = [super init];
    if (self) {
    
        self.aDeliveryDate = theDataDictionary[@"date"];
        NSArray *deliverySlots = theDataDictionary[@"delivery_slot"];
        NSMutableArray *theSlots = [[NSMutableArray alloc] init];
        if (deliverySlots && [deliverySlots count]>0) {
            for (NSDictionary *theDic in deliverySlots) {
                DeliveryTime *theTime = [[DeliveryTime alloc] init];
                 theTime.deliveryTimeId = [NSString stringWithFormat:@"%@",theDic[@"delivery_slot_id"]];
                theTime.deliveryTimeValue = theDic[@"delivery_slot_timing"];
                theTime.isDefaultDeliverySlot = [theDic[@"default"] boolValue];
                [theSlots addObject:theTime];
            }
            self.aDeliveryTimeArray = theSlots;
        }
        
        
        
    }
    
    
    return self;
}
@end

@implementation DeliveryTime
@end