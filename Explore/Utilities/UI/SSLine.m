//
//  SSLine.m
//  Explore
//
//  Created by Pranav on 17/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "SSLine.h"

@implementation SSLine


- (void)drawRect:(CGRect)rect {
    CGFloat rectHeight = CGRectGetHeight(rect);
    CGFloat rectWidth = CGRectGetWidth(rect);
    
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(0, rectHeight / 2)];
    [line addLineToPoint:CGPointMake(rectWidth, rectHeight / 2)];
    
    [UIColorFromRGB(kBackgroundGreyColor) setStroke];
//    [[UIColor redColor] setStroke];
    [line stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
