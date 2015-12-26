//
//  ProductDetailView.m
//  ParallexPDPSample
//
//  Created by Pranav on 08/07/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "ProductDetailView.h"
#import "PDPMoreDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomPopUp.h"
#import "SSLine.h"
#import "SSUtility.h"
#import "PDPHandler.h"

//#define HELVETICA_BOLD   @"Helvetica-Bold"
//#define HELVETICA        @"Helvetica"
//#define HELVETICA_NEUE_ITALIC      @"HelveticaNeue-Italic"
//#define HELVETICA_NEUE      @"HelveticaNeue"
//#define HelveticaNeue_Thin @"HelveticaNeue-Thin"





@interface ProductDetailView()<PDPMoreDetailDelegate>

@property (nonatomic,strong) UIImageView *logoImage;
@property (nonatomic,strong) UILabel     *productName;
@property (nonatomic,strong) UILabel     *productPrice;
@property (nonatomic,strong) UILabel     *strikeOutPrice;
@property (nonatomic,strong) UILabel     *discountAmount;
@property (nonatomic,strong) UIButton *likeImage;
@property (nonatomic,strong) UILabel     *likeCount;
@property (nonatomic,strong) UIImageView *pickSizeImage;
@property (nonatomic,strong) UILabel     *pickSizeHeading;

@property (nonatomic,strong) UIButton     *sizeGuide;
@property (nonatomic,strong) UIScrollView *sizeScrollContainer;

@property (nonatomic,strong) UIImageView  *coupanImage;
@property (nonatomic,strong) UILabel      *availableCoupans;

@property (nonatomic,strong) UIView        *deliveryOptionView;
@property (nonatomic,strong) UIView        *nearestStoreView;

@property (nonatomic,strong) UIButton      *tryAtHomeButton;
@property (nonatomic,strong) UIButton      *pickAtStoreButton;
//@property (nonatomic,strong) UIButton      *addToCartButton;

@property (nonatomic,strong) PDPMoreDetail *pdpMoreDetail;
@property (nonatomic,strong) UIView        *feedBackView;


@property (nonatomic, strong) GridView *suggestedProductView;
@property (nonatomic,strong)  CustomPopUp *popUp;
@property (nonatomic,strong) NSMutableArray *sizeBtnArray;
@property (nonatomic,strong) UIImageView *pdpCurveImage;
@property (nonatomic,strong) PDPHandler     *pdpRequestHandler;
@property (nonatomic,strong) NSMutableArray *selectedSize;
@property (nonatomic,strong) UIView         *storeCotainer;
@property (nonatomic,assign) NSInteger      productDetailY;


- (void)generateProductInfo;
- (UIView*)generateFirstStrip;
- (UIView*)generateSecondStrip;
- (UIView*)generateThirdStrip;
- (UIView *)checkDeliveryOptionsView;
- (UIView*)generateNearestStoreView;
- (void)generateNearestStoreContainer;
- (void)generatePDPMoreDetals;
- (UIView *)generateFeedBackView;
@end

@implementation ProductDetailView
@synthesize soundFileURLRef;
@synthesize soundFileObject;
#define kPDP_X_Padding 10.0f


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    return self;
}

- (void)generateProductInfo{
    
    self.firstStripView =  [self generateFirstStrip];
    [self.firstStripView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.firstStripView];
    
    self.secondStripView = [self generateSecondStrip];
    [self.secondStripView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.secondStripView];
//    self.floatingButtonsStartingFrame = CGRectMake(self.frame.origin.x
//                                              , self.firstStripView.frame.origin.y + self.firstStripView.frame.size.height-5, self.firstStripView.frame.size.width, self.firstStripView.frame.size.height);
    self.floatingButtonsStartingFrame = CGRectMake(self.frame.origin.x
                                                   , self.firstStripView.frame.origin.y + self.firstStripView.frame.size.height-5 + 5, self.firstStripView.frame.size.width, self.firstStripView.frame.size.height);

    self.floatingButtonsFixedFrame = CGRectMake(self.frame.origin.x, self.secondStripView.frame.origin.y + self.secondStripView.frame.size.height,self.frame.size.width, 50);
    
    self.thirdStripView = [self generateThirdStrip];
    [self.thirdStripView setBackgroundColor:[UIColor whiteColor]];
    self.originalFrame = self.thirdStripView.frame;
    [self addSubview:self.thirdStripView];
    
    self.productDetailY = self.floatingButtonsFixedFrame.origin.y + self.floatingButtonsFixedFrame.size.height +13;
    
    if(self.productData.productDescription && [self.productData.productDescription count]>0)
//    if(0)
    {
        [self generatePDPMoreDetals];
    }else{
        [self moreInfoTabChanged:0];
    }
   
    
    self.deliveryOptionView =[self checkDeliveryOptionsView];
    self.deliveryOptionView.layer.cornerRadius = 3.0f;
    [self.deliveryOptionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.deliveryOptionView];
    
    self.nearestStoreView = [self generateNearestStoreView];
    self.nearestStoreView.layer.cornerRadius = 3.0f;
    [self addSubview:self.nearestStoreView];
    
    self.feedBackView = [self generateFeedBackView];
    self.feedBackView.layer.cornerRadius = 3.0f;
    [self.feedBackView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.feedBackView];
    
    if(self.productData.suggestedProductList!=nil && self.productData.suggestedProductList.length >0)
    {
        [self showSuggestedProducts];
    }
}


- (void)generateNearestStoreContainer{
    
//    self.storeCotainer = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.pdpMoreDetail.frame.origin.y + self.pdpMoreDetail.frame.size.height+10, self.frame.size.width - 2*kPDP_X_Padding, 160)];
     self.storeCotainer = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.productDetailY, self.frame.size.width - 2*kPDP_X_Padding, 160)];
    
    
    [self.storeCotainer setBackgroundColor:[UIColor yellowColor]];
    [self addSubview:self.storeCotainer];
    
    self.deliveryOptionView =[self checkDeliveryOptionsView];
    self.deliveryOptionView.layer.cornerRadius = 3.0f;
    [self.deliveryOptionView setBackgroundColor:[UIColor whiteColor]];
    [self.storeCotainer addSubview:self.deliveryOptionView];
    
    self.nearestStoreView = [self generateNearestStoreView];
    self.nearestStoreView.layer.cornerRadius = 3.0f;
    [self.storeCotainer addSubview:self.nearestStoreView];
}

