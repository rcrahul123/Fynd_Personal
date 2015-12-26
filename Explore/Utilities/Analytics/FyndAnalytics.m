//
//  FyndGAAnalytics.m
//  Explore
//
//  Created by Pranav on 14/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "FyndAnalytics.h"


@implementation FyndAnalytics
static FyndAnalytics* sharedMySingleton = nil;
//static int const kGaDispatchPeriod = 30;


+(FyndAnalytics*)sharedMySingleton
{
    @synchronized([FyndAnalytics class])
    {
        if (!sharedMySingleton)
            sharedMySingleton =  [[self alloc] init];
        
        return sharedMySingleton;
    }
    
    return nil;
}


/*
-(void)sendGAPageTracking:(NSString *)pageName{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

}
 */
 
//+(void)trackPage:(NSString *)pageName withProperties:(NSDictionary *)theProperties{
//     Mixpanel *theMixPanel = [Mixpanel sharedInstance];
//    [theMixPanel track:pageName properties:theProperties];
//}

+(void)registerSuperPropertiesForSignUp:(MixPanelSuperProperties *)theSuperPropertyModel{
    Mixpanel *theInstance = [Mixpanel sharedInstance];
    
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    [theProps setObject:[theSuperPropertyModel.gender capitalizedString] forKey:@"gender"];
//    [theProps setObject:[theSuperPropertyModel.signUpMethod capitalizedString] forKey:@"signup_method"];
//    [theProps setObject:theSuperPropertyModel.mediaSource forKey:@"media_source"];
//    [theProps setObject:theSuperPropertyModel.userType forKey:@"user_type"];

    
    [theInstance registerSuperProperties:theProps];
    
    [self registerPeoplePropertiesForSignUp:theSuperPropertyModel];
    
    [theInstance track:@"signup"];
    
}
+(void)registerPeoplePropertiesForSignUp:(MixPanelSuperProperties *)theSuperPropertyModel{
    
    Mixpanel *theInstance = [Mixpanel sharedInstance];
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    [theProps setObject:[theSuperPropertyModel.firstName capitalizedString] forKey:@"$first_name"];
    [theProps setObject:[theSuperPropertyModel.lastName capitalizedString] forKey:@"$last_name"];
    [theProps setObject:[theSuperPropertyModel.gender capitalizedString] forKey:@"gender"];
    [theProps setObject:theSuperPropertyModel.emailId forKey:@"$email"];
    [theProps setObject:[theSuperPropertyModel.signUpMethod capitalizedString] forKey:@"$signup_method"];
//    [theProps setObject:@"False" forKey:@"is_onboard"];
    
    [theInstance identify:theInstance.distinctId];
    
    [theInstance.people set:theProps];
    
}


//+(void)trackBranchInstall:(NSDictionary *)params{
//    Mixpanel *theInstance = [Mixpanel sharedInstance];
//    [theInstance track:@"install" properties:params];
//}

+(void)registerSuperPropertiesForBranchInstall:(NSDictionary *)params{

    Mixpanel *theInstance = [Mixpanel sharedInstance];
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    

    if([params valueForKey:@"~campaign"] && [params valueForKey:@"~campaign"]!=nil){
        [theProps setObject:[params valueForKey:@"~campaign"] forKey:@"$install_campaign"];
    }else{
        [theProps setObject:@"Organic" forKey:@"$install_campaign"];
    }
    if([params valueForKey:@"~channel"] && [params valueForKey:@"~channel"]!=nil){
        [theProps setObject:[params valueForKey:@"~channel"] forKey:@"$media_source"];
    }else{
        [theProps setObject:@"Organic" forKey:@"$media_source"];
    }
    
//    [theInstance registerSuperProperties:theProps];
    [theInstance.people set:theProps];
    
    [theInstance track:@"install" properties:theProps];
}


+(void)trackOTPRequestWithTime:(NSString *)requestTime andRequestCount:(int)count{
    Mixpanel *theInstance = [Mixpanel sharedInstance];
    
    NSMutableDictionary *theEvents = [[NSMutableDictionary alloc] init];
    [theEvents setObject:requestTime forKey:@"otp_request_time"];
    [theEvents setObject:[NSString stringWithFormat:@"%d",count] forKey:@"otp_request_count"];

//    [FyndAnalytics createAlias];
    
    [theInstance track:@"otp_requested" properties:theEvents];
    
}


#pragma mark - Verify OTP

