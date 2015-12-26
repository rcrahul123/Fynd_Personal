//
//  PaymentSummaryView.m
//  Explore
//
//  Created by Rahul Chaudhari on 02/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PaymentSummaryView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kHorizontalMargin 6


@implementation PaymentSummaryView
@synthesize swipeIndicatorView, payButtonContainer, couponTextField, indicatorBarImage, indicatorDownArrowImage, indicatorUpArrowImage, indicatorImageView;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //        [self setBackgroundColor:UIColorFromRGB(0xd0d0d0)];
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
        
        
        self.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
        [self.layer setShadowOpacity:0.1];
        [self.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    }
    return self;
}


-(void)drawUIComponents{
    [self setupSwipeIndicator];
    
    //call on condition basis
    [self setupAddressAndPaymentView];
    [self addDetailView];
}

-(void)setupSwipeIndicator{
    swipeIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, RelativeSizeHeight(28, 480))];

    [swipeIndicatorView setBackgroundColor:[UIColor whiteColor]];
    
    indicatorUpArrowImage = [UIImage imageNamed:@"CartDetailSliderArrow"];
    indicatorBarImage = [UIImage imageNamed:@"CartDetailSliderBar"];

    indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(swipeIndicatorView.frame.size.width/2 - indicatorUpArrowImage.size.width/2, 3, indicatorUpArrowImage.size.width, indicatorUpArrowImage.size.height)];
    indicatorImageView.image = indicatorUpArrowImage;
    [swipeIndicatorView addSubview:indicatorImageView];
    
//    paymentDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, indicatorImageView.frame.origin.y + indicatorImageView.frame.size.height + 2, 150, 15)];
    paymentDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, indicatorImageView.frame.origin.y + indicatorImageView.frame.size.height +1, 150, RelativeSizeHeight(15, 480))];

    [paymentDetailLabel setText:@"PAYMENT DETAILS"];
    [paymentDetailLabel setFont:[UIFont variableFontWithName:kMontserrat_Light size:10.0]];

    [paymentDetailLabel setBackgroundColor:[UIColor clearColor]];
    [paymentDetailLabel setTextColor:UIColorFromRGB(kLightGreyColor)];
    [paymentDetailLabel sizeToFit];
    [paymentDetailLabel setCenter:CGPointMake(swipeIndicatorView.frame.size.width/2, paymentDetailLabel.center.y)];
    [swipeIndicatorView addSubview:paymentDetailLabel];
    [self addSubview:swipeIndicatorView];
}


-(void)setupPayButton{
    payButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, swipeIndicatorView.frame.origin.y + swipeIndicatorView.frame.size.height, self.frame.size.width, self.buttonHeight)];
    
    [payButtonContainer setBackgroundColor:[UIColor clearColor]];
    [self addSubview:payButtonContainer];
    
    NSMutableAttributedString *payButtonString = [[NSMutableAttributedString alloc] initWithString:@"QUICK PAY" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    payButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalMargin, kHorizontalMargin, payButtonContainer.frame.size.width - 2 * kHorizontalMargin, payButtonContainer.frame.size.height - 2 * kHorizontalMargin)];
    [payButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kDarkPurpleColor)] forState:UIControlStateNormal];
    [payButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kDarkPurpleColor)] forState:UIControlStateHighlighted];
    [payButton setAttributedTitle:payButtonString forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 3.0;
    payButton.clipsToBounds = YES;
    [payButtonContainer addSubview:payButton];
}

