//
//  RPWOverlayHandler.m
//  OverlayAnimation
//
//

#import "PopOverlayHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomPopUp.h"
#import "NearestStorePopUp.h"
#import "PinCodePopUp.h"
#import "PickAtStorePopUp.h"
#import "SSUtility.h"
#import "ReturnReasonsView.h"
#import "AddCartPopUp.h"
/*
#import "TCSStrategixLocationDataHandler.h"
#import "GraphServiceData.h"
#import "TCSStrategixProgressView.h"
#import "TCSStrategixSearchResultDisplayView.h"
#import "TCSStrategixAssociateSearchDataHandler.h"

#import "TCSStrategixTrendPopUpView.h"
#import "TCSStrategixMaleFemaleComparsionView.h"
*/

#define kOverlayMargin 41
#define kStartOverlayWidth 586
#define kStartOverlayHeight 460



#define kStartOverOverlayName @"start_over_overlay"
#define kLocationDetailsOverlayName @"location_details_overlay"




@interface PopOverlayHandler ()

@property (nonatomic, strong) UIView *rootView;





/*!
 @property	overlayType
 @abstract	contains the overlayType
 */
@property (assign, nonatomic) RPWOverlayType overlayType;


@property (nonatomic,strong) NSMutableArray                       *tempFootFallDataArray;
@property (nonatomic,strong) NSDictionary                         *locationDetailDict;
@property (nonatomic,strong) CustomPopUp                          *customPopUp;
@property (nonatomic,strong) NearestStorePopUp                    *nearestStorePopUp;
@property (nonatomic,strong) PinCodePopUp                         *pinCodePopUp;
@property (nonatomic,strong) PickAtStorePopUp                     *pickAtStorePopUp;
@property (nonatomic,strong) AddCartPopUp                         *addCartPopUp;


@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic,strong) NSMutableDictionary  *popUpResponseData;
/*!
 @property	shouldAutoDismiss
 @abstract	indicates if the overlay needs to be auto dismissed.
 */
@property (nonatomic, assign) BOOL shouldAutoDismiss;

/*!
 @method     presentAlert: rootView:
 @abstract   presents the overlay with animation.
 @param      iOverlayView - overlay contents
 @param      iRootView - presents the root view.
 @param      iOverlayType - the type of the overlay.
 */
- (void)presentOverlay:(UIView *)iOverlayView rootView:(UIView *)iRootView  andType:(RPWOverlayType)iOverlayType;

/*!
 @method     removeOverlay:
 @abstract   removes the overlay.
 @param     iTapGesture - tap gesture recognized.
 */
- (void)removeOverlay:(UITapGestureRecognizer *)iTapGesture;



/*!
 @method     :addCloseButton
 @abstract   adds the close button symbol for overlays.
 */
- (void)addCloseButton;


/*!
 @method     startOverOverlay
 @abstract   for startOver overlays
 */
- (void)createStartOverOverlay;





/*!
 @method     contentViewSetting withOverlayHeight backgroundColor
 @abstract   sets the content view with width,height and background color.
 @param      iOverlayWidth - overlay width
 @param      iOverlayHeight - overlay height
 @param      iBackgroundcolor - background color
 */
- (void)createContentViewWithWidth:(CGFloat)iOverlayWidth height:(CGFloat)iOverlayHeight backgroundColor:(UIColor*)iBackgroundColor;

@end


@implementation PopOverlayHandler
NSInteger type;
//@synthesize footfallView;

- (id)init {
	if (self = [super init]) {
//		self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024, 768)];
        
        
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DeviceWidth, kDeviceHeight)];
//        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 375, 667)];
		self.overlayView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.0];
        
		UITapGestureRecognizer *aTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeOverlay:)];
        aTapGestureRecognizer.delegate = self;
		[self.overlayView addGestureRecognizer:aTapGestureRecognizer];
    }
	return self;
}


