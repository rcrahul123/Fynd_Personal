//
//  CardAuthenticationViewController.h
//  Explore
//
//  Created by Amboj Goyal on 12/5/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentModes.h"
#import "UINavigationBar+Transparency.h"
#import "PaymentWebViewController.h"

@protocol CardAuthenticationViewDelegate <NSObject>

-(void)paymentDoneNavigateToFeedWithSuccess:(BOOL)isSuccessful;
-(void)showPaymentWebViewWithURLString:(NSString *)urlString andMethod:(NSString *)method andParams:(NSDictionary *)params;

-(void)dismissCVVScreen;

@end


@interface CardAuthenticationViewController : UIViewController
@property (nonatomic,strong) NSDictionary *responseDictionary;
@property (nonatomic,unsafe_unretained) id<CardAuthenticationViewDelegate> delegate;


-(void)configureCardAuthenticationViewWithCardModel:(CardModel *)theCardModel;

@end
