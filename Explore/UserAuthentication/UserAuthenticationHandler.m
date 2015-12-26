//
//  UserAuthenticationHandler.m
//  Explore
//
//  Created by Rahul Chaudhari on 16/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "UserAuthenticationHandler.h"

@implementation UserAuthenticationHandler

-(void)checkUserAlreadyloggedInWithCompletionHandler:(FyndAuthenticationHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"is-valid-session/"];
    [self sendHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(void)createNewUserAccount:(NSDictionary *)credentials withCompletionHandler:(FyndAuthenticationHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"signup/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:credentials withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)loginUser:(NSDictionary *)credentials withCompletionHandler:(FyndAuthenticationHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"login/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:credentials withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}



-(void)verifyOTP:(NSDictionary *)parameters withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"verify-otp-and-login/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:parameters withCompletionHandler:^(id responseData, NSError *error) {
        
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)verifyOTPForResetPassword:(NSDictionary *)parameters withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"verify-reset-password/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:parameters withCompletionHandler:^(id responseData, NSError *error) {
        
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)changePassword:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"set-new-password/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:userDetails withCompletionHandler:^(id responseData, NSError *error) {
        
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(void)sendOTPForgetPassword:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"forgot-password/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:userDetails withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)sendOTP:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"send-otp/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:userDetails withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}

-(void)completeUserOnBoardingWithCompletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"onboard-user/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)logoutUserWithCompletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"logout/"];
    [self sendHttpRequestWithURL:urlString withParameters:nil withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)checkIfFBUserExists:(NSDictionary *)fbUser withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"facebook-user-exists/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:fbUser withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler(responseData,nil);
            }
        }
    }];
}


-(void)loginUsingFacebook:(NSDictionary *)credentials withComppletionHandler:(FyndAuthenticationHandler) dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Accounts];
    [urlString appendString:@"facebook-signup-or-login/"];
    [self sendPostHttpRequestWithURL:urlString withParameters:credentials withCompletionHandler:^(id responseData, NSError *error) {
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
