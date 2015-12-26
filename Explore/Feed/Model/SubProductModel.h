//
//  SubProductModel.h
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionModel.h"

@interface SubProductModel : NSObject

@property (nonatomic, strong) NSString *product_image;
@property (nonatomic,strong) NSString *subProductAspectRatio;
@property (nonatomic, strong) ActionModel *action;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, assign) BOOL shouldShowBadge;

-(SubProductModel *)initWithDictionary:(NSDictionary *)dictionary;

@end
