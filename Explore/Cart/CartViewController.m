//
//  CartViewController.m
//  Explore
//
//  Created by Pranav on 01/09/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "CartViewController.h"
#import "CartItemCell.h"
#import "CartItem.h"
#import "SSLine.h"
#import "PopOverlayHandler.h"
#import "CartRequestHandler.h"
#import "SSUtility.h"
#import "CartData.h"
#import "TextFieldWithImage.h"
#import "AddFromWishlistViewController.h"
#import "CartRequestHandler.h"

#import "FyndBlankPage.h"
#import "FyndAnalytics.h"
#import "PDPViewController.h"

#import "ShippingAddressListViewController.h"

#import "ShippingAddressDetailViewController.h"

@interface CartViewController () <UITableViewDataSource,UITableViewDelegate,PopOverlayHandlerDelegate>{
//    NSUInteger previousIndex;
    ShippingAddressListViewController   *theAddressListView;
    ShippingAddressDetailViewController *theAddresDetailView;
    
    UIImageView *flashPayIconImage;
    UIImageView *flashPayTextImage;
    UILabel *priceLabel;
    CardAuthenticationViewController *theCardAuthView;
    UINavigationController *CVVNav;
}

@property (nonatomic,strong) UITableView *cartMainTableView;
@property (nonatomic,strong) NSMutableArray *dummyCardData;
@property (nonatomic,strong) NSMutableArray *paymentSummaryData;
@property (nonatomic,strong) PopOverlayHandler  *cartOverlayHandler;
@property (nonatomic,strong) CartData           *cartData;
@property (nonatomic,strong) TextFieldWithImage   *couponCodeTextField;
@property (nonatomic,strong) UIButton               *applyCouponButton;
@property (nonatomic,strong) UILabel                *appliedCouponValue;
@property (nonatomic,strong) UILabel                *couponStatusMessage;
@property (nonatomic,strong) UIButton               *cancelCouponButton;
@property (nonatomic,strong) CartRequestHandler     *cartHandler;
@property (nonatomic,assign) NSInteger              currentOperatedCartItem;
@property (nonatomic,assign) NSInteger              couponCellHeight;
@property (nonatomic,strong) UIImageView            *couponImage;
@property (nonatomic,strong) FyndBlankPage          *fyndBlankPage;
@property (nonatomic,strong) NSMutableDictionary    *cartItemFyndAFitData;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,assign) BOOL                   clickOnAplyBtn;
@property (nonatomic,assign) BOOL                   clickOnRemoveBtn;
@property (nonatomic,strong) UIView                 *addCartInfoView;
@property (nonatomic,assign) BOOL                   itemAddedFormWishlist;

@property (nonatomic,strong) NSMutableArray *cartItemCellsArray;


//for time slot
@property (nonatomic,strong) UIPickerView *theTimePicker;
@property (nonatomic,strong) NSMutableArray *timeSlotsArray;
@property (nonatomic,strong) NSMutableArray *daySlotsArray;
//@property (nonatomic,copy)   NSString *slotID;
//@property (nonatomic, strong) NSString *slotDay;
//@property (nonatomic, strong) NSString *slotTime;




- (void)intializeLayout;
//- (void)generateCardData;
- (void)fetchCartItemAvailableSizes:(CartItem *)catItem;
- (void)deleteCardItem:(CartItem *)currentItem;
- (void)editCartItemsSizes:(NSMutableArray *)sizeData;
- (void)getCartItems:(NSDictionary *)params;
@end

@implementation CartViewController
@synthesize paymentSummaryView;
CGFloat placeOrderBtnHeight = 50.0f;
CGFloat couponImageHeight = 40.0f;
CGPoint animationEndPoint;
#define cart_y_padding 10
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withColor:UIColorFromRGB(kDarkPurpleColor)];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    screenType = CartScreenNavigationFromRoot;
    self.itemAddedFormWishlist = FALSE;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:TRUE];
    if(screenType == CartScreenNavigationFromAddressTime){
        if(self.itemAddedFormWishlist){
            [self.cartMainTableView setContentOffset:CGPointZero animated:YES];
            [self generateAddCartInfoView:@"1 item has been added in your cart."];
        }
        screenType = CartScreenNavigationFromRoot;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    self.clickOnAplyBtn = FALSE;
    if(self.fyndBlankPage){
        [self.fyndBlankPage removeFromSuperview];
        self.fyndBlankPage = nil;
    }
    
    [self.navigationController.navigationBar changeNavigationBarToTransparent:FALSE];
    
    if(screenType == CartScreenNavigationFromPayment){
        screenType = CartScreenNavigationFromRoot;
        NSDictionary *paramDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"false", @"validate", nil];
        [self getCartItems:paramDictionary];
        
    }else if(screenType == CartScreenNavigationFromPaymentMode || screenType == CartScreenNavigationFromAddress){
        screenType = CartScreenNavigationFromRoot;
        
    }else if(screenType == CartScreenNavigationFromAddressTime){
        NSMutableIndexSet *indexsetToUpdate = [[NSMutableIndexSet alloc]init];
        for(NSInteger counter=0; counter < [self.cartData.cartItems count]; counter++){
            
            if([[self.cartData.cartItems objectAtIndex:counter] highlighted])
                [indexsetToUpdate addIndex:counter];
            
        }
        [self.cartMainTableView reloadSections:indexsetToUpdate withRowAnimation:UITableViewRowAnimationAutomatic];
        screenType = CartScreenNavigationFromRoot;
    }
    else{
        if(cartLoader){
            [cartLoader removeFromSuperview];
            cartLoader = nil;
        }
        cartLoader = [[FyndActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [cartLoader setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 30)];
        
        [self getCartItems:nil];
    }
    [self.cartMainTableView setContentOffset:CGPointZero animated:YES];
}


- (void)getCartItems:(NSDictionary *)params{

    [self clearView];
    
    self.cartHandler = [[CartRequestHandler alloc] init];
    [self.cartHandler getCartItems:params withCompletionHandler:^(id responseData, NSError *error) {
    [SSUtility removeBranchStoredData];
        if(!error){
            self.cartData = [[CartData alloc] initWithDictionary:responseData];
            [cartLoader stopAnimating];
            [cartLoader removeFromSuperview];
            
            NSString *errorMessage = responseData[@"message"];
            if(!self.cartData.isValid && errorMessage && errorMessage.length > 0){
                [SSUtility showOverlayViewWithMessage:errorMessage andColor:UIColorFromRGB(kRedColor)];
            }
            if(self.cartData.cartItems && [self.cartData.cartItems count]>0){
                
                int totalCartCount = (int)[self.cartData.cartItems count];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalCartCount] forKey:kHasItemInBag];
                [self intializeLayout];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kHasItemInBag];
                [self displayBlankPage:ErroNoCartItem];
            }
        }else{
            [self displayBlankPage:ErrorSystemDown];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag]) {
        //Increment the counter and change the icon
        int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
        
        UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];

        if (totalBagItems>0) {
            [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartFilledSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [cartBarItem setImage:[[UIImage imageNamed:@"CartFilledTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }else{
            [cartBarItem setSelectedImage:[[UIImage imageNamed:@"CartSelectedTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [cartBarItem setImage:[[UIImage imageNamed:@"CartTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
       }
        
    }];
    
}


-(void)clearView{
    if(self.cartMainTableView){
        [self.cartMainTableView removeFromSuperview];
        self.cartMainTableView = nil;
    }
    
    if(paymentSummaryView){
        if(isObserverAdded){
            @try {
                [paymentSummaryView removeObserver:self forKeyPath:@"center"];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                isObserverAdded = false;
            }
        }
        
        [paymentSummaryView removeFromSuperview];
        paymentSummaryView = nil;
    }
    
    if(overlayView){
        [overlayView removeFromSuperview];
        overlayView = nil;
    }
    
    if(payButton){
        [payButton removeFromSuperview];
        payButton = nil;
    }
    
    if(payButtonContainer){
        [payButtonContainer removeFromSuperview];
        payButtonContainer = nil;
    }
    
    [self.view addSubview:cartLoader];
    [cartLoader startAnimating];
    
}


- (void)intializeLayout{
//    self.cartMainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height+3)];
//    self.cartMainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-100)];
    self.cartMainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-RelativeSize(90, 375))];

    //RelativeSize(6, 320)
    self.cartMainTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cartMainTableView.delegate = self;
    self.cartMainTableView.exclusiveTouch = TRUE;
    if(self.tapGesture){
        self.tapGesture = nil;
    }

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGesture.enabled = FALSE;
    self.cartMainTableView.showsVerticalScrollIndicator = NO;
    [self.cartMainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cartMainTableView.bounds.size.width,8)];
    [tableHeaderView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    self.cartMainTableView.tableHeaderView = tableHeaderView;
    
    [self.cartMainTableView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self.view addSubview:self.cartMainTableView];
    
    CGFloat tempHeightVar = RelativeSizeHeight(500, 667); //90
    
    paymentSummaryView = [[PaymentSummaryView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - RelativeSize(95, 375) - self.tabBarController.tabBar.frame.size.height, self.view.frame.size.width, tempHeightVar)];
    paymentSummaryView.delegate = self;
    paymentSummaryView.paymentDelegate = self;
    paymentSummaryView.buttonHeight = RelativeSize(65, 375);
    paymentSummaryView.cartBreakupDetails = self.cartData.cartBreakUpValues;
    paymentSummaryView.couponData = self.cartData.coupanDetails;
    [paymentSummaryView drawUIComponents];
    paymentSummaryView.isAnchoringEnabled = true;
    
    //    paymentSummaryView.openedCenter = CGPointMake(paymentSummarxyView.center.x, self.tabBarController.tabBar.frame.origin.y - paymentSummaryView.frame.size.height);
    paymentSummaryView.openedCenter = CGPointMake(paymentSummaryView.center.x, self.tabBarController.tabBar.frame.origin.y - paymentSummaryView.frame.size.height/2);
    //    paymentSummaryView.anchoredCenter = CGPointMake(paymentSummaryView.center.x, paymentSummaryView.openedCenter.y + paymentSummaryView.anchoredCenter.y);
    
    CGFloat relativeAdjustment = RelativeSizeHeight(-2, 568);
    
    if(kDeviceHeight < 568){
        relativeAdjustment =  12*relativeAdjustment;
    }else if (kDeviceHeight > 568){
        relativeAdjustment = RelativeSizeHeight(20, 667);
    }

    paymentSummaryView.anchoredCenter = CGPointMake(paymentSummaryView.center.x, paymentSummaryView.openedCenter.y + paymentSummaryView.frame.size.height/2 + (paymentSummaryView.viewDetailBottom - paymentSummaryView.frame.size.height/2) - RelativeSizeHeight(65, 667) + relativeAdjustment);
    //Setting the PaymentSummaryView default as pullableState.
    
    
    paymentSummaryView.closedCenter = paymentSummaryView.center;
    slidingRange = fabs(paymentSummaryView.closedCenter.y - paymentSummaryView.openedCenter.y);
    [self.view addSubview:paymentSummaryView];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstTimeBagView = [[userDefaults objectForKey:@"isFirstTimeBagView"] boolValue];

    if(!isFirstTimeBagView){
        [paymentSummaryView setViewState:PullableStateHalfOpened animated:FALSE];
        [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"isFirstTimeBagView"];
    }
    
    
    if(overlayView){
        [overlayView removeFromSuperview];
        overlayView = nil;
    }
    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paymentSummaryView.frame.size.width, paymentSummaryView.frame.origin.y)];
    [overlayView setBackgroundColor:[UIColor blackColor]];
    overlayView.hidden = true;
    overlayView.alpha = 0.0f;
    [self.view addSubview:overlayView];
    overlayMaxAlpha = 0.6f;
    
    tapGestureToCloseDetailView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapGesture:)];
    [overlayView addGestureRecognizer:tapGestureToCloseDetailView];
    
    
    if(self.cartData.defaultPaymentOption){
        paymentSummaryView.paymentModeDictionary = self.cartData.defaultPaymentOption;
        [paymentSummaryView updatePaymentMode];
    }
    
    if([self.cartData.timeSlotsArray count] > 0){
        paymentSummaryView.defaultTimeSlot = [self.cartData.timeSlotsArray objectAtIndex:0];
    }
    
    if(self.cartData.defaultAddress){
        paymentSummaryView.defaultShippingAddress = self.cartData.defaultAddress;
        [paymentSummaryView updateAddress];
    }
    
    
