//
//  AutoSuggestModel.h
//  Explore
//
//  Created by Amboj Goyal on 7/23/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoSuggestModel : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *itemType;
@property (nonatomic, strong) NSString *itemValue;
@property (nonatomic, strong) NSString *itemURL;

-(AutoSuggestModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