- (void)removeOverlay:(UITapGestureRecognizer *)iTapGesture {
	CGPoint aTapLocation = [iTapGesture locationInView:iTapGesture.view];
    
	if (!CGRectContainsPoint(self.contentView.frame, aTapLocation)) {
        [self dismissOverlay];
	}
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch{
    UIView *view = touch.view;
    while (view.class != UIView.class) {
        
//        if (view.class == [self.trendPopUp.subMenusTable class]) {
        if (view.class == [self.nearestStorePopUp class] || view.class == [self.pickAtStorePopUp class] || view.class == [self.pinCodePopUp class]) {
            return NO;
        } else {
            view = view.superview;
        }
        
    }
    return YES;
}


// This is the entry point of this class.
- (void)presentOverlay:(RPWOverlayType)iOverlayType rootView:(UIView *)iRootView enableAutodismissal:(BOOL)iEnabled withUserInfo:(NSDictionary *)iInfo {
    self.shouldAutoDismiss = iEnabled;
    self.userInfo = [NSDictionary dictionaryWithDictionary:iInfo];

    [self prepareContentViewForOverlay:iOverlayType withInfo:iInfo];
}


- (void)prepareContentViewForOverlay:(RPWOverlayType)iOverlayType withInfo:(NSDictionary *)aDict {
    
//    NSInteger type = [[aDict objectForKey:@"PopUpType"] integerValue];
    type = [[aDict objectForKey:@"PopUpType"] integerValue];
//    self.overlayType = iOverlayType;
    self.overlayType = type;
     if(type == SizeGuideOverlay){
        [self createSizeGuidePopUp:aDict];
     }else if(type == NearestStoreOverlay){
         [self createNearesStoresPopUp:aDict];
     }else if(type == PinCodeOverlay){
         [self createPinCodePopUp:aDict];
     }else if(type == TryAtHomeOverlay || type == TryAtHomeFirstTimeOverlay || type == ExchangeProductOverlay || type == CartEditSizeOverlay || type == AddCartInBagOverlay){
         [self createTryAtHomePopUp:aDict];
     }else if(type == ProductInformationOveraly){
         [self showProductInformation:aDict];
     }else if(type == RateUsOverlay){
         [self showRateUsPopUp];
     }else if(type == ActivityIndicatorOverlay){
         [self showActivityIndicatorOverlay];
     }else if(type == InvalidCartOverlay){
         [self displayInvaidCartOverlay:aDict];
     }else if (type == ReturnReasonsOverlay){
         [self displayReturnReasonsOverlay:aDict];
     }else if(type == CustomAlertDeleteCartItem || type == CustomAlertCancelOrder || type == CustomAlertSignOut || type == CustomAlertPayment || type == CustomAlertPaymentFailed || type == CustomAlertShippingAddress || type == CustomAlertProfileUpdate){
         [self showCustomAlert:aDict];
     }
     else if(type == ADDCartOverlay){
         [self showAddCartPopUp];
//         [self showRateUsPopUp];
     }
//    [self presentOverlayWithContentViewOnRootView:[UIApplication sharedApplication].keyWindow.rootViewController.view  andType:iOverlayType];
    [self presentOverlayWithContentViewOnRootView:[UIApplication sharedApplication].keyWindow.rootViewController.view  andType:type];
}



- (void)presentOverlayWithContentViewOnRootView:(UIView *)iRootView andType:(RPWOverlayType)iOverlayType {
	self.overlayType = iOverlayType;
	self.contentView.layer.cornerRadius = 5.0;

    
//    if(iOverlayType == PinCodeOverlay){
    if(iOverlayType == PinCodeOverlay || iOverlayType == ADDCartOverlay){
        self.contentView.frame = CGRectMake(self.overlayView.center.x - floorf(self.contentView.frame.size.width/ 2),
                                            self.overlayView.center.y - floorf(self.contentView.frame.size.height/2)-120,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    }
    else{
        self.contentView.frame = CGRectMake(self.overlayView.center.x - floorf(self.contentView.frame.size.width/ 2),
                                        self.overlayView.center.y - floorf(self.contentView.frame.size.height/2),
                                        self.contentView.frame.size.width,
                                        self.contentView.frame.size.height);
    }
    

    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
	self.contentView.alpha = 1.0;
    [self.overlayView addSubview:self.contentView];
	
    [iRootView addSubview:self.overlayView];
	[iRootView bringSubviewToFront:self.overlayView];
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
	CGFloat theAnimationDuration = 0.3;
	
	
    [UIView animateWithDuration:theAnimationDuration animations:^{
        if (iOverlayType != RPWFilterResultsOverlay)
            self.overlayView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.7];
		self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
		self.contentView.alpha = 1.0;
    } completion:^(BOOL iFinished) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		[[NSNotificationCenter defaultCenter] postNotificationName:kRPWOverlayPresentNotification object:nil];
    }];
}