//    UIView *payButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 65 - 49, self.view.frame.size.width, 65)];
    payButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - paymentSummaryView.buttonHeight - 49, self.view.frame.size.width, paymentSummaryView.buttonHeight)];
    
    [payButtonContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:payButtonContainer];
    
//    NSMutableAttributedString *payButtonString = [[NSMutableAttributedString alloc] initWithString:@"QUICK PAY" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];

//    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
//                                        @{
//                                          @"NSFontFamilyAttribute" : @"Montserrat",
//                                          @"NSFontFaceAttribute" :  @"Italic"
//                                          }];
    
    
    
//    NSMutableAttributedString *payButtonString = [[NSMutableAttributedString alloc] initWithString:@"QUICK PAY" attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    NSMutableAttributedString *payButtonString = [[NSMutableAttributedString alloc] initWithString:@"QUICK PAY" attributes:@{NSFontAttributeName : [UIFont fontWithDescriptor:fontDescriptor size:16.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];

    payButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, payButtonContainer.frame.size.width - 2 * 6, payButtonContainer.frame.size.height - 2 * 6)];
    [payButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF89B59)] forState:UIControlStateNormal];
    [payButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0XFBA86C)] forState:UIControlStateHighlighted];
//    [payButton setAttributedTitle:payButtonString forState:UIControlStateNormal];
    payButton.layer.cornerRadius = 3.0;
    payButton.clipsToBounds = YES;
    [payButtonContainer addSubview:payButton];
    [payButton addTarget:self action:@selector(startPaymentProcess) forControlEvents:UIControlEventTouchUpInside];

    
    //Adding OverlayView
    
    payOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, payButton.frame.size.height)];
    [payOverlayView setBackgroundColor:[UIColor clearColor]];
    [payOverlayView setUserInteractionEnabled:FALSE];
    flashPayIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, payButton.frame.size.height/2 - 13, 26, 26)];
    [flashPayIconImage setBackgroundColor:[UIColor clearColor]];
    [flashPayIconImage setImage:[UIImage imageNamed:@"FlashPayLogo"]];
    
    
    flashPayTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(flashPayIconImage.frame.origin.x + flashPayIconImage.frame.size.width + 5, flashPayIconImage.frame.origin.y, 96, 26)];
    [flashPayTextImage setBackgroundColor:[UIColor clearColor]];
    [flashPayTextImage setImage:[UIImage imageNamed:@"FlashpayText"]];
    
    [payOverlayView addSubview:flashPayIconImage];
    [payOverlayView addSubview:flashPayTextImage];
    

//    NSMutableAttributedString *ruppeeSymbol = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",kRupeeSymbol] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:14.0f]}];
//
//        NSAttributedString *priceValue = [[NSAttributedString alloc] initWithString:[[self.cartData.cartBreakUpValues lastObject] valueForKey:@"Total"] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:16.0f]}];
//
//    [ruppeeSymbol appendAttributedString:priceValue];
//    
//    CGSize priceSize = [SSUtility getLabelDynamicSize:[ruppeeSymbol string] withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(MAXFLOAT, 35)];
//    
//    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(flashPayTextImage.frame.origin.x + flashPayTextImage.frame.size.width + 20, payButton.frame.size.height/2 - ceilf(priceSize.height/2), priceSize.width, priceSize.height)];
//    [priceLabel setAttributedText:ruppeeSymbol];
//    [priceLabel setTextColor:[UIColor whiteColor]];
//    [payOverlayView addSubview:priceLabel];
//    
//    [payOverlayView setFrame:CGRectMake(0, 0, priceLabel.frame.origin.x + priceLabel.frame.size.width, payOverlayView.frame.size.height)];
//
//    payOverlayView.center = payButton.center;
//    [payButtonContainer addSubview:payOverlayView];
    
    
    [self setTotalOnButton:[[self.cartData.cartBreakUpValues lastObject] valueForKey:@"Total"]];
    
    [payButtonContainer addSubview:payOverlayView];

    
    if(!isObserverAdded){
        [paymentSummaryView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionOld context:NULL];
        isObserverAdded = true;
    }

}


-(void)setTotalOnButton:(NSString *)totalCost{
    
    NSMutableAttributedString *ruppeeSymbol = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",kRupeeSymbol] attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:14.0f]}];
    
    NSAttributedString *priceValue = [[NSAttributedString alloc] initWithString:totalCost attributes:@{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Regular size:16.0f]}];
    
    [ruppeeSymbol appendAttributedString:priceValue];
    
    CGSize priceSize = [SSUtility getLabelDynamicSize:[ruppeeSymbol string] withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(MAXFLOAT, 35)];
    
    if(priceLabel){
        [priceLabel removeFromSuperview];
        priceLabel = nil;
    }
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(flashPayTextImage.frame.origin.x + flashPayTextImage.frame.size.width + 20, payButton.frame.size.height/2 - ceilf(priceSize.height/2), priceSize.width, priceSize.height)];
    [priceLabel setAttributedText:ruppeeSymbol];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [payOverlayView addSubview:priceLabel];
    
    [payOverlayView setFrame:CGRectMake(0, 0, priceLabel.frame.origin.x + priceLabel.frame.size.width, payOverlayView.frame.size.height)];
   
    payOverlayView.center = payButton.center;

}



-(void)closeTapGesture:(id)sender{
    [paymentSummaryView setViewState:PullableStateClosed animated:YES];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"center"]){
        
        CGFloat currentDiff = fabs(paymentSummaryView.center.y - paymentSummaryView.closedCenter.y);

        [overlayView setFrame:CGRectMake(overlayView.frame.origin.x, 0, overlayView.frame.size.width, paymentSummaryView.frame.origin.y)];

        if(currentDiff <= slidingRange){
            overlayView.hidden = false;
//            [overlayView setFrame:CGRectMake(overlayView.frame.origin.x, 0, overlayView.frame.size.width, paymentSummaryView.frame.origin.y)];
            [self setOverlayAlpha:(CGFloat)currentDiff];
            
        }else{
//            [overlayView setFrame:CGRectMake(overlayView.frame.origin.x, 0, overlayView.frame.size.width, paymentSummaryView.frame.origin.y)];
            overlayView.hidden = true;
            overlayView.alpha = 0.0f;
        }
        paymentSummaryView.indicatorImageView.image = paymentSummaryView.indicatorBarImage;
    }
}



-(void)setOverlayAlpha:(CGFloat)diff{
    CGFloat singleStepAlpha = overlayMaxAlpha/slidingRange;
    CGFloat alpha = singleStepAlpha * diff;
    overlayView.alpha = alpha;
}


