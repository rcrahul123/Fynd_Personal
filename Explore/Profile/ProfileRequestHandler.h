//
//  ProfileRequestHandler.h
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"

typedef void (^SSProfileRequestCompletionHandler)(id responseData,
                                               NSError *error);
typedef void (^SSUserProfileRequestCompletionHandler)(NSError *error);

@interface ProfileRequestHandler : SSBaseRequestHandler

- (void)fetchCouponData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;
- (void)fetchFreeShipping:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;
-(void)fetchWishListData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;
-(void)fetchProfileData:(NSDictionary *)params withCompletionHandler:(SSUserProfileRequestCompletionHandler)dataHandler;
- (void)uploadProfileData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;
-(void)getMyorderdataWithCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;

-(void)cancelOrder:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler;

@end
