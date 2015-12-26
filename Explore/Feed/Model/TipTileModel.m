//
//  TipTileModel.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "TipTileModel.h"

@implementation TipTileModel


-(TipTileModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        //        self.image_url = dictionary[@"image_url"];
        NSDictionary *imageData = [dictionary objectForKey:@"tip_image"];
        if([imageData isKindOfClass:[NSDictionary class]] && imageData!=nil){
            self.image_url = [imageData objectForKey:@"url"];
            self.aspect_ratio = [imageData objectForKey:@"aspect_ratio"];
        }

        self.tip_text = dictionary[@"tip_text"];
//        self.aspect_ratio = dictionary[@"aspect_ratio"];
    }
    
    return self;
}


@end