-(void)setupAddressAndPaymentView{
    topViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, swipeIndicatorView.frame.origin.y + swipeIndicatorView.frame.size.height + 1, self.frame.size.width, RelativeSizeHeight(127, 480))];

    [topViewContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:topViewContainer];
    
    
    //add address view
    addAddressView = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalMargin, 0, topViewContainer.frame.size.width - 2 * kHorizontalMargin, topViewContainer.frame.size.height/3)];
    [addAddressView setBackgroundColor:[UIColor clearColor]];
    [topViewContainer addSubview:addAddressView];
    
    hiddenAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(-kHorizontalMargin, 0, addAddressView.frame.size.width + kHorizontalMargin * 2 , addAddressView.frame.size.height)];
    hiddenAddressButton.tag = 193;
    [hiddenAddressButton setUserInteractionEnabled:YES];
    [addAddressView addSubview:hiddenAddressButton];
    [hiddenAddressButton setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [hiddenAddressButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [hiddenAddressButton addTarget:self action:@selector(addAddressClicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIImage *addressImage = [UIImage imageNamed:@"AddAddressFromCart"];
//    addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addAddressView.frame.size.height/2 - addressImage.size.height/2, addressImage.size.width, addressImage.size.height)];

    addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addAddressView.frame.size.height/2 - 15, 30,30)];
    addressImageView.image = addressImage;
    [addAddressView addSubview:addressImageView];
    
    addressPlusImage = [UIImage imageNamed:@"PlusIcon"];
    addressPlusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addAddressView.frame.size.width - addressPlusImage.size.width, addAddressView.frame.size.height/2 - addressPlusImage.size.height/2, addressPlusImage.size.width, addressPlusImage.size.height)];
    addressPlusImageView.image = addressPlusImage;
    [addAddressView addSubview:addressPlusImageView];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + addressImageView.frame.size.width + 10, 3, addAddressView.frame.size.width - addressImageView.frame.size.width - addressPlusImageView.frame.size.width - 10, addAddressView.frame.size.height - 6)];
    [addressLabel setText:@"Add Address"];
    [addressLabel setFont:[UIFont variableFontWithName:kMontserrat_Light size:16.0]];
    [addressLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [addAddressView addSubview:addressLabel];
    
    
    //add payment option view
    addPaymentOptionView = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addAddressView.frame.origin.y + addAddressView.frame.size.height, topViewContainer.frame.size.width - 2 * kHorizontalMargin, topViewContainer.frame.size.height/3)];
    [addPaymentOptionView setBackgroundColor:[UIColor clearColor]];
    [topViewContainer addSubview:addPaymentOptionView];
    
    hiddenPaymentOptionBtton = [[UIButton alloc] initWithFrame:CGRectMake(-kHorizontalMargin, 0, addAddressView.frame.size.width + kHorizontalMargin * 2 , addAddressView.frame.size.height)];
    hiddenPaymentOptionBtton.tag = 193;
    [hiddenPaymentOptionBtton setUserInteractionEnabled:YES];
    [addPaymentOptionView addSubview:hiddenPaymentOptionBtton];
    [hiddenPaymentOptionBtton setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [hiddenPaymentOptionBtton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [hiddenPaymentOptionBtton addTarget:self action:@selector(addPaymentOptionClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(-kHorizontalMargin, 0, self.frame.size.width, 1)];
    separator2.tag = 10;
    [separator2 setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [addPaymentOptionView addSubview:separator2];
    
//    changePaymentOptionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPaymentOptionClicked)];
//    [addPaymentOptionView addGestureRecognizer:changePaymentOptionGesture];
    
    UIImage *paymentImage = [UIImage imageNamed:@"AddPaymentOptionFromCart"];
//    paymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addPaymentOptionView.frame.size.height/2 - paymentImage.size.height/2, paymentImage.size.width, paymentImage.size.height)];
    paymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addPaymentOptionView.frame.size.height/2 - 15, 30, 30)];
    
    paymentImageView.image = paymentImage;
    [addPaymentOptionView addSubview:paymentImageView];
    
    paymentPlusImage = [UIImage imageNamed:@"PlusIcon"];
    paymentPlusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(addPaymentOptionView.frame.size.width - paymentPlusImage.size.width, addPaymentOptionView.frame.size.height/2 - paymentPlusImage.size.height/2, paymentPlusImage.size.width, paymentPlusImage.size.height)];
    paymentPlusImageView.image = paymentPlusImage;
    [addPaymentOptionView addSubview:paymentPlusImageView];
    
    paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(paymentImageView.frame.origin.x + paymentImageView.frame.size.width + 10, 3, addAddressView.frame.size.width - paymentImageView.frame.size.width - paymentPlusImageView.frame.size.width - 10, addPaymentOptionView.frame.size.height - 6)];
    [paymentLabel setText:@"Add Payment Option"];
    [paymentLabel setFont:[UIFont variableFontWithName:kMontserrat_Light size:16]];
    [paymentLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [paymentLabel setBackgroundColor:[UIColor clearColor]];
    [addPaymentOptionView addSubview:paymentLabel];
    
    //add coupon view
    enterCouponCodeView = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addPaymentOptionView.frame.origin.y + addPaymentOptionView.frame.size.height, topViewContainer.frame.size.width - 2 * kHorizontalMargin, topViewContainer.frame.size.height/3)];
    [enterCouponCodeView setBackgroundColor:[UIColor clearColor]];
    [topViewContainer addSubview:enterCouponCodeView];
    
    UIView *separator3 = [[UIView alloc] initWithFrame:CGRectMake(-kHorizontalMargin, 0, self.frame.size.width, 1)];
    separator3.tag = 10;
    [separator3 setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [enterCouponCodeView addSubview:separator3];
    
    UIImage *couponImage = [UIImage imageNamed:@"Coupons"];
//    couponImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, enterCouponCodeView.frame.size.height/2 - couponImage.size.height/2, couponImage.size.width, couponImage.size.height)];
    
    couponImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, enterCouponCodeView.frame.size.height/2 - 15, 30,30)];
    
    couponImageView.image = couponImage;
    [enterCouponCodeView addSubview:couponImageView];
    
    applyCouponButton = [[UIButton alloc] initWithFrame:CGRectMake(enterCouponCodeView.frame.size.width - 70, 0, 70, enterCouponCodeView.frame.size.height)];
    [applyCouponButton setCenter:CGPointMake(applyCouponButton.center.x, enterCouponCodeView.frame.size.height/2)];
    [applyCouponButton setBackgroundColor:[UIColor clearColor]];

    [applyCouponButton setAttributedTitle:couponButtonString forState:UIControlStateNormal];
    [applyCouponButton setHidden:true];
    [applyCouponButton addTarget:self action:@selector(applyCoupon) forControlEvents:UIControlEventTouchUpInside];
    [enterCouponCodeView addSubview:applyCouponButton];
    
    couponTextField = [[UITextField alloc] initWithFrame:CGRectMake(couponImageView.frame.origin.x + couponImageView.frame.size.width + 10, 3, enterCouponCodeView.frame.size.width - couponImageView.frame.size.width - applyCouponButton.frame.size.width - 30, enterCouponCodeView.frame.size.height - 6)];
    couponTextField.font = [UIFont variableFontWithName:kMontserrat_Light size:16];
    couponTextField.placeholder = @"Enter Coupon Code";
    [couponTextField setBackgroundColor:[UIColor clearColor]];
    [couponTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    couponTextField.delegate = self;
    couponTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    couponTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [enterCouponCodeView addSubview:couponTextField];
    
    couponLoader = [[FyndActivityIndicator alloc] initWithSize:CGSizeMake(enterCouponCodeView.frame.size.height/2, enterCouponCodeView.frame.size.height/2)];
    [couponLoader setCenter:applyCouponButton.center];
    couponLoader.hidden = true;
    [enterCouponCodeView addSubview:couponLoader];
    
    if(self.couponData.isCoupanApplied && self.couponData.isCoupanValid){
        couponTextField.text = self.couponData.couponCode;
    }
    
    [self updateCouponValue];
}

