//
//  FyndGAAnalytics.h
//  Explore
//
//  Created by Pranav on 14/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixPanelSuperProperties.h"
@interface FyndAnalytics : NSObject

+(FyndAnalytics*)sharedMySingleton;
//-(void)sendGAPageTracking:(NSString *)pageName;
//+(void)trackPage:(NSString *)pageName withProperties:(NSDictionary *)theProperties;

+(void)registerSuperPropertiesForSignUp:(MixPanelSuperProperties *)theSuperPropertyModel;
+(void)registerPeoplePropertiesForSignUp:(MixPanelSuperProperties *)theSuperPropertyModel;

+(void)trackOTPRequestWithTime:(NSString *)requestTime andRequestCount:(int)count;
+(void)trackOTPConfirmationWithMobile:(NSString *)mobile andDate:(NSString *)date andUserID:(NSString *)userId;

//+(void)registerPropertiesForOnBoardingForUser:(NSString *)userId Location:(NSString *)location withBrandCount:(int)brandCount andCollectionCount:(int)collectionCount;
+(void)registerPropertiesForOnBoardingForUser:(NSString *)userId Location:(NSString *)location withBrandsData:(NSArray *)brandsData andCollectionsData:(NSArray *)collectionData;
+(void)trackLocationAccessType:(NSString *)location_access_method andLocation:(NSString *)location;


+(void)trackPDPWith:(NSString *)source forItem:(NSString *)itemcode andBrand:(NSString *)brand andCategory:(NSString *)category andSubCategory:(NSString *)subCategory;


+(void)trackLoginWithLoginType:(NSString *)loginType andLoginDate:(NSString *)loginDate;

+(void)startSessionTracking;
+(void)endSessionTracking:(NSString *)date;

+(void)trackLogoutEvent:(NSString *)date;

+(void)trackBrandFollow:(NSString *)source brandName:(NSString *)brandName isUnFollowed:(BOOL)unfollow;
+(void)trackCollectionFollow:(NSString *)source collectiondName:(NSString *)collectionName isUnFollowed:(BOOL)unfollow;

+(void)trackProductLike:(NSString *)source itemCode:(NSString *)itemCode brandName:(NSString *)brandName isProductUnlike:(BOOL)unliked productCategory:(NSString *)cateogry productSubcategory:(NSString *)subCategory;


+(void)trackSearchEventFrom:(NSString *)source searchString:(NSString *)keyword searchDate:(NSString *)date;
+(void)trackCategoryEvent:(NSString *)gender category:(NSString *)category subcategory:(NSString *)subCategory;

+(void)trackLocationChange:(NSString *)location locationAccessMethod:(NSString *)accessMethod prevLocation:(NSString *)previousLocation;

+(void)trackAddToBagWithType:(NSString *)type brandName:(NSString *)brand itemCode:(NSString *)itemCode articleCode:(NSString *)articleCode productPrice:(NSString *)price from:(NSString *)source;

+(void)trackCheckout:(NSMutableDictionary *)dictionary;

+(void)trackPayment:(NSDictionary *)dictionary;

+(void)trackCancelOrder:(NSString *)value;
+(void)trackExchangeOrder;
+(void)trackReturnBag:(NSDictionary *)dictionary;

+(void)createAlias;
//+(void)trackBranchInstall:(NSDictionary *)params;
+(void)registerSuperPropertiesForBranchInstall:(NSDictionary *)params;
+(void)trackDeeplinkEventWithMarketingCampaign:(NSString *)marketingCampaign andChannel:(NSString *)channel;

+(NSString *)getCurrentDateString;
@end