+(void)trackOTPConfirmationWithMobile:(NSString *)mobile andDate:(NSString *)date andUserID:(NSString *)userId{
    date = [FyndAnalytics getCurrentDateString];
    Mixpanel *theInstance = [Mixpanel sharedInstance];
    
    NSMutableDictionary *theDic = [[NSMutableDictionary alloc] init];
//    [theDic setObject:mobile forKey:@"phone"];
//    [theDic setObject:date forKey:@"signup_date"];
    [theDic setObject:userId forKey:@"uid"];
    
    
    [theInstance registerSuperProperties:theDic];
//    [theInstance registerSuperPropertiesOnce:[NSDictionary dictionaryWithObject:date forKey:@"signup_date"]];
    
    //Regestring the People property
    [theInstance identify:theInstance.distinctId];
    
//    NSString *userID = [SSUtility getUserID];
//    if(userID){
//        [theInstance identify:userID];
//    }else{
//        [theInstance identify:theInstance.distinctId];
//    }
    
//    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
//    if(user){
//        [theInstance createAlias:user.userId forDistinctID:theInstance.distinctId];
//    }


//    [FyndAnalytics createAlias];
    
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    [theProps setObject:mobile forKey:@"$phone"];
    [theProps setObject:userId forKey:@"uid"];
    [theProps setObject:date forKey:@"$created"];

    [theInstance.people set:theProps];
    NSMutableDictionary *prop = [[NSMutableDictionary alloc] init];
    [prop setObject:mobile forKey:@"phone"];

    [theInstance track:@"otp_verified" properties:prop];
    
    
}

#pragma mark - On Boarding

+(void)registerPropertiesForOnBoardingForUser:(NSString *)userId Location:(NSString *)location withBrandsData:(NSArray *)brandsData andCollectionsData:(NSArray *)collectionData{
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
//    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
//    [theProps setObject:location forKey:@"location"];
//    [theProps setObject:[NSString stringWithFormat:@"%d",brandCount] forKey:@"onboard_brands_follow_count"];
//    [theProps setObject:[NSString stringWithFormat:@"%d",collectionCount] forKey:@"onboard_collections_follow_count"];
//    [theProps setObject:[NSString stringWithFormat:@"%d",brandCount] forKey:@"brands_follow_count"];
//    [theProps setObject:[NSString stringWithFormat:@"%d",collectionCount] forKey:@"collections_follow_count"];
//    [mixpanel registerSuperProperties:theProps];
    
    
    //Setting User Properties

    [mixpanel identify:mixpanel.distinctId];

    NSMutableDictionary *theProp = [[NSMutableDictionary alloc] init];
    [theProp setObject:[location capitalizedString] forKey:@"location"];
    [theProp setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[brandsData count]] forKey:@"onboard_brands_follow_count"];
    [theProp setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[collectionData count]] forKey:@"onboard_collections_follow_count"];
    [theProp setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[brandsData count]] forKey:@"brands_follow_count"];
    [theProp setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[collectionData count]] forKey:@"collections_follow_count"];
    
    [theProp setObject:[NSArray arrayWithArray:brandsData] forKey:@"brands_followed"];
    [theProp setObject:[NSArray arrayWithArray:collectionData] forKey:@"collections_followed"];
    [theProp setObject:@"True" forKey:@"is_onboard"];
    [mixpanel.people set:theProp];
    
    [FyndAnalytics trackLocationAccessType:[[NSUserDefaults standardUserDefaults] objectForKey:@"onboardingAccessType"] andLocation:[[NSUserDefaults standardUserDefaults] objectForKey:@"onboardingLocation"]];
    
}

+(void)trackLocationAccessType:(NSString *)location_access_method andLocation:(NSString *)location{
    Mixpanel *theMixPanel = [Mixpanel sharedInstance];
    
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    [theProps setObject:[location capitalizedString] forKey:@"location"];
    [theProps setObject:[location_access_method capitalizedString] forKey:@"location_access_method"];
    [theMixPanel track:@"onboard" properties:theProps];
}

