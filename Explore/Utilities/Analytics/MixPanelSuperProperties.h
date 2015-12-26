//
//  MixPanelSuperProperties.h
//  Explore
//
//  Created by Amboj Goyal on 10/4/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "FyndUser.h"
#import <Mixpanel.h>

@interface MixPanelSuperProperties : FyndUser




@property (nonatomic,copy) NSString *signUpMethod;
@property (nonatomic,copy) NSString *mediaSource;
@property (nonatomic,copy) NSString *userType;
@property (nonatomic,copy) NSString *signUpDate;


+(MixPanelSuperProperties*)sharedInstance;

//+(void)setMixPanelSuperPropertiesForSignUp;
//+(void)setMixPanelPeoplePropertiesForSignUp;


@end
