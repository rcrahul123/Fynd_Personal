//
//  PDPHandler.h
//  Explore
//
//  Created by Pranav on 18/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"


typedef void (^SSBaseRequestCompletionHandler)(id responseData,
                                               NSError *error);
@interface PDPHandler : SSBaseRequestHandler

//@property (nonatomic,strong) NSString *productDetailUrl;
- (void)fetchProductDetails:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler;
- (void)followBrand:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler;
- (void)unfollowBrand:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler;
- (void)getFyndAFitSize:(NSDictionary *)params withCompletionHandler:(SSBaseRequestCompletionHandler)completionHandler;
@end