+(void)trackPDPWith:(NSString *)source forItem:(NSString *)itemcode andBrand:(NSString *)brand andCategory:(NSString *)category andSubCategory:(NSString *)subCategory{
    Mixpanel *theMixPanel = [Mixpanel sharedInstance];
    
    NSString *categoryString;
    if([category isKindOfClass:[NSNumber class]]){
        categoryString = [NSString stringWithFormat:@"%@", category];
    }else{
        categoryString = category;
    }
    
    NSString *subCategoryString;
    if([subCategory isKindOfClass:[NSNumber class]]){
        subCategoryString = [NSString stringWithFormat:@"%@", subCategory];
    }else{
        subCategoryString = subCategory;
    }
    
    NSMutableDictionary *theProps = [[NSMutableDictionary alloc] init];
    if(source && source.length > 0){
        [theProps setObject:[source capitalizedString] forKey:@"source"];
    }
    
    if(itemcode && itemcode.length > 0){
        [theProps setObject:[NSString stringWithFormat:@"%@",[itemcode capitalizedString]] forKey:@"itemcode"];
    }
    
    if(brand && brand.length > 0){
        [theProps setObject:[brand capitalizedString] forKey:@"brand"];
    }
    
    if (categoryString == nil) {
        [theProps setObject:@" " forKey:@"category"];
    }else
        [theProps setObject:[NSString stringWithFormat:@"%@", categoryString] forKey:@"category"];
    
    if (subCategoryString == nil) {
        [theProps setObject:@" " forKey:@"subcategory"];
    }else
        [theProps setObject:[NSString stringWithFormat:@"%@", subCategoryString] forKey:@"subcategory"];
    
    [theMixPanel track:@"product_view" properties:theProps];
}


#pragma mark - login
+(void)trackLoginWithLoginType:(NSString *)loginType andLoginDate:(NSString *)loginDate{
    loginDate = [FyndAnalytics getCurrentDateString];

    Mixpanel *theMixPanel = [Mixpanel sharedInstance];
    
    NSString *userID = (NSString *)[SSUtility getUserID];
    NSString *strID;
    if([userID isKindOfClass:[NSNumber class]]){
        strID = [NSString stringWithFormat:@"%@", userID];
    }else{
        strID = userID;
    }
    
//    if(![theMixPanel.distinctId isEqualToString:strID]){
        [theMixPanel identify:strID];
//    }else{
//        [theMixPanel identify:theMixPanel.distinctId];
//    }
    
//    [theMixPanel registerSuperProperties:@{@"gender" : [gender capitalizedString]}];
    
    NSMutableDictionary *peopleProps = [[NSMutableDictionary alloc] init];
    [peopleProps setObject:loginDate forKey:@"last_login"];
    [theMixPanel.people set:peopleProps];
    [theMixPanel.people increment:@"login_count" by:@1];
    [FyndAnalytics startSessionTracking];
    [theMixPanel track:@"login" properties:@{@"login_method" : [loginType capitalizedString]}];

}


#pragma mark - login
+(void)startSessionTracking{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *userID = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    NSString *genderStr = [[SSUtility loadUserObjectWithKey:kFyndUserKey] gender];
    if (genderStr != nil && userID != nil) {
        [mixPanel registerSuperProperties:@{@"gender" : [genderStr capitalizedString],@"uid":userID}];
        [mixPanel identify:userID];
        [mixPanel timeEvent:@"user_session"];        
    }
}

+(void)endSessionTracking:(NSString *)date{
    date = [FyndAnalytics getCurrentDateString];
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    [mixPanel.people increment:@"session_count" by:@1];
    [mixPanel.people set:@{@"session_date": date}];
    
    [mixPanel track:@"user_session"];
}

#pragma pragma - logout
+(void)trackLogoutEvent:(NSString *)date{
    date = [FyndAnalytics getCurrentDateString];
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    
    [mixPanel identify:str];
    [mixPanel.people set:@{@"last_logout": date}];
    
//    [mixPanel registerSuperProperties:@{@"last_logout":date}];
    
    [mixPanel track:@"logout"];
    
}


#pragma mark - follow unfollow
+(void)trackBrandFollow:(NSString *)source brandName:(NSString *)brandName isUnFollowed:(BOOL)unfollow{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];

    //setting incremental super property
    