- (void)feedBack:(id)sender{
    if([self.detailDelegate respondsToSelector:@selector(displayFeedBack)]){
        [self.detailDelegate displayFeedBack];
    }
}

- (UIView*)generateFirstStrip{

    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width, 80)];
    [aView setBackgroundColor:[UIColor clearColor]];
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, RelativeSizeHeight(40, 568), RelativeSizeHeight(40, 568))];
    [self.logoImage setBackgroundColor:[UIColor clearColor]];
    self.logoImage.layer.borderWidth =1.0f;
    self.logoImage.layer.borderColor = UIColorFromRGB(kBorderColor).CGColor;
    [self.logoImage.layer setCornerRadius:3.0f];
    self.logoImage.clipsToBounds = TRUE;

    ImageData *logoData = self.productData.logoImageData;
    if(logoData.imageUrl && logoData.imageUrl.length >0)
    {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoData.imageUrl]];
        [self.logoImage setImage:[UIImage imageWithData:imageData]];
//                [self.logoImage setImage:[UIImage imageNamed:@"lee.jpg"]];
    }
    
    [aView addSubview:self.logoImage];
    self.productName = [[UILabel alloc] initWithFrame:CGRectMake(self.logoImage.frame.origin.x + self.logoImage.frame.size.width + 10, self.logoImage.frame.origin.y, 216, 20)];
    [self.productName setBackgroundColor:[UIColor clearColor]];
    [self.productName setText:self.productData.productName];
    [self.productName setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
    [aView addSubview:self.productName];

    UIImage *image = [UIImage imageNamed:@"WishlistLargeFilled"];
    self.likeImage = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width -44, self.productName.frame.origin.y, image.size.width, image.size.height)];
    [self.likeImage setBackgroundColor:[UIColor clearColor]];
    if(self.productData.productBookMerked)
        [self.likeImage setBackgroundImage:[UIImage imageNamed:@"WishlistLargeFilled"] forState:UIControlStateNormal];
    else
        [self.likeImage setBackgroundImage:[UIImage imageNamed:@"WishlistLarge"] forState:UIControlStateNormal];
    [self.likeImage addTarget:self action:@selector(toggleLike) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:self.likeImage];
    

    NSString *priceString = [NSString stringWithFormat:@"%@ %@",kRupeeSymbol,self.productData.productEffectivePrice];
    UIFont *price_String = [UIFont fontWithName:kMontserrat_Regular size:14.0f];
    CGSize priceSize = [SSUtility getLabelDynamicSize:priceString withFont:price_String withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.productPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.productName.frame.origin.x, self.productName.frame.origin.y + self.productName.frame.size.height, priceSize.width, priceSize.height)];
    [self.productPrice setBackgroundColor:[UIColor clearColor]];

    [self.productPrice setText:priceString];
    [self.productPrice setFont:price_String];
    [self.productPrice setTextColor:UIColorFromRGB(kSignUpColor)];
    [aView addSubview:self.productPrice];
    
    if(![self.productData.productEffectivePrice isEqualToString:self.productData.productMarkedPrice]){
        NSString *str = [NSString stringWithFormat:@" %@ %@ ", kRupeeSymbol,self.productData.productMarkedPrice];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeString addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)
                                         , NSStrikethroughColorAttributeName: UIColorFromRGB(kRedColor)
                                         } range:NSMakeRange(0, str.length)];

        
        CGSize markedOutPriceSize = [SSUtility getLabelDynamicSize:str withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        self.strikeOutPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.productPrice.frame.origin.x + self.productPrice.frame.size.width +5, self.productPrice.frame.origin.y+2, markedOutPriceSize.width, markedOutPriceSize.height)];
        [self.strikeOutPrice setBackgroundColor:[UIColor clearColor]];
        [self.strikeOutPrice setAttributedText:attributeString];
//        [self.strikeOutPrice setTextColor:UIColorFromRGB(kLightGreyColor)];
        [self.strikeOutPrice setTextColor:UIColorFromRGB(kRedColor)];
        [self.strikeOutPrice setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
        [aView addSubview:self.strikeOutPrice];
        
    }
    
    if(self.productData.discount && self.productData.discount.length > 0){
        if(![[self.productData.discount uppercaseString] isEqualToString:@"NONE"]){
            CGSize discountAmountSize = [SSUtility getLabelDynamicSize:self.productData.discount withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.discountAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.strikeOutPrice.frame.origin.x + self.strikeOutPrice.frame.size.width +5, self.strikeOutPrice.frame.origin.y, discountAmountSize.width, discountAmountSize.height)];
            [self.discountAmount setBackgroundColor:[UIColor clearColor]];
            [self.discountAmount setText:self.productData.discount];
            [self.discountAmount setTextColor:UIColorFromRGB(kRedColor)];
            [self.discountAmount setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
            [aView addSubview:self.discountAmount];
        }
    }

    if(self.productData.badge && self.productData.badge.length > 0){
        CGSize badgeLabelSize = [SSUtility getLabelDynamicSize:self.productData.badge withFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.productPrice.frame.origin.x, self.productPrice.frame.origin.y + self.productPrice.frame.size.height, badgeLabelSize.width, badgeLabelSize.height)];
        [self.badgeLabel setBackgroundColor:[UIColor clearColor]];
        [self.badgeLabel setText:self.productData.badge];
        [self.badgeLabel setTextColor:UIColorFromRGB(kRedColor)];
        [self.badgeLabel setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];

        [aView addSubview:self.badgeLabel];
    }

    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(aView.frame.origin.x+10, aView.frame.origin.y + aView.frame.size.height-3, aView.frame.size.width-20, 1)];
    [aView addSubview:line];
    
    return aView;
}


