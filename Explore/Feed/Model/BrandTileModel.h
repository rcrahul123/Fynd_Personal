//
//  BrandTileModel.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionModel.h"
#import "SubProductModel.h"

#import "ProductTileModel.h"

//@interface Action : NSObject
//@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString *url;
//
//@end

//@interface Products : NSObject
//@property (nonatomic, strong) NSString *product_image;
//@property (nonatomic, strong) Action *action;
//
//@end

@interface BrandTileModel : NSObject{
    ProductTileModel *product;
    SubProductModel *subProductModel;
}

//@property (nonatomic, strong) NSString *aspect_ratio;
@property (nonatomic, strong) NSString *brandID;
@property (nonatomic, strong) NSString *brandBannerAspectRatio;
@property (nonatomic, strong) NSString *banner_url;

@property (nonatomic, strong) NSString *banner_title;

@property (nonatomic, strong) NSString *brandlogo;
@property (nonatomic, strong) NSString *brandLogoAspectRatio;

@property (nonatomic, strong) NSString *collection_logo;
@property (nonatomic, strong) NSString *nearest_store;
@property (nonatomic) bool is_following;
@property (nonatomic) NSInteger product_count;
@property (nonatomic) NSInteger store_count;
@property (nonatomic) NSInteger follower_count;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) ActionModel *action;

@property (nonatomic, strong) NSMutableArray *pickOfTheWeekProducts;
@property (nonatomic, strong) NSMutableArray *moreProducts;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *brandDescription;
@property (nonatomic,assign) enum BrandTileType theBrandTileType;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, strong) NSString *discountString;
-(BrandTileModel *)initWithDictionary:(NSDictionary *)dictionary;
-(BrandTileModel *)initWithBrowseDataDictionary:(NSDictionary *)dictionary;

@end
