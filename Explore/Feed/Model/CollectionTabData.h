//
//  CategoryTabData.h
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaginationData.h"

@interface CollectionTabData : NSObject
@property (nonatomic,strong) NSMutableArray *collectionArray;
@property (nonatomic,strong) PaginationData *paginationInfo;

@end
