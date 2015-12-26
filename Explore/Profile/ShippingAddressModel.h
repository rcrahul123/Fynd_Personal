//
//  ShippingAddressModel.h
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingAddressModel : NSObject

@property (nonatomic,copy) NSString * theFirstName;
@property (nonatomic,copy) NSString * theMobileNo;
@property (nonatomic,copy) NSString * theFlatNBuildingName;
@property (nonatomic,copy) NSString * theStreetName;
@property (nonatomic,copy) NSString * thePincode;
@property (nonatomic,copy) NSString * theAddressType;
@property (nonatomic,copy)NSString *theAddressID;
@property (nonatomic,assign)BOOL isDefaultAddress;
@property (nonatomic,copy)NSString *theUserId;
@property (nonatomic,strong)NSMutableArray *theTimeSlotArray;
-(ShippingAddressModel *)initWithDictionary:(NSDictionary *)dictionary;
@end
