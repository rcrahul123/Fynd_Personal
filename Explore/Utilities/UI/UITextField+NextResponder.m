//
//  UITextField+NextResponder.m
//  Explore
//
//  Created by Amboj Goyal on 8/20/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "UITextField+NextResponder.h"
#import <objc/runtime.h>

static char defaultHashKey;

@implementation UITextField (NextResponder)
- (UITextField*) nextTextField {
    return objc_getAssociatedObject(self, &defaultHashKey);
}

- (void) setNextTextField:(UITextField *)nextTextField{
    objc_setAssociatedObject(self, &defaultHashKey, nextTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
