//
//  OnBoardingRequestHandler.h
//  Explore
//
//  Created by Amboj Goyal on 8/19/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"
#import "BrandTabData.h"
#import "CollectionTabData.h"

typedef void (^OnBoardingRequestCompletionHandler)(id responseData,
                                               NSError *error);


@interface OnBoardingRequestHandler : SSBaseRequestHandler
@property (nonatomic,strong) BrandTabData       *brandTabData;
@property (nonatomic,strong) CollectionTabData  *collectionTabData;

-(void)sendOnBoardingDataWithParams:(NSDictionary *)params withCompletionHandler:(OnBoardingRequestCompletionHandler)completionHandler;
-(void)fetchBrandsTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(OnBoardingRequestCompletionHandler)dataHandler;
-(void)fetchCollectionTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(OnBoardingRequestCompletionHandler)dataHandler;
-(void)sendOnBoardingDataWithMultipleParams:(NSArray *)params withCompletionHandler:(OnBoardingRequestCompletionHandler)completionHandler;

@end
