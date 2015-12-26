//
//  BankCardData.h
//  Explore
//
//  Created by Pranav on 01/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardData : NSObject

@property (nonatomic,strong) NSString *cardName;
@property (nonatomic,assign) NSInteger expMonth;
@property (nonatomic,strong) NSString *cardBrand;
@property (nonatomic,strong) NSString *cardToken;
@property (nonatomic,assign) NSInteger expYear;
@property (nonatomic,assign) BOOL     expired;
@property (nonatomic,assign) NSInteger cardId;
@property (nonatomic,strong) NSString *cardNumber;
@property (nonatomic,assign) BankCard  cardType;
@property (nonatomic,strong) NSString *cardImage;
@property (nonatomic,strong) NSString *cardFormattedNumder;

-(BankCardData *)initWithDictionary:(NSDictionary *)dict;
@end
