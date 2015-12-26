//
//  MyCoupons.m
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "MyCoupons.h"

@implementation MyCoupons

-(MyCoupons *)initWithDictionary:(NSDictionary *)dictionary{
    
    if(self == [super init]){
        self.coupanName = dictionary[@"coupanName"];
        self.coupanDescription = dictionary[@"coupanDescription"];
        self.discountAmount = [dictionary[@"coupanDiscount"] integerValue];
        self.coupanExpiry = dictionary[@"coupanExpiry"];
    }
    return self;
}

@end
