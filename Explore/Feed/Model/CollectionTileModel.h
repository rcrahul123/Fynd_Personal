//
//  CollectionTileModel.h
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
//@property (nonatomic, strong) ActionModel *action;
//
//@end

@interface CollectionTileModel : NSObject

//@property (nonatomic, strong) NSString *aspect_ratio;
@property (nonatomic, strong) NSString *collectionID;
@property (nonatomic, strong) NSString *bannerAspectRatio;
@property (nonatomic, strong) NSString *banner_url;


@property (nonatomic, strong) NSString *banner_title;

@property (nonatomic, strong) NSString *collectionlogo;
@property (nonatomic, strong) NSString *collectionLogoAspectRatio;

@property (nonatomic, strong) NSString *last_updated;
@property (nonatomic) bool is_following;
@property (nonatomic) NSInteger product_count;
@property (nonatomic) NSInteger follower_count;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) ActionModel *action;

@property (nonatomic, strong) NSMutableArray *pickOfTheWeekProducts;
@property (nonatomic, strong) NSMutableArray *moreProducts;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *collectionDescription;
@property (nonatomic,assign) enum CollectionTileType theCollectionTileType;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, strong) NSString *discountString;

-(CollectionTileModel *)initWithDictionary:(NSDictionary *)dictionary;
-(CollectionTileModel *)initWithBrowseDataDictionary:(NSDictionary *)dictionary;

@end
