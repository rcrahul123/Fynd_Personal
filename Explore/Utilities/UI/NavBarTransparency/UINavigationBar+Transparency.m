//
//  UINavigationBar+Transparency.m
//  Explore
//
//  Created by Amboj Goyal on 7/24/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "UINavigationBar+Transparency.h"

@implementation UINavigationBar (Transparency)
-(void)changeNavigationBarToTransparent:(BOOL)isTransparent{
    if (isTransparent) {
        [self setBackgroundImage:[UIImage new]
                   forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [UIImage new];
        self.translucent = YES;
        self.backgroundColor = [UIColor clearColor];
        
    }else{
        self.translucent = FALSE;
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = UIColorFromRGB(0xF2F2F2);
        
        self.shadowImage = [self imageWithColor:UIColorFromRGB(kSignUpColor)];
    }
}

-(void)setFont:(UIFont *)theFont withColor:(UIColor *)theColor{
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:theFont forKey:NSFontAttributeName];
    [titleBarAttributes setValue:theColor forKey:NSForegroundColorAttributeName];
    [self setTitleTextAttributes:titleBarAttributes];
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 0.25f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