-(void)addDetailView{
    
    bottomViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, topViewContainer.frame.origin.y + topViewContainer.frame.size.height, self.frame.size.width, self.frame.size.height - (topViewContainer.frame.origin.y + topViewContainer.frame.size.height))];
    [bottomViewContainer setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bottomViewContainer];
    
    viewDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, RelativeSizeHeight(15, 480))];
    [viewDetailLabel setBackgroundColor:[UIColor clearColor]];
    [viewDetailLabel setText:@"VIEW DETAILS"];
    [viewDetailLabel setFont:[UIFont variableFontWithName:kMontserrat_Light size:12.0]];
    [viewDetailLabel sizeToFit];
    [viewDetailLabel setTextColor:UIColorFromRGB(kLightGreyColor)];
    [viewDetailLabel setCenter:CGPointMake(bottomViewContainer.frame.size.width/2, viewDetailLabel.center.y)];
    [bottomViewContainer addSubview:viewDetailLabel];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator= false;
    [self setupDetailView];
    
    self.viewDetailBottom = bottomViewContainer.frame.origin.y + viewDetailLabel.frame.origin.y + viewDetailLabel.frame.size.height;
}


-(void)setupDetailView{
 
    [self updateDetailView];
    [bottomViewContainer setFrame:CGRectMake(bottomViewContainer.frame.origin.x, bottomViewContainer.frame.origin.y, bottomViewContainer.frame.size.width, scrollView.frame.origin.y + scrollView.frame.size.height + 2 * self.buttonHeight)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomViewContainer.frame.origin.y + bottomViewContainer.frame.size.height)];
    self.anchoredCenter = CGPointMake(self.center.x, bottomViewContainer.frame.origin.y + scrollView.frame.origin.y - RelativeSizeHeight(95, 667));
}



