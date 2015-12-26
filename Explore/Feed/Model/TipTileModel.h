//
//  TipTileModel.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipTileModel : NSObject


@property (nonatomic, strong) NSString *aspect_ratio;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *tip_text;

-(TipTileModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