#define kSizeButtonsPadding 10
#define kSizeButtonWidth    45
#define kSizeBoxCount       8
- (UIView*)generateSecondStrip{
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.firstStripView.frame.origin.y + self.firstStripView.frame.size.height, self.firstStripView.frame.size.width, self.firstStripView.frame.size.height)];
    [bView setBackgroundColor:[UIColor clearColor]];
    
    self.pickSizeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 32, 32)];
    [self.pickSizeImage setBackgroundColor:[UIColor clearColor]];
    [self.pickSizeImage setImage:[UIImage imageNamed:@"Size"]];
    [bView addSubview:self.pickSizeImage];
    

    self.pickSizeHeading = [[UILabel alloc] initWithFrame:CGRectMake(self.pickSizeImage.frame.origin.x + self.pickSizeImage.frame.size.width, self.pickSizeImage.frame.origin.y + self.pickSizeImage.frame.size.height/2 -10, 100, 20)];
    [self.pickSizeHeading setBackgroundColor:[UIColor clearColor]];
    [self.pickSizeHeading setText:@"Pick Size"];
    [self.pickSizeHeading setTextColor:UIColorFromRGB(KTextColor)];
    [self.pickSizeHeading setFont:[UIFont fontWithName:kMontserrat_Regular size:16.0f]];
    [bView addSubview:self.pickSizeHeading];
    
    if(self.productData.sizeGuideImageData.imageUrl!=nil && self.productData.sizeGuideImageData.imageUrl.length >0)
    {
        self.sizeGuide = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sizeGuide setBackgroundColor:[UIColor clearColor]];
        [self.sizeGuide setTitle:@"Size Guide" forState:UIControlStateNormal];
        [self.sizeGuide setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
        [self.sizeGuide setTitleColor:UIColorFromRGB(kButtonTouchStateColor) forState:UIControlStateHighlighted];
        

        [self.sizeGuide setFrame:CGRectMake(self.frame.size.width -(100), self.pickSizeHeading.frame.origin.y, 100, 20)];
        [self.sizeGuide.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
        [self.sizeGuide addTarget:self action:@selector(displaySizeGuide:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:self.sizeGuide];
    }
    
    self.sizeScrollContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(kSizeButtonsPadding, self.pickSizeHeading.frame.origin.y + self.pickSizeHeading.frame.size.height + kPDP_X_Padding-2, bView.frame.size.width -5, kSizeButtonsPadding + kSizeButtonWidth)];
    self.sizeScrollContainer.showsHorizontalScrollIndicator = NO;
    [self.sizeScrollContainer setBackgroundColor:[UIColor clearColor]];

    
    NSInteger sizeBoxCount = [self.productData.sizeArray count];
    CGFloat calculateSize = sizeBoxCount *kSizeButtonWidth + (sizeBoxCount+1)*kSizeButtonsPadding;
    [self.sizeScrollContainer setContentSize:CGSizeMake(calculateSize,self.sizeScrollContainer.frame.size.height)];
    self.sizeBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger counter=0; counter < sizeBoxCount; counter++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = counter;
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderColor = UIColorFromRGB(0xBDBDBD).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 5.0f;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:12.0f]];
        [btn addTarget:self action:@selector(sizeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.sizeBtnArray addObject:btn];
        
        ProductSize *sizeData = [self.productData.sizeArray objectAtIndex:counter];

        if(sizeData.sizeDisplay != (id)[NSNull null])
            [btn setTitle:sizeData.sizeDisplay forState:UIControlStateNormal];
        else
            [btn setTitle:@"OP" forState:UIControlStateNormal];
        
        [btn setFrame:CGRectMake((counter+1)*kSizeButtonsPadding + counter*kSizeButtonWidth, 5, kSizeButtonWidth, kSizeButtonWidth)];
        
        if(sizeData.sizeAvailable){
            btn.enabled = TRUE;
            btn.alpha = 1.0f;
        }else{
            btn.enabled = FALSE;
            btn.alpha = 0.2f;
        }
        [self.sizeScrollContainer addSubview:btn];
    }
    [bView addSubview:self.sizeScrollContainer];
    [self.sizeScrollContainer setBackgroundColor:[UIColor clearColor]];
    
    
    self.coupanImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.sizeScrollContainer.frame.origin.x, self.sizeScrollContainer.frame.origin.y + self.sizeScrollContainer.frame.size.height + 12, 32, 32)];
    [self.coupanImage setBackgroundColor:[UIColor clearColor]];
    [self.coupanImage setImage:[UIImage imageNamed:@"Coupons"]];
//    [bView addSubview:self.coupanImage];


    CGFloat previousHeight = self.coupanImage.frame.origin.y;
    if ([self.productData.coupans count]>0)
    {
        [bView addSubview:self.coupanImage];
        UILabel *coupon = [[UILabel alloc] initWithFrame:CGRectMake(self.coupanImage.frame.origin.x + self.coupanImage.frame.size.width,previousHeight, 300, 32)];
        [coupon setBackgroundColor:[UIColor clearColor]];

        NSMutableAttributedString * storeString1 = [[NSMutableAttributedString alloc] initWithString:@"Use Coupon Code " attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Light size:14.0f], NSForegroundColorAttributeName : UIColorFromRGB(kSignUpColor)}];
        
       NSAttributedString * storesString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.productData.coupans objectAtIndex:0]] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMontserrat_Regular size:14.0f], NSForegroundColorAttributeName : UIColorFromRGB(kPinkColor)}];
        
        [storeString1 appendAttributedString:storesString2];
        
        [coupon setAttributedText:storeString1];
        previousHeight+= coupon.frame.size.height;
        [bView addSubview:coupon];
        
        //    }
    }
    [bView setFrame:CGRectMake(bView.frame.origin.x, bView.frame.origin.y, bView.frame.size.width, previousHeight + 20)];//37
    
    return bView;
}

- (UIView*)generateThirdStrip{
    
     //  New PDP Changes
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.floatingButtonsStartingFrame.origin.y-15 , self.frame.size.width, 64)];
     [cView setBackgroundColor:[UIColor whiteColor]];

    NSInteger addToCartStartPoint =8;