//    NSDictionary *currentSuperProperties = [mixPanel currentSuperProperties];
//    NSInteger count = [currentSuperProperties[@"brands_follow_count"] integerValue];
//    if(count && count > 0){
//        if(!unfollow){
//            count = count + 1;
//        }else{
//            count = count - 1;
//        }
//    }else{
//        count = 1;
//    }
//    [mixPanel registerSuperProperties:@{@"brands_follow_count" : [NSNumber numberWithInteger:count]}];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    if(!unfollow){
        [mixPanel.people increment:@"brands_follow_count" by:@1];
    }else{
        [mixPanel.people increment:@"brands_follow_count" by:@(-1)];
    }
    //    NSMutableDictionary *theDic = [[NSMutableDictionary alloc] init];
    //    [theDic setObject:[NSArray arrayWithObject:brandName] forKey:@"brands_followed"];
    //
    //    [mixPanel.people union:(theDic)];
    
    NSMutableDictionary *eventProps = [[NSMutableDictionary alloc] init];
    if(source){
        [eventProps setObject:[source capitalizedString] forKey:@"source"];
    }
    if(brandName && brandName.length > 0){
        [eventProps setObject:[brandName capitalizedString] forKey:@"brand"];
    }
    [eventProps setObject:[NSNumber numberWithBool:unfollow] forKey:@"unfollow_flag"];
    
    if(unfollow){
        [eventProps setObject:@"True" forKey:@"unfollow_flag"];
    }else{
        [eventProps setObject:@"False" forKey:@"unfollow_flag"];
    }
    
    [mixPanel track:@"brands_follow" properties:eventProps];
}



+(void)trackCollectionFollow:(NSString *)source collectiondName:(NSString *)collectionName isUnFollowed:(BOOL)unfollow{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    //setting incremental super property
    //    NSDictionary *currentSuperProperties = [mixPanel currentSuperProperties];
    //    NSInteger count = [currentSuperProperties[@"collections_follow_count"] integerValue];
    //    if(count && count > 0){
    //        if(!unfollow){
    //            count = count + 1;
    //        }else{
    //            count = count - 1;
    //        }    }else{
    //        count = 1;
    //    }
    //    [mixPanel registerSuperProperties:@{@"collections_follow_count" : [NSNumber numberWithInteger:count]}];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    if(!unfollow){
        [mixPanel.people increment:@"collections_follow_count" by:@1];
    }else{
        [mixPanel.people increment:@"collections_follow_count" by:@(-1)];
    }
    NSMutableDictionary *eventProps = [[NSMutableDictionary alloc] init];
    if(source){
        [eventProps setObject:[source capitalizedString] forKey:@"source"];
    }
    
    if(collectionName && collectionName.length > 0){
        [eventProps setObject:[collectionName capitalizedString] forKey:@"collection"];
    }
    if(unfollow){
        [eventProps setObject:@"True" forKey:@"unfollow_flag"];
    }else{
        [eventProps setObject:@"False" forKey:@"unfollow_flag"];
    }
    
    
    [mixPanel track:@"collections_follow" properties:eventProps];
}


+(void)trackProductLike:(NSString *)source itemCode:(NSString *)itemCode brandName:(NSString *)brandName isProductUnlike:(BOOL)unliked productCategory:(NSString *)cateogry productSubcategory:(NSString *)subCategory{
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    //setting incremental super property
    //    NSDictionary *currentSuperProperties = [mixPanel currentSuperProperties];
    //    NSInteger count = [currentSuperProperties[@"product_like_count"] integerValue];
    //    if(count && count > 0){
    //        if(!unliked){
    //            count = count + 1;
    //        }else{
    //            count = count - 1;
    //        }
    //    }else{
    //        count = 1;
    //    }
    //    [mixPanel registerSuperProperties:@{@"product_like_count" : [NSNumber numberWithInteger:count]}];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    
    NSString *categoryString;
    if([cateogry isKindOfClass:[NSNumber class]]){
        categoryString = [NSString stringWithFormat:@"%@", cateogry];
    }else{
        categoryString = cateogry;
    }
    
    NSString *subCategoryString;
    if([subCategory isKindOfClass:[NSNumber class]]){
        subCategoryString = [NSString stringWithFormat:@"%@", subCategory];
    }else{
        subCategoryString = subCategory;
    }
    
    
    if(!unliked){
        [mixPanel.people increment:@"product_like_count" by:@1];
    }else{
        [mixPanel.people increment:@"product_like_count" by:@(-1)];
    }
    NSMutableDictionary *eventProps = [[NSMutableDictionary alloc] init];
    if (source && source.length>0) {
        [eventProps setObject:[source capitalizedString] forKey:@"source"];
    }
    if (itemCode && itemCode.length>0) {
        [eventProps setObject:[itemCode capitalizedString] forKey:@"itemcode"];
    }
    
    if (brandName && brandName.length>0) {
        [eventProps setObject:[brandName capitalizedString] forKey:@"brand"];
    }

    
    if(unliked){
        [eventProps setObject:@"True" forKey:@"product_unlike_flag"];
    }else{
        [eventProps setObject:@"False" forKey:@"product_unlike_flag"];
    }
    if (categoryString && categoryString.length>0) {
        [eventProps setObject:[categoryString capitalizedString] forKey:@"category"];
    }
    if (subCategory && subCategoryString.length>0) {
        [eventProps setObject:[subCategoryString capitalizedString] forKey:@"subcategory"];
    }

    
    [mixPanel track:@"product_like" properties:eventProps];
}