-(void)updateDetailView{
    for(UIView *view in [scrollView subviews]){
        [view removeFromSuperview];
    }

    CGFloat height = 0.0f;
    NSDictionary *dict = [self.cartBreakupDetails objectAtIndex:0];
    CGSize aSize = [SSUtility getLabelDynamicSize:[[dict allKeys] objectAtIndex:0] withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(300, MAXFLOAT)];
    aSize.height = RelativeSizeHeight(23, 480);
    height += ([self.cartBreakupDetails count])*aSize.height + (([self.cartBreakupDetails count]) * 5);
    
    CGFloat availableHeight = bottomViewContainer.frame.size.height - viewDetailLabel.frame.origin.y - viewDetailLabel.frame.size.height - 65;
    
    if(height > availableHeight){
        [scrollView setFrame:CGRectMake(kHorizontalMargin, viewDetailLabel.frame.origin.y + viewDetailLabel.frame.size.height, bottomViewContainer.frame.size.width - 2 * kHorizontalMargin, availableHeight)];
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, height + aSize.height)];
    }else{
        [scrollView setFrame:CGRectMake(kHorizontalMargin, viewDetailLabel.frame.origin.y + viewDetailLabel.frame.size.height, bottomViewContainer.frame.size.width - 2 * kHorizontalMargin, height)];
    }
    [bottomViewContainer addSubview:scrollView];
    
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat itemPadding = 2.0f;
    CGFloat oldOItemHeight = RelativeSizeHeight(7, 667);
    for(NSInteger counter=0; counter < [self.cartBreakupDetails count] - 1; counter++){
        NSDictionary *currentDict = [self.cartBreakupDetails objectAtIndex:counter];
        
        NSString *key = [[currentDict allKeys] objectAtIndex:0];
        
        UIFont *paymentOptionFont = nil;
        UIColor *paymentHeadingColor;
        if(counter == [self.cartBreakupDetails count]-1){
            paymentOptionFont = [UIFont variableFontWithName:kMontserrat_Light size:14.0];
        }else{
            paymentOptionFont = [UIFont variableFontWithName:kMontserrat_Light size:14.0];
        }
        
        UILabel *heading = [SSUtility generateLabel:key withRect:CGRectMake(kHorizontalMargin,  oldOItemHeight, 200, RelativeSizeHeight(23, 480)) withFont:paymentOptionFont];
        [heading setTextAlignment:NSTextAlignmentLeft];
        [heading setBackgroundColor:[UIColor clearColor]];
        NSString *headingString = [[currentDict allKeys] objectAtIndex:0];
        if(counter == [self.cartBreakupDetails count]-1){
            headingString = @"TOTAL";
            paymentHeadingColor = UIColorFromRGB(kSignUpColor);
        }else{
            paymentHeadingColor = UIColorFromRGB(kGenderSelectorTintColor);
        }
        
        [heading setText:headingString];
        [heading setTextColor:paymentHeadingColor];
        [scrollView addSubview:heading];
        
        UIColor *valueColor = UIColorFromRGB(kSignUpColor);
        NSString *value = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol,[currentDict objectForKey:key]];
        if([[key uppercaseString] isEqualToString:@"DELIVERY"] || [[key uppercaseString] isEqualToString:@"DELIVERY CHARGE"]){
            NSInteger deliveryFee = [[currentDict objectForKey:key] integerValue];
            if(deliveryFee > 0){
                value = [NSString stringWithFormat:@"%@ %ld",kRupeeSymbol,(long)deliveryFee];
                valueColor = UIColorFromRGB(kCouponSucessColor);
                
            }else{
                value = @"Free";
                valueColor = UIColorFromRGB(0x33CC99);
            }
        }
        else if([[key uppercaseString] isEqualToString:@"COUPON"]){
            NSArray *arr = [[currentDict objectForKey:key] componentsSeparatedByString:@"-"];
            if([arr count]>1){
                value = [NSString stringWithFormat:@"- %@ %@",kRupeeSymbol,[arr objectAtIndex:1]];
                valueColor = UIColorFromRGB(0x33CC99);
            }
            else if([arr count] == 0){
                valueColor = UIColorFromRGB(kCouponSucessColor);

            }
        }else if([[key uppercaseString] isEqualToString:@"SAVINGS"]){
            NSArray *arr = [[currentDict objectForKey:key] componentsSeparatedByString:@"-"];
            if([arr count]>1){
                value = [NSString stringWithFormat:@"- %@ %@",kRupeeSymbol,[arr objectAtIndex:1]];
                valueColor = UIColorFromRGB(0x33CC99);
            }
            else if([arr count] == 0){
                valueColor = UIColorFromRGB(kCouponSucessColor);
                
            }
        }
        CGSize valueSize = [SSUtility getLabelDynamicSize:value withFont:[UIFont variableFontWithName:kMontserrat_Light size:14.0] withSize:CGSizeMake(100, 100)];
        UILabel *valueLabel = [SSUtility generateLabel:value withRect:CGRectMake(scrollView.frame.size.width - valueSize.width - 2 * kHorizontalMargin, heading.frame.origin.y, valueSize.width + kHorizontalMargin, heading.frame.size.height) withFont:[UIFont variableFontWithName:kMontserrat_Light size:14.0]];
        [valueLabel setBackgroundColor:[UIColor clearColor]];
        [valueLabel setTextColor:valueColor];
        [scrollView addSubview:valueLabel];
        oldOItemHeight = heading.frame.origin.y + heading.frame.size.height + itemPadding;
    }
}

#pragma mark - perform actions

-(void)addAddressClicked{
    if([self.paymentDelegate respondsToSelector:@selector(addNewAddress)]){
        [self.paymentDelegate addNewAddress];
    }
}

-(void)changeTimeSlotTapped{
    if([self.paymentDelegate respondsToSelector:@selector(changeTimeSlot)]){
        [self.paymentDelegate changeTimeSlot];
    }
}

-(void)addPaymentOptionClicked{
    if([self.paymentDelegate respondsToSelector:@selector(addPaymentMode)]){
        [self.paymentDelegate addPaymentMode];
    }
}


