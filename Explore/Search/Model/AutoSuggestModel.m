//
//  AutoSuggestModel.m
//  Explore
//
//  Created by Amboj Goyal on 7/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "AutoSuggestModel.h"

@implementation AutoSuggestModel


-(AutoSuggestModel *)initWithDictionary:(NSDictionary *)data{
    self = [super init];
    if(self){
        self.displayName = data[@"display"];
        NSDictionary *actionDictionary = data[@"action"];
        self.itemType = actionDictionary[@"type"];
        self.itemValue = actionDictionary[@"value"];
        self.itemURL = actionDictionary[@"url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_displayName forKey:@"displayName"];
    [aCoder encodeObject:_itemType forKey:@"itemType"];
    [aCoder encodeObject:_itemValue forKey:@"itemValue"];
    [aCoder encodeObject:_itemURL forKey:@"itemURL"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
        self.itemType = [aDecoder decodeObjectForKey:@"itemType"];
        self.itemValue = [aDecoder decodeObjectForKey:@"itemValue"];
        self.itemURL = [aDecoder decodeObjectForKey:@"itemURL"];
    }
    return self;
}


@end