#pragma mark - search and category event
+(void)trackSearchEventFrom:(NSString *)source searchString:(NSString *)keyword searchDate:(NSString *)date  {
    date = [FyndAnalytics getCurrentDateString];
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    //setting incremental super property
    //    NSDictionary *currentSuperProperties = [mixPanel currentSuperProperties];
    //    NSInteger count = [currentSuperProperties[@"search_count"] integerValue];
    //    if(count && count > 0){
    //        count = count + 1;
    //    }else{
    //        count = 1;
    //    }
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    [mixPanel.people increment:@"search_count" by:@1];
    [mixPanel.people set:@{@"last_search_date": date}];
    
    //    NSMutableDictionary *superDictionary = [[NSMutableDictionary alloc] init];
    //    [superDictionary setObject:[NSNumber numberWithInteger:count] forKey:@"search_count"];
    //    [superDictionary setObject:date forKey:@"last_search_date"];
    //
    //    [mixPanel registerSuperProperties:superDictionary];
    if(!(source && source.length > 0)){
        source = @"Feed";
    }
    if(!(keyword && keyword.length > 0)){
        keyword = @"";
    }
    [mixPanel track:@"search" properties:@{@"keyword" : keyword, @"source": source}];
}


+(void)trackCategoryEvent:(NSString *)gender category:(NSString *)category subcategory:(NSString *)subCategory{
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSMutableDictionary *eventProps = [[NSMutableDictionary alloc] init];
    if (gender) {
        [eventProps setObject:[gender capitalizedString] forKey:@"category_gender"];
    }
    if (category) {
        [eventProps setObject:[category capitalizedString] forKey:@"category"];
    }
    if (subCategory) {
        [eventProps setObject:[subCategory capitalizedString] forKey:@"subcategory"];        
    }
    
    [mixPanel track:@"category" properties:eventProps];
}


#pragma mark - location change
+(void)trackLocationChange:(NSString *)location locationAccessMethod:(NSString *)accessMethod prevLocation:(NSString *)previousLocation{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    //    [mixPanel registerSuperProperties:@{@"location":location}];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[location capitalizedString] forKey:@"location"];
    [dictionary setObject:[previousLocation capitalizedString] forKey:@"location_previous"];
    [dictionary setObject:[accessMethod capitalizedString] forKey:@"location_access_method"];
    [mixPanel.people set:dictionary];
    
    [mixPanel track:@"location_change"];
}




#pragma mark - add to bag
+(void)trackAddToBagWithType:(NSString *)type brandName:(NSString *)brand itemCode:(NSString *)itemCode articleCode:(NSString *)articleCode productPrice:(NSString *)price from:(NSString *)source{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[brand capitalizedString] forKey:@"brand"];
    [params setObject:[type capitalizedString] forKey:@"type"];
    [params setObject:[source capitalizedString] forKey:@"source"];
    
    NSMutableDictionary *theDic = [[NSMutableDictionary alloc] init];
    [theDic setObject:itemCode forKey:@"itemCode"];
    [theDic setObject:price forKey:@"price"];
    [params setObject:theDic forKey:@"bag"];
    
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //    [dict setObject:[brand capitalizedString] forKey:@"brand"];
    //    [dict setObject:[type capitalizedString] forKey:@"type"];
    //
    //    NSError * err;
    //    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
    //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    //    NSMutableArray *array = [[NSMutableArray alloc] init];
    //    [array addObject:myString];
    //    
    //    [params setObject:array forKey:@"bag"];
    
    //    [array addObject:brand];
    //    [array addObject:type];
    //    
    //    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:array options:0 error:&err];
    //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    [mixPanel track:@"bag_add" properties:params];
}


+(void)trackCheckout:(NSMutableDictionary *)dictionary{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *str = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:str];
    
    [mixPanel.people set:@{@"delivery_pincode" : [dictionary objectForKey:@"delivery_pincode"]}];
    
    [mixPanel track:@"check_out" properties:dictionary];
}


