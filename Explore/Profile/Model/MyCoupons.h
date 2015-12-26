//
//  MyCoupons.h
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCoupons : NSObject

@property (nonatomic,copy) NSString *coupanName;
@property (nonatomic,assign) NSInteger discountAmount;
@property (nonatomic,copy) NSString *coupanDescription;
@property (nonatomic,copy) NSString *coupanExpiry;

-(MyCoupons *)initWithDictionary:(NSDictionary *)dictionary;
@end