- (void)dismissOverlay {
    
//    if(self.pickAtStorePopUp.productSizeArray){
//        [self.pickAtStorePopUp.productSizeArray removeAllObjects];
////        self.pickAtStorePopUp.productSizeArray = nil;
//    }
    NSString *anOverlayName = nil;

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    } completion:^(BOOL iFinished) {
		[self resetOverlay];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRPWOverlayDismissNotification object:nil];
    }];
    anOverlayName = [self overlayName];
}


- (NSString *)overlayName {
    NSString *aReturnVal = nil;
    aReturnVal = kStartOverOverlayName;
    
    if (self.overlayType == MyTCSLocationDetailsOverlay) {
        aReturnVal = kLocationDetailsOverlayName;
    }
    
    return aReturnVal;
}


- (void)resetOverlay {
	[self.contentView removeFromSuperview];
	[self.overlayView removeFromSuperview];
	self.overlayView.alpha = 1;
	self.contentView = nil;
}


- (void)createContentViewWithWidth:(CGFloat)iOverlayWidth height:(CGFloat)iOverlayHeight backgroundColor:(UIColor*)iBackgroundColor {
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = CGRectMake(0, 0, iOverlayWidth, iOverlayHeight);

    self.contentView.backgroundColor = iBackgroundColor;
//    self.contentView.backgroundColor = [UIColor greenColor];
}



- (void)createStartOverContentView {
	[self createContentViewWithWidth:kStartOverlayWidth height:kStartOverlayHeight backgroundColor:[UIColor whiteColor]];
    self.contentView.exclusiveTouch = YES;
    
    self.dummyView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart_popup.png"]];
    [self.contentView addSubview:self.dummyView ];
}


- (void)createSizeGuidePopUp:(NSDictionary *)dict{
    [self createContentViewWithWidth:RelativeSize(300, 320) height:RelativeSizeHeight(420, 568) backgroundColor:[UIColor whiteColor]];
    self.customPopUp = [[CustomPopUp alloc] initWithFrame:CGRectMake(0,0,RelativeSize(300, 320), RelativeSizeHeight(420, 568))];
    self.customPopUp.sizeGuideDict = dict;
    [self.customPopUp setBackgroundColor:[UIColor whiteColor]];
    [self.customPopUp fetchGuideImage];
    [self.contentView addSubview:self.customPopUp];
}


