//
//  BKCardPatternInfo.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import "BKCardPatternInfo.h"

@interface BKCardPatternInfo ()

@property (nonatomic, strong) NSString              *companyName;
@property (nonatomic, strong) NSString              *shortName;
@property (nonatomic, strong) NSRegularExpression   *patternRegularExpression;
@property (nonatomic, strong) NSArray               *numberGrouping;
@property (nonatomic, strong) NSArray               *lengths;
@property (nonatomic) NSInteger                     maxLength;

@end

@implementation BKCardPatternInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self) {
        NSString *pattern = aDictionary[@"pattern"];
        self.patternRegularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        self.companyName = aDictionary[@"companyName"];
        self.shortName = aDictionary[@"shortName"];
        self.numberGrouping = [[self class] numberArrayWithCommaSeparatedString:aDictionary[@"numberGrouping"] maxValue:NULL];
        
        NSInteger maxLength;
        self.lengths = [[self class] numberArrayWithCommaSeparatedString:aDictionary[@"length"] maxValue:&maxLength];
        self.maxLength = maxLength;

    }
    return self;
}

+ (NSArray *)numberArrayWithCommaSeparatedString:(NSString *)aCommaSeparatedString maxValue:(NSInteger *)outMaxValue
{
    NSArray *components = [aCommaSeparatedString componentsSeparatedByString:@","];
    
    NSMutableArray *mutableResultArray = [NSMutableArray arrayWithCapacity:components.count];
    
    NSInteger maxValue = 0;
    
    for (NSString *component in components) {
        NSInteger integer = component.integerValue;
        if (integer > 0) {
            [mutableResultArray addObject:@(integer)];
            maxValue = MAX(maxValue, integer);
        }
    }
    
    if (outMaxValue) {
        *outMaxValue = maxValue;
    }
    
    return [NSArray arrayWithArray:mutableResultArray];
}

- (BOOL)patternMatchesWithNumberString:(NSString *)aNumberString
{
    NSUInteger numberOfMatches = [self.patternRegularExpression numberOfMatchesInString:aNumberString options:0 range:NSMakeRange(0, aNumberString.length)];
    return numberOfMatches > 0;
}

- (NSString *)groupedStringWithString:(NSString *)aString
{
    if (aString.length == 0) {
        return @"";
    }
    
    if (aString.length > self.maxLength) {
        aString = [aString substringWithRange:NSMakeRange(0, self.maxLength)];
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:aString.length + self.numberGrouping.count - 1];
    
    NSInteger location = 0;
    
    for (NSInteger i = 0; i < self.numberGrouping.count; i++) {
        
        NSNumber *digitCountNumber = self.numberGrouping[i];
        NSInteger digitCount = digitCountNumber.integerValue;
        
        NSRange substringRange = NSMakeRange(location, digitCount);
        
        if (NSMaxRange(substringRange) <= aString.length) {
            
            [mutableString appendString:[aString substringWithRange:substringRange]];
            
            location += digitCount;
            
            if (i < self.numberGrouping.count - 1) {
                [mutableString appendString:@" "];
            } else {
                [mutableString appendString:[aString substringFromIndex:location]];
            }
            
        } else {
            [mutableString appendString:[aString substringFromIndex:location]];
            break;
        }
    }
    
    return [NSString stringWithString:mutableString];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"companyName=%@, shortName=%@, pattern=%@, numberGrouping=%@, lengths=%@",
            self.companyName, self.shortName, self.patternRegularExpression, self.numberGrouping, self.lengths];
}

@end
