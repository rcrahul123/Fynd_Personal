//
//  TabRequestHandler.h
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"
#import "BrandTabData.h"
#import "CollectionTabData.h"

typedef void (^SSBaseRequestCompletionHandler)(id responseData,
                                               NSError *error);

@interface HomeRequestHandler : SSBaseRequestHandler

@property (nonatomic,strong) BrandTabData       *brandTabData;
@property (nonatomic,strong) CollectionTabData  *collectionTabData;
@property (nonatomic) BOOL  profileBrands;
@property (nonatomic) BOOL  profileCollections;

-(void)fetchFeedDataWithParams:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler;
-(void)fetchBrandsTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;
-(void)fetchCollectionTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;

-(void)fetchNotifications:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;

//-(void)getLocationWithParam:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;
@end
