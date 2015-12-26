//
//  ProductDescripton.m
//  Explore
//
//  Created by Pranav on 10/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPModel.h"

@implementation PDPModel
-(PDPModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.isTryAtHomeAvailable = [dictionary[@"is_try_at_home_available"] boolValue];
//        self.sizeGuideArray = dictionary[@"size_guide"];
        NSArray *anArray  = dictionary[@"sizes"];
        self.sizeArray = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSInteger sizeCounter=0; sizeCounter < [anArray count]; sizeCounter++){
            NSDictionary *sizeDict = [anArray objectAtIndex:sizeCounter];
            ProductSize *size = [[ProductSize alloc] initWithDictionary:sizeDict];
            [self.sizeArray addObject:size];
        }
        
        self.bookmarkCount = [dictionary[@"bookmark_count"] integerValue];
        self.brandName = dictionary[@"brand"];
        
        self.productDescription = dictionary[@"description"]; //info_text
        self.productInfomation = dictionary[@"info_text"];
        self.productBookMerked = [dictionary[@"is_bookmarked"] boolValue];
        self.productInfo = dictionary[@"info_text"];
        
        self.discount = dictionary[@"discount"];
//        self.discount = @"50%";
        
        self.logoImageData = [[ImageData alloc] initWithDictionary:dictionary[@"brand_logo"]];
        self.sizeGuideImageData = [[ImageData alloc] initWithDictionary:dictionary[@"size_guide"]];
        self.productEffectivePrice =dictionary[@"price_effective"];
      
        self.productMarkedPrice = dictionary[@"price_marked"];
//        self.productMarkedPrice = @"4000";
//        self.badge = @"Limited Stock";
        self.badge = dictionary[@"badge"];

        self.bookedMarkedPrice = [dictionary[@"is_bookmarked"] boolValue];
        self.priceMarked =dictionary[@"price_marked"];
        self.pickAtStoreAvailable = [dictionary[@"is_pick_at_store_available"] boolValue];
        self.shareUrl = dictionary[@"share_url"];
        self.brandName = dictionary[@"brand"];
        self.suggestedProductList = dictionary[@"similar_products_url"];
        self.producetAllImages = [[NSMutableArray alloc] initWithCapacity:0];
         NSArray *pdpImage = dictionary[@"images"];
        for(NSInteger counter=0; counter < [pdpImage count];counter++){
            NSDictionary *imageDataDict = [pdpImage objectAtIndex:counter];
            ImageData *imageData = [[ImageData alloc] initWithDictionary:imageDataDict];
            [self.producetAllImages addObject:imageData];
        }
        self.productName = dictionary[@"product_name"];
        self.coupans = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *coupons = dictionary[@"coupons"];
        for(NSInteger couponCounter=0; couponCounter< [coupons count];couponCounter++){
            NSString *oneCoupon = [coupons objectAtIndex:couponCounter];
            [self.coupans addObject:oneCoupon];
        }

        NSArray *storesArray = dictionary[@"stores"];
        self.stores = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSInteger storeCounter=0; storeCounter < [storesArray count]; storeCounter++){
            NSDictionary *storeDict = [storesArray objectAtIndex:storeCounter];
            Store *store = [[Store alloc] initWithDictionary:storeDict];
            [self.stores addObject:store];
        }
        NSDictionary *categoryDic = dictionary[@"categories"];

        self.parentCategoryID = categoryDic[@"parent_category"];
        self.childCategoryID = categoryDic[@"child_category"];
        
        
    }
    return self;
}


@end

@implementation ImageData

-(ImageData *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.imageUrl = dictionary[@"url"];
        self.imageAspectRatio = dictionary[@"aspect_ratio"];
    }
    return self;
}

@end

@implementation ProductSize
- (ProductSize *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        if (dictionary[@"is_available"]) {
            self.sizeAvailable = [dictionary[@"is_available"] boolValue];
        }

        self.sizeDisplay = dictionary[@"display"];
        self.sizeValue = dictionary[@"value"];
        self.articleId = [NSString stringWithFormat:@"%@",dictionary[@"article_id"]];
    }
    return self;
}
@end

@implementation Store

-(Store*)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.storeName = dictionary[@"name"];
        NSDictionary *distanceKey = dictionary[@"distance"];
        self.storeDistance = [NSString stringWithFormat:@"%@ %@", distanceKey[@"value"], distanceKey[@"unit"]];
        self.storeAddress = dictionary[@"address"];
        self.isStoreOpen = [dictionary[@"is_store_open"] boolValue];
        self.storeTiming = dictionary[@"store_timings"];
        self.storeNumber = dictionary[@"phone"];
        NSArray *latLongData = dictionary[@"lat_long"];
        self.storeLatitude = [latLongData objectAtIndex:0];
        self.storeLongitude = [latLongData objectAtIndex:1];
    }
    return self;
}
@end
