//
//  DeepLinkerHandler.m
//  Explore
//
//  Created by Pranav on 24/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "DeepLinkerHandler.h"
#import "TabBarViewController.h"

static DeepLinkerHandler *sharedInstance = nil;
@implementation DeepLinkerHandler



NSString *qSearchString = nil;

+(DeepLinkerHandler *)sharedSingleton{
    
    @synchronized([DeepLinkerHandler class]) {
    
        if(!sharedInstance){
            sharedInstance = [[DeepLinkerHandler alloc] init];
        }
    }
    return nil;
    
}

+(void)navigateViaParams:(NSDictionary *)paramDict{

//    BranchScreenType type = [self brandModuleType:[paramDict objectForKey:@"$ios_url"]];
    BranchScreenType type = [self brandModuleType:[paramDict objectForKey:@"type"]];
    NSArray *paramList = [self getBranchParamsForModule:type andParams:paramDict];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:paramList forKey:@"BranchParameters"];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    NSArray *viewControllersArray = [(UINavigationController *)[window rootViewController] viewControllers];
    __block UITabBarController *tabController;
    
    [viewControllersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TabBarViewController class]]) {
            tabController = (UITabBarController *)[viewControllersArray objectAtIndex:idx];
        }
    }];
    
    FyndUser *storedUser = [SSUtility loadUserObjectWithKey:kFyndUserKey];
    if(storedUser==nil && [[userDefaults objectForKey:@"isLaunchedViaBranch"] boolValue]){
        [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"loggedOutUserClickBranchLink"];
    }
    
    if(type == BranchScreenCollections){
        [tabController setSelectedIndex:2];
    }else if(type == BranchScreenBrands){
        [tabController setSelectedIndex:1];
    }
    else if(type == BranchScreenBrandPage){
    
        NSMutableString *paramsString = [[NSMutableString alloc] init];
        NSArray *params  = [userDefaults objectForKey:@"BranchParameters"];
        for(NSInteger counter=0; counter < [params count]; counter++){
            NSDictionary *dict = [params objectAtIndex:counter];
            NSString *key = [[dict allKeys] objectAtIndex:0];
            [paramsString appendString:key];
            [paramsString appendString:@"="];
            [paramsString appendString:[dict objectForKey:key]];
            if(counter != ([params count]-1))
                [paramsString appendString:@"&"];
        }
        
        
        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
        [theURL appendString:[NSString stringWithFormat:@"browse-by-brand/?%@",paramsString]];
        
        [tabController setSelectedIndex:0];
        UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
        [navBarController popToRootViewControllerAnimated:NO];
        if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
            
            FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
            [feedController showBrowseByBrandPage:theURL];
        }
      
    }
    else if(type == BranchScreenCollectionPage){
        //        [tabController setSelectedIndex:0];
        
        
        NSMutableString *paramsString = [[NSMutableString alloc] init];
        NSArray *params  = [userDefaults objectForKey:@"BranchParameters"];
        for(NSInteger counter=0; counter < [params count]; counter++){
            NSDictionary *dict = [params objectAtIndex:counter];
            NSString *key = [[dict allKeys] objectAtIndex:0];
            [paramsString appendString:key];
            [paramsString appendString:@"="];
            [paramsString appendString:[dict objectForKey:key]];
            if(counter != ([params count]-1))
                [paramsString appendString:@"&"];
        }
        
        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
        [theURL appendString:[NSString stringWithFormat:@"browse-by-collection/?%@",paramsString]];
        
        [tabController setSelectedIndex:0];
        UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
        [navBarController popToRootViewControllerAnimated:NO];
        if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
            
            FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
            feedController.suppressGender = TRUE;
            [feedController showBrowseByCollectionPage:theURL];
        }
        
    }
    else if(type == BranchScreenProfile){
        [tabController setSelectedIndex:3];
    }
    else if(type == BranchScreenBag){
        [tabController setSelectedIndex:4];
    }
    else if(type == BranchScreenSearch){
        
        NSMutableString *paramsString = [[NSMutableString alloc] init];
        NSArray *params  = [userDefaults objectForKey:@"BranchParameters"];
        for(NSInteger counter=0; counter < [params count]; counter++){
            NSDictionary *dict = [params objectAtIndex:counter];
            NSString *key = [[dict allKeys] objectAtIndex:0];
            [paramsString appendString:key];
            [paramsString appendString:@"="];
            [paramsString appendString:[dict objectForKey:key]];
            if(counter != ([params count]-1))
                [paramsString appendString:@"&"];
        }
        
        NSMutableString *theURL = [[NSMutableString alloc] initWithString:kAPI_Inventory];
        [theURL appendString:[NSString stringWithFormat:@"browse-by-category/?%@",paramsString]];
        
        [tabController setSelectedIndex:0];
        UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
        [navBarController popToRootViewControllerAnimated:NO];
        if([[[navBarController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
            
            FeedViewController *feedController = [[(UINavigationController *)navBarController viewControllers] objectAtIndex:0];
            if(qSearchString && qSearchString.length > 0)
                feedController.deepLinkSearchString =  qSearchString;
            else
                feedController.deepLinkSearchString = @"";
            [feedController showBrowseByCategoryScreen:theURL];
        }
        
    }
    NSDictionary *branchActualParams = [userDefaults objectForKey:@"BranchServiceResponse"];
    [FyndAnalytics trackDeeplinkEventWithMarketingCampaign:[branchActualParams objectForKey:@"~campaign"] andChannel:[branchActualParams objectForKey:@"~channel"]];
    
    // Need to check if its required for starting two cases.
//    UINavigationController *navBarController = [[tabController viewControllers] objectAtIndex:0];
//    [navBarController popToRootViewControllerAnimated:NO];
    
}

+(BranchScreenType)brandModuleType:(NSString *)urlType{
    BranchScreenType type;
    NSString *paramString = urlType;
    if([[paramString uppercaseString] isEqualToString:@"COLLECTIONS"]){
        type = BranchScreenCollections;
    }else if([[paramString uppercaseString] isEqualToString:@"BRANDS"]){
        type = BranchScreenBrands;
    }
    else if([[paramString uppercaseString] isEqualToString:@"BRAND-PAGE"]){
        type = BranchScreenBrandPage;
    }
    else if([[paramString uppercaseString] isEqualToString:@"COLLECTION-PAGE"]){
        type = BranchScreenCollectionPage;
    }
    else if([[paramString uppercaseString] isEqualToString:@"PROFILE"]){
        type = BranchScreenProfile;
    }
    else if([[paramString uppercaseString] isEqualToString:@"BAG"]){
        type = BranchScreenBag;
    }
//    else if([[paramString uppercaseString] isEqualToString:@"SEARCH-BY-BROWSE"]){
//        type = BranchScreenBrowse;
//    }
    else if([[paramString uppercaseString] isEqualToString:@"SEARCH-BY"]){
        type = BranchScreenSearch;
    }
    
    return type;
}


+(NSArray *)getBranchParamsForModule:(BranchScreenType )type andParams:(NSDictionary *)branchParams{
    
    NSMutableArray *params = nil;
    qSearchString = nil;
    
    switch (type) {
        case BranchScreenCollections:{
                params = [[NSMutableArray alloc] initWithCapacity:0];
            
//                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[branchParams objectForKey:@"gender"],@"gender",nil];
             NSString *genderString = [[branchParams objectForKey:@"gender"] lowercaseString];
             if(genderString!=nil && genderString.length > 0){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"gender",nil];
                [params addObject:dict];
             }
            }
           
            break;
        
        case BranchScreenBrands:{
                params = [[NSMutableArray alloc] initWithCapacity:0];
//                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[branchParams objectForKey:@"gender"],@"gender",nil];
             NSString *genderString = [[branchParams objectForKey:@"gender"] lowercaseString];
             if(genderString!=nil && genderString.length > 0){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"gender",nil];
                [params addObject:dict];
             }
            }
            break;
        
        case BranchScreenBrandPage:{
            
            params = [[NSMutableArray alloc] initWithCapacity:0];
            NSString *genderString = [[branchParams objectForKey:@"gender"] lowercaseString];
            if(genderString!=nil && genderString.length > 0){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"gender",nil];
                [params addObject:dict];
            }
            
            NSString *brandNameString = [branchParams objectForKey:@"brand"];
            if(brandNameString && brandNameString!=nil){
                NSString *encdodedBrand = [SSUtility handleEncoding:brandNameString];
                NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:encdodedBrand,@"brand",nil];
                [params addObject:dict1];
            }
            
            NSString *sortOnString = [branchParams objectForKey:@"sort"];
            if(sortOnString && sortOnString!=nil){
                NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:sortOnString,@"sort_on",nil];
                [params addObject:dict2];
            }
            
            NSString *catString = [branchParams objectForKey:@"category"];
            NSArray *diffCat = [catString componentsSeparatedByString:@","];
            for(NSInteger catCounter=0; catCounter < [diffCat count]; catCounter++){
            
                NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[diffCat objectAtIndex:catCounter],@"category_id",nil];
                [params addObject:dict3];
            }
            
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"items",nil];
            [params addObject:dict3];
            NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"filters",nil];
            [params addObject:dict4];
            NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"headers",nil];
            [params addObject:dict5];
            
        }
            break;
            
        case BranchScreenCollectionPage:{
            
            params = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSString *genderString = [[branchParams objectForKey:@"gender"] lowercaseString];
            if(genderString.length>0 && genderString!=nil){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"gender",nil];
                [params addObject:dict];
            }
             
            
            NSString *sortOnString = [branchParams objectForKey:@"sort"];
            if(sortOnString && sortOnString!=nil){
                NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:sortOnString,@"sort_on",nil];
                [params addObject:dict2];
            }
            
            
            NSString *catString = [branchParams objectForKey:@"category"];
            NSArray *diffCat = [catString componentsSeparatedByString:@","];
            for(NSInteger catCounter=0; catCounter < [diffCat count]; catCounter++){
                
                NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[diffCat objectAtIndex:catCounter],@"category_id",nil];
                [params addObject:dict3];
            }
            
            
            
            NSString *collectionIdString = [branchParams objectForKey:@"collection"];
            if(collectionIdString && collectionIdString!=nil){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:collectionIdString,@"collection_id",nil];
                [params addObject:dict];
            }
            
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"items",nil];
            [params addObject:dict3];
            NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"filters",nil];
            [params addObject:dict4];
            NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"headers",nil];
            [params addObject:dict5];
        
        }
        break;
        
        case BranchScreenSearch:{
            
            params = [[NSMutableArray alloc] initWithCapacity:0];
            NSString *genderString = [[branchParams objectForKey:@"gender"] lowercaseString];
            if(genderString.length > 0 && genderString!=nil){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"gender",nil];
                [params addObject:dict];
            }
            
            
            NSString *titleString = [branchParams objectForKey:@"title"];
            if(titleString && titleString!=nil){
                NSString *title = [SSUtility handleEncoding:titleString];
                qSearchString = title;
            }

            
            NSString *catString = [branchParams objectForKey:@"category"];
            NSArray *diffCat = [catString componentsSeparatedByString:@","];
            for(NSInteger catCounter=0; catCounter < [diffCat count]; catCounter++){
                
                NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[diffCat objectAtIndex:catCounter],@"category_id",nil];
                [params addObject:dict3];
            }
            
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"items",nil];
            [params addObject:dict3];
            NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"true",@"filters",nil];
            [params addObject:dict4];
        }
        break;
        case BranchScreenProfile:{
            params = [[NSMutableArray alloc] initWithCapacity:0];
            NSString *genderString = [branchParams objectForKey:@"screen_name"];
            if(genderString && genderString!=nil){
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:genderString,@"screen_name",nil];
                [params addObject:dict];
            }
        }
            
            
        default:
            break;
    }
    return [params copy];
}


@end
