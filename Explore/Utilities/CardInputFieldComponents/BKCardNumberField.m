//
//  BKCardNumberField.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

#import "BKCardNumberField.h"
#import "BKCardNumberFormatter.h"
#import "BKMoneyUtils.h"

@interface BKCardNumberField ()

@property (nonatomic, strong) BKCardNumberFormatter     *cardNumberFormatter;
@property (nonatomic, strong) UIImageView               *cardLogoImageView;
@property (nonatomic, strong) NSCharacterSet            *numberCharacterSet;

@end

@implementation BKCardNumberField

#pragma mark - Initialize

- (void)commonInit
{
    [super commonInit];
    
    _cardNumberFormatter = [[BKCardNumberFormatter alloc] init];
    
    _numberCharacterSet = [BKMoneyUtils numberCharacterSet];
    
    self.keyboardType = UIKeyboardTypeNumberPad;
//    self.clearButtonMode = UITextFieldViewModeAlways;
    
    [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Dealloc

- (void)dealloc
{
}

#pragma mark - UITextFieldDelegate

- (void)deleteBackward {
    BOOL shouldDismiss = [self.text length] == 0;
    
    [super deleteBackward];
    
    if ([self.userDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        [self.userDelegate textField:self shouldChangeCharactersInRange:NSMakeRange(self.text.length, 0) replacementString:@""];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.userDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        if (NO == [self.userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
            return NO;
        }
    }
    
    NSString *currentText = textField.text;
    
    NSCharacterSet *nonNumberCharacterSet = [self.numberCharacterSet invertedSet];
    
    if (string.length == 0 && [[currentText substringWithRange:range] stringByTrimmingCharactersInSet:nonNumberCharacterSet].length == 0) {
        // find non-whitespace character backward
        NSRange numberCharacterRange = [currentText rangeOfCharacterFromSet:self.numberCharacterSet
                                                                    options:NSBackwardsSearch
                                                                      range:NSMakeRange(0, range.location)];
        // adjust replace range
        if (numberCharacterRange.location != NSNotFound) {
            range = NSUnionRange(range, numberCharacterRange);
        }
    }
    
    NSString *newString = [currentText stringByReplacingCharactersInRange:range withString:string];
    
    // formatting card number
    textField.text = [self.cardNumberFormatter formattedStringFromRawString:newString];

    // send editing changed action because we edited text manually.
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.userDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        if (NO == [self.userDelegate textFieldShouldClear:textField]) {
            return NO;
        }
    }
    
    // reset card number formatter
    textField.text = [self.cardNumberFormatter formattedStringFromRawString:@""];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

- (void)textFieldEditingChanged:(id)sender
{
    [self updateCardLogoImage];
}

#pragma mark - Private Methods

- (void)updateCardLogoImage
{
    if (nil == self.cardLogoImageView) {
        return;
    }
    
    BKCardPatternInfo *patternInfo = self.cardNumberFormatter.cardPatternInfo;
    
    UIImage *cardLogoImage = nil;
    
    if (patternInfo) {
        cardLogoImage = [UIImage imageNamed:[NSString stringWithFormat:@"CardLogo.bundle/%@", patternInfo.shortName]];
    }
    
    if (nil == patternInfo || nil == cardLogoImage) {
        cardLogoImage = [UIImage imageNamed:@"CardLogo.bundle/default"];
    }

    self.cardLogoImageView.image = cardLogoImage;
}

#pragma mark - Public Methods

- (void)setShowsCardLogo:(BOOL)showsCardLogo
{
    if (_showsCardLogo != showsCardLogo) {
        _showsCardLogo = showsCardLogo;
        
        if (showsCardLogo) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            imageView.contentMode = UIViewContentModeCenter;
            
            self.leftView = imageView;
            self.leftViewMode = UITextFieldViewModeAlways;
            
            self.cardLogoImageView = imageView;
            
            [self updateCardLogoImage];
            
        } else {
            self.leftView = nil;
        }
    }
}

- (void)setCardNumber:(NSString *)cardNumber
{
    self.text = [self.cardNumberFormatter formattedStringFromRawString:cardNumber];
}

- (NSString *)cardNumber
{
    return [self.cardNumberFormatter rawStringFromFormattedString:self.text];
}

- (NSString *)cardCompanyName
{
    return self.cardNumberFormatter.cardPatternInfo.companyName;
}

@end
