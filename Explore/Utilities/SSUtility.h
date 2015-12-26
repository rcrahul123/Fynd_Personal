//
//  SSUtility.h
//  BrandCollectionPOC
//
//  Created by Pranav on 25/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ProductTileModel.h"
#import "BrandTileModel.h"
#import "CollectionTileModel.h"
#import "TipTileModel.h"
#import "GridView.h"
#import "FyndUser.h"

#import "HTMLTileModel.h"
#import "OffersTileModel.h"



@class GridView;
@class BrandsVIewController;
@class CollectionsViewController;

@interface SSUtility : NSObject

+ (CGSize)getLabelDynamicSize:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size;
+ (CGSize)getSingleLineLabelDynamicSize:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size;
+ (UILabel *)generateLabel:(NSString *)unitValue withRect:(CGRect)unitRect withFont:(UIFont *)font;
+ (UIColor *)colorFromHexString:(NSString *)hexString;


+(NSMutableArray *)parseJSON:(NSArray *)data forGridView:(GridView *)gridView;
+(CGFloat)calculateBrandCellHeight:(BrandTileModel *)brandData forGridView:(GridView *)grid;
+ (CGFloat)calculateCollectionGridHeight:(CollectionTileModel *)collectionData forGridView:(GridView *)grid;
+(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width;
+ (CGFloat)getProductsAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width;

+(NSString *)getValueForParam:(NSString *)param from:(NSString *)url;
+(UIImage *)imageWithColor:(UIColor *)color;
+(void)saveCustomObject:(id)object;
+(FyndUser*)loadUserObjectWithKey:(NSString*)key;

+ (void)showActivityOverlay:(UIView *)view;
+ (void)dismissActivityOverlay;


+(void)deleteUserDataForKey:(NSString *)key;
+(NSString *)handleEncoding:(NSString *)urlString;
+(CGSize)getDynamicSizeWithSpacing:(NSString *)title withFont:(UIFont *)font withSize:(CGSize)size spacing:(NSInteger)spaceValue;
+(CGFloat)getMinimumButtonHeight:(float)originalSize relatedToHeight:(float)screenHeight;

+(NSString *)getDeviceName;
+(NSString *)getUserAgentString;
+(BOOL)checkIfUserInAllowedCities:(NSString *)city;


+(id)traverseToGetControllerName:(UIView *)view;

+(NSString *)getUserID;

+(void)showOverlayViewWithMessage:(NSString *)theMessage andColor:(UIColor *)theOverlayColor;
+(UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(CGFloat)alpha;
+(void)removeBranchStoredData;

@end