- (void)applyCoupon{
    if([couponTextField isFirstResponder]){
        [couponTextField resignFirstResponder];
    }
    [applyCouponButton setHidden:true];
    [couponLoader setHidden:false];
    [couponLoader startAnimating];
    
    if(requestHandler == nil){
        requestHandler = [[CartRequestHandler alloc] init];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:couponTextField.text,@"coupon_code", nil];
    [requestHandler applyCoupanCode:dict withCompletionHandler:^(id responseData, NSError *error) {
        
        [self updateCartPaymentSummary:responseData];
        if(self.couponData){
            if(self.couponData.isCoupanValid){
                if(self.paymentDelegate && [self.paymentDelegate respondsToSelector:@selector(couponAppliedSuccessfully:)]){
                    [self.paymentDelegate couponAppliedSuccessfully:self.couponData.coupanStatus];
                }
                isCouponApplied = true;
                [self updateCouponValue];
                [self updateDetailView];

            }else{
                if(!self.couponData.isCoupanValid){
                    if(self.paymentDelegate && [self.paymentDelegate respondsToSelector:@selector(failedToApplyCoupon:)]){
                        [self.paymentDelegate failedToApplyCoupon:self.couponData.coupanStatus];
                    }
                    [self updateCouponValue];
                }
            }
        }else{
            if(self.paymentDelegate && [self.paymentDelegate respondsToSelector:@selector(failedToApplyCoupon:)]){
                NSString *msg = @"Invalid Coupon";
                [self.paymentDelegate failedToApplyCoupon:msg];
            }
        }
    }];
}


-(void)removeCoupon{
    if([couponTextField isFirstResponder]){
        [couponTextField resignFirstResponder];
    }
    [applyCouponButton setHidden:true];
    [couponLoader setHidden:false];
    [couponLoader startAnimating];
    
    if(requestHandler == nil){
        requestHandler = [[CartRequestHandler alloc] init];
    }
    [requestHandler removeCoupanCode:nil withCompletionHandler:^(id responseData, NSError *error) {
        [couponLoader stopAnimating];
        [couponLoader setHidden:TRUE];
        
        [self updateCartPaymentSummary:responseData];
        if(responseData[@"is_removed"] && [responseData[@"is_removed"] boolValue]){
            if(self.paymentDelegate && [self.paymentDelegate respondsToSelector:@selector(couponAppliedSuccessfully:)]){
                [self.paymentDelegate couponAppliedSuccessfully:responseData[@"message"]];
            }
            isCouponApplied = false;
            isCouponRemoved = TRUE;
            [self updateCouponValue];
            [self updateDetailView];
            
        }else{
            if(self.paymentDelegate && [self.paymentDelegate respondsToSelector:@selector(failedToApplyCoupon:)]){
                [self.paymentDelegate failedToApplyCoupon:responseData[@"message"]];
            }
            [self updateCouponValue];
        }
    }];
}


- (void)updateCartPaymentSummary:(NSDictionary *)refreshPaymentDict{
    
    if(self.cartBreakupDetails){
        [self.cartBreakupDetails removeAllObjects];
        self.cartBreakupDetails = nil;
    }
    self.cartBreakupDetails = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *breakUpValues = [refreshPaymentDict objectForKey:@"breakup_values"];
    if(breakUpValues){
        self.cartBreakupDetails = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    for(NSInteger counter=0; counter < [breakUpValues count]; counter++){
        
        NSDictionary *paymentDict = [breakUpValues objectAtIndex:counter];
        NSString *paymentKey = [paymentDict objectForKey:@"key"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[paymentDict objectForKey:@"value"]],paymentKey, nil];
        [self.cartBreakupDetails addObject:dict];
    }
    
    NSDictionary *coupanDetailDict = [refreshPaymentDict objectForKey:@"coupon_details"];
    if(coupanDetailDict){
        self.couponData = [[CoupanDetails alloc] init];
        self.couponData.couponCode = [coupanDetailDict objectForKey:@"coupon_code"];
        self.couponData.isCoupanValid = [[coupanDetailDict objectForKey:@"is_valid"] boolValue];
        self.couponData.isCoupanApplied = [[coupanDetailDict objectForKey:@"is_applied"] boolValue];
        self.couponData.coupanStatus = [coupanDetailDict objectForKey:@"coupon_status"];
    }
}




