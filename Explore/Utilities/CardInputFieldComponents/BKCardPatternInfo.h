//
//  BKCardPatternInfo.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import <Foundation/Foundation.h>

@interface BKCardPatternInfo : NSObject

/**
 * The card company name. (e.g., Visa, Master, ...)
 */
@property (nonatomic, strong, readonly) NSString      *companyName;

/**
 * Short card company name. (e.g., visa, master, ...)
 */
@property (nonatomic, strong, readonly) NSString      *shortName;

/**
 * Initialize card pattern info with dictionary object in CardPatterns.plist
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/**
 * Check whether number string matches credit card number pattern.
 */
- (BOOL)patternMatchesWithNumberString:(NSString *)aNumberString;

/**
 * Returns formatted card number string. (e.g., 1234 1234 1234 1234)
 */
- (NSString *)groupedStringWithString:(NSString *)aString;

@end