-(void)startPaymentProcess{
    
    if(!self.cartData.defaultAddress){
        [paymentSummaryView showAddressErrorState];
        [SSUtility showOverlayViewWithMessage:@"Please add an address" andColor:UIColorFromRGB(kRedColor)];
        
        if(paymentSummaryView.state == PullableStateClosed){
            [paymentSummaryView setViewState:PullableStateHalfOpened animated:YES];
        }
        
    }else if(!self.cartData.defaultPaymentOption){
        [paymentSummaryView showPaymentErrorState];
        [SSUtility showOverlayViewWithMessage:@"Please add payment option" andColor:UIColorFromRGB(kRedColor)];

        
        if(paymentSummaryView.state == PullableStateClosed){
            [paymentSummaryView setViewState:PullableStateHalfOpened animated:YES];
        }
        
    }else if(!self.cartData.timeSlotsArray){
        if(paymentSummaryView.state == PullableStateClosed){
            [paymentSummaryView setViewState:PullableStateHalfOpened animated:YES];
        }
        
    }else{
        //    if(self.cartData.defaultAddress && self.cartData.timeSlotsArray && self.cartData.defaultPaymentOption){
        [self.view addSubview:cartLoader];
        [cartLoader startAnimating];
        
        NSMutableDictionary *omsParamDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        [omsParamDictionary setObject:self.cartData.orderId forKey:@"order_id"];
        
        NSString *paymentMode = [[self.cartData.defaultPaymentOption objectForKey:@"mode"] uppercaseString];
        
        if([[paymentMode uppercaseString] isEqualToString:@"COD"]){
            [omsParamDictionary setObject:@"COD" forKey:@"payment_mode"];
            
        }else if([[paymentMode uppercaseString] isEqualToString:@"CDOD"]){
            [omsParamDictionary setObject:@"CDOD" forKey:@"payment_mode"];
            
        }else if([[paymentMode uppercaseString] isEqualToString:@"NB"]){
            NetBankingModel *bank = (NetBankingModel *)self.cartData.defaultPaymentOption[@"data"];
            
            [omsParamDictionary setObject:@"NB" forKey:@"payment_mode"];
            [omsParamDictionary setObject:bank.bankCode forKey:@"payment_identifier"];
            
        }else if([[paymentMode uppercaseString] isEqualToString:@"CARD"]){
            [omsParamDictionary setObject:@"CARD" forKey:@"payment_mode"];
            
            CardModel *card = self.cartData.defaultPaymentOption[@"data"];
            [omsParamDictionary setObject:[NSString stringWithFormat:@"%@",card.cardId] forKey:@"payment_identifier"];
        }
        
        DeliveryTimeSlotModel *slot = paymentSummaryView.defaultTimeSlot;
        DeliveryTime *time = [slot.aDeliveryTimeArray objectAtIndex:0];
        [omsParamDictionary setObject:[NSString stringWithFormat:@"%@",time.deliveryTimeId] forKey:@"delivery_slot_id"];
        [omsParamDictionary setObject:[NSString stringWithFormat:@"%@", self.cartData.defaultAddress.theAddressID] forKey:@"address_id"];
        
        [self.cartHandler cartCheckoutWithParams:omsParamDictionary withCompletionHandler:^(id responseData, NSError *error) {
            [cartLoader removeFromSuperview];
            [cartLoader stopAnimating];
            if(responseData){
                BOOL success = [responseData[@"is_valid"] boolValue];
                if(success){
                    
                    NSDictionary *datDictionary = responseData[@"data"];
                    NSString *paymentMode = [datDictionary[@"payment_mode"] uppercaseString];
                    self.orderId = datDictionary[@"order_id"];
                    [self sendCheckoutEvent];
                    if([paymentMode isEqualToString:@"CDOD"] || [paymentMode isEqualToString:@"COD"]){
                        
                        //TODO: go to feed with order card
//                        if(self.paymentOverlay == nil)
//                            self.paymentOverlay = [[PopOverlayHandler alloc] init];
//                        
//                        self.paymentOverlay.overlayDelegate = self;
//                        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//                        [parameters setObject:@"Thank You" forKey:@"Alert Title"];
//                        [parameters setObject:@"OK" forKey:@"RightButtonTitle"];
//                        [parameters setObject:[NSNumber numberWithInt:CustomAlertPayment] forKey:@"PopUpType"];
//                        [parameters setObject:@"Your order has been placed successfully" forKey:@"Alert Message"];
//                        [self.paymentOverlay presentOverlay:CustomAlertPayment rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
                        [self sendPaymentEvent:TRUE];
                        [self navigateToFeedPage];
                    }else if ([paymentMode isEqualToString:@"NB"]){
//                        screenType = CartScreenNavigationFromPayment;
                        [self fetchWebViewParams:responseData[@"data"]];
                        
                    }else if([paymentMode isEqualToString:@"CARD"]){
                        
                        screenType = CartScreenNavigationFromPaymentMode;

                        CardModel *card = self.cartData.defaultPaymentOption[@"data"];
                        theCardAuthView = [[CardAuthenticationViewController alloc] init];
                        theCardAuthView.delegate = self;
                        theCardAuthView.responseDictionary = datDictionary;
                        [theCardAuthView configureCardAuthenticationViewWithCardModel:card];
                        
                        CVVNav = [[UINavigationController alloc] initWithRootViewController:theCardAuthView];
                        [self.navigationController presentViewController:CVVNav animated:TRUE completion:nil];
//                        [self.navigationController pushViewController:theCardAuthView animated:TRUE];
                    }
                }else{
                    
                    CartData *cartData =[[CartData alloc] initWithDictionary:responseData];
                    
                    NSString *errorMessage = responseData[@"message"];
                    if(!self.cartData.isValid && errorMessage && errorMessage.length > 0){
                        [SSUtility showOverlayViewWithMessage:errorMessage andColor:UIColorFromRGB(kRedColor)];
                    }
                    
                    if(cartData){
                        if([cartData.cartItems count] > 0){
                            previousState = PullableStateClosed;
                            [self updateWithNewCartData:cartData];
                            [SSUtility showOverlayViewWithMessage:@"Some items in your cart are not deliverable" andColor:UIColorFromRGB(kRedColor)];
                        }else{
                            [self clearView];
                            [cartLoader stopAnimating];
                            [cartLoader removeFromSuperview];
                            
                            if(self.cartMainTableView){
                                [self.cartMainTableView removeFromSuperview];
                                self.cartMainTableView.dataSource = nil;
                                self.cartMainTableView.delegate = nil;
                            }
                            [self displayBlankPage:ErroNoCartItem];
                        }
                    }
                }
            }
        }];
    }
}


-(void)fetchWebViewParams:(NSDictionary *)dictionary{
    [self.view addSubview:cartLoader];
    [cartLoader startAnimating];
    NSString *orderId = dictionary[@"order_id"];
    
    NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc] init];
    
    [paramDictionary setObject:orderId forKey:@"order_id"];
    [paramDictionary setObject:@"devops_fynd" forKey:@"merchant_id"];
    [paramDictionary setObject:@"NB" forKey:@"payment_method_type"];
    [paramDictionary setObject:dictionary[@"bank_code"] forKey:@"payment_method"];
    [paramDictionary setObject:@"true" forKey:@"redirect_after_payment"];
    [paramDictionary setObject:@"json" forKey:@"format"];
    
    PaymentCartRequestHandler *paymentRequestHandler = [[PaymentCartRequestHandler alloc] init];
    
    [paymentRequestHandler fetchTransactionParamsFromJustPay:paramDictionary withCompletionHandler:^(id responseData, NSError *error) {
        [cartLoader removeFromSuperview];
        [cartLoader stopAnimating];
        if(responseData){
            NSDictionary *paymentDictionary = responseData[@"payment"];
            if(paymentDictionary){
                NSDictionary *authenticationDictioanry = paymentDictionary[@"authentication"];
                
                if(authenticationDictioanry){
                    NSString *urlString = authenticationDictioanry[@"url"];
                    NSString *method = authenticationDictioanry[@"method"];
                    NSDictionary *params = authenticationDictioanry[@"params"];
                    paymentWebViewController = [[PaymentWebViewController alloc] init];
                    paymentWebViewController.paymentWebDelegate = self;
                    paymentWebViewController.urlString = urlString;
                    paymentWebViewController.method = method;
                    paymentWebViewController.params = params;
                    [self.navigationController pushViewController:paymentWebViewController animated:YES];
                    screenType = CartScreenNavigationFromPayment;
                }
            }
        }
    }];
}


- (void)navigateToCart{
    UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:4];
    [navController popToRootViewControllerAnimated:TRUE];
    TabBarViewController *theTabBar = (TabBarViewController *)self.tabBarController;
    [theTabBar setSelectedIndex:4];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)navigateToFeedPage{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kHasItemInBag];
    UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];
    [cartBarItem setSelectedImage:[UIImage imageNamed:@"CartSelectedTab"]];
    [cartBarItem setImage:[UIImage imageNamed:@"CartTab"]];
    
    
    UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:0];
    [navController popToRootViewControllerAnimated:NO];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
   
    if([[[navController viewControllers] objectAtIndex:0] isKindOfClass:[FeedViewController class]]){
        FeedViewController *feedController = [[(UINavigationController *)navController viewControllers] objectAtIndex:0];
        
        [feedController getNewFeedDataWithOrderID:self.orderId];
    }
    TabBarViewController *theTabBar = (TabBarViewController *)self.tabBarController;
    [theTabBar setIsLoadingOrderID:TRUE];
    [theTabBar setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}



