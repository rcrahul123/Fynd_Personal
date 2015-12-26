//
//  PaymentModes.m
//  Explore
//
//  Created by Amboj Goyal on 9/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PaymentModes.h"


@implementation NetBankingModel

-(NetBankingModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.bankCode = dictionary[@"bank_code"];
        self.bankLogo = dictionary[@"url"];
        self.bankName = dictionary[@"bank_name"];
    }
    return self;
}
@end



@implementation CardModel

-(CardModel *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.cardBrand = dictionary[@"card_brand"];
        self.cardId = dictionary[@"card_id"];
        self.cardName = dictionary[@"card_name"];
        self.cardNumber = dictionary[@"card_number"];
        self.cardToken = dictionary[@"card_token"];
        self.expiryMonth = dictionary[@"exp_month"];
        NSString *cardExpiryYear = dictionary[@"exp_year"];
        if (cardExpiryYear != nil && cardExpiryYear.length>2) {
            cardExpiryYear = [cardExpiryYear substringFromIndex:MAX((int)[cardExpiryYear length]-2,0)];
        }
        self.expiryYear = cardExpiryYear;
        self.isExipred = [dictionary[@"expired"] boolValue];
        self.cardReference = dictionary[@"card_reference"];
        
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
        NSString *formattedCard=[self.cardNumber substringFromIndex:MAX((int)[self.cardNumber length]-4,0)];

        
        NSMutableAttributedString * paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•••• %@",formattedCard] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14]}];
        
        [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:22], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, 4)];
        
        
        
        
//        NSMutableAttributedString *dotString = [[NSMutableAttributedString alloc] initWithString:@"•••• " attributes:@{
//                                                NSFontAttributeName : [UIFont fontWithName:kMontserrat_Black size:26.0f]
//                                                }];
//        
//        NSAttributedString *formattedNumberString = [[NSAttributedString alloc] initWithString:formattedCard];
//        [dotString appendAttributedString:formattedNumberString];
        self.cardFormattedNumber = formattedCard;

    }
    return self;
}
@end



@implementation PaymentModes
-(PaymentModes *)initWithDictionary:(NSMutableDictionary *)dataDictionary{
    self = [super init];
    if (self) {
        self.paymentModeId = [NSString stringWithFormat:@"%@",dataDictionary[@"payment_mode_id"]];
        self.paymentDisplayName = dataDictionary[@"display_name"];
        self.paymentName = dataDictionary[@"name"];
        
        NSArray *submoduleArray;
        
        self.optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        if([[self.paymentName uppercaseString] isEqualToString:@"CARD"]){
            submoduleArray = dataDictionary[@"list"];
            for(int i = 0; i < [submoduleArray count]; i++){
                CardModel *model = [[CardModel alloc] initWithDictionary:[submoduleArray objectAtIndex:i]];
                [self.optionsArray addObject:model];
            }
            
        }else if([[self.paymentName uppercaseString] isEqualToString:@"NB"]){
            submoduleArray = dataDictionary[@"list"];
            
            for(int i = 0; i < [submoduleArray count]; i++){
                NetBankingModel *model = [[NetBankingModel alloc] initWithDictionary:[submoduleArray objectAtIndex:i]];
                [self.optionsArray addObject:model];
            }
            
        }
    }
    return self;
}


//-(NSDictionary *)getDefaultPaymentMethod:(NSDictionary *)dataDictionary{
//    
//    NSDictionary *defaultOptionDictionary;
//    
//    NSString *mode = dataDictionary[@"mode"];
//    NSDictionary *dictionary = dataDictionary[@"data"];
//    if([[mode uppercaseString] isEqualToString:@"CARD"]){
//        CardModel *card = [[CardModel alloc] initWithDictionary:dictionary];
//        defaultOptionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:mode, @"mode", card, @"data", nil];
//
//    }else if([[mode uppercaseString] isEqualToString:@"NB"]){
//        NetBankingModel *bank = [[NetBankingModel alloc] initWithDictionary:dictionary];
//        defaultOptionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:mode, @"mode", bank, @"data", nil];
//    }
//    
//    return defaultOptionDictionary;
//}


@end
