//
//  PaymentModes.h
//  Explore
//
//  Created by Amboj Goyal on 9/16/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBankingModel : NSObject

@property (nonatomic, strong) NSString *bankCode;
@property (nonatomic, strong) NSString *bankLogo;
@property (nonatomic, strong) NSString *bankName;

-(NetBankingModel *)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface CardModel : NSObject

@property (nonatomic, strong) NSString *cardBrand;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *cardToken;
@property (nonatomic, strong) NSString *expiryMonth;
@property (nonatomic, strong) NSString *expiryYear;
@property (nonatomic, assign) BOOL isExipred;
@property (nonatomic, strong) NSString *cardFormattedNumber;
@property (nonatomic,assign) BankCard  cardType;
@property (nonatomic,strong) NSString *cardImage;
@property (nonatomic, strong) NSString *cardReference;

-(CardModel *)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface PaymentModes : NSObject
@property (nonatomic,copy)NSString *paymentModeId;
@property (nonatomic,copy)NSString *paymentDisplayName;
@property (nonatomic,copy)NSString *paymentName;
@property (nonatomic,copy)NSString *paymentImageName;

@property (nonatomic, strong) NSMutableArray  *optionsArray;
-(PaymentModes *)initWithDictionary:(NSMutableDictionary *)dataDictionary;

@end
