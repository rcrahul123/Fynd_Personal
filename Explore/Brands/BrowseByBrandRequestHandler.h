//
//  BrowseByBrandRequestHandler.h
//  Explore
//
//  Created by Rahul Chaudhari on 05/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"

typedef void (^SSBrowseByBrandCompletionHandler)(id responseData, NSError *error);


@interface BrowseByBrandRequestHandler : SSBaseRequestHandler

-(void)fetchBrowseByBrandDataWithArray:(NSArray *)paramArray fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;

-(void)fetchBrowseByBrandData:(NSDictionary *)paramDictionary fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;

-(void)followBrand:(NSString *)brandID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;

-(void)unfollowBrand:(NSString *)brandID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler;

@end
