//
//  ActionModel.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;

-(ActionModel *)initWithDictionary:(NSDictionary *)dictionary;
@end
