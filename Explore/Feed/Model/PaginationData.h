//
//  PaginationData.h
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaginationData : NSObject

@property (nonatomic,assign) NSInteger  currentPage;
@property (nonatomic,assign) BOOL       hasNext;
@property (nonatomic,assign) BOOL       hasPrevious;
@property (nonatomic,assign) NSInteger  totalPage;

-(PaginationData *)initWithDictionary:(NSDictionary *)dictionary;
@end
