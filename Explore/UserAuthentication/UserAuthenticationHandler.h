//
//  UserAuthenticationHandler.h
//  Explore
//
//  Created by Rahul Chaudhari on 16/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"

typedef void (^FyndAuthenticationHandler)(id responseData, NSError *error);




@interface UserAuthenticationHandler : SSBaseRequestHandler{
    UILabel *msgView;
}


-(void)checkUserAlreadyloggedInWithCompletionHandler:(FyndAuthenticationHandler)dataHandler;

-(void)createNewUserAccount:(NSDictionary *)credentials withCompletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)loginUser:(NSDictionary *)credentials withCompletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)sendOTP:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)verifyOTP:(NSDictionary *)parameters withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)completeUserOnBoardingWithCompletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)logoutUserWithCompletionHandler:(FyndAuthenticationHandler) dataHandler;

-(void)sendOTPForgetPassword:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)verifyOTPForResetPassword:(NSDictionary *)parameters withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)changePassword:(NSDictionary *)userDetails  withComppletionHandler:(FyndAuthenticationHandler) dataHandler;

-(void)checkIfFBUserExists:(NSDictionary *)fbUser withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
-(void)loginUsingFacebook:(NSDictionary *)credentials withComppletionHandler:(FyndAuthenticationHandler) dataHandler;
@end
