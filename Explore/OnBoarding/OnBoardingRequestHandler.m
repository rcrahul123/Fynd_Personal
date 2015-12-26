//
//  OnBoardingRequestHandler.m
//  Explore
//
//  Created by Amboj Goyal on 8/19/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "OnBoardingRequestHandler.h"

@implementation OnBoardingRequestHandler


-(void)fetchBrandsTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(OnBoardingRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"get-all-brands/?"];
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


-(void)fetchCollectionTabDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(OnBoardingRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"get-all-collections/?"];
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

-(void)sendOnBoardingDataWithParams:(NSDictionary *)params withCompletionHandler:(OnBoardingRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kBrandFollowURL];
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

-(void)sendOnBoardingDataWithMultipleParams:(NSArray *)params withCompletionHandler:(OnBoardingRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kBrandFollowURL];
    NSString *keyTitle = (NSString *)[[[params objectAtIndex:0] allKeys] objectAtIndex:0];
    NSMutableString *postString = [[NSMutableString alloc] init];
    for (int i= 0; i<[params count]; i++) {
        [postString appendString:keyTitle];
        [postString appendString:@"="];
//        [postString appendString:[self handleEncoding:[[params objectAtIndex:i] valueForKey:keyTitle]]];
        [postString appendString:[[params objectAtIndex:i] valueForKey:keyTitle]];

        if(i != ([params count]-1))
            [postString appendString:@"&"];
    }
    
    [urlString appendString:postString];
    
    [self sendHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
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

-(NSString *)handleEncoding:(NSString *)urlString{
    NSString *encodedStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]" , kCFStringEncodingUTF8);
    return encodedStr;
}

@end