//    if(self.productData.isTryAtHomeAvailable)
    if(self.productData.isTryAtHomeAvailable && (self.productData.fyndAFitDictonary!= nil && [[self.productData.fyndAFitDictonary allKeys] count]>0) )
    {

        self.tryAtHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tryAtHomeButton.layer.cornerRadius = 3.0f;

        [self.tryAtHomeButton setFrame:CGRectMake(addToCartStartPoint, self.pickAtStoreButton.frame.origin.y + 8, (self.frame.size.width -((2*addToCartStartPoint) +12))/2, 50)];

        [self.tryAtHomeButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonPurpleColor)] forState:UIControlStateNormal];
        [self.tryAtHomeButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonPurpleTouchColor)] forState:UIControlStateHighlighted];
        [self.tryAtHomeButton setClipsToBounds:YES];
        [self.tryAtHomeButton setTitle:@"FYND A FIT" forState:UIControlStateNormal];
        self.tryAtHomeButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:14.0f];
        [self.tryAtHomeButton addTarget:self action:@selector(pickAtStore:) forControlEvents:UIControlEventTouchUpInside];
        
        [cView addSubview:self.tryAtHomeButton];
        addToCartStartPoint+=  self.tryAtHomeButton.frame.origin.x + self.tryAtHomeButton.frame.size.width;
    }

    self.addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addToCartButton.layer.cornerRadius = 3.0f;
    [self.addToCartButton setFrame:CGRectMake(addToCartStartPoint, self.pickAtStoreButton.frame.origin.y+8, self.frame.size.width - (addToCartStartPoint+8), 50)];
    [self.addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [self.addToCartButton setClipsToBounds:YES];
    [self.addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToCartButton addTarget:self action:@selector(addItemToCart:) forControlEvents:UIControlEventTouchUpInside];
    self.addToCartButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:14.0f];
    [cView addSubview:self.addToCartButton];

    
    
    /* // New PDP Changes
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(cView.frame.origin.x, self.addToCartButton.frame.origin.y + self.addToCartButton.frame.size.height+10, cView.frame.size.width, 1)];
    [cView addSubview:line];
     */
    
    return cView;
}

-(void)updateButtonsFrame:(CGRect)rect{
        [self.thirdStripView setFrame:CGRectMake(self.frame.origin.x, rect.origin.y , self.frame.size.width, 68)];
}

- (void)addItemToCart:(id)sender{
    
    BOOL aBool= FALSE;
    if(self.isItemAddedIntoCart)
        aBool = TRUE;
        
    if(self.addCartItemBlock){
        self.addCartItemBlock(self.selectedSize,aBool);
    }
}


- (void)updateAddToCartButton{

    if(self.isItemAddedIntoCart){

        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.addToCartButton setAlpha:0.1];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.addToCartButton setAlpha:1.0];
                [self.addToCartButton setTitle:@"CHECKOUT" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }else

        [self.addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
}



- (UIView *)checkDeliveryOptionsView{
//    UIView *storeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.pdpMoreDetail.frame.origin.y + self.pdpMoreDetail.frame.size.height+10, self.frame.size.width - 2*kPDP_X_Padding, 50)];
    UIView *storeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.productDetailY, self.frame.size.width - 2*kPDP_X_Padding, 50)];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDeliveryOptions:)];
    tapGesture.numberOfTapsRequired = 1;
    [storeView addGestureRecognizer:tapGesture];
    
    UIButton *checkDlvryInvisibleButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, storeView.frame.size.width - 0, storeView.frame.size.height - 0)];
    [checkDlvryInvisibleButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [checkDlvryInvisibleButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xE4E5E6)] forState:UIControlStateHighlighted];
    [checkDlvryInvisibleButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];


    [checkDlvryInvisibleButton addTarget:self action:@selector(showDeliveryOptions:) forControlEvents:UIControlEventTouchUpInside];
    [storeView addSubview:checkDlvryInvisibleButton];
    storeView.clipsToBounds = YES;
    
    UIImageView *checkDeliveryImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, storeView.frame.size.height/2 - 16,32, 32)];
    [checkDeliveryImage setBackgroundColor:[UIColor clearColor]];
    [checkDeliveryImage setImage:[UIImage imageNamed:@"Delivery"]];
    [storeView addSubview:checkDeliveryImage];

    
    UIButton *checkDeliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkDeliveryBtn setFrame:CGRectMake(checkDeliveryImage.frame.origin.x + checkDeliveryImage.frame.size.width+5,checkDeliveryImage.frame.origin.y + checkDeliveryImage.frame.size.height/2 - 15, 250, 30)];
    [checkDeliveryBtn setUserInteractionEnabled:FALSE];
    [checkDeliveryBtn setBackgroundColor:[UIColor clearColor]];
    [checkDeliveryBtn setTitle:@"Check Delivery Options" forState:UIControlStateNormal];
    [checkDeliveryBtn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
//    [checkDeliveryBtn addTarget:self action:@selector(showDeliveryOptions:) forControlEvents:UIControlEventTouchUpInside];
    [checkDeliveryBtn setTitleColor:UIColorFromRGB(KTextColor) forState:UIControlStateNormal];
    checkDeliveryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [storeView addSubview:checkDeliveryBtn];
    
    /*
    UIImage* sourceImage = [UIImage imageNamed:kBackButtonImage];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                                scale:sourceImage.scale
                                          orientation:UIImageOrientationUpMirrored];
     */
    
    /*
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 36-15, storeView.frame.size.height/2 - 14,28, 28)];
    [arrowImage setBackgroundColor:[UIColor clearColor]];
//    [arrowImage setImage:flippedImage];
     */
    [storeView addSubview:[self getBackImageforView:storeView.frame.size.height/2+1]];
    
    [storeView setBackgroundColor:[UIColor whiteColor]];
    
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(0, storeView.frame.size.height-1, storeView.frame.size.width, 1)];
    [storeView addSubview:line];
    
    return storeView;
}

- (void)showDeliveryOptions:(id)sender{
    if([self.detailDelegate respondsToSelector:@selector(displayPopUp:withUserInput:)]){
        [self.detailDelegate displayPopUp:PDPPinCodePopUp withUserInput:nil];
    }
}