+(void)trackPayment:(NSDictionary *)dictionary{
    
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    //setting incremental super property
    
    NSString *userString = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:userString];
    
    if ([dictionary[@"payment_status"] isEqualToString:@"successful"]) {
        [mixPanel.people increment:@"order_count" by:@1];
        [mixPanel.people set:@{@"last_ordered_date": [FyndAnalytics getCurrentDateString]}];
    }
    
    
    
    
    NSString *paymentValue = [dictionary objectForKey:@"life_time_value"];
    paymentValue = [paymentValue stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat value = [paymentValue floatValue];
    [mixPanel.people trackCharge:[NSNumber numberWithFloat:value]];
    
    [mixPanel track:@"payment" properties:@{
                                            @"payment_type" : [[dictionary objectForKey:@"payment_type"] capitalizedString],
                                            @"orderid" : [dictionary objectForKey:@"orderid"],
                                            @"payment_status":[[dictionary objectForKey:@"payment_status"] capitalizedString],
                                            @"payment_value" : [NSNumber numberWithFloat:value],
                                            @"bag_count":[NSNumber numberWithInt:[[dictionary objectForKey:@"bag_count"] intValue]]
                                            }];
}


+(void)trackCancelOrder:(NSString *)value{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *userString = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:userString];
    
    
    [mixPanel.people increment:@"cancel_order_count" by:@1];
    value = [value stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat amount = [value floatValue];
    [mixPanel.people trackCharge:[NSNumber numberWithFloat:-amount]];
    
    [mixPanel track:@"cancel_order"];
}


+(void)trackExchangeOrder{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *userString = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:userString];
    
    
    [mixPanel.people increment:@"exchange_bag_count" by:@1];
    
    [mixPanel track:@"exchange_bag"];
}



+(void)trackReturnBag:(NSDictionary *)dictionary{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *userString = [[SSUtility loadUserObjectWithKey:kFyndUserKey] userId];
    [mixPanel identify:userString];
    
    [mixPanel.people increment:@"return_bag_count" by:@1];
    NSString *value = [[dictionary objectForKey:@"value"] stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat amount = [value floatValue];
    [mixPanel.people trackCharge:[NSNumber numberWithFloat:-amount]];
    
    NSArray *array = [dictionary objectForKey:@"reason"];
    
    NSMutableString *reasonString = [[NSMutableString alloc] init];
    if([array count] > 0){
        for(int i = 0; i < [array count]; i++){
            [reasonString appendString:[array objectAtIndex:i]];
            
            if(i < [array count] - 1){
                [reasonString appendString:@", "];
            }
        }
    }
    [mixPanel track:@"return_bag" properties:@{@"reason" : array}];
}



#pragma marks - alias
+(void)createAlias{
    Mixpanel *mixPanel = [Mixpanel sharedInstance];
    
    NSString *userID = (NSString *)[SSUtility getUserID];
    NSString *strID;
    if([userID isKindOfClass:[NSNumber class]]){
        strID = [NSString stringWithFormat:@"%@", userID];
    }else
        strID = userID;
    
    //    if(![mixPanel.distinctId isEqualToString:strID]){
    if(strID){
        [mixPanel createAlias:strID forDistinctID:mixPanel.distinctId];
    }else{
    }
    //    }
    [mixPanel identify:strID];
    
}


#pragma mark - Tracking Deeplink events

+(void)trackDeeplinkEventWithMarketingCampaign:(NSString *)marketingCampaign andChannel:(NSString *)channel{
    Mixpanel *theInstance = [Mixpanel sharedInstance];
    
    FyndUser *user = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL deepLinkEventFired = [[userDefaults objectForKey:@"BranchDeepLinkEventFired"] boolValue];
    if(user!=nil && !deepLinkEventFired){
        
        NSMutableDictionary *thedeeplinkDic = [[NSMutableDictionary alloc] init];
        [thedeeplinkDic setObject:[NSArray arrayWithObject:marketingCampaign] forKey:@"marketing_campaign_opened"];
        [thedeeplinkDic setObject:[NSArray arrayWithObject:channel] forKey:@"marketing_channels"];
        
        [theInstance registerSuperProperties:@{@"gender" : [user.gender capitalizedString],@"uid":user.userId}];
        [theInstance.people union:thedeeplinkDic];
        
        [theInstance track:@"deeplink" properties:@{
                                                    @"marketing_campaign":marketingCampaign,
                                                    @"channel":channel
                                                    }];
        
        [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"BranchDeepLinkEventFired"];
        
    }
}


+(NSString *)getCurrentDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *string = [formatter stringFromDate:now];
    return string;
}


@end
