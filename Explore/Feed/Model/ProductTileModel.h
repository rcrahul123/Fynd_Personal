//
//  ProductTileModel.h
//  FreshSample
//
//  Created by Rahul on 6/17/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActionModel.h"


//@interface Action : NSObject
//
//@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString *url;
//@end

@interface ProductTileModel : NSObject

@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *product_image;
@property (nonatomic, strong) NSString *aspect_ratio;

@property (nonatomic) bool isImageDownloaded;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic) bool is_bookmarked;
@property (nonatomic) NSString *price_marked;
@property (nonatomic) NSString *price_effective;
@property (nonatomic, strong) NSString *brand_name;
//@property (nonatomic, strong) NSString *brand_logo;
@property (nonatomic, strong) NSString *productLogo;
@property (nonatomic, strong) NSString *productLogoAspectRatio;
@property (nonatomic, strong) NSString *badge_url;

@property (nonatomic, strong) ActionModel *action;
@property (nonatomic,assign) enum ProductTileType tileType;
@property (nonatomic, assign) BOOL isOutOfStock;

@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, strong) NSString *badgeString;
@property (nonatomic, strong) NSString *discountString;
@property (nonatomic, assign) BOOL shouldShowMarkedPrice;


-(ProductTileModel *)initWithDictionary:(NSDictionary *)dictionary;
@end
