//
//  BKCardNumberFormatter.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import "BKCardNumberFormatter.h"
#import "BKCardPatternInfo.h"
#import "BKMoneyUtils.h"

@interface BKCardNumberFormatter ()

@property (nonatomic, strong) NSSet                 *cardPatterns;
@property (nonatomic, strong) NSRegularExpression   *nonNumericRegularExpression;

@property (nonatomic, strong) NSString              *cachedPrefix;
@property (nonatomic, strong) BKCardPatternInfo     *cardPatternInfo;

@end

@implementation BKCardNumberFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CardPatterns" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dictionary in array) {
            
            BKCardPatternInfo *pattern = [[BKCardPatternInfo alloc] initWithDictionary:dictionary];
            if (pattern) {
                [mutableArray addObject:pattern];
            }
        }
        
        self.cardPatterns = [NSSet setWithArray:mutableArray];
        
        self.nonNumericRegularExpression = [BKMoneyUtils nonNumericRegularExpression];
    }
    return self;
}

- (NSString *)stringForObjectValue:(id)obj
{
    if (NO == [obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *numberString = [self.nonNumericRegularExpression stringByReplacingMatchesInString:obj
                                                                                      options:0
                                                                                        range:NSMakeRange(0, [obj length])
                                                                                 withTemplate:@""];
    
    BKCardPatternInfo *patternInfo = [self cardPatternInfoWithNumberString:numberString];
    
    if (patternInfo) {
        return [patternInfo groupedStringWithString:numberString];
    } else {
        return numberString;
    }
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    if (obj) {
        *obj = [self.nonNumericRegularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    }
    
    return YES;
}

- (NSString *)formattedStringFromRawString:(NSString *)rawString
{
    return [self stringForObjectValue:rawString];
}

- (NSString *)rawStringFromFormattedString:(NSString *)string
{
    NSString *result = nil;
    NSString *errorDescription = nil;
    if ([self getObjectValue:&result forString:string errorDescription:&errorDescription]) {
        return result;
    } else {
        return nil;
    }
}

- (BKCardPatternInfo *)cardPatternInfoWithNumberString:(NSString *)aNumberString
{
    if (self.cachedPrefix && [aNumberString hasPrefix:self.cachedPrefix] && self.cardPatternInfo) {
        return self.cardPatternInfo;
    }
    
    for (BKCardPatternInfo *patternInfo in self.cardPatterns) {
        
        if ([patternInfo patternMatchesWithNumberString:aNumberString]) {
            
            self.cardPatternInfo = patternInfo;
            self.cachedPrefix = aNumberString;
            
            return patternInfo;
        }
        if ([patternInfo.shortName isEqualToString:@"rupay"]) {
            if (aNumberString.length>5) {
                if ([[self class] validateForRupay:aNumberString]) {
                    self.cardPatternInfo = patternInfo;
                    self.cachedPrefix = aNumberString;
                    
                    return patternInfo;
                }
            }
        }
    }
    //Check for Rupay and sent the BKCardPatternInfo.
//    if (aNumberString.length>5) {
//        if ([[self class] validateForRupay:aNumberString]) {
//            
//            NSMutableDictionary *theRupayDictionary = [[NSMutableDictionary  alloc] init];
//            [theRupayDictionary setObject:@"" forKey:@"pattern"];
//            [theRupayDictionary setObject:@"Rupay" forKey:@"companyName"];
//            [theRupayDictionary setObject:@"rupay" forKey:@"shortName"];
//            [theRupayDictionary setObject:@"4,4,4,4" forKey:@"numberGrouping"];
//            [theRupayDictionary setObject:@"16" forKey:@"length"];
//
//            
//            
//            BKCardPatternInfo *theRupayPattern = [[BKCardPatternInfo alloc] initWithDictionary:theRupayDictionary];
//            self.cardPatternInfo = theRupayPattern;
//            self.cachedPrefix = aNumberString;
//            return theRupayPattern;
//        }
//    }
    
    self.cachedPrefix = nil;
    self.cardPatternInfo = nil;
    
    return nil;
}

+(BOOL)validateForRupay:(NSString *)cardNo{
    BOOL isValidRupay = FALSE;
    NSMutableArray *rupayValidationArray = [[NSMutableArray alloc] init];
    
    NSArray *range_1 = [[NSArray alloc] initWithObjects:@"508500",@"508999", nil];
    NSArray *range_2 = [[NSArray alloc] initWithObjects:@"606985",@"607384", nil];
    NSArray *range_3 = [[NSArray alloc] initWithObjects:@"607385",@"607984", nil];
    NSArray *range_4 = [[NSArray alloc] initWithObjects:@"608001",@"608100", nil];
    NSArray *range_5 = [[NSArray alloc] initWithObjects:@"608101",@"608200", nil];
    NSArray *range_6 = [[NSArray alloc] initWithObjects:@"608201",@"608300", nil];
    NSArray *range_7 = [[NSArray alloc] initWithObjects:@"608301",@"608350", nil];
    NSArray *range_8 = [[NSArray alloc] initWithObjects:@"608351",@"608500", nil];
    NSArray *range_9 = [[NSArray alloc] initWithObjects:@"652150",@"652849", nil];
    NSArray *range_10 = [[NSArray alloc] initWithObjects:@"652850",@"653049", nil];
    NSArray *range_11 = [[NSArray alloc] initWithObjects:@"652050",@"653149", nil];
    
    
    [rupayValidationArray addObject:range_1];
    [rupayValidationArray addObject:range_2];
    [rupayValidationArray addObject:range_3];
    [rupayValidationArray addObject:range_4];
    [rupayValidationArray addObject:range_5];
    [rupayValidationArray addObject:range_6];
    [rupayValidationArray addObject:range_7];
    [rupayValidationArray addObject:range_8];
    [rupayValidationArray addObject:range_9];
    [rupayValidationArray addObject:range_10];
    [rupayValidationArray addObject:range_11];
    
    cardNo = [cardNo stringByReplacingOccurrencesOfString:@" " withString:@""];    
    if (cardNo.length>5) {
        
        cardNo = [cardNo stringByReplacingOccurrencesOfString:@"[^\\d]g" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, 6)];
        
        cardNo = [cardNo stringByReplacingOccurrencesOfString:@" " withString:@""];
        cardNo = [cardNo substringWithRange:NSMakeRange(0, 6)];
        for (int i = 0; i<[rupayValidationArray count]; i++) {
            NSArray *theRangeArray = [rupayValidationArray objectAtIndex:i];
            for (int j = 0; j<[theRangeArray count]; j++) {
                int min = [[theRangeArray objectAtIndex:0] intValue];
                int max = [[theRangeArray objectAtIndex:1] intValue];
                int val = [cardNo intValue];
                if(val >= min && val <= max) {
                    isValidRupay = TRUE;
                    break;
                }
            }
        }
    }
    
    return isValidRupay;
}


@end