-(UIView *)generateNearestStoreView{
    
    UIView *nearStoreView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kPDP_X_Padding, self.checkDeliveryOptionsView.frame.origin.y + self.checkDeliveryOptionsView.frame.size.height, self.frame.size.width-2*kPDP_X_Padding, 150)];

    [nearStoreView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(10,5, 32, 32)];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:[UIImage imageNamed:@"Store"]];
    [nearStoreView addSubview:imageView];
    
    UILabel *nearestStoreName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width+5,imageView.frame.origin.y + imageView.frame.size.height/2 - 10 , 180, 20)];
    [nearestStoreName setBackgroundColor:[UIColor clearColor]];
    [nearestStoreName setText:@"Nearest Store"];
    [nearestStoreName setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [nearestStoreName setTextColor:UIColorFromRGB(KTextColor)];
    [nearStoreView addSubview:nearestStoreName];

    if ([self.productData.stores count]>0) {
        Store *nearestStore = [self.productData.stores objectAtIndex:0];
        NSString *storeName = [NSString stringWithFormat:@"%@",nearestStore.storeName];
        //@"Phoenix Mall, Lower Parel";//
        CGSize storeNameSize = [SSUtility getLabelDynamicSize:storeName withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
        
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+7, imageView.frame.origin.y + imageView.frame.size.height +0, storeNameSize.width + 10, 20)];
        [address setBackgroundColor:[UIColor clearColor]];
        
        
        [address setText:storeName];
        [address setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [address setTextColor:UIColorFromRGB(kTurquoiseColor)];
        [nearStoreView addSubview:address];
        
        UILabel *storeDistance = [[UILabel alloc] initWithFrame:CGRectMake(address.frame.origin.x+address.frame.size.width, address.frame.origin.y, 250, 20)];
        [storeDistance setBackgroundColor:[UIColor clearColor]];
        NSString *storeDistanceValue = [NSString stringWithFormat:@"(%@)",nearestStore.storeDistance];
        
        [storeDistance setText:storeDistanceValue];
        [storeDistance setFont:[UIFont fontWithName:kMontserrat_Light size:12.0f]];
        [storeDistance setTextColor:UIColorFromRGB(kLightGreyColor)];
        [nearStoreView addSubview:storeDistance];
        
        CGSize detailAddressSize = [SSUtility getLabelDynamicSize:nearestStore.storeAddress withFont:[UIFont fontWithName:kMontserrat_Light size:13.0f] withSize:CGSizeMake(self.frame.size.width - (address.frame.origin.x + 3*kPDPElementsPadding), MAXFLOAT)];

        UILabel *addressDetail = [[UILabel alloc] initWithFrame:CGRectMake(address.frame.origin.x, address.frame.origin.y + address.frame.size.height +5, detailAddressSize.width, detailAddressSize.height)];
        [addressDetail setBackgroundColor:[UIColor clearColor]];
        [addressDetail setNumberOfLines:0];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        
        NSDictionary *tempDict = @{NSFontAttributeName:[UIFont fontWithName:kMontserrat_Light size:13.0f]
                                   ,NSParagraphStyleAttributeName:paragraphStyle};
        
        
        addressDetail.attributedText = [[NSAttributedString alloc]initWithString:nearestStore.storeAddress attributes:tempDict];
        
//        [addressDetail setText:nearestStore.storeAddress];
        [addressDetail setTextColor:UIColorFromRGB(kLightGreyColor)];
        [addressDetail setFont:[UIFont fontWithName:kMontserrat_Light size:13.0f]];
        [nearStoreView addSubview:addressDetail];

        
        UIButton *seeAllStores = [UIButton buttonWithType:UIButtonTypeCustom];
        [seeAllStores setBackgroundColor:[UIColor clearColor]];
        seeAllStores.tag = 20;
        [seeAllStores setFrame:CGRectMake(address.frame.origin.x, addressDetail.frame.origin.y + addressDetail.frame.size.height+5, 120, 35)];//40
        [seeAllStores.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        [seeAllStores setTitle:@"View All Stores" forState:UIControlStateNormal];
        [seeAllStores.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [seeAllStores setTitleColor:UIColorFromRGB(kTurquoiseColor) forState:UIControlStateNormal];
        [seeAllStores setTitleColor:UIColorFromRGB(kButtonTouchStateColor) forState:UIControlStateHighlighted];
        [seeAllStores addTarget:self action:@selector(displayAllStores:) forControlEvents:UIControlEventTouchUpInside];
        [nearStoreView addSubview:seeAllStores];
        
        
        UIImageView *indicatoreImage= [[UIImageView alloc] initWithFrame:CGRectMake(nearStoreView.frame.size.width -15, seeAllStores.frame.origin.y +  seeAllStores.frame.size.height/2, 6,11)];
        [indicatoreImage setBackgroundColor:[UIColor clearColor]];
        [indicatoreImage setImage:[UIImage imageNamed:@"CheckDelivery_arrow.png"]];
//        [nearStoreView addSubview:indicatoreImage];
        
        [nearStoreView addSubview:[self getBackImageforView:(seeAllStores.frame.origin.y +  seeAllStores.frame.size.height/2)]];
        
        [nearStoreView setFrame:CGRectMake(nearStoreView.frame.origin.x, nearStoreView.frame.origin.y, nearStoreView.frame.size.width,seeAllStores.frame.origin.y + seeAllStores.frame.size.height+kPDPElementsPadding)];
    }
    return nearStoreView;
}

- (void)displayAllStores:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if([self.detailDelegate respondsToSelector:@selector(displayPopUp:withUserInput:)]){
        if(btn.tag==20)
            [self.detailDelegate displayPopUp:PDPSeeAllStorePopUp withUserInput:nil];
        else
            [self.detailDelegate displayPopUp:PDPPickAtStorePopUp withUserInput:nil];
    }
}

- (void)pickAtStore:(id)sender{
    if([self.detailDelegate respondsToSelector:@selector(displayPopUp:withUserInput:)]){
        [self.detailDelegate displayPopUp:PDPTRYAtHomePopUp withUserInput:nil];
    }
}


- (void)generatePDPMoreDetals{
//    self.pdpMoreDetail = [[PDPMoreDetail alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.floatingButtonsFixedFrame.origin.y + self.floatingButtonsFixedFrame.size.height +13, self.frame.size.width - 2*kPDP_X_Padding, 40)];
     self.pdpMoreDetail = [[PDPMoreDetail alloc] initWithFrame:CGRectMake(self.frame.origin.x + kPDP_X_Padding, self.productDetailY, self.frame.size.width - 2*kPDP_X_Padding, 40)];
    self.pdpMoreDetail.layer.cornerRadius = 3.0f;
    self.pdpMoreDetail.moreDetailDelegate = self;

    [self moreInfoTabChanged:0];
    
    self.pdpMoreDetail.productMoreDescription = self.productData.productDescription;

    [self.pdpMoreDetail generatePDPMoreDetail];
    [self addSubview:self.pdpMoreDetail];
   
    self.productDetailY = self.pdpMoreDetail.frame.origin.y + self.pdpMoreDetail.frame.size.height + 10;
    
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.pdpMoreDetail.frame.origin.y + self.pdpMoreDetail.frame.size.height)];
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + self.pdpMoreDetail.frame.size.height)];
}