#pragma mark - PullableViewDelegate

-(void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened{
    
    if(opened){
        
    }
}

-(void)pullableView:(PullableView *)pView multiStateChange:(PullableState)state{
    if([paymentSummaryView.couponTextField isFirstResponder] && paymentSummaryView.state != PullableStateOpened){
        [paymentSummaryView.couponTextField resignFirstResponder];
    }
    
    switch (state) {
        case PullableStateOpened:
            paymentSummaryView.indicatorImageView.image = paymentSummaryView.indicatorUpArrowImage;
            paymentSummaryView.indicatorImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
            break;

        case PullableStateHalfOpened:
            paymentSummaryView.indicatorImageView.image = paymentSummaryView.indicatorBarImage;
            paymentSummaryView.indicatorImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            break;

        case PullableStateClosed:
            paymentSummaryView.indicatorImageView.image = paymentSummaryView.indicatorUpArrowImage;
            paymentSummaryView.indicatorImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            break;

        default:
            break;
    }
}


#pragma mark - paymanetSummary delegate


-(void)addNewAddress{

    previousState= paymentSummaryView.state;
    screenType = CartScreenNavigationFromAddress;
    if (paymentSummaryView.defaultShippingAddress) {
    
        if (theAddressListView) {
            theAddressListView = nil;
        }
        theAddressListView = [[ShippingAddressListViewController alloc] init];
        theAddressListView.delegate = self;
        theAddressListView.theShippingEnum = ShippingAddressCart;
        [self.navigationController pushViewController:theAddressListView animated:TRUE];
    }else{
        if (theAddresDetailView) {
            theAddresDetailView = nil;
        }
        theAddresDetailView = [[ShippingAddressDetailViewController alloc] init];
        [theAddresDetailView configureDetailScreenWithData:nil];
        theAddresDetailView.isComingFromCart = TRUE;
        theAddresDetailView.delegate = self;
        [self.navigationController pushViewController:theAddresDetailView animated:TRUE];
    }
}


-(void)newAddressAdded:(CartData *)data{
    [self updateWithNewCartData:data];
}

-(void)newAddressSelected:(CartData *)data{
    [self updateWithNewCartData:data];
}



-(void)updateWithNewCartData:(CartData *)data{
    self.cartData = data;
    [self clearView];
    [self intializeLayout];
    [paymentSummaryView setViewState:previousState animated:NO];
}


-(void)changeTimeSlot{
    
    //TODO : show picker
    [self populateTimeSlotsArray];
    [self changeTime];
    
    [paymentSummaryView updateTimeSlot];
}

-(void)addPaymentMode{
    
    screenType = CartScreenNavigationFromPaymentMode;
    if(paymentController){
        paymentController.thePaymentDelegate = nil;
        paymentController = nil;
    }
    paymentController = [[PaymentController alloc] init];
    paymentController.parsedPaymentOptions = self.cartData.parsedPaymentModes;
    paymentController.cardList = self.cartData.cardList;
    paymentController.paymentMode = PaymentScreenTypeCart;
    paymentController.thePaymentDelegate = self;
    [self.navigationController pushViewController:paymentController animated:YES];
}

-(void)couponAppliedSuccessfully:(NSString *)message{
    
    if (self.cartData.cartBreakUpValues) {
        [self.cartData.cartBreakUpValues removeAllObjects];
        self.cartData.cartBreakUpValues = paymentSummaryView.cartBreakupDetails;
    }
    [self generateAddCartInfoView:message];
    [self setTotalOnButton:[paymentSummaryView.cartBreakupDetails lastObject][@"Total"]];
}



-(void)failedToApplyCoupon:(NSString *)message{
    [SSUtility showOverlayViewWithMessage:message andColor:UIColorFromRGB(kRedColor)];
}


#pragma mark -


- (void)displayBlankPage:(ErrorBlankImage)pageType{
    if(self.fyndBlankPage){
        [self.fyndBlankPage removeFromSuperview];
        self.fyndBlankPage = nil;
    }
    self.fyndBlankPage = [[FyndBlankPage alloc] initWithFrame:CGRectMake(10, cart_y_padding, self.view.frame.size.width-20, kDeviceHeight - (cart_y_padding +64 + 44+10)) blankPageType:pageType];
    __weak CartViewController *controller = self;
    self.fyndBlankPage.blankPageBlock=^(){
        if(pageType == ErroNoCartItem){
            [controller.tabBarController setSelectedIndex:0];
        }
        else if(pageType == ErrorSystemDown){
            [controller tapOnRetry];
        }
    };
    [self.view addSubview:self.fyndBlankPage];
}


- (void)tapOnRetry{
    if(self.fyndBlankPage){
        [self.fyndBlankPage removeFromSuperview];
        self.fyndBlankPage = nil;
    }
    [self getCartItems:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)paymentSummaryCellHeight:(NSArray *)array{
    CGFloat height = 0.0f;
    
    NSDictionary *dict = [array objectAtIndex:0];
    CGSize aSize = [SSUtility getLabelDynamicSize:[[dict allKeys] objectAtIndex:0] withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(300, MAXFLOAT)];
    aSize.height = 30.0f;
//    height += [array count]*aSize.height + (([array count] +2) * 5) + placeOrderBtnHeight + 50;
    height += [array count]*aSize.height + (([array count] +2) * 5) + placeOrderBtnHeight + RelativeSizeHeight(30, kDeviceHeight);
    return height;
}


- (CGFloat)calculateCouponCodeCellHeight{
    CGFloat height = 0.0f;
    if(self.cartData.coupanDetails.isCoupanApplied == FALSE && self.cartData.coupanDetails.isCoupanValid == FALSE)
    {
        height += couponImageHeight + 2*cart_y_padding;
    }else{
        CGSize messageSize = [SSUtility getLabelDynamicSize:self.cartData.coupanDetails.coupanStatus withFont:[UIFont fontWithName:kMontserrat_Light size:12.0f] withSize:CGSizeMake(self.cartMainTableView.frame.size.width - (8*cart_y_padding), MAXFLOAT)];
        height += couponImageHeight+ messageSize.height + 2*cart_y_padding;
    }
    
    self.couponCellHeight = height;
    return height;
}

#pragma mark UITableView Methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.cartData.cartItems count]+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0f;
    if(indexPath.section <=[self.cartData.cartItems count]-1){
        CartItem *item = [self.cartData.cartItems objectAtIndex:indexPath.section];
        cellHeight = [self getCartItemAspectRatio:item.productImageAspectRatio andWidth:70.0f];
        cellHeight +=10;
    }
    else if(indexPath.section ==  [self.cartData.cartItems count]){
        cellHeight = 50.0f;
    }
    else if(indexPath.section ==  [self.cartData.cartItems count]+1){
        if(indexPath.row == 0)
            cellHeight = [self calculateCouponCodeCellHeight];
        else if(indexPath.row == 1)
            cellHeight = [self paymentSummaryCellHeight:self.cartData.cartBreakUpValues];
    }
    
    return cellHeight;
    
}


- (CGFloat)getCartItemAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue]-10;
    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount = 0;
    if(section ==[self.cartData.cartItems count]+1){
//        rowCount = 2;
        rowCount = 1;

    }else{
        rowCount = 1;
    }
    return rowCount;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 8)];
    [footerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = nil;
    UITableViewCell *cell= nil;
    if(indexPath.section <= [self.cartData.cartItems count]-1){

        {
            cellIdentifier = @"CartItemIdentifier";
            CartItemCell *cartCell = (CartItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            __weak CartViewController *cartController = self;
            if(cartCell == nil){
                cartCell = [[CartItemCell alloc] init];
                if (self.cartItemCellsArray == nil) {
                    self.cartItemCellsArray = [[NSMutableArray alloc] init];
                }

            }
            cartCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cartCell.cartCellData = [self.cartData.cartItems objectAtIndex:indexPath.section];
            [cartCell configureItemLayout];
            cartCell.tag= indexPath.section;
            cartCell.cardEdit= ^(CartItem *editCartItem){
                self.currentOperatedCartItem = [self.cartData.cartItems indexOfObject:editCartItem];
                [cartController fetchCartItemAvailableSizes:editCartItem];
            };
            cartCell.cardDelete= ^(CartItem *item){
                [cartController deleteCardItem:item];
            };
            cartCell.cartItemPDP=^(NSString *actionUrl){
                PDPViewController *pdpController = [[PDPViewController alloc] init];
                pdpController.productURL = actionUrl;
                [self.navigationController pushViewController:pdpController animated:TRUE];
            };
            cartCell.theSwipeBlock = ^(UIPanGestureRecognizer *thePan, id cell){
              
                [self manageSwipeWithGesture:thePan andCell:cell];
            };
            [self.cartItemCellsArray addObject:cartCell];
            cell = (UITableViewCell *)cartCell;
        }
    }
    else if(indexPath.section == [self.cartData.cartItems count]){
        
        
        cellIdentifier = @"WishItemIdentifier";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *wishCellView = [self addWishListCellView];
        [cell setBackgroundColor:[UIColor clearColor]];
//        cell.layer.cornerRadius =  5.0f;
        [cell.contentView addSubview:wishCellView];
    }
//    else if(indexPath.section == [self.cartData.cartItems count]+1){
//        
//        if(indexPath.row ==0){
//            cellIdentifier = @"CouponCodeCell";
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            UIView *couponCodeCellView = [self generateCouponCodeCellView];
//            
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:couponCodeCellView.bounds
//                                                           byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
//                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
//            CAShapeLayer *maskLayer = [CAShapeLayer layer];
//            maskLayer.frame = couponCodeCellView.bounds;
//            maskLayer.path = maskPath.CGPath;
//            cell.layer.mask = maskLayer;
//            [cell addSubview:couponCodeCellView];
//        }else if(indexPath.row ==1){
//            cellIdentifier = @"PaymentCellIdentifier";
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            UIView *paymentDetail = [self paymentSummaryView];
//            [paymentDetail setBackgroundColor:[UIColor whiteColor]];
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:paymentDetail.bounds
//                                                           byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
//                                                                 cornerRadii:CGSizeMake(3.0, 3.0)];
//            CAShapeLayer *maskLayer = [CAShapeLayer layer];
//            maskLayer.frame = paymentDetail.bounds;
//            maskLayer.path = maskPath.CGPath;
//            cell.layer.mask = maskLayer;
//            
//            
//            [cell.contentView addSubview:paymentDetail];
//        }
//    }
    
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.section == [self.cartData.cartItems count]){
         [self showAddWishListScreen];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/
- (void)showAddWishListScreen{
    AddFromWishlistViewController *addItemsWishListCtrl = [[AddFromWishlistViewController alloc] init];
    screenType = CartScreenNavigationFromWishlist;
    CartViewController *cart = self;
    addItemsWishListCtrl.itemAdded = ^(BOOL isItemAdded){
        //            [cart generateAddCartInfoView];
        cart.itemAddedFormWishlist = isItemAdded;
    };
    [self.navigationController pushViewController:addItemsWishListCtrl animated:TRUE];
}


- (void)generateAddCartInfoView:(NSString *)msg{
    
    self.addCartInfoView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-115, self.view.frame.size.width, 50)];
    [self.addCartInfoView setBackgroundColor:UIColorFromRGB(kGreenColor)];
    NSString *infoString = msg;
    CGSize size = [SSUtility getLabelDynamicSize:infoString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.addCartInfoView.frame.size.width, MAXFLOAT)];
    UILabel *info = [SSUtility generateLabel:msg withRect:CGRectMake(self.addCartInfoView.frame.size.width/2 - size.width/2, self.addCartInfoView.frame.size.height/2 - size.height/2, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
    [info setTextColor:[UIColor whiteColor]];
    [self.addCartInfoView addSubview:info];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.addCartInfoView];
    animationEndPoint = CGPointMake(self.view.frame.origin.y,0);
    [self animteAddCartInfo:animationEndPoint];
}

