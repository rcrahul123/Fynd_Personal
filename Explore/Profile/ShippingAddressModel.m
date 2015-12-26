//
//  ShippingAddressModel.m
//  Explore
//
//  Created by Amboj Goyal on 8/12/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ShippingAddressModel.h"

@implementation ShippingAddressModel
-(ShippingAddressModel *)initWithDictionary:(NSDictionary *)dictionary{
    
    if(self == [super init]){
        self.theFirstName = dictionary[@"name"];
        self.theMobileNo = [NSString stringWithFormat:@"%@",dictionary[@"phone"]];
        self.theFlatNBuildingName = dictionary[@"address"];
        self.theStreetName = dictionary[@"area"];
        self.thePincode = [NSString stringWithFormat:@"%@",dictionary[@"pincode"]];
        self.theAddressType = dictionary[@"address_type"];
        self.theUserId = [NSString stringWithFormat:@"%@",dictionary[@"user_id"]];
        self.theAddressID = [NSString stringWithFormat:@"%@",dictionary[@"address_id"]];
        self.isDefaultAddress = [dictionary[@"is_default_address"] boolValue];
    }
    return self;
}

@end
