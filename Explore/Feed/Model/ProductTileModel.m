//
//  ProductTileModel.m
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ProductTileModel.h"

//@implementation Action
//
//-(Action *)initWithDictionary:(NSDictionary *)dictionary{
//    self = [super init];
//    if(self){
//        self.type = dictionary[@"type"];
//        self.url = dictionary[@"url"];
//    }
//    
//    return self;
//}
//
//@end

@implementation ProductTileModel

-(ProductTileModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
//        self.aspect_ratio = dictionary[@"aspect_ratio"];
        //        self.aspect_ratio = dictionary[@"aspect_ratio"];
        NSDictionary *imageData = [dictionary objectForKey:@"product_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.product_image = [imageData objectForKey:@"url"];
            self.aspect_ratio = [imageData objectForKey:@"aspect_ratio"];
        }
        self.isImageDownloaded = dictionary[@"isImageDownloaded"];
//        self.product_image = dictionary[@"product_image"];

        self.product_name = dictionary[@"product_name"];
        self.is_bookmarked = [dictionary[@"is_bookmarked"] boolValue];
        self.price_marked = dictionary[@"price_marked"];
        self.price_effective = dictionary[@"price_effective"];
        self.brand_name = dictionary[@"brand_name"];
//        self.brand_logo = dictionary[@"brand_logo"];
        
        NSDictionary *logoData = [dictionary objectForKey:@"brand_logo"];
        if([logoData isKindOfClass:[NSDictionary class]] && logoData!=nil){
            self.productLogo = [logoData objectForKey:@"url"];
            self.productLogoAspectRatio = [logoData objectForKey:@"aspect_ratio"];
        }
        self.badge_url = dictionary[@"badge_url"];
        self.action = [[ActionModel alloc] initWithDictionary:dictionary[@"action"]];
        self.isOutOfStock = [dictionary[@"is_out_of_stock"] boolValue];
        if (dictionary[@"product_color"] != [NSNull null]) {
            self.productColor = dictionary[@"product_color"];
        }else{
            self.productColor = @"C4DDE0";
        }
        
        self.discountString = dictionary[@"discount"];
//        self.discountString = @"55% OFF";

    }
    return self;
}

@end
