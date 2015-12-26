//
//  BKMoneyUtils.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import <Foundation/Foundation.h>

@interface BKMoneyUtils : NSObject

+ (NSRegularExpression *)nonNumericRegularExpression;

+ (NSCharacterSet *)numberCharacterSet;

@end
