//
//  CollectionTileModel.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CollectionTileModel.h"

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

@implementation CollectionTileModel

-(CollectionTileModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        self.discountString = dictionary[@"discount"];
//        self.aspect_ratio = dictionary[@"aspect_ratio"];
//        self.banner_url = dictionary[@"banner_url"];
        
        //        self.aspect_ratio = dictionary[@"aspect_ratio"];
        //        self.banner_url = dictionary[@"banner_url"];
        
        NSDictionary *imageData = [dictionary objectForKey:@"banner_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.banner_url = [imageData objectForKey:@"url"];
            self.bannerAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }

        self.banner_title = dictionary[@"banner_title"];
        self.name = dictionary[@"banner_title"];

//        self.brand_logo = dictionary[@"collection_logo"];
    
        
        NSDictionary *logoData = [dictionary objectForKey:@"collection_logo"];
        if([logoData isKindOfClass:[NSDictionary class]] && logoData!=nil){
            self.collectionlogo = [logoData objectForKey:@"url"];
            self.collectionLogoAspectRatio = [logoData objectForKey:@"aspect_ratio"];
        }
        
        self.last_updated = dictionary[@"last_updated"];
        self.is_following = [dictionary[@"is_following"] boolValue];
        self.product_count = [dictionary[@"product_count"] floatValue];
        self.follower_count = [dictionary[@"follower_count"] floatValue];
        
        self.products = [[NSMutableArray alloc] initWithCapacity:0];
        for(int i = 0; i < [dictionary[@"products"] count]; i++){
            [self.products addObject:[[SubProductModel alloc] initWithDictionary:[dictionary[@"products"] objectAtIndex:i]]];
        }
        self.action = [[ActionModel alloc] initWithDictionary:dictionary[@"action"]];
        
        if (dictionary[@"product_color"] != [NSNull null]) {
            self.productColor = dictionary[@"product_color"];
        }else{
            self.productColor = @"C4DDE0";
        }

    }
    return self;
}

-(CollectionTileModel *)initWithBrowseDataDictionary:(NSDictionary *)dictionary{
    
    self = [super init];
    if(self){
        
        NSDictionary *headerDictionary = [dictionary objectForKey:@"headers"];
        
        self.name = [headerDictionary objectForKey:@"banner_title"];
        self.collectionDescription = [headerDictionary objectForKey:@"description"];
        
        NSDictionary *imageData = [headerDictionary objectForKey:@"banner_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.banner_url = [imageData objectForKey:@"url"];
            self.bannerAspectRatio = [imageData objectForKey:@"aspect_ratio"];
        }
        
        NSDictionary *logoData = [headerDictionary objectForKey:@"collection_logo"];
        if([logoData isKindOfClass:[NSDictionary class]] && logoData!=nil){
            self.collectionlogo = [logoData objectForKey:@"url"];
            self.collectionLogoAspectRatio = [logoData objectForKey:@"aspect_ratio"];
        }
        
        self.is_following = [[headerDictionary objectForKey:@"is_following"] boolValue];
        self.follower_count = [headerDictionary[@"follower_count"] integerValue];
        self.product_count = [headerDictionary[@"product_count"] integerValue];
        self.last_updated = headerDictionary[@"last_updated"];
        
        NSArray *pickOfWeekProductsArray = [dictionary objectForKey:@"pick_of_the_week"];
        self.pickOfTheWeekProducts = [[NSMutableArray alloc] initWithCapacity:[pickOfWeekProductsArray count]];
        for(int i = 0; i < [pickOfWeekProductsArray count]; i++){
            NSDictionary *productDict = [pickOfWeekProductsArray objectAtIndex:i];
            ProductTileModel *product = [[ProductTileModel alloc] initWithDictionary:[productDict objectForKey:@"values"]];
            [self.pickOfTheWeekProducts addObject:product];
        }
        
        NSArray *morePorductsArray = [dictionary objectForKey:@"product_detail"];
        self.moreProducts = [[NSMutableArray alloc] initWithCapacity:[morePorductsArray count]];
        for(int i = 0; i < [morePorductsArray count]; i++){
            NSDictionary *productDict = [morePorductsArray objectAtIndex:i];
            ProductTileModel *product = [[ProductTileModel alloc] initWithDictionary:productDict];
            [self.moreProducts addObject:product];
        }
    }
    return self;
}
@end
