//
//  CategoryModel.m
//  Explore
//
//  Created by Amboj Goyal on 7/30/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

-(CategoryModel *)initWithDictionary:(NSDictionary *)data{
    self = [super init];
    if(self){
        self.theCategoryName = data[@"name"];
        self.theCategoryUID = data[@"uid"];
        self.theCategoryValue = data[@"value"];
        self.theCategoryURL = data[@"url"];
    }
    return self;
}


@end