- (void)createNearesStoresPopUp:(NSDictionary *)dataDict{
    
//    CGFloat heightForPopUp = RelativeSizeHeight(360, 480);

    CGFloat heightForPopUp = RelativeSizeHeight(400, 480); //[self calculateNearestPopUpHeight];

    [self createContentViewWithWidth:RelativeSize(300, 320) height:heightForPopUp backgroundColor:[UIColor whiteColor]];
    
    self.nearestStorePopUp = [[NearestStorePopUp alloc] initWithFrame:CGRectMake(0,0, RelativeSize(300, 320),heightForPopUp)];
    self.nearestStorePopUp.brandName = [dataDict objectForKey:@"BrandName"];
    self.nearestStorePopUp.brandLogoImageUrl = [dataDict objectForKey:@"BrandLogo"];
    self.nearestStorePopUp.storedData = [dataDict objectForKey:@"PopUpData"];
    
    self.nearestStorePopUp.layer.cornerRadius = 5.0;
    if([dataDict objectForKey:@"isViewAllStores"]){
        self.nearestStorePopUp.isViewAllStores = [[dataDict objectForKey:@"isViewAllStores"] boolValue];
    }
    [self.contentView setClipsToBounds:TRUE];
    [self.nearestStorePopUp generateStores];
    [self.contentView addSubview:self.nearestStorePopUp];
    __weak PopOverlayHandler *overlayWeak = self;
    self.nearestStorePopUp.tapOnCancel = ^(){
        [overlayWeak dismissOverlay];
    };
}


- (CGFloat)calculateNearestPopUpHeight{
    CGFloat popUpHeight = 0.0f;
    CGFloat headerHeight = 100.0f; //60.0f;
    CGFloat cell1Height = 80.0f;

    
    popUpHeight += RelativeSizeHeight(headerHeight, 480);
    popUpHeight += RelativeSizeHeight(cell1Height, 480);
    popUpHeight += 310.0f;//RelativeSizeHeight(cell3Height, 480);
    
    return popUpHeight;
}


- (void)createPinCodePopUp:(NSDictionary *)dataDict{
    [self createContentViewWithWidth:RelativeSize(300, 320) height:RelativeSizeHeight(150, 480) backgroundColor:[UIColor clearColor]];
    
    self.pinCodePopUp= [[PinCodePopUp alloc] initWithFrame:CGRectMake(0,0, RelativeSize(300, 320)
                                                                      , RelativeSizeHeight(150, 480))];

    if(self.pinCodePopUp.frame.size.height <=150.0f){
        [self.pinCodePopUp setFrame:CGRectMake(self.pinCodePopUp.frame.origin.x, self.pinCodePopUp.frame.origin.y, self.pinCodePopUp.frame.size.width,180)];
    }
    
    self.pinCodePopUp.productId = [dataDict objectForKey:@"ProductId"];
    [self.pinCodePopUp configurePopUp];
    [self.pinCodePopUp setBackgroundColor:[UIColor whiteColor]];
    self.pinCodePopUp.layer.cornerRadius = 5.0;
    __weak PopOverlayHandler *overlayWeak = self;
    self.pinCodePopUp.tappedOnCancel = ^(){
        [overlayWeak dismissOverlay];
    };
    
    self.pinCodePopUp.updatePinCodeLayPutBlock=^(CGSize size){
        [overlayWeak updatePinCodeContentView:size];
    };
    self.pinCodePopUp.center = CGPointMake(self.contentView.center.x, self.contentView.center.y+80);
    [self.contentView addSubview:self.pinCodePopUp];
}


- (void)updatePinCodeContentView:(CGSize)size{
    [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, size.width, size.height)];
}


