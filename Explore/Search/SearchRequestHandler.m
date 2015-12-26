//
//  SearchRequestHandler.m
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SearchRequestHandler.h"
#import "AutoSuggestModel.h"
@implementation SearchRequestHandler

#pragma mark - Fetch Functions.
-(void)fetchSearchDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"autocomplete/?"];
    [self sendHttpRequestWithURL:urlString withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                dataHandler([self parseSearchData:responseData],nil);
            }
        }
    }];
}


-(void)fetchCategoryDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kAPI_Inventory];
    [urlString appendString:@"get-categories/"];
    [self sendHttpRequestWithURL:urlString withParameters:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        if (dataHandler) {
            if (error) {
                dataHandler(nil,error);
            }else{
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:responseData forKey:@"cachedCategoryData"];
                [defaults setObject:[NSDate date] forKey:@"cachedDate"];
                
                dataHandler([self parseCategoryData:responseData],nil);
            }
        }
    }];
//    NSError *error = nil;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"json"];
//    NSData *categoryData = [NSData dataWithContentsOfFile:path];
//    NSArray *categoryDataDictionary = [NSJSONSerialization JSONObjectWithData:categoryData options:0 error:&error];
//    if (categoryDataDictionary) {
//        dataHandler([self parseCategoryData:categoryDataDictionary],nil);
//    }else{
//        dataHandler(nil,error);
//    }
}


#pragma mark - Parsing Functions.
-(NSArray *)parseSearchData:(NSArray *)data{
    NSMutableArray * suggestedArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger count = [data count];
    if (count>0) {
        
        for(int i = 0; i < count; i++){
            AutoSuggestModel *model = [[AutoSuggestModel alloc] initWithDictionary:[data objectAtIndex:i]];
            
            [suggestedArray addObject:model];
        }
    }
    return suggestedArray;
}

-(NSMutableArray *)parseCategoryData:(NSArray *)categoryDictionary{
//    NSMutableDictionary * finalCategoryDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *finalCategoryArray = [[NSMutableArray alloc] init];
    
    NSInteger count = [categoryDictionary  count];
    if (count>0) {
        //Looping all Categories -- Men, Women, Boys, Girls.
        for(int i = 0; i < count; i++){
        NSMutableDictionary * finalCategoryDictionary = [[NSMutableDictionary alloc] init];
            NSString *theKey = [[[categoryDictionary objectAtIndex:i] valueForKey:@"key"] valueForKey:@"display"];
            
            NSArray *categoryWiseArray = [[categoryDictionary objectAtIndex:i] valueForKey:@"values"];
            NSMutableArray *outputCategoryWise = [[NSMutableArray alloc] init];
            //categoryWiseArray output - Data of FootWear, Data of SportsWear.....
            
            for (int j= 0; j<[categoryWiseArray count]; j++) {
                
                    NSDictionary *dictionaryForLevel_1 =  [categoryWiseArray objectAtIndex:j];
                    CategoryModel *modelLevel_One = [[CategoryModel alloc] initWithDictionary:dictionaryForLevel_1];
                
                    NSArray *subCategoryArray = [dictionaryForLevel_1 valueForKey:@"childs"];
                    NSMutableArray *outputSubCategoryArray = [[NSMutableArray alloc] init];
                        for (int k = 0; k<[subCategoryArray count]; k++) {
                            NSDictionary *dictionaryForLevel_2 =  [subCategoryArray objectAtIndex:k];
                            CategoryModel * modelLevel_Two = [[CategoryModel alloc] initWithDictionary:dictionaryForLevel_2];
                            [outputSubCategoryArray addObject:modelLevel_Two];
                        }
                [modelLevel_One setChildArray:outputSubCategoryArray];
                [outputCategoryWise addObject:modelLevel_One];
            }
            

            
            [finalCategoryDictionary setObject:outputCategoryWise forKey:theKey];
            [finalCategoryArray addObject:finalCategoryDictionary];
        }

    }
    return finalCategoryArray;
}

//-(NSMutableDictionary *)parseCategoryData:(NSDictionary *)categoryDictionary{
//    NSMutableDictionary * finalCategoryDictionary = [[NSMutableDictionary alloc] init];
//    NSMutableArray *finalCategotyArray = [[NSMutableArray alloc] init];
//    NSInteger count = [[categoryDictionary allKeys] count];
//    if (count>0) {
//        //Looping all Categories -- Men, Women, Boys, Girls.
//        for(int i = 0; i < count; i++){
//            NSString *theKey = [[categoryDictionary allKeys] objectAtIndex:i];
//            
//            NSArray *categoryWiseArray = [categoryDictionary valueForKey:theKey];
//            NSMutableArray *outputCategoryWise = [[NSMutableArray alloc] init];
//            //categoryWiseArray output - Data of FootWear, Data of SportsWear.....
//            
//            for (int j= 0; j<[categoryWiseArray count]; j++) {
//                
//                NSDictionary *dictionaryForLevel_1 =  [categoryWiseArray objectAtIndex:j];
//                CategoryModel *modelLevel_One = [[CategoryModel alloc] initWithDictionary:dictionaryForLevel_1];
//                
//                NSArray *subCategoryArray = [dictionaryForLevel_1 valueForKey:@"childs"];
//                NSMutableArray *outputSubCategoryArray = [[NSMutableArray alloc] init];
//                for (int k = 0; k<[subCategoryArray count]; k++) {
//                    NSDictionary *dictionaryForLevel_2 =  [subCategoryArray objectAtIndex:k];
//                    CategoryModel * modelLevel_Two = [[CategoryModel alloc] initWithDictionary:dictionaryForLevel_2];
//                    [outputSubCategoryArray addObject:modelLevel_Two];
//                }
//                [modelLevel_One setChildArray:outputSubCategoryArray];
//                [outputCategoryWise addObject:modelLevel_One];
//            }
//            
//            
//            
//            [finalCategoryDictionary setObject:outputCategoryWise forKey:theKey];
//            [finalCategotyArray addObject:finalCategoryDictionary];
//        }
//        
//    }
//    return finalCategoryDictionary;
//}



@end
