//
//  BankCardData.m
//  Explore
//
//  Created by Pranav on 01/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "BankCardData.h"

@implementation BankCardData

-(BankCardData *)initWithDictionary:(NSDictionary *)dict{
 
    if(self == [super init]){
        NSString *cardDisplayName = dict[@"card_name"];
        if(cardDisplayName!=nil && cardDisplayName.length > 0)
            self.cardName = cardDisplayName;
        else
            self.cardName = @" ";
        
        self.expMonth = [dict[@"exp_month"] integerValue];
        self.cardBrand = dict[@"card_brand"];
        
        if([self.cardBrand isEqualToString:@"AMEX"]){
            self.cardType = AmexBankCard;
            self.cardImage = @"Amex.png";
        }
        else if([self.cardBrand isEqualToString:@"DINERS"]){
            self.cardType = VisaBankCard;
            self.cardImage = @"Diners.png";
        }
        else if([self.cardBrand isEqualToString:@"MAESTRO"]){
            self.cardType = MaestroBankCard;
            self.cardImage = @"Maestro.png";
        }
        else if([self.cardBrand isEqualToString:@"MASTERCARD"]){
            self.cardType = MasterBankCard;
            self.cardImage = @"Master.png";
        }
        else if([self.cardBrand isEqualToString:@"RUPAY"]){
            self.cardType = RupayBankCard;
            self.cardImage = @"Rupay.png";
        }
        else if([self.cardBrand isEqualToString:@"VISA"]){
            self.cardType = VisaBankCard;
            self.cardImage = @"Visa.png";
        }else if ([self.cardBrand isEqualToString:@"VISAELECTRON"]){
            self.cardType = VisaElectronBankCard;
            self.cardImage = @"Visa.png";
        }
        
        
        self.cardToken = dict[@"card_token"];
        self.expYear = [dict[@"exp_year"] integerValue];
        self.expired = [dict[@"expired"] boolValue];
        self.cardId = [dict[@"card_id"] integerValue];
        self.cardNumber = dict[@"card_number"];
        
        NSString *formattedCard=[self.cardNumber substringFromIndex:MAX((int)[self.cardNumber length]-4,0)];
        
        self.cardFormattedNumder = [NSString stringWithFormat:@"•••• %@",formattedCard];

    }
    
    return self;
}

@end