- (void)animteAddCartInfo:(CGPoint)destinationPoint{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [self.addCartInfoView setFrame:CGRectMake(self.addCartInfoView.frame.origin.x, destinationPoint.y, self.addCartInfoView.frame.size.width, self.addCartInfoView.frame.size.height)];
    [UIView commitAnimations];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [UIView animateWithDuration:3.0f animations:^{
        self.addCartInfoView.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
                         if(self.addCartInfoView){
                             [self.addCartInfoView removeFromSuperview];
                             self.addCartInfoView = nil;
                         }
                     }];
    
}





- (void)fetchCartItemAvailableSizes:(CartItem *)catItem{
    [self.view addSubview:cartLoader];
    [cartLoader startAnimating];
    
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    
    if(itemSizes){
        [itemSizes removeAllObjects];
        itemSizes = nil;
    }
    itemSizes = [[NSMutableArray alloc] initWithCapacity:0];
    __weak CartViewController *cartCtrl = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)catItem.productId],@"product_id",nil];
    
    if(!catItem.tryAtHomeSelected){
        [self.cartHandler getItemAvailableSizes:dict withCompletionHandler:^(id responseData, NSError *error) {
            
            NSArray *sizeArray = [responseData objectForKey:@"sizes"];
            for(NSInteger counter=0; counter < [sizeArray count]; counter++){
                NSDictionary *sizeDict = [sizeArray objectAtIndex:counter];
                ProductSize *size = [[ProductSize alloc] initWithDictionary:sizeDict];
                [itemSizes addObject:size];
            }
            [cartLoader stopAnimating];
            [cartLoader removeFromSuperview];

            [cartCtrl showItemSizesPopUp:itemSizes cartItem:catItem];
        }];
    }else{
        [self.cartHandler getCartItemFyndAFitSizes:dict withCompletionHandler:^(id responseData, NSError *error) {
            [cartLoader stopAnimating];
            [cartLoader removeFromSuperview];

            self.cartItemFyndAFitData = [[NSMutableDictionary alloc] initWithCapacity:0];
            catItem.convenienceFee = [responseData objectForKey:@"convenience_fee"];
            NSArray *sizes =  [responseData objectForKey:@"size_options"];
            for(NSInteger counter=0; counter < [sizes count]; counter++){
                NSDictionary *dict = [sizes objectAtIndex:counter];
                
                ProductSize *size = [[ProductSize alloc] init];
                size.sizeValue = [dict objectForKey:@"size"];
                size.sizeDisplay = [dict objectForKey:@"size"];
                [itemSizes addObject:size];
                
                NSArray *possibleSize = [dict objectForKey:@"possible_sizes"];
                NSMutableArray *associatedSizeArray = nil;
                if(possibleSize && [possibleSize count]>0){
                    associatedSizeArray = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    for(NSInteger sizeCounter=0; sizeCounter < [possibleSize count]; sizeCounter++){
                         NSDictionary *currentSize = [possibleSize objectAtIndex:sizeCounter];
                        ProductSize *size = [[ProductSize alloc] initWithDictionary:currentSize];
                        [associatedSizeArray addObject:size];
                    }
                }
                [self.cartItemFyndAFitData setObject:associatedSizeArray forKey:[dict objectForKey:@"size"]];
                
            }
            [cartCtrl showItemSizesPopUp:itemSizes cartItem:catItem];
            
        }];
    }
    
   
}



- (void)performActionOnOverlay:(NSInteger)tag andPopType:(RPWOverlayType )type andInputDictionary:(NSMutableDictionary *)dictionary{
    
    NSUserDefaults *userDefaults = nil;
    CartItem *item = nil;
    if(tag==-1){ //If user click on cancel then this will execute
        [self.cartOverlayHandler dismissOverlay];
        return;
    }
    switch (type) {
        case TryAtHomeFirstTimeOverlay:
            
            userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];
            
            if(!isTryAtHomeFirstTime){
                [userDefaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"isTryAtHomeGuideSeen"];
            }
            
            [self.cartOverlayHandler dismissOverlay];
            item = [self.cartData.cartItems objectAtIndex:self.currentOperatedCartItem];
            [self  fetchCartItemAvailableSizes:item];
            break;
        
            
        case TryAtHomeOverlay:
            [self.cartOverlayHandler dismissOverlay];
            self.cartOverlayHandler.contentView.userInteractionEnabled = FALSE;
            [self editCartItemsSizes:[dictionary objectForKey:@"selectedSizeData"]];
            break;
            
        case CartEditSizeOverlay:
            [self.cartOverlayHandler dismissOverlay];
            self.cartOverlayHandler.contentView.userInteractionEnabled = FALSE;
            [self editCartItemsSizes:[dictionary objectForKey:@"selectedSizeData"]];
            break;
        
        case CustomAlertPayment:
            [self sendPaymentEvent:TRUE];
            [self.paymentOverlay dismissOverlay];
            [self navigateToFeedPage];
            break;
            
        case CustomAlertPaymentFailed:
            [self.paymentOverlay dismissOverlay];
            [self navigateToCart];
            break;
    
        default:
            break;
    }
    
}





- (void)showItemSizesPopUp:(NSMutableArray *)array cartItem:(CartItem *)item{
    
    if(self.cartOverlayHandler){
        self.cartOverlayHandler.overlayDelegate = nil;
        self.cartOverlayHandler = nil;
    }
    self.cartOverlayHandler = [[PopOverlayHandler alloc] init];
    self.cartOverlayHandler.overlayDelegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isTryAtHomeFirstTime = [[userDefaults objectForKey:@"isTryAtHomeGuideSeen"] boolValue];
    
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithBool:isTryAtHomeFirstTime] forKey:@"TryAtHomeModuleType"];
    if(item.tryAtHomeSelected){
        [parameters setObject:[NSNumber numberWithInt:2] forKey:@"maxSizeSelection"];
        if(!isTryAtHomeFirstTime){
            [parameters setObject:[NSNumber numberWithInt:TryAtHomeFirstTimeOverlay] forKey:@"PopUpType"];
        }
        else{
            [parameters setObject:[NSNumber numberWithInt:TryAtHomeOverlay] forKey:@"PopUpType"];
        }
        [parameters setObject:self.cartItemFyndAFitData forKey:@"DependentSizes"];
        [parameters setObject:item.convenienceFee forKey:@"convenienceFee"];
        
    }else{
        [parameters setObject:[NSNumber numberWithInt:1] forKey:@"maxSizeSelection"];
        [parameters setObject:[NSNumber numberWithInt:CartEditSizeOverlay] forKey:@"PopUpType"];
    }
    
    NSArray *preSelectedSize = [item.itemSize componentsSeparatedByString:@","];
    [parameters setObject:preSelectedSize forKey:@"preSelectedSize"];
    
    [parameters setObject:@"CANCEL" forKey:@"LeftButtonTitle"];
    [parameters setObject:@"SAVE CHANGES" forKey:@"RightButtonTitle"];
    [parameters setObject:[NSNumber numberWithInteger:SelectSizeFromEditSize] forKey:@"TryAtHomAction"];
    
    [parameters setObject:array forKey:@"PopUpData"];
    [self.cartOverlayHandler presentOverlay:SizeGuideOverlay rootView:self.view enableAutodismissal:TRUE withUserInfo:parameters];
}