- (UIView *)generateFeedBackView{

    UIView *feedbackView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x+kPDP_X_Padding, self.nearestStoreView.frame.origin.y + self.nearestStoreView.frame.size.height+ kPDP_X_Padding, self.frame.size.width - 2*kPDP_X_Padding, 50)];

    UITapGestureRecognizer *feedBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedBack:)];
    [feedbackView addGestureRecognizer:feedBackGesture];

    UIButton *feedBackInvisibleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, feedbackView.frame.size.width, feedbackView.frame.size.height)];
    [feedBackInvisibleButton setBackgroundImage:[SSUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [feedBackInvisibleButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xE4E5E6)] forState:UIControlStateHighlighted];
    [feedBackInvisibleButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xF4F4F4)] forState:UIControlStateHighlighted];
    [feedBackInvisibleButton addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchUpInside];
    [feedbackView addSubview:feedBackInvisibleButton];
    
    
    UIImageView *feedBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(RelativeSize(10, 320), feedbackView.frame.size.height/2 - 16, 32, 32)];
    [feedBackImage setBackgroundColor:[UIColor clearColor]];
    [feedBackImage setImage:[UIImage imageNamed:@"Return"]];
    [feedbackView addSubview:feedBackImage];
    
    UILabel *feedBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(feedBackImage.frame.origin.x + feedBackImage.frame.size.width, feedbackView.frame.size.height/2 - 10, 200, 20)];
    [feedBackLabel setBackgroundColor:[UIColor clearColor]];
    [feedBackLabel setText:@"Return Policy"];
    [feedBackLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [feedBackLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [feedbackView addSubview:feedBackLabel];
    
    [feedbackView addSubview:[self getBackImageforView:feedbackView.frame.size.height/2]];

    feedbackView.clipsToBounds = YES;
    return feedbackView;
}



-(void)showSuggestedProducts{

    
    self.gridContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.feedBackView.frame.origin.y + self.feedBackView.frame.size.height + 10, self.frame.size.width, 0)];
    [self.gridContainerView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    [self addSubview:self.gridContainerView];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.gridContainerView.frame.size.width,0)];
    
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
    [headerLabel setText:@"You May Also Like"];
    [self.gridContainerView addSubview:headerLabel];
    [self.gridContainerView setHidden:TRUE];
    self.suggestedProductView = [[GridView alloc] initWithFrame:CGRectMake(0, 50, self.gridContainerView.frame.size.width, 0)];
    self.suggestedProductView.shouldHideLoaderSection = TRUE;
    [self.gridContainerView addSubview:self.suggestedProductView];
    
    
    NSString *dataURL = self.productData.suggestedProductList;
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dataURL]];
    
    [req setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] stringValue] forHTTPHeaderField:@"latitude"];
    [req setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] stringValue] forHTTPHeaderField:@"longitude"];
    [req setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"city"] forHTTPHeaderField:@"city"];
    [req setValue:[NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[[UIScreen mainScreen] scale] * DeviceWidth] stringValue]]  forHTTPHeaderField:@"display-width"];
   
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data.length > 0){
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if(json!=nil){
                self.suggestedProductView.parsedDataArray = [SSUtility parseJSON:[json objectForKey:@"items"] forGridView:self.suggestedProductView];
                self.suggestedProductView.delegate = self;
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [self.gridContainerView setHidden:FALSE];
                    [headerLabel setFrame:CGRectMake(0, 0, self.gridContainerView.frame.size.width,50)];
                    [headerLabel setCenter:CGPointMake(self.gridContainerView.frame.size.width/2, 25)];
                   
                    if(!isObserverAdded){
                    [self addObserver:self forKeyPath:@"self.suggestedProductView.collectionView.contentSize" options:NSKeyValueObservingOptionOld context:NULL];
                    isObserverAdded = true;
                    }
                

                    [self.suggestedProductView addCollectionView];
                });
            }
        }
    }];
//    if(!isFetching){
        [dataTask resume];
//        isFetching = true;
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"self.suggestedProductView.collectionView.contentSize"]) {
        [self.suggestedProductView setFrame:CGRectMake(self.suggestedProductView.frame.origin.x, self.suggestedProductView.frame.origin.y
                                                       , self.suggestedProductView.frame.size.width, self.suggestedProductView.collectionView.contentSize.height)];
        [self.gridContainerView setFrame:CGRectMake(self.gridContainerView.frame.origin.x, self.gridContainerView.frame.origin.y, self.gridContainerView.frame.size.width, self.suggestedProductView.frame.origin.y + self.suggestedProductView.frame.size.height)];
        [self.suggestedProductView.collectionView setFrame:CGRectMake(self.suggestedProductView.collectionView.frame.origin.x, self.suggestedProductView.collectionView.frame.origin.y, self.suggestedProductView.collectionView.frame.size.width, self.suggestedProductView.frame.size.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.gridContainerView.frame.origin.y + self.gridContainerView.frame.size.height + 10)];
        
        if(isObserverAdded){
            [self removeObserver:self forKeyPath:@"self.suggestedProductView.collectionView.contentSize"];
            isObserverAdded = false;
        }
    }
    
}


