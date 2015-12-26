//
//  ReturnReasons.m
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ReturnReasons.h"

@implementation ReturnReasons
-(ReturnReasons *)initWithData:(NSDictionary *)theDataDictionary{
    self = [super init];
    if (self) {
        self.reason = theDataDictionary[@"reason"];
        self.reasonId = theDataDictionary[@"reason_id"];
        self.isReason_Selected = FALSE;
    }
    return self;
}

@end
