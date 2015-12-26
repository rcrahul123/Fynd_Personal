//
//  PaymentController.h
//  Explore
//
//  Created by Pranav on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentModes.h"
#import "PaymentModeCell.h"
typedef enum PaymentScreenType{
    PaymentScreenTypeProfile,
    PaymentScreenTypeCart
}PaymentScreenType;

@protocol PaymentControllerDelegate;
@interface PaymentController : UIViewController{
    
//    UIScrollView *scrollView;
    NSMutableArray *cardList;
    NSMutableArray *netBankingOptions;
    FyndActivityIndicator *bankCardLoader;
    FyndActivityIndicator *cardLoader;
    
}

@property (nonatomic, assign) PaymentScreenType paymentMode;

@property (nonatomic, strong) NSDictionary *availablePaymentModes;
@property (nonatomic, strong) NSMutableArray *parsedPaymentOptions;
@property (nonatomic, strong) NSMutableArray *cardList;
@property (nonatomic,unsafe_unretained) id<PaymentControllerDelegate>thePaymentDelegate;
@end

@protocol PaymentControllerDelegate <NSObject>
- (void)selectedOptionWithDataDictionary:(NSDictionary *)theData;
@end
