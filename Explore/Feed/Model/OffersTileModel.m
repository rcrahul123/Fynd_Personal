//
//  OrdersTileModel.m
//  Explore
//
//  Created by Rahul Chaudhari on 14/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "OffersTileModel.h"

@implementation OfferSubTile

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        NSDictionary *bannerData = dictionary[@"banner_image"];
        self.aspectRatio = bannerData[@"aspect_ratio"];
        self.imageURL = bannerData[@"url"];
        
        self.actionModel = [[ActionModel alloc] initWithDictionary:dictionary[@"action"]];
    }
    return self;
}
@end


@implementation OffersTileModel

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.subModuleArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *array = dictionary[@"offers"];
        if(array){
            for(int i = 0; i < [array count]; i++){
                OfferSubTile *tile = [[OfferSubTile alloc] initWithDictionary:[array objectAtIndex:i]];
                self.aspectRatio = tile.aspectRatio;
                [self.subModuleArray addObject:tile];
            }
        }
    }
    return self;
}

@end
