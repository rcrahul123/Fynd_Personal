//
//  TabRequestHandler.m
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "HomeRequestHandler.h"
#import "BrandTileModel.h"
#import "CollectionTileModel.h"

@implementation HomeRequestHandler


-(void)fetchFeedDataWithParams:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"get-feeds/?"];

    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


-(void)fetchBrandsTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];

    NSString *brandUrl = nil;
    if(self.profileBrands){
        brandUrl = @"get-my-selections/?";
    }else{
        brandUrl = @"get-all-brands/?";
    }
    
    [urlString appendString:brandUrl];
    
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


-(void)fetchCollectionTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    NSString *brandUrl = nil;
    if(self.profileCollections){
        brandUrl = @"get-my-selections/?";
    }else{
        brandUrl = @"get-all-collections/?";
    }
    
    [urlString appendString:brandUrl];
    
    [self sendHttpRequestWithURL:urlString withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
           
    // Dummy Error Objects
    
//     NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
//     [userInfo setObject:INAPPROPRIATE_RESPONSE_MESSAGE forKey:ERROR_MESSAGE_KEY];
//     error = [NSError errorWithDomain:@"Explore" code:100 userInfo:[userInfo copy]];

            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


- (BrandTabData *)parseBrandData:(id)data{
    if(self.brandTabData == nil){
        self.brandTabData = [[BrandTabData alloc] init];
    }
    NSArray *brands = [data objectForKey:@"items"];
    for(NSInteger counter=0; counter < [brands count]; counter++){
        NSDictionary *brandDict = [[brands objectAtIndex:counter] objectForKey:@"value"];
        BrandTileModel *brandModel = [[BrandTileModel alloc] initWithDictionary:brandDict];
        [self.brandTabData.brandArray addObject:brandModel];
    }
    self.brandTabData.paginationInfo = [[PaginationData alloc] initWithDictionary:[data objectForKey:@"page"]];
    return self.brandTabData;
}


- (CollectionTabData *)parseCollectionData:(id)data{
    
    if(self.collectionTabData == nil){
        self.collectionTabData = [[CollectionTabData alloc] init];
    }
    NSArray *brands = [data objectForKey:@"items"];
    for(NSInteger counter=0; counter < [brands count]; counter++){
        NSDictionary *brandDict = [[brands objectAtIndex:counter] objectForKey:@"value"];
        CollectionTileModel *collectionModel = [[CollectionTileModel alloc] initWithDictionary:brandDict];
        [self.collectionTabData.collectionArray addObject:collectionModel];
    }
    self.collectionTabData.paginationInfo = [[PaginationData alloc] initWithDictionary:[data objectForKey:@"page"]];

    
    return self.collectionTabData;
}


-(void)fetchNotifications:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:[NSString stringWithFormat:@"%@?",kNotificationList]];
    
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



@end
