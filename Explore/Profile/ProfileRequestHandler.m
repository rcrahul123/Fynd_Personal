//
//  ProfileRequestHandler.m
//  Explore
//
//  Created by Pranav on 13/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ProfileRequestHandler.h"
#import "MyCoupons.h"
#import "SSUtility.h"
#import "FyndUser.h"


@interface ProfileRequestHandler()
//- (NSArray *)parseDummyCouponData;
- (NSDictionary *)freeShippingData;
//@property (nonatomic,strong) FyndUser *userProfile;
@end

@implementation ProfileRequestHandler


- (void)fetchCouponData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    
    /*
    [self sendHttpRequestWithURL:@"http://orbis-staging.addsale.com/api/v1/inventory/get-all-brands/?" withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                 dataHandler([self parseDummyCouponData:responseData],nil);
//                dataHandler(responseData,nil);
            }
        }
    }];
     */
     

    dataHandler([self parseDummyCouponData:nil],nil);
}


- (void)fetchFreeShipping:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    
    /*
     [self sendHttpRequestWithURL:@"http://orbis-staging.addsale.com/api/v1/inventory/get-all-brands/?" withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
     if (dataHandler) {
     if (error) {
     dataHandler(nil,error);
     }else{
     dataHandler([self parseDummyCouponData:responseData],nil);
     //                dataHandler(responseData,nil);
     }
     }
     }];
     */
    
    dataHandler([self freeShippingData],nil);
}

-(void)fetchWishListData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"get-my-selections/?type=product&"];
    
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            
            // Dummy Error Objects
//            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
//            [userInfo setObject:INAPPROPRIATE_RESPONSE_MESSAGE forKey:ERROR_MESSAGE_KEY];
//            error = [NSError errorWithDomain:@"Explore" code:100 userInfo:[userInfo copy]];
            
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];

}


-(void)fetchProfileData:(NSDictionary *)params withCompletionHandler:(SSUserProfileRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"get-profile/"];
    
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {

            // Dummy Error Objects
//            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
//            [userInfo setObject:INAPPROPRIATE_RESPONSE_MESSAGE forKey:ERROR_MESSAGE_KEY];
//            error = [NSError errorWithDomain:@"Explore" code:100 userInfo:[userInfo copy]];
            
            if (error) {
                dataHandler(error);
            }else{
//                dataHandler([self parseDummyCouponData:responseData],nil);
                 [self parseProfileData:responseData];
                  dataHandler(nil);
            }
        }
    }];

}


-(void)parseProfileData:(id)data{
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    
    user.emailId = [data objectForKey:@"email"];
    user.firstName = [data objectForKey:@"first_name"];
    user.lastName = [data objectForKey:@"last_name"];
    user.gender = [data objectForKey:@"gender"];
    user.mobileNumber = [data objectForKey:@"mobile"];
    user.profilePicUrl = [data objectForKey:@"profile_pic_url"];
    user.joiningDate = [data objectForKey:@"joining_date"];
    user.isOnboarded = [[data objectForKey:@"is_onboarded"] boolValue];
    [SSUtility saveCustomObject:user];
}


- (void)uploadProfileData:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"update-profile/"];
    [self sendPostDataInMultipart:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (error) {
            dataHandler(nil,error);
        }else{
            dataHandler(responseData,nil);
        }
    }];
}

-(void)getMyorderdataWithCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"my-orders/"];
    [self sendHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (error) {
            dataHandler(nil,error);
        }else{
            dataHandler(responseData,nil);
        }
    }];
}


-(void)returnMyOrder:(NSDictionary *)params WithCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"return-item"];
    [self sendHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (error) {
            dataHandler(nil,error);
        }else{
            dataHandler(responseData,nil);
        }
    }];
}


- (NSArray *)parseDummyCouponData:(id)responseData{
    NSMutableArray *dummyCoupanArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"TW20",@"coupanName",@"Use this coupon code at checkput to get 20% of any order",@"coupanDescription",@"12 July 2015",@"coupanExpiry",nil];
    
    for(NSInteger counter=0; counter < 5; counter++){
        MyCoupons *coupon = [[MyCoupons alloc] initWithDictionary:dict];
        [dummyCoupanArray addObject:coupon];
    }
    return [dummyCoupanArray copy];
}

- (NSDictionary *)freeShippingData{
    NSDictionary *freeShioppingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"JL9TW",@"ShippingCode",@"Share this code to get Twill coupons worth $500 evertytime a purchase from Twill",@"ShippingCodeDescription", nil];
    return freeShioppingDict;
}

#pragma mark - Cancel Order

-(void)cancelOrder:(NSDictionary *)params withCompletionHandler:(SSProfileRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_AVIS];
    [urlString appendString:kCancelOrder];
    [self sendPostHttpRequestWithURL:urlString withParameters:params withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }    }];

}

@end