-(void)updateCouponValue{

    [couponLoader setHidden:true];
    [couponLoader stopAnimating];

    if(couponValueLabel){
        [couponValueLabel removeFromSuperview];
        couponValueLabel = nil;
    }

    if(self.couponTextField.text.length > 0){
        if(isCouponRemoved){
            couponImageView.image = [UIImage imageNamed:@"Coupons"];
            [couponTextField setUserInteractionEnabled:TRUE];
            isCouponRemoved = false;
            [couponTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
            [applyCouponButton setHidden:true];
            couponTextField.text = @"";
            couponButtonString = [[NSAttributedString alloc] initWithString:@"Apply" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)}];
            NSAttributedString *removeTouchState = [[NSAttributedString alloc] initWithString:@"Apply" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor)}];
            
            
            [applyCouponButton removeTarget:self action:@selector(removeCoupon) forControlEvents:UIControlEventTouchUpInside];
            [applyCouponButton addTarget:self action:@selector(applyCoupon) forControlEvents:UIControlEventTouchUpInside];
            [applyCouponButton setAttributedTitle:couponButtonString forState:UIControlStateNormal];
            [applyCouponButton setAttributedTitle:removeTouchState forState:UIControlStateHighlighted];
        }else if(self.couponData){
            if(self.couponData.isCoupanApplied || isCouponApplied){
                couponImageView.image = [UIImage imageNamed:@"CouponValid"];
                couponTextField.text = self.couponData.couponCode;
                [couponTextField setTextColor:UIColorFromRGB(kGreenColor)];
                [applyCouponButton setHidden:false];
                
                couponButtonString = [[NSAttributedString alloc] initWithString:@"Remove" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12], NSForegroundColorAttributeName : UIColorFromRGB(kGenderSelectorTintColor)}];
                
                NSAttributedString *removeTouchState = [[NSAttributedString alloc] initWithString:@"Remove" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:12], NSForegroundColorAttributeName : UIColorFromRGB(kBackgroundGreyColor)}];
                
                [applyCouponButton removeTarget:self action:@selector(applyCoupon) forControlEvents:UIControlEventTouchUpInside];
                [applyCouponButton addTarget:self action:@selector(removeCoupon) forControlEvents:UIControlEventTouchUpInside];
                [applyCouponButton setAttributedTitle:couponButtonString forState:UIControlStateNormal];
                [applyCouponButton setAttributedTitle:removeTouchState forState:UIControlStateHighlighted];
                
                [couponTextField setUserInteractionEnabled:false];
            }else{
                couponImageView.image = [UIImage imageNamed:@"CouponInvalid"];
                [couponTextField setTextColor:UIColorFromRGB(kRedColor)];
                [applyCouponButton setHidden:true];
                couponButtonString = [[NSAttributedString alloc] initWithString:@"Apply" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)}];
                
                NSAttributedString *removeTouchState = [[NSAttributedString alloc] initWithString:@"Apply" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kButtonTouchStateColor)}];

                
                [applyCouponButton removeTarget:self action:@selector(removeCoupon) forControlEvents:UIControlEventTouchUpInside];
                [applyCouponButton addTarget:self action:@selector(applyCoupon) forControlEvents:UIControlEventTouchUpInside];
                [applyCouponButton setAttributedTitle:couponButtonString forState:UIControlStateNormal];
                [applyCouponButton setAttributedTitle:removeTouchState forState:UIControlStateHighlighted];
            }
        }
    }
}


#pragma mark - update UI methods
-(void)updateAddress{
    
    for(UIView *view in [addAddressView subviews]){
        if(view.tag != 10 && view.tag != 193)
            [view removeFromSuperview];
    }
    
    for(UIView *view in [timeSlotContainer subviews]){
        [view removeFromSuperview];
    }
    
    [addAddressView setFrame:CGRectMake(addAddressView.frame.origin.x, addAddressView.frame.origin.y, topViewContainer.frame.size.width/2 - kHorizontalMargin - 0.5, addAddressView.frame.size.height)];
    [hiddenAddressButton setFrame:CGRectMake(-kHorizontalMargin, 0, addAddressView.frame.size.width + kHorizontalMargin + 0.5, addAddressView.frame.size.height)];

    
    NSString *type = [self.defaultShippingAddress.theAddressType uppercaseString];
    NSString *detail = [NSString stringWithFormat:@"%@, %@, %@", self.defaultShippingAddress.theFlatNBuildingName, self.defaultShippingAddress.theStreetName, self.defaultShippingAddress.thePincode];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];

    NSAttributedString *addressTypeString = [[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)}];
    CGRect addrTypeRect = [addressTypeString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width, addAddressView.frame.size.height/2) options:NSStringDrawingUsesFontLeading context:NULL];
    
    addressTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, addrTypeRect.size.width, addrTypeRect.size.height)];
    [addressTypeLabel setCenter:CGPointMake(addAddressView.frame.size.width/2, addAddressView.frame.size.height/4)];
    [addressTypeLabel setAttributedText:addressTypeString];
    [addAddressView addSubview:addressTypeLabel];
    
    NSAttributedString *addressString = [[NSAttributedString alloc] initWithString:detail attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor), NSParagraphStyleAttributeName : paragraphStyle}];
    CGRect addrStringRect = [addressString boundingRectWithSize:CGSizeMake(addAddressView.frame.size.width - 5, addAddressView.frame.size.height/2) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
    
    addressName = [[UILabel alloc] initWithFrame:CGRectMake(0, addAddressView.frame.size.width/2, addrStringRect.size.width, addrStringRect.size.height)];
    [addressName setCenter:CGPointMake(addAddressView.frame.size.width/2, addAddressView.frame.size.height/2 + addAddressView.frame.size.height/4 -4)];
    [addressName setAttributedText:addressString];
    [addAddressView addSubview:addressName];
    [self updateTimeSlot];
}


