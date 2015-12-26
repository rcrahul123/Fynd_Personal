//
//  OrdersTileModel.h
//  Explore
//
//  Created by Rahul Chaudhari on 14/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionModel.h"

@interface OfferSubTile : NSObject
@property (nonatomic, strong) NSString *aspectRatio;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) ActionModel *actionModel;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface OffersTileModel : NSObject
@property (nonatomic, strong) NSString *aspectRatio;
@property (nonatomic, strong) NSMutableArray *subModuleArray;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