- (void)createTryAtHomePopUp:(NSDictionary *)dataDict{
    [self createContentViewWithWidth:RelativeSize(300, 320) height:RelativeSizeHeight(300, 568) backgroundColor:[UIColor whiteColor]];
    if (self.pickAtStorePopUp) {
        [self.pickAtStorePopUp removeFromSuperview];
        self.pickAtStorePopUp = nil;
    }
    
    self.pickAtStorePopUp = [[PickAtStorePopUp alloc] initWithFrame:CGRectMake(0, 0, RelativeSize(300, 320),RelativeSizeHeight(300, 568))];
    self.pickAtStorePopUp.productSizeArray = [dataDict objectForKey:@"PopUpData"];
    self.pickAtStorePopUp.tryAtHomeDataDict = dataDict;
    
    
    NSInteger popUpType = [[dataDict objectForKey:@"PopUpType"] integerValue];
    if(popUpType==TryAtHomeFirstTimeOverlay){
        self.pickAtStorePopUp.tryHomePopUpType  = TryAtHomeFirstTime;
    }else if(popUpType == TryAtHomeOverlay){
        self.pickAtStorePopUp.tryHomePopUpType  = TryAtHomePDP;
    }else if(popUpType == ExchangeProductOverlay){
        self.pickAtStorePopUp.tryHomePopUpType  = TryAtHomeExchangeItem;
    }else if(popUpType == CartEditSizeOverlay){
        self.pickAtStorePopUp.tryHomePopUpType  = TryAtHomeCart;
    }else if(popUpType == AddCartInBagOverlay){
        self.pickAtStorePopUp.tryHomePopUpType = TryAtHomeAddItemInCart;
    }
    
    [self.pickAtStorePopUp setUpTryAtHome];
    __weak id delegate = self.overlayDelegate;
    __block RPWOverlayType overlayType = self.overlayType;
    self.pickAtStorePopUp.popUpAction =^(TryAtHomeType type){
        if([delegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
            [delegate performActionOnOverlay:0 andPopType:overlayType andInputDictionary:nil];
        }
    };
    
    self.pickAtStorePopUp.cancePopUpBlock=^{
        if([delegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
            [delegate performActionOnOverlay:-1 andPopType:overlayType andInputDictionary:nil];
        }
    };
    
    self.pickAtStorePopUp.addToCartBlock = ^(NSMutableArray *anArrray){
        if([delegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setObject:anArrray forKey:@"selectedSizeData"];
            [delegate performActionOnOverlay:0 andPopType:overlayType andInputDictionary:dict];
        }
    };

    self.contentView.frame = self.pickAtStorePopUp.frame;
    self.pickAtStorePopUp.center = self.contentView.center;
    [self.contentView addSubview:self.pickAtStorePopUp];
}

- (void)showProductInformation:(NSDictionary *)dataDict{

    [self createContentViewWithWidth:300 height:RelativeSizeHeight(80, 568) backgroundColor:[UIColor whiteColor]];
    NSString *productInforString =[dataDict objectForKey:@"PopUpData"];
    CGSize infoSize= [SSUtility getLabelDynamicSize:productInforString withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(280, MAXFLOAT)];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(15 , self.contentView.frame.size.height/2 - infoSize.height/2, infoSize.width, infoSize.height)];
    [info setTextColor:UIColorFromRGB(kSignUpColor)];
    [info setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [info setNumberOfLines:0];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setText:productInforString];//
    [self.contentView addSubview:info];
}


- (void)showRateUsPopUp{
    [self createContentViewWithWidth:300 height:300 backgroundColor:[UIColor whiteColor]];
    
    CGSize titleSize= [SSUtility getLabelDynamicSize:@"Rate Us" withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(280, MAXFLOAT)];
    
    UILabel *rateUsHeading = [SSUtility generateLabel:@"Rate Us" withRect:CGRectMake(self.contentView.frame.size.width/2  -titleSize.width/2, 20, titleSize.width, titleSize.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [rateUsHeading setTextColor:UIColorFromRGB(kSignUpColor)];
    [rateUsHeading setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView addSubview:rateUsHeading];

    
    NSString *rateUsInfo = @"Find us on app store or write a review. You can also email us for suggestion or feedback";

    CGSize infoSize = [SSUtility getDynamicSizeWithSpacing:rateUsInfo withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(280, MAXFLOAT) spacing:5.0f];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2 - infoSize.width/2,rateUsHeading.frame.origin.y + rateUsHeading.frame.size.height + kStorePadding, infoSize.width, infoSize.height)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *tempDict = @{NSFontAttributeName:rateUsInfo
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    
    info.attributedText = [[NSAttributedString alloc]initWithString:rateUsInfo attributes:tempDict];
    
    [info setTextColor:[UIColor blackColor]];
    [info setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [info setNumberOfLines:0];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [info setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:info];

  
    UIButton *appStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    appStoreButton.layer.cornerRadius = 3.0f;
    [appStoreButton setFrame:CGRectMake(self.contentView.frame.size.width/2 - 100 , info.frame.origin.y + info.frame.size.height + kStorePadding, 200, 50)];
    [appStoreButton setClipsToBounds:TRUE];
    appStoreButton.layer.cornerRadius = 3.0f;
    appStoreButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
    appStoreButton.layer.borderWidth = 1.0f;
    [appStoreButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    [appStoreButton setTitle:@"VISIT APP STORE" forState:UIControlStateNormal];
    [appStoreButton addTarget:self action:@selector(navigateToAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [appStoreButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [appStoreButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [appStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appStoreButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [self.contentView addSubview:appStoreButton];
    
    UIButton *emailUs = [UIButton buttonWithType:UIButtonTypeCustom];
    emailUs.layer.cornerRadius = 3.0f;
    [emailUs setFrame:CGRectMake(self.contentView.frame.size.width/2 - 100 , appStoreButton.frame.origin.y + appStoreButton.frame.size.height+kStorePadding, 200, 30)];
    [emailUs setBackgroundColor:[UIColor clearColor]];
    [emailUs setTitle:@"Email Us" forState:UIControlStateNormal];
    [emailUs setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
    [emailUs setTitleColor:UIColorFromRGB(kButtonTouchStateColor) forState:UIControlStateHighlighted];
    emailUs.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [emailUs addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:emailUs];
    
    [self.contentView setFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,emailUs.frame.origin.y + emailUs.frame.size.height+20)];
}


- (void)navigateToAppStore:(id)sender{
    if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
        [self.overlayDelegate performActionOnOverlay:0 andPopType:self.overlayType andInputDictionary:nil];
    }
}
- (void)sendEmail:(id)sender{
    NSMutableDictionary *emailDic = [[NSMutableDictionary alloc] init];
    [emailDic setObject:@"email" forKey:@"action"];
    if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
        [self.overlayDelegate performActionOnOverlay:0 andPopType:self.overlayType andInputDictionary:emailDic];
    }
}

- (void)showActivityIndicatorOverlay{
    [self createContentViewWithWidth:200 height:200 backgroundColor:[UIColor clearColor]];
    
//    UIActivityIndicatorView *loadingSymbol = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [loadingSymbol startAnimating];
//    [loadingSymbol setCenter:CGPointMake(self.contentView.frame.size.width/2,self.contentView.frame.size.height/2)];
//    [self.contentView addSubview:loadingSymbol];
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [image setCenter:CGPointMake(self.contentView.frame.size.width/2,self.contentView.frame.size.height/2)];
    [image setImage:[UIImage imageNamed:@"Loader.gif"]];
    [self.contentView addSubview:image];
}


- (void)displayInvaidCartOverlay:(NSDictionary *)dataDict{
//    [self createContentViewWithWidth:300 height:200 backgroundColor:UIColorFromRGB(0x4d4e65)];
    [self createContentViewWithWidth:300 height:170 backgroundColor:[UIColor whiteColor]];
    
    
    CGSize titleSize= [SSUtility getLabelDynamicSize:@"Undelivered Items" withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(280, MAXFLOAT)];

    UILabel *title = [SSUtility generateLabel:@"Undelivered Items" withRect:CGRectMake(self.contentView.frame.size.width/2  -titleSize.width/2, 20, titleSize.width, titleSize.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [title setTextColor:UIColorFromRGB(kSignUpColor)];
    [title setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView addSubview:title];
    
    NSString *productInforString = [dataDict objectForKey:@"PopUpData"];
    self.popUpResponseData = [dataDict objectForKey:@"ResponseData"];
    CGSize infoSize = [SSUtility getDynamicSizeWithSpacing:productInforString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(280, MAXFLOAT) spacing:5.0f];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2 - infoSize.width/2 , self.contentView.frame.size.height/2 - infoSize.height, infoSize.width, infoSize.height)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *tempDict = @{NSFontAttributeName:productInforString
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    
    info.attributedText = [[NSAttributedString alloc]initWithString:productInforString attributes:tempDict];
    
    [info setTextColor:[UIColor blackColor]];
    [info setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [info setNumberOfLines:0];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:info];
    
    UIButton *backToCart = [UIButton buttonWithType:UIButtonTypeCustom];
    [backToCart setTitle:@"BACK TO CART" forState:UIControlStateNormal];
    [backToCart setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [backToCart setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [backToCart setClipsToBounds:TRUE];
    backToCart.layer.cornerRadius = 3.0f;
    [backToCart addTarget:self action:@selector(backToCart:) forControlEvents:UIControlEventTouchUpInside];
    [backToCart setFrame:CGRectMake(RelativeSize(8, 320), self.contentView.frame.size.height - (RelativeSize(8, 480) +50), self.contentView.frame.size.width - RelativeSize(16, 320), 50)];
    [backToCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backToCart.titleLabel.font = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    [self.contentView addSubview:backToCart];
}

-(void)displayReturnReasonsOverlay:(NSDictionary *)dataDict{
    [self createContentViewWithWidth:RelativeSize(275, 320) height:310 backgroundColor:[UIColor whiteColor]];//RelativeSizeHeight(400, 667)
//    NSString *productInforString = [dataDict objectForKey:@"PopUpData"];
//    self.popUpResponseData = [dataDict objectForKey:@"ResponseData"];
    
    ReturnReasonsView *theReasonsView = [[ReturnReasonsView alloc] initWithFrame:CGRectMake(0, 0, RelativeSize(275, 320), 310)];//RelativeSizeHeight(400, 667)
    [theReasonsView setBackgroundColor:[UIColor whiteColor]];
    [theReasonsView configureWithData:[dataDict objectForKey:@"ResponseData"]];
    theReasonsView.theSaveButton = ^(NSArray *theSelectedResons){
        NSMutableDictionary *reasonsDic = [[NSMutableDictionary alloc] init];
        if ([theSelectedResons count]>0) {
            [reasonsDic setObject:theSelectedResons forKey:@"reasons"];
        }
       if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
            [self.overlayDelegate performActionOnOverlay:0 andPopType:self.overlayType andInputDictionary:reasonsDic];
        }
    };
    theReasonsView.theCancelButton = ^(){
        if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
            [self.overlayDelegate performActionOnOverlay:-1 andPopType:self.overlayType andInputDictionary:nil];
        }
    };
    [self.contentView addSubview:theReasonsView];
}


- (void)showCustomAlert:(NSDictionary *)dataDict{
    
    [self createContentViewWithWidth:300 height:170 backgroundColor:[UIColor whiteColor]];
    
    NSString *alertTitle = [dataDict objectForKey:@"Alert Title"];
    CGSize titleSize= [SSUtility getLabelDynamicSize:alertTitle withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f] withSize:CGSizeMake(280, MAXFLOAT)];
    
    UILabel *title = [SSUtility generateLabel:alertTitle withRect:CGRectMake(self.contentView.frame.size.width/2  -titleSize.width/2, 20, titleSize.width, titleSize.height) withFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [title setTextColor:UIColorFromRGB(kSignUpColor)];
    [title setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView addSubview:title];
    
    NSString *productInforString = [dataDict objectForKey:@"Alert Message"];
    CGSize infoSize = [SSUtility getDynamicSizeWithSpacing:productInforString withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(280, MAXFLOAT) spacing:5.0f];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width/2 - infoSize.width/2 , self.contentView.frame.size.height/2 - infoSize.height, infoSize.width, infoSize.height)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *tempDict = @{NSFontAttributeName:productInforString
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    
    info.attributedText = [[NSAttributedString alloc]initWithString:productInforString attributes:tempDict];
    
    [info setTextColor:[UIColor blackColor]];
    [info setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [info setNumberOfLines:0];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:info];
    
//    NSInteger offSet = info.frame.origin.y + info.frame.size.height + 30;
    NSInteger offSet = self.contentView.frame.size.height - (60);
    UIView *alertActionView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x, offSet, self.contentView.frame.size.width, 50)];
    [alertActionView setBackgroundColor:[UIColor clearColor]];
    NSString *leftButtonStr =  [dataDict objectForKey:@"LeftButtonTitle"];
    NSInteger addToCartStartPoint =10;
    
    if(leftButtonStr && leftButtonStr.length > 0){
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.layer.cornerRadius = 3.0f;
        [leftButton setClipsToBounds:YES];
        [leftButton setFrame:CGRectMake(addToCartStartPoint,0 , (self.contentView.frame.size.width -3*addToCartStartPoint)/2 , 50)];
        [leftButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D4D5)] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xE4E5E6)] forState:UIControlStateHighlighted];
        [leftButton setTitle:leftButtonStr forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(customAlertCancel:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:14.0f];
        [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [alertActionView addSubview:leftButton];
        addToCartStartPoint+=  leftButton.frame.origin.x + leftButton.frame.size.width;
        offSet = leftButton.frame.origin.y ;
    }
    
    NSString *rightButtonStr =  [dataDict objectForKey:@"RightButtonTitle"];
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.layer.cornerRadius = 3.0f;
    [rightBtn setClipsToBounds:YES];
    [rightBtn setFrame:CGRectMake(addToCartStartPoint, 0 , self.contentView.frame.size.width-addToCartStartPoint-10, 50)];
    [rightBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [rightBtn setTitle:rightButtonStr forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:14.0f];
    [rightBtn addTarget:self action:@selector(customAlertDone:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [alertActionView addSubview:rightBtn];
    [self.contentView addSubview:alertActionView];
    
}

- (void)customAlertCancel:(id)sender{
    if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
        [self.overlayDelegate performActionOnOverlay:-1 andPopType:self.overlayType andInputDictionary:self.popUpResponseData];
    }
}

- (void)customAlertDone:(id)sender{
    if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
        [self.overlayDelegate performActionOnOverlay:200 andPopType:self.overlayType andInputDictionary:self.popUpResponseData];
    }
}

- (void)backToCart:(id)sender{
    if([self.overlayDelegate respondsToSelector:@selector(performActionOnOverlay:andPopType:andInputDictionary:)]){
        [self.overlayDelegate performActionOnOverlay:0 andPopType:self.overlayType andInputDictionary:self.popUpResponseData];
    }
}


- (void)showAddCartPopUp{
    
    [self createContentViewWithWidth:RelativeSize(300, 320) height:RelativeSizeHeight(150, 680) backgroundColor:[UIColor clearColor]];
    
    self.addCartPopUp= [[AddCartPopUp alloc] initWithFrame:CGRectMake(0,0, RelativeSize(300, 320)
                                                                      , RelativeSizeHeight(150, 680))];
    
    [self.addCartPopUp configureAddCart];
    [self.addCartPopUp setBackgroundColor:[UIColor whiteColor]];
    self.addCartPopUp.layer.cornerRadius = 5.0;
    __weak PopOverlayHandler *overlayWeak = self;
//    self.pinCodePopUp.tappedOnCancel = ^(){
//        [overlayWeak dismissOverlay];
//    };
//    
//    self.pinCodePopUp.updatePinCodeLayPutBlock=^(CGSize size){
//        [overlayWeak updatePinCodeContentView:size];
//    };
    self.addCartPopUp.center = CGPointMake(self.contentView.center.x, self.contentView.center.y+80);
    [self.contentView addSubview:self.addCartPopUp];
}


@end
