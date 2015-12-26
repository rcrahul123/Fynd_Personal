//
//  FyndUser.m
//  Explore
//
//  Created by Pranav on 11/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FyndUser.h"

@implementation FyndUser
static FyndUser* _sharedMySingleton = nil;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.profilePicUrl forKey:@"profileCover"];
    [encoder encodeObject:self.gender forKey:@"fyndGender"];
    [encoder encodeObject:self.emailId forKey:@"emailId"];
//    [encoder encodeObject:self.lastLogin forKey:@"lastLogin"];
    [encoder encodeObject:self.mobileNumber forKey:@"mobileNumber"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.password forKey:@"otp"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isOnboarded] forKey:@"isOnboarded"];
    [encoder encodeObject:self.joiningDate forKey:@"joiningdate"];
    [encoder encodeObject:[NSNumber numberWithBool:self.shouldShowHaveOTP] forKey:@"shouldShowHaveOTP"];
    [encoder encodeObject:self.userId forKey:@"user_id"];
    [encoder encodeObject:self.tokenExpiryDateString forKey:@"tokenExpiryDateString"];
    [encoder encodeObject:self.fbID forKey:@"fbID"];
    [encoder encodeObject:self.tokenString forKey:@"tokenString"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.profilePicUrl = [decoder decodeObjectForKey:@"profileCover"];
        self.gender = [decoder decodeObjectForKey:@"fyndGender"];
        self.emailId = [decoder decodeObjectForKey:@"emailId"];
        self.mobileNumber = [decoder decodeObjectForKey:@"mobileNumber"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.otp = [decoder decodeObjectForKey:@"otp"];
        self.isOnboarded = [[decoder decodeObjectForKey:@"isOnboarded"] boolValue];
        self.joiningDate = [decoder decodeObjectForKey:@"joiningdate"];
        self.shouldShowHaveOTP = [[decoder decodeObjectForKey:@"shouldShowHaveOTP"] boolValue];
        self.userId = [decoder decodeObjectForKey:@"user_id"];
        self.tokenExpiryDateString = [decoder decodeObjectForKey:@"tokenExpiryDateString"];
        self.fbID = [decoder decodeObjectForKey:@"fbID"];
        self.tokenString = [decoder decodeObjectForKey:@"tokenString"];
    }
    return self;
}

+(FyndUser *)objectFromData:(NSData *)data
{
    return (FyndUser *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}


+(FyndUser*)sharedMySingleton
{
    @synchronized([FyndUser class])
    {
        if (!_sharedMySingleton)
          _sharedMySingleton =  [[self alloc] init];
        
        return _sharedMySingleton;
    }
    
    return nil;
}


@end
