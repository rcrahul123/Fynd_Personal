//
//  SubProductModel.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SubProductModel.h"

@implementation SubProductModel


-(SubProductModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
//        self.product_image = dictionary[@"product_image"];
        
        NSDictionary *imageData = [dictionary objectForKey:@"product_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.product_image = [imageData objectForKey:@"url"];
            self.subProductAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }
        if (dictionary[@"product_color"] != [NSNull null]) {
            self.productColor = dictionary[@"product_color"];
        }else{
            self.productColor = @"C4DDE0";
        }
        self.action = [[ActionModel alloc] initWithDictionary:dictionary[@"action"]];
        
//        self.shouldShowBadge = [dictionary[@"isDiscountAvailable"] boolValue];
        self.shouldShowBadge = true;
    }
    return self;
}

@end
