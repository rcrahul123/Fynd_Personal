//
//  Luhn.m
//  Luhn Algorithm (Mod 10)
//
//  Created by Max Kramer on 30/12/2012.
//  Copyright (c) 2012 Max Kramer. All rights reserved.
//

#import "Luhn.h"

@implementation NSString (Luhn)

- (BOOL) isValidCreditCardNumber {
    return [Luhn validateString:self];
}

- (OLCreditCardType) creditCardType {
    return [Luhn typeFromString:self];
}

@end

@interface NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing;

@end

@implementation NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing {
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

@end

@implementation Luhn

+ (OLCreditCardType) typeFromString:(NSString *) string {
    BOOL valid = [string isValidCreditCardNumber];
    if (!valid) {
        return OLCreditCardTypeInvalid;
    }
    
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return OLCreditCardTypeInvalid;
    }
    
    NSArray *enums = @[@(OLCreditCardTypeAmex), @(OLCreditCardTypeDinersClub), @(OLCreditCardTypeDiscover), @(OLCreditCardTypeJCB), @(OLCreditCardTypeMastercard), @(OLCreditCardTypeVisa)];
    
    __block OLCreditCardType type = OLCreditCardTypeInvalid;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OLCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [Luhn predicateForType:_type];
        BOOL isCurrentType = [predicate evaluateWithObject:formattedString];
        if (isCurrentType) {
            type = _type;
            *stop = YES;
        }
    }];
    return type;
}

+ (NSPredicate *) predicateForType:(OLCreditCardType) type {
    if (type == OLCreditCardTypeInvalid || type == OLCreditCardTypeUnsupported) {
        return nil;
    }
    NSString *regex = nil;
    switch (type) {
        case OLCreditCardTypeAmex:
            regex = @"^3[47][0-9]{5,}$";
            break;
        case OLCreditCardTypeDinersClub:
            regex = @"^3(?:0[0-5]|[68][0-9])[0-9]{4,}$";
            break;
        case OLCreditCardTypeDiscover:
            regex = @"^6(?:011|5[0-9]{2})[0-9]{3,}$";
            break;
        case OLCreditCardTypeJCB:
            regex = @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$";
            break;
        case OLCreditCardTypeMastercard:
            regex = @"^5[1-5][0-9]{5,}$";
            break;
        case OLCreditCardTypeVisa:
            regex = @"^4[0-9]{6,}$";
            break;
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
}

+ (BOOL) validateString:(NSString *)string forType:(OLCreditCardType)type {
    return [Luhn typeFromString:string] == type;
}

+ (BOOL)validateString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;
}

+(NSString *)getCardTypeForCardNumber:(NSString *)cardNumber{
    NSString *cardType = nil;
    
    NSString *nonRupayCard = [[self class] validateForNonRupayCard:cardNumber];
    cardType = nonRupayCard;

    if (cardNumber.length>5) {
        BOOL isRupayString = [[self class] validateForRupay:cardNumber];
        if (isRupayString) {
            cardType = @"rupay";
        }
    }

    return cardType;
}
+(NSDictionary *)getCardPatterns{

    NSMutableDictionary *cardType = [[NSMutableDictionary alloc] init];
    
//    /^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\d+$/,
//    [cardType setValue:@"^(5018|5044|5020|5038|603845|6304|6759|676[1-3]|6220|639|504834|56|58)" forKey:@"maestro"];
    [cardType setValue:@"^(5018|5044|5020|5038|603845|6304|6759|676[1-3]|6220|639|504834|56|58)" forKey:@"maestro"];
    
    [cardType setValue:@"^(4026|417500|4405|4508|4844|4913|4917)" forKey:@"visaelectron"];
    
    [cardType setValue:@"^(36|38|39|30[0-5])" forKey:@"dinnersclub"];
    
    [cardType setValue:@"^(5[1-5]|2[2-7])" forKey:@"mastercard"];
    
    [cardType setValue:@"^35" forKey:@"jcb"];
    
    [cardType setValue:@"^(6011|65|64[4-9]|622)" forKey:@"discover"];
    
    [cardType setValue:@"^3[47]" forKey:@"amex"];
    
    [cardType setValue:@"^4[0-9]" forKey:@"visa"];
    
    return cardType;
}

+(NSString *)validateForNonRupayCard:(NSString *)cardNumber{
    NSString *cardType = nil;
    
    cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@"/[^\\d]/g" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, cardNumber.length)];
    NSDictionary *cardPatters = [Luhn getCardPatterns];
    for (NSString *key in [cardPatters allKeys]) {
        NSString *regex = [cardPatters valueForKey:key];
        NSRange range = [cardNumber rangeOfString:regex options:NSRegularExpressionSearch | NSRegularExpressionCaseInsensitive];
        if (range.length>0) {
            cardType = key;
            break;
        }else{
            cardType = @"InValid";
        }
    }
    return cardType;
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