-(void)parseJSON:(NSData *)data{
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
    //    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSMutableArray *parsedDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for(int i = 0; i < [json count]; i ++){
        
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[[json objectAtIndex:i] objectForKey:@"tile_size"] forKey:@"tile_size"];
        
        if([[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"1"] || [[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"0"]){
            
            //            width = self.view.frame.size.width/2;
            width = self.suggestedProductView.collectionView.frame.size.width/2;
            [dict setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
            
        }else if([[[[json objectAtIndex:i] objectForKey:@"tile_size"] stringValue] isEqualToString:@"2"]){
            
            //            width = self.view.frame.size.width;
            width = self.suggestedProductView.collectionView.frame.size.width;
            [dict setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
        }
        
        [dict setObject:[[json objectAtIndex:i] valueForKey:@"tile_type"] forKey:@"tile_type"];
        
        //        height = [self getHeightFromAspectRatio:[[json objectAtIndex:i] objectForKey:@"aspect_ratio"] andWidth:width];
        
        if([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"product"]){
            
            //            height += RelativeSize(42, 320);
            ProductTileModel *prod = [[ProductTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"values"]];
            height = [self getHeightFromAspectRatio:prod.aspect_ratio andWidth:width];
            height += RelativeSize(42, 320);
            [dict setObject:prod forKey:@"values"];
            
        }
        else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"tip"]){
            
            TipTileModel *tip = [[TipTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"values"]];
            //            height = [self getHeightFromAspectRatio:tip.aspect_ratio andWidth:width];
            [dict setObject:tip forKey:@"values"];
            height = [self getProductsAspectRatio:tip.aspect_ratio andWidth:width];
            
        }
        else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"brand"]){
            
            BrandTileModel *brand = [[BrandTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"values"]];
            height = [self calculateBrandCellHeight:brand];
            [dict setObject:brand forKey:@"values"];
            
        }else if ([[[json objectAtIndex:i] objectForKey:@"tile_type"] isEqualToString:@"collection"]){
            
            CollectionTileModel *collection = [[CollectionTileModel alloc] initWithDictionary:[[json objectAtIndex:i] objectForKey:@"values"]];
            height = [self calculateCollectionGridHeight:collection];
            [dict setObject:collection forKey:@"values"];
        }
        
        [dict setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
        [parsedDataArray addObject:dict];
    }
    self.suggestedProductView.parsedDataArray = parsedDataArray;
}

CGSize gridSize ;
CGSize productAspectRatioSize;
- (CGFloat)calculateBrandCellHeight:(BrandTileModel *)brandData{
    CGFloat dynamicHeight = 0.0f;
    //    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:@"4:1.7" andWidth:self.view.frame.size.width];
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:brandData.brandBannerAspectRatio andWidth:self.frame.size.width];
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    gridSize = [SSUtility getLabelDynamicSize:brandData.banner_title withFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + gridSize.height;
    
    NSString *modifiedString = [NSString stringWithFormat:@"Nearest %@",brandData.nearest_store];
    gridSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + gridSize.height;
    
    CGFloat calculatedWidth = ((self.suggestedProductView.collectionView.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    //    CGFloat productContainerHeight = [self getProductsAspectRatio:@"2:3" andWidth:calculatedWidth];
    
    SubProductModel *subProduct = [brandData.products objectAtIndex:0];
    CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
    
    productAspectRatioSize = CGSizeMake(calculatedWidth,productContainerHeight);
    dynamicHeight += productContainerHeight + kGridComponentPadding;
    dynamicHeight += kGridComponentPadding + 60;
    return dynamicHeight;
}


- (CGFloat)calculateCollectionGridHeight:(CollectionTileModel *)collectionData{
    CGFloat dynamicHeight = 0.0f;
    //    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:@"4:1.7" andWidth:self.view.frame.size.width];
    CGFloat bannerDynamicHeight = [self getHeightFromAspectRatio:collectionData.bannerAspectRatio andWidth:self.frame.size.width];
    dynamicHeight += bannerDynamicHeight + kGridComponentPadding;
    
    gridSize = [SSUtility getLabelDynamicSize:collectionData.banner_title withFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + gridSize.height;
    
    NSString *modifiedString = [NSString stringWithFormat:@"Last Updated %@",collectionData.last_updated];
    gridSize = [SSUtility getLabelDynamicSize:modifiedString withFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f] withSize:CGSizeMake(250, MAXFLOAT)];
    dynamicHeight += kGridComponentPadding + gridSize.height;
    
    CGFloat calculatedWidth = ((self.suggestedProductView.collectionView.frame.size.width - 2*kGridComponentPadding) - 2*kGridComponentPadding)/3.5;
    //    CGFloat productContainerHeight = [self getProductsAspectRatio:@"2:3" andWidth:calculatedWidth];
    SubProductModel *subProduct = [collectionData.products objectAtIndex:0];
    CGFloat productContainerHeight = [self getProductsAspectRatio:subProduct.subProductAspectRatio andWidth:calculatedWidth];
    
    productAspectRatioSize = CGSizeMake(calculatedWidth,productContainerHeight);
    dynamicHeight += productContainerHeight + kGridComponentPadding;
    dynamicHeight += kGridComponentPadding + 60;
    return dynamicHeight;
}


-(CGFloat)getHeightFromAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width - RelativeSize(20, 320)) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}

- (CGFloat)getProductsAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}


-(void)updateFloatingButtons:(CGPoint)contenttOffset{
    
//    if(contenttOffset.y <=  -500){
//        [self.thirdStripView setFrame:floatingButtonsStartingFrame];
//    }else if(contenttOffset.y + 64 + floatingButtonsStartingFrame.origin.y < floatingButtonsFixedFrame.origin.y){
//        [self.thirdStripView setFrame:CGRectMake(self.thirdStripView.frame.origin.x, floatingButtonsStartingFrame.origin.y + contenttOffset.y + 84, self.thirdStripView.frame.size.width, self.thirdStripView.frame.size.height)];
//    }
//    
}

-(void)displaySizeGuide:(id)sender{
    
    if([self.detailDelegate respondsToSelector:@selector(showSizeGuide:)]){
        [self.detailDelegate showSizeGuide:nil];
    }
}

-(void)displayPinCodePopUp:(id)sender{
    if([self.detailDelegate respondsToSelector:@selector(displayPopUp:withUserInput:)]){
        [self.detailDelegate displayPopUp:PDPPinCodePopUp withUserInput:nil ];
    }
}