- (void)editCartItemsSizes:(NSMutableArray *)sizeData{
   
    if(sizeData && [sizeData count]>0){
        [self.view addSubview:cartLoader];
        [cartLoader startAnimating];
        
        if(self.cartHandler == nil){
            self.cartHandler = [[CartRequestHandler alloc] init];
        }
        NSMutableString *editedSize = [[NSMutableString alloc] init];
        NSDictionary *paramDict = nil;
        if([sizeData count]==1){
            ProductSize *size = [sizeData objectAtIndex:0];
            [editedSize appendString:size.sizeValue];
            paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.currentOperatedCartItem],@"cart_index",size.sizeValue,@"size1",nil];
        }else{
            ProductSize *size1 = [sizeData objectAtIndex:0];
            ProductSize *size2 = [sizeData objectAtIndex:1];
            [editedSize appendString:size1.sizeValue];
            [editedSize appendString:[NSString stringWithFormat:@",%@",size2.sizeValue]];
            paramDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.currentOperatedCartItem],@"cart_index",size1.sizeValue,@"size1",size2.sizeValue,@"size2",nil];
        }
        
        [self.cartHandler updateCartItemSizes:paramDict withCompletionHandler:^(id responseData, NSError *error) {
            [cartLoader stopAnimating];
            [cartLoader removeFromSuperview];

            [self.cartOverlayHandler dismissOverlay];

            if([[responseData objectForKey:@"is_updated"] boolValue]){
                CartItem *item = [self.cartData.cartItems objectAtIndex:self.currentOperatedCartItem];
                item.itemSize = editedSize;
                [self.cartData.cartItems replaceObjectAtIndex:self.currentOperatedCartItem withObject:item];
                [self.cartMainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:self.currentOperatedCartItem]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

        }];
    }

}


- (void)deleteCardItem:(CartItem *)currentItem{

    [self.view addSubview:cartLoader];
    [cartLoader startAnimating];
    
    NSInteger currentItemIdex = [self.cartData.cartItems indexOfObject:currentItem];
    if(self.cartHandler == nil){
        self.cartHandler = [[CartRequestHandler alloc] init];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)currentItemIdex],@"cart_index", nil];
    [self.cartHandler deleteCartItem:dict withCompletionHandler:^(id responseData, NSError *error) {
        [cartLoader stopAnimating];
        [cartLoader removeFromSuperview];
        
        if(responseData){
            CartData *cartData =[[CartData alloc] initWithDictionary:responseData];
            if(cartData){

                if([cartData.cartItems count] > 0){
                    previousState = PullableStateClosed;
                    [self updateWithNewCartData:cartData];
                    int totalBagItems =[[[NSUserDefaults standardUserDefaults] valueForKey:kHasItemInBag] intValue];
                    totalBagItems --;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:totalBagItems] forKey:kHasItemInBag];
                    if(self.cartData.coupanDetails.isCoupanApplied && !self.cartData.coupanDetails.isCoupanValid){
                        [SSUtility showOverlayViewWithMessage:self.cartData.coupanDetails.coupanStatus andColor:UIColorFromRGB(kRedColor)];
                    }
                }else{
                    [self clearView];
                    [cartLoader stopAnimating];
                    [cartLoader removeFromSuperview];

                    if(self.cartMainTableView){
                        [self.cartMainTableView removeFromSuperview];
                        self.cartMainTableView.dataSource = nil;
                        self.cartMainTableView.delegate = nil;
                    }
                        [self displayBlankPage:ErroNoCartItem];
                        //Set the Normal Image for the Cart Tab and reset the BOOL
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kHasItemInBag];
                        
                        UITabBarItem *cartBarItem = [self.tabBarController.tabBar.items objectAtIndex:4];
                        [cartBarItem setSelectedImage:[UIImage imageNamed:@"CartSelectedTab"]];
                        [cartBarItem setImage:[UIImage imageNamed:@"CartTab"]];
                }
            }
        }

    }];
    
}


- (void)refeshPaymentSummary{
    [self.cartMainTableView reloadRowsAtIndexPaths:[self indexPathForStores:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (NSArray *)indexPathForStores:(NSInteger)rows{
    
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter< rows; counter++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:counter inSection:[self.cartData.cartItems count]+1]];
    }
    return [indexPathArray copy];
}


- (UIView *)addWishListCellView{
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(RelativeSize(6, 320), 0, self.cartMainTableView.frame.size.width - (RelativeSize(12, 320)), 45)];
    aView.layer.cornerRadius = 3.0f;
    [aView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *wishlistInvisibleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, aView.frame.size.width, aView.frame.size.height)];
    [wishlistInvisibleButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [wishlistInvisibleButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [wishlistInvisibleButton addTarget:self action:@selector(showAddWishListScreen) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:wishlistInvisibleButton];
    wishlistInvisibleButton.clipsToBounds = YES;

    
    UIImage *image = [UIImage imageNamed:@"CartWishlist"];
    UIButton *heartButton = [[UIButton alloc] initWithFrame:CGRectMake(5, aView.frame.size.height/2 - image.size.height/2, image.size.width,image.size.height)];
    [heartButton setBackgroundColor:[UIColor clearColor]];
    [heartButton setImage:[UIImage imageNamed:@"CartWishlist"] forState:UIControlStateNormal];
    [aView addSubview:heartButton];

   
    
//    UILabel *addFromWishList = [[UILabel alloc] initWithFrame:CGRectMake(heartButton.frame.origin.x + heartButton.frame.size.width, aView.frame.size.height/2 - 17, 150, 35)];
    UILabel *addFromWishList = [[UILabel alloc] initWithFrame:CGRectMake(heartButton.frame.origin.x + heartButton.frame.size.width + 7, aView.frame.size.height/2 - 18, 150, 35)];
    [addFromWishList setBackgroundColor:[UIColor clearColor]];
    [addFromWishList setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [addFromWishList setText:@"Add From Wishlist"];
    [addFromWishList setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [aView bringSubviewToFront:heartButton];
//    [addFromWishList setCenter:CGPointMake(aView.center.x + heartButton.frame.size.width/2, aView.frame.size.height/2)];
    [aView addSubview:addFromWishList];
    
//    [heartButton setCenter:CGPointMake(addFromWishList.frame.origin.x - heartButton.frame.size.width/2, addFromWishList.center.y)];
    
    
    UIImage* sourceImage = [UIImage imageNamed:kBackButtonImage];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                                scale:sourceImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.cartMainTableView.frame.size.width - 36 - RelativeSize(9, 320), aView.frame.size.height/2 - 13,26, 26)];
    [arrowImage setBackgroundColor:[UIColor clearColor]];
    [arrowImage setImage:flippedImage];
    [aView  addSubview:arrowImage];
    
    aView.clipsToBounds = YES;
    return aView;
}


- (UIView *)paymentSummaryView{
    CGFloat height = [self tableView:self.cartMainTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:[self.cartData.cartItems count]+1]];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cartMainTableView.frame.size.width, height)];
    
    CGFloat itemPadding = 5.0f;
    CGFloat oldOItemHeight = 10.0f;
    for(NSInteger counter=0; counter < [self.cartData.cartBreakUpValues count]; counter++){
        NSDictionary *currentDict = [self.cartData.cartBreakUpValues objectAtIndex:counter];

    
        NSString *key = [[currentDict allKeys] objectAtIndex:0];
        
        UIFont *paymentOptionFont = nil;
        UIColor *paymentHeadingColor;
        if(counter == [self.cartData.cartBreakUpValues count]-1){
            paymentOptionFont = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
        }else{
            paymentOptionFont = [UIFont fontWithName:kMontserrat_Light size:14.0f];
        }
            
        
        UILabel *heading = [SSUtility generateLabel:key withRect:CGRectMake(15,  oldOItemHeight, 200, 30) withFont:paymentOptionFont];
        [heading setTextAlignment:NSTextAlignmentLeft];
        [heading setBackgroundColor:[UIColor clearColor]];
        NSString *headingString = [[currentDict allKeys] objectAtIndex:0];
        if(counter == [self.cartData.cartBreakUpValues count]-1){
            headingString = @"TOTAL";
            paymentHeadingColor = UIColorFromRGB(kSignUpColor);
        }else{
            paymentHeadingColor = UIColorFromRGB(kGenderSelectorTintColor);
        }
        
        [heading setText:headingString];
        [heading setTextColor:paymentHeadingColor];
        [aView addSubview:heading];

        UIColor *valueColor = UIColorFromRGB(kSignUpColor);
        NSString *value = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol,[currentDict objectForKey:key]];
        if([[key uppercaseString] isEqualToString:@"DELIVERY"]){
            NSInteger deliveryFee = [[currentDict objectForKey:key] integerValue];
            if(deliveryFee > 0){
                value = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol,[currentDict objectForKey:key]];
            }else{
                value = @"Free";
            }
            valueColor = UIColorFromRGB(kCouponSucessColor);
        }
        else if([[key uppercaseString] isEqualToString:@"COUPON"]){
            NSArray *arr = [[currentDict objectForKey:key] componentsSeparatedByString:@"-"];
            if([arr count]>1)
                value = [NSString stringWithFormat:@"- %@ %@",kRupeeSymbol,[arr objectAtIndex:1]];
        }
        CGSize valueSize = [SSUtility getLabelDynamicSize:value withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(100, 100)];
        UILabel *valueLabel = [SSUtility generateLabel:value withRect:CGRectMake(self.cartMainTableView.frame.size.width - (3*itemPadding + valueSize.width), heading.frame.origin.y, valueSize.width, heading.frame.size.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [valueLabel setBackgroundColor:[UIColor clearColor]];
        [valueLabel setTextColor:valueColor];
        [aView addSubview:valueLabel];
        
        oldOItemHeight = heading.frame.origin.y + heading.frame.size.height + itemPadding;
        if(counter == [self.cartData.cartBreakUpValues count]-2){
            SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(heading.frame.origin.x, heading.frame.origin.y + heading.frame.size.height+cart_y_padding, valueLabel.frame.origin.x + valueLabel.frame.size.width-10, 1)];
            [aView addSubview:line];
            oldOItemHeight+= 2*itemPadding;
        }
    }
    return aView;
}


