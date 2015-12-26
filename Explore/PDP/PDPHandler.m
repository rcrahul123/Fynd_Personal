//
//  PDPHandler.m
//  Explore
//
//  Created by Pranav on 18/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPHandler.h"

@implementation PDPHandler


- (void)fetchProductDetails:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler{
   
    NSString *url = [params objectForKey:[[params allKeys] objectAtIndex:0]];
    
    [self sendHttpRequestWithURL:url withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            }else{
                completionHandler(responseData,nil);
            }
        }
    }];
}


- (void)followBrand:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler{
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


- (void)unfollowBrand:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kBrandUnfollowURL];
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

- (void)getFyndAFitSize:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:kFynaAFitSizesURL];
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


@end
