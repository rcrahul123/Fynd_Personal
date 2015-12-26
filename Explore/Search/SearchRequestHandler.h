//
//  SearchRequestHandler.h
//  Explore
//
//  Created by Amboj Goyal on 7/26/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSBaseRequestHandler.h"
#import "CategoryModel.h"
typedef void (^SSBaseRequestCompletionHandler)(id responseData,
                                               NSError *error);
@interface SearchRequestHandler : SSBaseRequestHandler

-(void)fetchSearchDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;
-(void)fetchCategoryDataWithParameters:(NSDictionary *)paramDictionary withRequestCompletionhandler:(SSBaseRequestCompletionHandler)dataHandler;


-(NSMutableArray *)parseCategoryData:(NSArray *)categoryDictionary;

@end
