//
//  CategoryModel.h
//  Explore
//
//  Created by Amboj Goyal on 7/30/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic,strong) NSString *theCategoryName;
@property (nonatomic,strong) NSString *theCategoryValue;
@property (nonatomic,strong) NSString *theCategoryUID;
@property (nonatomic, strong) NSString *theCategoryURL;
@property (nonatomic,strong) NSArray *childArray;
-(CategoryModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
