//
//  BKCardNumberFormatter.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import <Foundation/Foundation.h>
#import "BKCardPatternInfo.h"


@interface BKCardNumberFormatter : NSFormatter

/**
 * The card pattern info that is used last time.
 */
@property (nonatomic, strong, readonly) BKCardPatternInfo *cardPatternInfo;

/**
 * Returns formatted card number string from raw string.
 */
- (NSString *)formattedStringFromRawString:(NSString *)rawString;

/**
 * Returns raw string from formatted string.
 */
- (NSString *)rawStringFromFormattedString:(NSString *)string;

@end
