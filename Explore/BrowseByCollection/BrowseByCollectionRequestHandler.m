//
//  BrowseByCollectionRequestHandler.m
//  Explore
//
//  Created by Rahul Chaudhari on 05/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrowseByCollectionRequestHandler.h"


@implementation BrowseByCollectionRequestHandler

-(void)fetchBrowseByBrandDataWithArray:(NSArray *)paramArray fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler{
    [self sendHttpRequestWithURL:urlString withParameterArray:paramArray withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(void)fetchBrowseByBrandData:(NSDictionary *)paramDictionary fromURL:(NSString *)urlString withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler{
    [self sendHttpRequestWithURL:urlString withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)followCollection:(NSString *)collectionID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kBrandFollowURL];
    [self sendHttpRequestWithURL:urlString withParameters:@{@"collection_id" : collectionID} withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)unfollowCollection:(NSString *)collectionID withRequestCompletionhandler:(SSBrowseByBrandCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kBrandUnfollowURL];
    [self sendHttpRequestWithURL:urlString withParameters:@{@"collection_id" : collectionID} withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)parseCollectionData:(id)response{
    
}


@end