-(void)sizeSelected:(id)sender{
    
    if(self.selectedSize){
        [self.selectedSize removeAllObjects];
    }
    if(self.selectedSize== nil){
        self.selectedSize = [[NSMutableArray alloc] initWithCapacity:0];
    }
    UIButton *selectedSizeButton= (id)sender;
//    for(UIButton *eachSizeButton in self.sizeBtnArray){
    for(NSInteger counter=0; counter< [self.sizeBtnArray count]; counter++){
        UIButton *eachSizeButton = [self.sizeBtnArray objectAtIndex:counter];
        if(eachSizeButton.tag==selectedSizeButton.tag){
        
            ProductSize *sizeData = [self.productData.sizeArray objectAtIndex:eachSizeButton.tag];
            [self.selectedSize addObject:sizeData];
            [eachSizeButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
            [eachSizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            eachSizeButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;

        }else{
            [eachSizeButton setBackgroundColor:[UIColor whiteColor]];
            [eachSizeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            eachSizeButton.layer.borderColor = UIColorFromRGB(0xBDBDBD).CGColor;
        }
    }
    if(self.isItemAddedIntoCart){
        self.isItemAddedIntoCart = FALSE;
        [self.addToCartButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
    }
}


-(void)toggleLike{
    
    if(likeTimer){
        [likeTimer invalidate];
        likeTimer = nil;
    }
    likeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hitLike) userInfo:nil repeats:NO];
    
    self.productData.productBookMerked = !self.productData.productBookMerked;
    [self.likeImage setBackgroundImage:self.productData.productBookMerked ? [UIImage imageNamed:@"WishlistLargeFilled"] : [UIImage imageNamed:@"WishlistLarge"] forState:UIControlStateNormal];
    
//    if(!self.productData.productBookMerked){
//        [FyndAnalytics trackProductLike:@"product" itemCode:self.productData.productID brandName:self.productData.brandName isProductUnlike:YES productCategory:self.productData.parentCategoryID productSubcategory:self.productData.childCategoryID];
//    }else{
//        [FyndAnalytics trackProductLike:@"product" itemCode:self.productData.productID brandName:self.productData.brandName isProductUnlike:NO productCategory:self.productData.parentCategoryID productSubcategory:self.productData.childCategoryID];
//    }
}


-(void)hitLike{
    if(self.pdpRequestHandler== nil){
        self.pdpRequestHandler = [[PDPHandler alloc] init];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.productData.productID],@"product_id", nil];

    if(!self.productData.productBookMerked){
        [self.pdpRequestHandler unfollowBrand:dict withCompletionHandler:^(id responseData, NSError *error) {
            [self updateProductLike:responseData];
            [FyndAnalytics trackProductLike:@"product" itemCode:self.productData.productID brandName:self.productData.brandName isProductUnlike:NO productCategory:self.productData.parentCategoryID productSubcategory:self.productData.childCategoryID];
        }];
    }else{
        [self.pdpRequestHandler followBrand:dict withCompletionHandler:^(id responseData, NSError *error) {
            [self updateProductLike:responseData];
            [FyndAnalytics trackProductLike:@"product" itemCode:self.productData.productID brandName:self.productData.brandName isProductUnlike:YES productCategory:self.productData.parentCategoryID productSubcategory:self.productData.childCategoryID];
        }];
    }
}


- (void)updateProductLike:(id)data{
    if ([data objectForKey:@"counts"]) {
        NSArray *countArray = [data valueForKey:@"counts"];
        if ([countArray count]>0) {
            NSDictionary *countDic = [countArray objectAtIndex:0];
            if ([countDic objectForKey:@"count"]) {
                self.productData.bookmarkCount = [[countDic objectForKey:@"count"] integerValue];
                [self.likeCount setText:[NSString stringWithFormat:@"%ld",(long)self.productData.bookmarkCount]];
            }
        }
    }
}




#pragma mark PDPMoreDetail Delegate
 - (void)moreInfoTabChanged:(NSInteger)anIndex{

     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.3f];
     
     [self.deliveryOptionView setFrame:CGRectMake(self.checkDeliveryOptionsView.frame.origin.x, self.pdpMoreDetail.frame.origin.y + self.pdpMoreDetail.frame.size.height+10, self.deliveryOptionView.frame.size.width, self.deliveryOptionView.frame.size.height)];
     
//     [self.deliveryOptionView setFrame:CGRectMake(self.checkDeliveryOptionsView.frame.origin.x, self.productDetailY, self.deliveryOptionView.frame.size.width, self.deliveryOptionView.frame.size.height)];
     
     [self.nearestStoreView setFrame:CGRectMake(self.nearestStoreView.frame.origin.x, /*self.checkDeliveryOptionsView.frame.origin.y + self.checkDeliveryOptionsView.frame.size.height*/self.deliveryOptionView.frame.origin.y + self.deliveryOptionView.frame.size.height, self.nearestStoreView.frame.size.width, self.nearestStoreView.frame.size.height)];
     
     [self.feedBackView setFrame:CGRectMake(self.feedBackView.frame.origin.x, self.nearestStoreView.frame.origin.y + self.nearestStoreView.frame.size.height+10, self.feedBackView.frame.size.width, self.feedBackView.frame.size.height)];
     
     [self.gridContainerView setFrame:CGRectMake(self.gridContainerView.frame.origin.x, self.feedBackView.frame.origin.y+self.feedBackView.frame.size.height, self.gridContainerView.frame.size.width, self.suggestedProductView.frame.origin.y + self.suggestedProductView.frame.size.height)];
    
     [UIView commitAnimations];
    
    if([self.detailDelegate respondsToSelector:@selector(updateProductInfoLayout:withSimilarProductsContainerHeight:)]){
        [self.detailDelegate updateProductInfoLayout:anIndex withSimilarProductsContainerHeight:self.gridContainerView.frame.size.height];
//        [self.detailDelegate updateProductInfoLayout:anIndex withSimilarProductsContainerHeight:0];
    }
}


-(void)wiggleView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @4, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.3;
    animation.additive = YES;
    [self.sizeScrollContainer.layer addAnimation:animation forKey:@"wiggle"];
    
    /*
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
     */
    
    [self playSound];
}



- (void)playSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(UIImageView *)getBackImageforView:(CGFloat)theView{
    UIImage* sourceImage = [UIImage imageNamed:kBackButtonImage];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                                scale:sourceImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 36-15, theView - 13,26, 26)];
    [arrowImage setBackgroundColor:[UIColor clearColor]];
    [arrowImage setImage:flippedImage];
    return arrowImage;
}

#pragma mark - GridView Delegates

-(void)showPDPScreen:(NSString *)productURL{
    if (self.detailDelegate && [self.detailDelegate respondsToSelector:@selector(showSimilarProductsWithProductURL:)]) {
        [self.detailDelegate showSimilarProductsWithProductURL:productURL];
    }
}


-(void)removeObserver{
    if(isObserverAdded){
        [self removeObserver:self forKeyPath:@"self.suggestedProductView.collectionView.contentSize"];
        isObserverAdded = false;
    }
}

@end


