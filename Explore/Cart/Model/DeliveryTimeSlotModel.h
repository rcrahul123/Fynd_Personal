//
//  DeliveryTimeSlotModel.h
//  Explore
//
//  Created by Amboj Goyal on 9/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryTime : NSObject
@property (nonatomic,copy)NSString *deliveryTimeId;
@property (nonatomic,copy)NSString *deliveryTimeValue;
@property (nonatomic,assign)BOOL isDefaultDeliverySlot;

@end

@interface DeliveryTimeSlotModel : NSObject
@property (nonatomic,copy) NSString *aDeliveryDate;
@property (nonatomic,strong) NSArray *aDeliveryTimeArray;
@property (nonatomic,assign)BOOL isDefaultDate;

-(DeliveryTimeSlotModel *)initWithData:(NSDictionary *)theDataDictionary;
@end

