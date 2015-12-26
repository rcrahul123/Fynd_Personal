//
//  BrandTabData.m
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "BrandTabData.h"

@implementation BrandTabData

- (id)init{
    if(self ==[super init]){
        self.brandArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
@end
