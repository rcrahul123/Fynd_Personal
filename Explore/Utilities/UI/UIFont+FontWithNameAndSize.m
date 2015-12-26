//
//  UIFont+FontWithNameAndSize.m
//  Explore
//
//  Created by Rahul Chaudhari on 21/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "UIFont+FontWithNameAndSize.h"

@implementation UIFont (FontWithNameAndSize)


+(UIFont *)variableFontWithName:(NSString *)name size:(CGFloat)size{
    UIFont *font;
    if(DeviceWidth >= 375){
        font = [UIFont fontWithName:name size:size];
    }else if(DeviceWidth == 320){
        font = [UIFont fontWithName:name size:(320 * size/375)];
    }
    return font;
}
@end