-(void)updateTimeSlot{
    
    if(timeSlotContainer){
        for(UIView *view in [timeSlotContainer subviews]){
            if(view.tag != 10)
                [view removeFromSuperview];
        }
        [timeSlotContainer removeFromSuperview];
        timeSlotContainer = nil;
    }
    
    timeSlotContainer = [[UIView alloc] initWithFrame:CGRectMake(addAddressView.frame.origin.x + addAddressView.frame.size.width + 0.5, addAddressView.frame.origin.y, topViewContainer.frame.size.width/2 - kHorizontalMargin, addAddressView.frame.size.height)];
    [topViewContainer addSubview:timeSlotContainer];
    
    hiddenTimeSlotButton = [[UIButton alloc] initWithFrame:CGRectMake(-0.5, 0, addAddressView.frame.size.width + kHorizontalMargin + 0.5 , addAddressView.frame.size.height)];
    hiddenTimeSlotButton.tag = 193;
    [hiddenTimeSlotButton setUserInteractionEnabled:YES];
    [timeSlotContainer addSubview:hiddenTimeSlotButton];
    [hiddenTimeSlotButton setBackgroundImage:[SSUtility imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [hiddenTimeSlotButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kBackgroundGreyColor)] forState:UIControlStateHighlighted];
    [hiddenTimeSlotButton addTarget:self action:@selector(changeTimeSlotTapped) forControlEvents:UIControlEventTouchUpInside];

    
    if(self.defaultTimeSlot && self.defaultTimeSlot.aDeliveryTimeArray){

        NSString *header = [self.defaultTimeSlot.aDeliveryDate uppercaseString];
        DeliveryTime *timeMod = (DeliveryTime *)[self.defaultTimeSlot.aDeliveryTimeArray objectAtIndex:0];
        NSString *time = timeMod.deliveryTimeValue;
        
        NSAttributedString *timeHeaderString = [[NSAttributedString alloc] initWithString:header attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kLightGreyColor)}];
        CGRect timeHeaderRect = [timeHeaderString boundingRectWithSize:CGSizeMake(timeSlotContainer.frame.size.width, timeSlotContainer.frame.size.height/2) options:NSStringDrawingUsesFontLeading context:NULL];
        
        timeSlotHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, timeHeaderRect.size.width, timeHeaderRect.size.height)];
        [timeSlotHeader setCenter:CGPointMake(timeSlotContainer.frame.size.width/2, timeSlotContainer.frame.size.height/4)];
        [timeSlotHeader setAttributedText:timeHeaderString];
        [timeSlotContainer addSubview:timeSlotHeader];
        
        NSAttributedString *timeValueString = [[NSAttributedString alloc] initWithString:time attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14.0], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
        CGRect timeValueRect = [timeValueString boundingRectWithSize:CGSizeMake(timeSlotContainer.frame.size.width, timeSlotContainer.frame.size.height/2) options:NSStringDrawingTruncatesLastVisibleLine context:NULL];
        
        timeSlotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeSlotContainer.frame.size.width/2, timeValueRect.size.width, timeValueRect.size.height)];
        [timeSlotLabel setCenter:CGPointMake(timeSlotContainer.frame.size.width/2, timeSlotContainer.frame.size.height/2 + timeSlotContainer.frame.size.height/4-4)];
        [timeSlotLabel setAttributedText:timeValueString];
        [timeSlotLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [timeSlotContainer addSubview:timeSlotLabel];
    
    }else{
        [self showNotTimeSlots];
    }
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(addAddressView.frame.origin.x + addAddressView.frame.size.width, 5, 1, addAddressView.frame.size.height - 10)];
    [divider setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [topViewContainer addSubview:divider];

//    changeTimeSlotGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTimeSlotTapped)];
//    [timeSlotContainer addGestureRecognizer:changeTimeSlotGesture];
}

-(void)showNotTimeSlots{
    NSString *noTimeSlot = @"No Time Slots ";
    CGSize noTimeSlots = [SSUtility getLabelDynamicSize:noTimeSlot withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(MAXFLOAT, 30)];
    
    timeSlotErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeSlotContainer.frame.size.width/2-noTimeSlots.height/2, noTimeSlots.width, noTimeSlots.height)];
    [timeSlotErrorLabel setCenter:CGPointMake(timeSlotContainer.frame.size.width/2, timeSlotContainer.frame.size.height/2)];
    [timeSlotErrorLabel setText:@"No Time Slots"];
    [timeSlotErrorLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
    [timeSlotErrorLabel setTextColor:UIColorFromRGB(kRedColor)];
    [timeSlotContainer addSubview:timeSlotErrorLabel];
}