- (void)updateCardItemStatus:(CartScreenNavigationType)type withData:(NSDictionary*)validateCartResponse{
    [self.cartData refreshInvalidCartItems:validateCartResponse];
    screenType = type;

}

-(void)dismissKeyboard{
    if([self.couponCodeTextField.theTextField isFirstResponder]){
        [self.couponCodeTextField.theTextField resignFirstResponder];
        self.tapGesture.enabled = FALSE;
    }
}

-(void)manageSwipeWithGesture:(UIPanGestureRecognizer *)recognizer andCell:(id)cell{
    
    CartItemCell *theCartCell = (CartItemCell *)cell;
    
    if (!self.cartMainTableView.isDecelerating && !self.cartMainTableView.isDragging) {
        
        CGPoint translation = [recognizer translationInView:theCartCell.contentView];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:theCartCell.contentView];
        
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {

            CGPoint velocity = [recognizer velocityInView:theCartCell.contentView];
            if (velocity.x>0) {
                //right pan
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    recognizer.view.center =CGPointMake(theCartCell.contentView.center.x,theCartCell.contentView.center.y);
                } completion:^(BOOL finished) {
                    theCartCell.isCellOpen = FALSE;
                }];

            }else{
                //pan left

                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    recognizer.view.center = CGPointMake(theCartCell.contentView.center.x-70, theCartCell.contentView.center.y);
                } completion:^(BOOL finished) {

                    //Closing the other open tabs
                    NSArray *paths = [self.cartMainTableView indexPathsForVisibleRows];
                    for (NSIndexPath *path in paths) {
                        if ([[self.cartMainTableView cellForRowAtIndexPath:path] isKindOfClass:[CartItemCell class]]) {
                            CartItemCell * openedCell = (CartItemCell *)[self.cartMainTableView cellForRowAtIndexPath:path];
                            if ([openedCell isCellOpen]) {
                                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    openedCell.cardMainView.center =CGPointMake(self.cartMainTableView.center.x,openedCell.cardMainView.center.y);
                                } completion:^(BOOL finished) {
                                    openedCell.isCellOpen = FALSE;
                                }];                
                            }
                        }
                    }
                    //Closing the other open tabs - Code ends                    
                    theCartCell.isCellOpen = TRUE;
                }];
            }
        }
    }

    
    
    
}

#pragma mark - Payment Controller Delegate

- (void)selectedOptionWithDataDictionary:(NSDictionary *)theData{
    
    self.cartData.defaultPaymentOption = theData;
    
    //Todo get data and populate the view for cart.
    paymentSummaryView.paymentModeDictionary = theData;
    [paymentSummaryView updatePaymentMode];
}
-(void)selectedNetbankingOption:(NSDictionary *)netBankingData{
    
    screenType = CartScreenNavigationFromPaymentMode;
    self.cartData.defaultPaymentOption = netBankingData;
    paymentSummaryView.paymentModeDictionary = netBankingData;
    [paymentSummaryView updatePaymentMode];
    
}

#pragma mark - AddressList Delegate

- (void)selectedAddressAndTimeSlot:(NSDictionary *)dataDictionary{
    if (dataDictionary[@"addressModel"]) {
        ShippingAddressModel *theAddressModel = dataDictionary[@"addressModel"];
        paymentSummaryView.defaultShippingAddress = theAddressModel;
    }
    if (dataDictionary[@"timeSlotModel"]) {
        DeliveryTimeSlotModel *theTimeSlot = dataDictionary[@"timeSlotModel"];
        paymentSummaryView.defaultTimeSlot = theTimeSlot;
    }
    
    //Todo - Need to get the time slots also from the address class
    screenType = CartScreenNavigationFromAddress;

    [paymentSummaryView updateAddress];
}

#pragma mark - Payment Successfull Delegate

-(void)paymentDoneNavigateToFeedWithSuccess:(BOOL)isSuccessful hasUserCancelled:(BOOL)isManualCancellation{
    if (isSuccessful) {
        [self navigateToFeedPage];
        screenType = CartScreenNavigationFromPayment;
        [self sendPaymentEvent:TRUE];
    }else{
        //Show Error
        [self sendPaymentEvent:FALSE];
        screenType = CartScreenNavigationFromPayment;
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *navController = [[self.tabBarController viewControllers] objectAtIndex:4];
            [navController popToRootViewControllerAnimated:NO];
            
            TabBarViewController *theTabBar = (TabBarViewController *)self.tabBarController;
            
            [theTabBar setSelectedIndex:4];
            [self.navigationController popToRootViewControllerAnimated:NO];
            if (!isManualCancellation) {
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
                [SSUtility showOverlayViewWithMessage:@"Sorry! Unable to process payment" andColor:UIColorFromRGB(kRedColor)];                
            }
        });
        
    }

}

-(void)showPaymentWebViewWithURLString:(NSString *)urlString andMethod:(NSString *)method andParams:(NSDictionary *)params{
    
    if (paymentWebViewController) {
        paymentWebViewController = nil;

    }
     paymentWebViewController = [[PaymentWebViewController alloc] init];
     paymentWebViewController.paymentWebDelegate = self;
     paymentWebViewController.urlString = urlString;
     paymentWebViewController.method = method;
     paymentWebViewController.params = params;
     [self.navigationController pushViewController:paymentWebViewController animated:YES];
     screenType = CartScreenNavigationFromPaymentMode;

    
    [self.navigationController dismissViewControllerAnimated:false completion:nil];
}

-(void)dismissCVVScreen{
    screenType = CartScreenNavigationFromPayment;
}

//
//-(void)paymentSuccessNavigateToCartView{
//    [self navigateToFeedPage];
//}

#pragma mark - Time Slot Picker


-(void)changeTime{
    
    if (self.timeSlotsArray && [self.timeSlotsArray count]>0) {
        
        if(pickerViewContainer){
            [pickerViewContainer removeFromSuperview];
            pickerViewContainer = nil;
        }
        pickerViewContainer =[[UIView alloc] initWithFrame:CGRectMake(0,kDeviceHeight,self.view.frame.size.width, 260)];
        [pickerViewContainer setBackgroundColor:[UIColor clearColor]];
        
        UIView *toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerViewContainer.frame.size.width, 44)];
        toolBarView.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
        [toolBarView.layer setShadowOpacity:0.1];
        [toolBarView.layer setShadowOffset:CGSizeMake(0.0, -1.0)];
        [toolBarView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 32, 32)];
        [addressImageView setImage:[UIImage imageNamed:@"Schedule"]];
        [toolBarView addSubview:addressImageView];
        
        UILabel *deliveryTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressImageView.frame.origin.x + addressImageView.frame.size.width, 0, 100, 40)];
        [deliveryTimeLabel setText:@"Delivery Time"];
        [deliveryTimeLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [deliveryTimeLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [toolBarView addSubview:deliveryTimeLabel];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(toolBarView.frame.size.width - 50, 0, 40, 40)];
        NSAttributedString *doneString = [[NSAttributedString alloc] initWithString : @"Done"
                                                                         attributes : @{
                                                                                        NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0],
                                                                                        NSForegroundColorAttributeName : UIColorFromRGB(kTurquoiseColor)
                                                                                        }];
        [btn addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setAttributedTitle:doneString forState:UIControlStateNormal];
        [toolBarView addSubview:btn];
        
        pickerSeperator = [[SSLine alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y + btn.frame.size.height, toolBarView.frame.size.width, 1)];
        [toolBarView addSubview:pickerSeperator];
        
        [pickerViewContainer addSubview:toolBarView];
        
        if (_theTimePicker) {
            [_theTimePicker removeFromSuperview];
            _theTimePicker = nil;
        }
        
        _theTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, toolBarView.frame.size.width, 216)];
        _theTimePicker.delegate=self;
        _theTimePicker.dataSource=self;
        _theTimePicker.showsSelectionIndicator=YES;
        [_theTimePicker setBackgroundColor:[UIColor whiteColor]];
        [pickerViewContainer addSubview:_theTimePicker];
        
        __block NSInteger selectedDayIndex = 0;
        __block NSInteger selectedTimeIndex = 0;
        [self.cartData.timeSlotsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DeliveryTimeSlotModel *aSlot = (DeliveryTimeSlotModel *)obj;

            
            if ([[aSlot.aDeliveryDate uppercaseString] isEqualToString:[paymentSummaryView.defaultTimeSlot.aDeliveryDate uppercaseString]]) {
                selectedDayIndex = idx;
                NSArray *theArr = aSlot.aDeliveryTimeArray;
                if (self.timeSlotsArray && theArr) {
                    [self.timeSlotsArray removeAllObjects];
                }
                [self.timeSlotsArray addObjectsFromArray:theArr];
            }
        }];
        DeliveryTime *defaultDeliveryTime = (DeliveryTime *)[paymentSummaryView.defaultTimeSlot.aDeliveryTimeArray objectAtIndex:0];
        [self.timeSlotsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DeliveryTime *timeStr = (DeliveryTime *)obj;
            if ([[timeStr.deliveryTimeValue uppercaseString] isEqualToString:[defaultDeliveryTime.deliveryTimeValue uppercaseString]]) {
                selectedTimeIndex = idx;
            }
        }];
        
        
        [_theTimePicker selectRow:selectedDayIndex inComponent:0 animated:TRUE];
        [_theTimePicker selectRow:selectedTimeIndex inComponent:1 animated:TRUE];
        [overlayView addSubview:pickerViewContainer];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:pickerViewContainer];

        [paymentSummaryView setViewState:PullableStateClosed animated:TRUE];
        [UIView animateWithDuration:0.5 animations:^{
            [pickerViewContainer setFrame:CGRectMake(0,kDeviceHeight-260,self.view.frame.size.width,260)];
        }];

        
    }
}

