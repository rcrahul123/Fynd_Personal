//
//  UITextField+NextResponder.h
//  Explore
//
//  Created by Amboj Goyal on 8/20/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (NextResponder)
@property(retain, nonatomic)UITextField* nextTextField;
@end
