//
//  CategoryTabData.m
//  Explore
//
//  Created by Pranav on 04/08/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CollectionTabData.h"

@implementation CollectionTabData

- (id)init{
    if(self ==[super init]){
        self.collectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


@end