-(void)doneBtnPressed:(id)sender{
    
    DeliveryTimeSlotModel *theSelectedSlot = [[DeliveryTimeSlotModel alloc] init];
    
    theSelectedSlot.aDeliveryDate = [self.daySlotsArray objectAtIndex:[self.theTimePicker selectedRowInComponent:0]];
    theSelectedSlot.aDeliveryTimeArray = [NSArray arrayWithObject:[self.timeSlotsArray objectAtIndex:[self.theTimePicker selectedRowInComponent:1]]];


     [paymentSummaryView setViewState:PullableStateHalfOpened animated:TRUE];
    
    [UIView animateWithDuration:0.5 animations:^{
        [pickerViewContainer setFrame:CGRectMake(0,kDeviceHeight,self.view.frame.size.width, 260)];
    } completion:^(BOOL finished) {
        [pickerViewContainer removeFromSuperview];
        pickerViewContainer = nil;
        [_theTimePicker removeFromSuperview];
        _theTimePicker = nil;

//        [UIView animateWithDuration:0.5 animations:^{
//            [paymentSummaryView setViewState:PullableStateHalfOpened animated:TRUE];
//        }];
        
    }];

    
    paymentSummaryView.defaultTimeSlot = theSelectedSlot;
    [paymentSummaryView updateTimeSlot];

   
}

-(void)populateTimeSlotsArray{
    self.timeSlotsArray = [[NSMutableArray alloc] init];
    
    self.daySlotsArray = [[NSMutableArray alloc] init];
    if (_daySlotsArray) {
        [_daySlotsArray removeAllObjects];
    }
    __block  NSInteger defaultDayIndex = 0;
    __block NSInteger defaultTimeIndex = 0;
    
    [self.cartData.timeSlotsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger date_idx, BOOL *stop) {
        DeliveryTimeSlotModel *aDict = (DeliveryTimeSlotModel *)obj;
        [self.daySlotsArray addObject:aDict.aDeliveryDate];
        
        for (int tSlot = 0; tSlot<[aDict.aDeliveryTimeArray count]; tSlot ++) {
            DeliveryTime *theTime = [aDict.aDeliveryTimeArray objectAtIndex:tSlot];
            if (theTime.isDefaultDeliverySlot) {
                defaultTimeIndex = tSlot;
                defaultDayIndex = date_idx;
                break;
            }
        }
    }];
    
    NSArray *theArr = [(DeliveryTimeSlotModel *)[self.cartData.timeSlotsArray objectAtIndex:defaultDayIndex] aDeliveryTimeArray];
    if (self.timeSlotsArray) {
        [self.timeSlotsArray removeAllObjects];
    }
    [self.timeSlotsArray addObjectsFromArray:theArr];
    
//    self.slotID = [(DeliveryTime *)[theArr objectAtIndex:defaultTimeIndex] deliveryTimeId];
}


#pragma mark - PickerView Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component == 0) {
        return [self.daySlotsArray count];
    }else
        return [self.timeSlotsArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    UILabel *theLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    [theLabel setTextColor:UIColorFromRGB(kTurquoiseColor)];
    NSString *textStr = [theLabel text];

    if (component == 0) {
        [self.cartData.timeSlotsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DeliveryTimeSlotModel *aSlot = (DeliveryTimeSlotModel *)obj;
            if ([aSlot.aDeliveryDate isEqualToString:textStr]) {
                NSArray *theArr = aSlot.aDeliveryTimeArray;
                if (self.timeSlotsArray && theArr) {
                    [self.timeSlotsArray removeAllObjects];
                }
                [self.timeSlotsArray addObjectsFromArray:theArr];
            }
        }];
        [pickerView reloadComponent:1];
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (tView == nil){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        [tView setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    // Fill the label text here
    NSString *titleStr = nil;
    if (component == 0) {
        titleStr =  [self.daySlotsArray objectAtIndex:row];
    }else{
        titleStr = [[self.timeSlotsArray objectAtIndex:row] deliveryTimeValue];
    }
    [tView setText:titleStr];
    
        
    return tView;
}

#pragma mark - MixPanel Track Event


-(void)sendCheckoutEvent{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:paymentSummaryView.defaultShippingAddress.thePincode forKey:@"delivery_pincode"];
    if(self.cartData.coupanDetails.couponCode && self.cartData.coupanDetails.couponCode != nil && self.cartData.coupanDetails.isCoupanValid){
        [dict setObject:self.cartData.coupanDetails.couponCode forKey:@"coupon_code"];
    }else{
        [dict setObject:@"" forKey:@"coupon_code"];
    }
    
    [dict setObject:self.cartData.orderId forKey:@"orderid"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.cartData.cartItems count]; i++){
        
        CartItem *item = [self.cartData.cartItems objectAtIndex:i];
        
        NSString *itemCost = [item.itemCost stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[NSString stringWithFormat:@"%d", (int)item.productId] forKey:@"itemcode"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", [itemCost intValue]] forKey:@"price"];
        
        [array addObject:tempDict];
    }
    
    [dict setObject:[NSArray arrayWithArray:array] forKey:@"bags"];
    
    //    NSArray *slotsArray = self.theShippingModel.theTimeSlotArray;
    
    NSString *dayString = paymentSummaryView.defaultTimeSlot.aDeliveryDate;
    NSString *timeString =((DeliveryTime *)[paymentSummaryView.defaultTimeSlot.aDeliveryTimeArray objectAtIndex:0]).deliveryTimeValue;
    
    NSDate *date;
    NSDate *deliveryDate;
    NSString *startTime = [[timeString componentsSeparatedByString:@"-"] objectAtIndex:0];
    startTime = [startTime stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *startTimeValue = [[startTime componentsSeparatedByString:@":"] objectAtIndex:0];
    NSInteger startTimeInt = [startTimeValue integerValue];
    if(startTimeInt){
        if([startTime rangeOfString:@"A"].length>0 || [startTime rangeOfString:@"a"].length>0){
            //        if([startTime containsString:@"A"] || [startTime containsString:@"a"]){
            
        }else if ([startTime rangeOfString:@"P"].length>0 || [startTime rangeOfString:@"p"].length>0){
            startTimeInt += 12;
        }
    }
    
    if([[dayString lowercaseString] isEqualToString:@"today"]){
        date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        [components setHour:startTimeInt];
        deliveryDate = [calendar dateFromComponents:components];
    }else{
        date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        [components setHour:startTimeInt];
        deliveryDate = [calendar dateFromComponents:components];
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:deliveryDate];
    
    [dict setObject:dateString forKey:@"delivery_slot"];
    [FyndAnalytics trackCheckout:dict];
}

-(void)sendPaymentEvent:(BOOL)success{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)[self.cartData.cartItems count]] forKey:@"bag_count"];
     NSString *paymentMode = [[self.cartData.defaultPaymentOption objectForKey:@"mode"] uppercaseString];
    if([paymentMode isEqualToString:@"PT"]){
        [dictionary setObject:@"paytm_wallet" forKey:@"payment_type"];
    }
    else if ([paymentMode isEqualToString:@"OP"]){
        [dictionary setObject:@"paytm" forKey:@"payment_type"];
    }
    else if ([paymentMode isEqualToString:@"COD"]){
        [dictionary setObject:@"cod" forKey:@"payment_type"];
    }
    else if ([paymentMode isEqualToString:@"CDOD"]){
        [dictionary setObject:@"cdod" forKey:@"payment_type"];
    }
    else if ([paymentMode isEqualToString:@"NB"]){
        [dictionary setObject:@"nb" forKey:@"payment_type"];
    }
    else if ([paymentMode isEqualToString:@"CARD"]){
        [dictionary setObject:@"card" forKey:@"payment_type"];
    }
    
    
    [dictionary setObject:self.orderId forKey:@"orderid"];
    
    if(success){
        [dictionary setObject:@"successful" forKey:@"payment_status"];
    }else{
        [dictionary setObject:@"unsuccessful" forKey:@"payment_status"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *dateString = [formatter stringFromDate:now];
    
    [dictionary setObject:dateString forKey:@"last_ordered_date"];
    NSString *paymentValue = [[self.cartData.cartBreakUpValues lastObject] valueForKey:@"Total"];
    if (paymentValue && paymentValue.length>0) {
        [dictionary setObject:paymentValue forKey:@"life_time_value"];
    }

    
    [FyndAnalytics trackPayment:dictionary];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
