//
//  ActionModel.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ActionModel.h"

@implementation ActionModel

-(ActionModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.type = dictionary[@"type"];
        self.url = dictionary[@"url"];
    }
    
    return self;
}

@end
