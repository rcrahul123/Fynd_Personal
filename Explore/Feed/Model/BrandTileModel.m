//
//  BrandTileModel.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrandTileModel.h"

//@implementation Action
//
//-(Action *)initWithDictionary:(NSDictionary *)dictionary{
//    self = [super init];
//    if(self){
//        self.type = dictionary[@"type"];
//        self.url = dictionary[@"url"];
//    }
//    return self;
//}
//@end


//@implementation Products
//
//-(Products *)initWithDictionary:(NSDictionary *)dictionary{
//    self = [super init];
//    if(self){
//        self.product_image = dictionary[@"product_image"];
//        self.action = [[ActionModel alloc] initWithDictionary:dictionary[@"url"]];
//    }
//    return self;
//}
//@end


@implementation BrandTileModel



-(BrandTileModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        //        self.aspect_ratio = dictionary[@"aspect_ratio"];
        //        self.banner_url = dictionary[@"banner_url"];
        
        //        self.aspect_ratio = dictionary[@"aspect_ratio"];
        //        self.banner_url = dictionary[@"banner_url"];
        
        self.discountString = dictionary[@"discount"];
        
        NSDictionary *imageData = [dictionary objectForKey:@"banner_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.banner_url = [imageData objectForKey:@"url"];
            self.brandBannerAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }
        self.banner_title = dictionary[@"banner_title"];
        self.name = [dictionary objectForKey:@"banner_title"];
        
        
        //        self.brand_logo = dictionary[@"brand_logo"];
        NSDictionary *logoData = [dictionary objectForKey:@"brand_logo"];
        if([logoData isKindOfClass:[NSDictionary class]] && logoData!=nil){
            self.brandlogo = [logoData objectForKey:@"url"];
            self.brandLogoAspectRatio = [logoData objectForKey:@"aspect_ratio"];
        }
        self.nearest_store = dictionary[@"nearest_store"];
        if(dictionary[@"is_following"] != [NSNull null]){
            self.is_following = [dictionary[@"is_following"] boolValue];
        }
        if(dictionary[@"product_count"] != [NSNull null]){
            self.product_count = [dictionary[@"product_count"] floatValue];
        }
        if(dictionary[@"store_count"] != [NSNull null]){
            self.store_count = [dictionary[@"store_count"] floatValue];
        }
        if(dictionary[@"follower_count"] != [NSNull null]){
            self.follower_count = [dictionary[@"follower_count"] floatValue];
        }
        
        self.products = [[NSMutableArray alloc] initWithCapacity:0];
        for(int i = 0; i < [dictionary[@"products"] count]; i++){
            subProductModel = [[SubProductModel alloc] initWithDictionary:[dictionary[@"products"] objectAtIndex:i]];
            [self.products addObject:subProductModel];
        }
        self.action = [[ActionModel alloc] initWithDictionary:dictionary[@"action"]];
    }
    if (dictionary[@"product_color"] != [NSNull null]) {
        self.productColor = dictionary[@"product_color"];
    }else{
        self.productColor = @"C4DDE0";
    }
    
    return self;
}


-(BrandTileModel *)initWithBrowseDataDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        NSDictionary *headerDictionary = [dictionary objectForKey:@"headers"];
        
        self.name = [headerDictionary objectForKey:@"banner_title"];
        self.brandDescription = [headerDictionary objectForKey:@"description"];
        
        NSDictionary *imageData = [headerDictionary objectForKey:@"banner_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.banner_url = [imageData objectForKey:@"url"];
            self.brandBannerAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }
        
        NSDictionary *logoData = [headerDictionary objectForKey:@"brand_logo"];
        if([logoData isKindOfClass:[NSDictionary class]] && logoData!=nil){
            self.brandlogo = [logoData objectForKey:@"url"];
            self.brandLogoAspectRatio = [logoData objectForKey:@"aspect_ratio"];
        }
        
        self.is_following = [headerDictionary[@"is_following"] floatValue];
        self.store_count = [headerDictionary[@"store_count"] floatValue];
        self.follower_count = [headerDictionary[@"follower_count"] floatValue];
        self.nearest_store = headerDictionary[@"nearest_store"];
        
        
        NSArray *pickOfWeekProductsArray = [dictionary objectForKey:@"pick_of_the_week"];
        self.pickOfTheWeekProducts = [[NSMutableArray alloc] initWithCapacity:[pickOfWeekProductsArray count]];
        for(int i = 0; i < [pickOfWeekProductsArray count]; i++){
            NSDictionary *productDict = [pickOfWeekProductsArray objectAtIndex:i];
            product = [[ProductTileModel alloc] initWithDictionary:[productDict objectForKey:@"values"]];
            [self.pickOfTheWeekProducts addObject:product];
        }
        
        NSArray *morePorductsArray = [dictionary objectForKey:@"product_detail"];
        self.moreProducts = [[NSMutableArray alloc] initWithCapacity:[morePorductsArray count]];
        for(int i = 0; i < [morePorductsArray count]; i++){
            NSDictionary *productDict = [morePorductsArray objectAtIndex:i];
            product = [[ProductTileModel alloc] initWithDictionary:productDict];
            [self.moreProducts addObject:product];
        }
    }
    return self;
}

@end
