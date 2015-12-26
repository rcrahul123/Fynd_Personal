//
//  AddCartPopUp.h
//  Explore
//
//  Created by Pranav on 24/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BankCardData.h"
#import "PaymentModes.h"

@protocol AddCartPopUpDelegate;
@interface AddCartPopUp : UIView

//@property (nonatomic,strong) BankCardData *selectedCard;
@property (nonatomic,strong) CardModel *selectedCard;
@property (nonatomic,weak) id<AddCartPopUpDelegate> addCartDelegate;
@property (nonatomic,assign) BOOL isAddingCard;
@property (nonatomic,strong) UIImageView *cardBackgroundImage;
- (void)configureAddCart;
@end

@protocol AddCartPopUpDelegate <NSObject>

- (void)actionPerormOnAddCard:(NSInteger)tag andAddedCard:(CardModel *)cardData;

@end
