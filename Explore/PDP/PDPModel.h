//
//  ProductDescripton.h
//  Explore
//
//  Created by Pranav on 10/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageData;
@interface PDPModel : NSObject

@property (nonatomic, strong) NSString          *productID;
@property (nonatomic,assign) BOOL               isTryAtHomeAvailable;
@property (nonatomic,strong) NSString           *productInfomation;
@property (nonatomic,strong) NSString           *discount;
@property (nonatomic,assign) BOOL               productBookMerked;
@property (nonatomic,strong) NSString           *convenienceFee;
@property (nonatomic,strong) NSMutableArray     *sizeArray;
@property (nonatomic,strong) NSMutableArray     *productDescription;
@property (nonatomic,copy)   NSString           *productInfo;
@property (nonatomic,strong) ImageData          *logoImageData;
@property (nonatomic,strong) ImageData          *sizeGuideImageData;
@property (nonatomic,strong) NSString          *productEffectivePrice;
@property (nonatomic,strong) NSString          *productMarkedPrice;
@property (nonatomic,assign) BOOL               bookedMarkedPrice;
@property (nonatomic,assign) NSString          *priceMarked;
@property (nonatomic,assign) BOOL               pickAtStoreAvailable;
@property (nonatomic,copy)   NSString           *shareUrl;
@property (nonatomic,strong) NSMutableArray     *producetAllImages;
@property (nonatomic,copy) NSString             *productName;
@property (nonatomic,strong) NSMutableArray     *coupans;
@property (nonatomic,strong) NSMutableArray     *stores;
@property (nonatomic, assign) NSInteger         bookmarkCount;
@property (nonatomic, strong) NSString          *brandName;
@property (nonatomic, strong) NSString          *suggestedProductList;
@property (nonatomic,strong) NSMutableDictionary    *fyndAFitDictonary;
@property(nonatomic,strong) NSString            *parentCategoryID;
@property(nonatomic,strong) NSString            *childCategoryID;
@property (nonatomic, strong) NSString          *badge;
-(PDPModel *)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface ImageData: NSObject
@property (nonatomic,copy) NSString             *imageUrl;
@property (nonatomic,copy) NSString             *imageAspectRatio;
-(ImageData *)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface ProductSize : NSObject
@property (nonatomic,assign) BOOL sizeAvailable;
@property (nonatomic,copy) NSString *sizeDisplay;
@property (nonatomic,copy) NSString *sizeValue;
@property (nonatomic,copy) NSString *articleId;
- (ProductSize *)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface Store : NSObject
@property (nonatomic,strong) NSString *storeName;
@property (nonatomic,strong) NSString *storeDistance;
@property (nonatomic,strong) NSString *storeAddress;
@property (nonatomic,assign) BOOL       isStoreOpen;
@property (nonatomic,strong) NSString   *storeTiming;
@property (nonatomic,strong) NSString *storeLatitude;
@property (nonatomic,strong) NSString *storeLongitude;
@property (nonatomic,strong) NSString *storeNumber;
-(Store*)initWithDictionary:(NSDictionary *)dictionary;
@end