-(void)updatePaymentMode{
    
    for(UIView *view in [addPaymentOptionView subviews]){
        if(view.tag != 10 && view.tag != 193)
            [view removeFromSuperview];
    }
    
    NSString *imageName;
    NSMutableAttributedString *paymentDetailString = nil;
    CGRect paymentDetailSize = CGRectZero;
    
    NSAttributedString *paymentModeString = nil;
    CGRect paymentModeSize = CGRectZero;
    
    NSString *nameString = nil;
    
    NSString *mode = self.paymentModeDictionary[@"mode"];
    if([[mode uppercaseString] isEqualToString:@"COD"]){
        imageName = @"CashOnDelivery";
        nameString = @"Cash On Delivery";
        
    }else if([[mode uppercaseString] isEqualToString:@"CDOD"]){
        imageName = @"CardDelivery";
        nameString = @"Card On Delivery";
        
    }else if([[mode uppercaseString] isEqualToString:@"CARD"]){
         CardModel *card = self.paymentModeDictionary[@"data"];

        imageName = card.cardImage;
        paymentDetailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•••• %@", [card.cardNumber substringFromIndex:[card.cardNumber length] - 4]] attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:14], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
        [paymentDetailString setAttributes:@{NSFontAttributeName :[UIFont fontWithName:kMontserrat_Regular size:22], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)} range:NSMakeRange(0, 4)];
        
        nameString = card.cardName;

    }else if([[mode uppercaseString] isEqualToString:@"NB"]){
        NetBankingModel *bank = self.paymentModeDictionary[@"data"];
        if ([bank.bankLogo isEqualToString:@""] || bank.bankLogo == nil) {
            imageName = @"NetBanking";
        }else{
            imageName = bank.bankLogo;
        }

        nameString = bank.bankName;
    }else if ([[mode uppercaseString] isEqualToString:@"PT"]){
        imageName = @"Wallet";
        nameString = @"Paytm Wallet";
    }
    
    UIImage *bankImage = nil;
    if (![[mode uppercaseString] isEqualToString:@"NB"]) {
        bankImage = [UIImage imageNamed:imageName];
    }

    UIImageView *bankImageView = nil;

    bankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHorizontalMargin, addPaymentOptionView.frame.size.height/2 - 15, 30, 30)];
    if ([[mode uppercaseString] isEqualToString:@"NB"]) {
        if ([imageName rangeOfString:@"http"].length>0) {
            [bankImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
            [bankImageView setFrame:CGRectMake(kHorizontalMargin,addPaymentOptionView.frame.size.height/2 - 12, 30, 25)];
        }else{
            [bankImageView setImage:[UIImage imageNamed:imageName]];
        }
        
    }else
        bankImageView.image = bankImage;
    [addPaymentOptionView addSubview:bankImageView];
    
    paymentDetailSize = [paymentDetailString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading context:NULL];
    
    UILabel *paymentDetailInfo = [[UILabel alloc] initWithFrame:CGRectMake(addPaymentOptionView.frame.size.width - paymentDetailSize.size.width - 6, addPaymentOptionView.frame.size.height/2 - paymentDetailSize.size.height/2, paymentDetailSize.size.width, paymentDetailSize.size.height)];
    [paymentDetailInfo setAttributedText:paymentDetailString];
    [addPaymentOptionView addSubview:paymentDetailInfo];
    
    paymentModeString = [[NSAttributedString alloc] initWithString:nameString attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kDarkPurpleColor)}];
    paymentModeSize = [paymentModeString boundingRectWithSize:CGSizeMake(paymentDetailInfo.frame.origin.x - (bankImageView.frame.origin.x + bankImageView.frame.size.width + 5), MAXFLOAT) options:NSStringDrawingUsesFontLeading context:NULL];
    
    UILabel *payModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bankImageView.frame.origin.x + bankImageView.frame.size.width + 5, addPaymentOptionView.frame.size.height/2 - paymentModeSize.size.height/2, paymentModeSize.size.width, paymentModeSize.size.height)];
    [payModeLabel setAttributedText:paymentModeString];
    [addPaymentOptionView addSubview:payModeLabel];
}

#pragma mark - error states
-(void)showAddressErrorState{
    
    UIImage *redPlus = [UIImage imageNamed:@"PlusIconRed"];
    [addressPlusImageView setImage:redPlus];
    
    UIImage *image = [UIImage imageNamed:@"AddPaymentOptionError"];
    [addressImageView setImage:image];
    [addressLabel setTextColor:UIColorFromRGB(kRedColor)];
}

-(void)showPaymentErrorState{
    UIImage *redPlus = [UIImage imageNamed:@"PlusIconRed"];
    [paymentPlusImageView setImage:redPlus];
    
    UIImage *image = [UIImage imageNamed:@"AddPaymentOptionError"];
    [paymentImageView setImage:image];
    [paymentLabel setTextColor:UIColorFromRGB(kRedColor)];
}

#pragma mark - textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setViewState:PullableStateOpened animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(finalString.length > 0){
        couponImageView.image = [UIImage imageNamed:@"Coupons"];
        [couponTextField setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [couponValueLabel setHidden:YES];
        [couponLoader setHidden:YES];
        [applyCouponButton setHidden:false];
        
        couponButtonString = [[NSAttributedString alloc] initWithString:@"Apply" attributes:@{NSFontAttributeName : [UIFont variableFontWithName:kMontserrat_Light size:16], NSForegroundColorAttributeName : UIColorFromRGB(kGreenColor)}];
        [applyCouponButton removeTarget:self action:@selector(removeCoupon) forControlEvents:UIControlEventTouchUpInside];
        [applyCouponButton addTarget:self action:@selector(applyCoupon) forControlEvents:UIControlEventTouchUpInside];
        [applyCouponButton setAttributedTitle:couponButtonString forState:UIControlStateNormal];
        
    }else{
        [applyCouponButton setHidden:true];
    }
    
    
    return YES;
}

@end
