//
//  BrowseByCollectionRequestHandler.h
//  Explore
//
//  Created by Rahul Chaudhari on 05/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"

@interface BrowseByCollectionRequestHandler : SSBaseRequestHandler

typedef void (^SSBrowseByBrandCompletionHandler)(id responseData, NSError *error);

-(void)fetchBrowseByBrandDataWithArray:(NSArray *)paramArray fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;
-(void)fetchBrowseByBrandData:(NSDictionary *)paramDictionary fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;
-(void)followCollection:(NSString *)collectionID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;
-(void)unfollowCollection:(NSString *)collectionID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;

@end
