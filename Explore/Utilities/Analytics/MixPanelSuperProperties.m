//
//  MixPanelSuperProperties.m
//  Explore
//
//  Created by Amboj Goyal on 10/4/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "MixPanelSuperProperties.h"
static MixPanelSuperProperties * _sharedInstance = nil;
@implementation MixPanelSuperProperties

+(MixPanelSuperProperties*)sharedInstance{
    @synchronized([MixPanelSuperProperties class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        return _sharedInstance;
    }
    
    return nil;

}



@end
