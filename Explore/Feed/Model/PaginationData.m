//
//  PaginationData.m
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PaginationData.h"

@implementation PaginationData

-(PaginationData *)initWithDictionary:(NSDictionary *)dictionary{
 
    self = [super init];
    if(self){
        self.currentPage = [dictionary[@"current"] integerValue];
        self.hasNext = [dictionary[@"has_next"] boolValue];
        self.hasPrevious = [dictionary[@"has_previous"] boolValue];
        self.totalPage = [dictionary[@"total"] integerValue];
    }
    
    return self;
}

@end
