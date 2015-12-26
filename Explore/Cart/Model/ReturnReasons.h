//
//  ReturnReasons.h
//  Explore
//
//  Created by Amboj Goyal on 9/21/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnReasons : NSObject

@property (nonatomic,copy) NSString *reason;
@property (nonatomic,copy) NSString *reasonId;
@property (nonatomic,assign) BOOL isReason_Selected;
-(ReturnReasons *)initWithData:(NSDictionary *)theDataDictionary;
@end
