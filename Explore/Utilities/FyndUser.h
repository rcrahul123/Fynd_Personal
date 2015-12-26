//
//  FyndUser.h
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyndUser : NSObject


@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *mobileNumber;
@property (nonatomic,copy) NSString *emailId;
@property (nonatomic,assign) BOOL     isMale;
@property (nonatomic,copy) NSString *profileCoverUrl;
@property (nonatomic,copy) NSString *profilePicUrl;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *password; //temporary
@property (nonatomic, strong) NSString *otp;
@property (nonatomic,assign) BOOL isOnboarded;
@property (nonatomic, assign) BOOL shouldShowHaveOTP;

@property (nonatomic,copy) NSString  *joiningDate;

@property (nonatomic, strong) NSString *tokenExpiryDateString;
@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *tokenString;
@property (nonatomic,copy) NSString *userId;
+(FyndUser*)sharedMySingleton;

@end
