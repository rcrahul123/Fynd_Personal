//
//  DeepLinkerHandler.h
//  Explore
//
//  Created by Pranav on 24/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeepLinkerHandler : NSObject

+(DeepLinkerHandler *)sharedSingleton;
+(void)navigateViaParams:(NSDictionary *)paramDict;
//@property (nonatomic,assign) static BranchScreenType branchDeepLinkType;
+(BranchScreenType)brandModuleType:(NSString *)urlType;
@end
