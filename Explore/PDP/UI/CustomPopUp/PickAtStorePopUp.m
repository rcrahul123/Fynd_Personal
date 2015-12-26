//
//  PickAtStorePopUp.m
//  Explore
//
//  Created by Pranav on 22/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PickAtStorePopUp.h"
#import "PDPModel.h"
#import <QuartzCore/QuartzCore.h>
#import "SSLine.h"
#import "SizeBox.h"

@interface PickAtStorePopUp()<UIScrollViewDelegate>{
       PopHeaderView *popUpHeaderView;
}
@property (nonatomic,strong) UIImageView *cirlceImage;
@property (nonatomic,strong) UIView      *sizeButtonContainer;
@property (nonatomic,strong) UILabel     *convenienceFee;
@property (nonatomic,strong) UIButton    *addCartBtn;
@property (nonatomic,strong) UIButton    *leftButton;
@property (nonatomic,strong )NSMutableArray *selectedButtons;
@property (nonatomic,strong) NSMutableArray *selectedSizes;
@property (nonatomic,strong) NSMutableArray *sizeBtnArray;
@property (nonatomic,assign) NSInteger      maxSizeCapacity;
@property (nonatomic,assign) NSInteger      previousSelectedIndex;
@property (nonatomic,strong) UILabel        *sizeErrorMessage;
@property (nonatomic,strong) UIView         *popUpActionView;
@property (nonatomic,strong) UIScrollView   *sizeBoxScrollView;
@property (nonatomic,strong) UIView         *sizeBoxContainer;
@property (nonatomic,assign) NSInteger      currentScrollPage;
@property (nonatomic,strong) UIButton       *cancelButton;

@property (nonatomic,strong) NSDictionary   *fyndaFitData;
@property (nonatomic,strong) NSMutableArray *sizeBoxArray;
@property (nonatomic,strong) NSArray        *dependentArray;
@property (nonatomic,strong) ProductSize    *selectedSize;
@property (nonatomic,strong) ProductSize    *previousSelectedSize;
@end

@implementation PickAtStorePopUp


- (id)initWithFrame:(CGRect)frame{
    
    if(self== [super initWithFrame:frame]){
//        [self setUpTryAtHome];
    }
    return self;
}


- (void)setUpTryAtHome{
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds = TRUE;
    if(self.tryHomePopUpType == TryAtHomeFirstTime){
        [self configureForFirstTime];
    }
    else if(self.tryHomePopUpType == TryAtHomePDP || self.tryHomePopUpType == TryAtHomeExchangeItem || self.tryHomePopUpType == TryAtHomeCart || self.tryHomePopUpType == TryAtHomeAddItemInCart){
        [self configure];
    }
}


#define kSizePadding 10
CGFloat fixLogoImageWidth = 60.0f;
CGFloat fixLogoImageHeight =0.0f;
CGFloat fixSizeHeadingHeight  =30.0f;
CGFloat fixComponentPadding  =10.0f;
- (void)configure{
    
    self.selectedButtons = [[NSMutableArray alloc] init];
    self.selectedSizes = [[NSMutableArray alloc] initWithCapacity:0];
    self.sizeBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self showHeader];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    
    self.maxSizeCapacity = [[self.tryAtHomeDataDict objectForKey:@"maxSizeSelection"] integerValue];
//    NSArray *prePopulatedSize = [self.tryAtHomeDataDict objectForKey:@"preSelectedSize"];
    self.fyndaFitData = [self.tryAtHomeDataDict objectForKey:@"DependentSizes"];

    CGRect aRect = CGRectZero;
    if(self.tryHomePopUpType == TryAtHomePDP)
    {
        
        self.cirlceImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - fixLogoImageWidth/2, 1.5*fixComponentPadding, RelativeSize(fixLogoImageWidth,320), RelativeSizeHeight(fixLogoImageWidth, 568))];
        [self.cirlceImage setBackgroundColor:[UIColor clearColor]];
        [self.cirlceImage setImage:[UIImage imageNamed:@"FyndaFit"]];
        [self addSubview:self.cirlceImage];
        aRect = self.cirlceImage.frame;
        
        UILabel *heading = [SSUtility generateLabel:@"FYND A FIT" withRect:CGRectMake(self.frame.size.width/2-75, self.cirlceImage.frame.origin.y + self.cirlceImage.frame.size.height, 150, 30) withFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f]];
        [heading setTextColor:UIColorFromRGB(kTurquoiseColor)];
        [self addSubview:heading];
        aRect = heading.frame;
    }
    else if(self.tryHomePopUpType == TryAtHomeExchangeItem || self.tryHomePopUpType == TryAtHomeCart || self.tryHomePopUpType == TryAtHomeAddItemInCart){
        UIImageView *anImage = [[UIImageView alloc] initWithFrame:CGRectMake(fixComponentPadding, fixComponentPadding, 30, 30)];
        [anImage setBackgroundColor:[UIColor clearColor]];
        [anImage setImage:[UIImage imageNamed:@"Size"]];
        [self addSubview:anImage];
        NSString *popUpTitle = nil;
        if(self.tryHomePopUpType == TryAtHomeExchangeItem){
            popUpTitle = @"Select New Size";
        }else if(self.tryHomePopUpType == TryAtHomeCart){
            popUpTitle = @"Edit Size";
        }else if(self.tryHomePopUpType == TryAtHomeAddItemInCart){
            popUpTitle = @"Select Size";
        }
        UILabel *exchangeTitle = [SSUtility generateLabel:popUpTitle withRect:CGRectMake(anImage.frame.origin.x + anImage.frame.size.width+5, fixComponentPadding, 200, 30) withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        exchangeTitle.textAlignment = NSTextAlignmentLeft;
        [exchangeTitle setBackgroundColor:[UIColor clearColor]];
        [exchangeTitle setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [self addSubview:exchangeTitle];
        exchangeTitle.textColor = UIColorFromRGB(kSignUpColor);
        
        SSLine *hLine = [[SSLine alloc] initWithFrame:CGRectMake(0, exchangeTitle.frame.origin.y + exchangeTitle.frame.size.height, self.frame.size.width, 1)];
        [self addSubview:hLine];
        
        aRect = exchangeTitle.frame;
        
        
    }
    
    
    
    
    
    NSString *popUpInfo = nil;
    CGSize sizeLabelHeadingSize = CGSizeZero;
    CGSize sizeLabelHeadingSize1 = CGSizeZero;
    NSString *convenienceFee = [self.tryAtHomeDataDict objectForKey:@"convenienceFee"];
    if(self.tryHomePopUpType == TryAtHomePDP){
        
//        popUpInfo = [NSString stringWithFormat:@"Select 2 sizes and try them at home for a convenience fee of %@50",kRupeeSymbol];
        popUpInfo = [NSString stringWithFormat:@"Select 2 sizes and try them at home for a convenience fee of %@%@", kRupeeSymbol,convenienceFee];
        
        sizeLabelHeadingSize = [SSUtility getDynamicSizeWithSpacing:popUpInfo withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.frame.size.width - fixComponentPadding*4, /*RelativeSizeHeight(fixSizeHeadingHeight, 480)*/MAXFLOAT) spacing:5.0f];
        
        UILabel *sizeHeading = [[UILabel alloc] initWithFrame:CGRectMake(RelativeSize((self.frame.size.width/2 - sizeLabelHeadingSize.width/2), 320), aRect.origin.y + aRect.size.height+fixComponentPadding/2, sizeLabelHeadingSize.width,sizeLabelHeadingSize.height)];
        [sizeHeading setBackgroundColor:[UIColor clearColor]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        NSDictionary *tempDict = @{NSFontAttributeName:popUpInfo
                                   ,NSParagraphStyleAttributeName:paragraphStyle};
        sizeHeading.attributedText = [[NSAttributedString alloc]initWithString:popUpInfo attributes:tempDict];
        [sizeHeading setTextAlignment:NSTextAlignmentCenter];
        [sizeHeading setNumberOfLines:0];
        [sizeHeading setTextColor:UIColorFromRGB(kLightGreyColor)];
        [sizeHeading setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [self addSubview:sizeHeading];
        aRect = sizeHeading.frame;

        sizeLabelHeadingSize1 = [SSUtility getLabelDynamicSize:@"Select the first Size" withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(self.frame.size.width - 10*4, MAXFLOAT)];
    }
    
    // **********
    NSInteger sizeBoxHeight = 0.0f;
//    sizeBoxHeight += sizeLabelHeadingSize.height + 20;
    sizeBoxHeight += sizeLabelHeadingSize1.height + 20;
    NSInteger sizeQuoitent1 = [self.productSizeArray count]/6;
    NSInteger sizeBoxesHeight = (sizeQuoitent1+1)*45 + (sizeQuoitent1)*fixComponentPadding;
    sizeBoxHeight += sizeBoxesHeight;
//    sizeBoxHeight += 2.5*fixComponentPadding;
   
    NSInteger pageCount =1;
    BOOL     sizeBoxFyndAFit= FALSE;
    if(self.maxSizeCapacity ==2)
    {
        pageCount = 2;
        sizeBoxFyndAFit = TRUE;
    }
    self.sizeBoxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, aRect.origin.y + aRect.size.height+fixComponentPadding, self.frame.size.width, sizeBoxHeight)];
    
    self.sizeBoxScrollView.scrollEnabled = FALSE;
    self.sizeBoxScrollView.delegate = self;
    self.sizeBoxScrollView.showsHorizontalScrollIndicator = FALSE;
    [self.sizeBoxScrollView setBackgroundColor:[UIColor whiteColor]];
    self.sizeBoxArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.sizeBoxScrollView setContentSize:CGSizeMake(self.frame.size.width*pageCount, sizeBoxHeight)];
    
    for(NSInteger i=0; i < pageCount; i++){
        SizeBox *sizeBox = [[SizeBox alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.sizeBoxScrollView.frame.size.width, self.sizeBoxScrollView.frame.size.height)];
        sizeBox.isFyndAFitPopUp = sizeBoxFyndAFit;
        sizeBox.title = popUpInfo;
        sizeBox.sizeBoxTag = i;
        sizeBox.sizeBoxData = self.productSizeArray;
        [sizeBox setUpSizeBox];
        [sizeBox setBackgroundColor:[UIColor clearColor]];
        [self.sizeBoxArray addObject:sizeBox];
        [self.sizeBoxScrollView addSubview:sizeBox];
        
        PickAtStorePopUp *pickPopUp = self;
        sizeBox.dependentSizeBock=^(ProductSize *size,SizeBox *sizeBox){
            [pickPopUp getDependentSize:size withSizeBox:sizeBox];
        };
        
        [self addSubview:self.sizeBoxScrollView];
    }
    if([self.selectedButtons count]==self.maxSizeCapacity){
        self.addCartBtn.enabled = TRUE;
        self.addCartBtn.alpha = 1.0;
    }else{
        self.addCartBtn.enabled = FALSE;
        self.addCartBtn.alpha = 0.2f;
    }

    NSInteger offSet = self.sizeBoxScrollView.frame.origin.y + self.sizeBoxScrollView.frame.size.height + 30;;
    self.popUpActionView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, offSet, self.frame.size.width, 50)];
    [self.popUpActionView setBackgroundColor:[UIColor clearColor]];
    NSString *leftButtonStr =  [self.tryAtHomeDataDict objectForKey:@"LeftButtonTitle"];
    NSInteger addToCartStartPoint =10;
    
    if(leftButtonStr && leftButtonStr.length > 0){
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.layer.cornerRadius = 3.0f;
        [self.cancelButton setClipsToBounds:YES];
        [self.cancelButton setFrame:CGRectMake(addToCartStartPoint,0 , (self.frame.size.width -3*addToCartStartPoint)/2 , 50)];
        [self.cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xD3D4D5)] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(0xE4E5E6)] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:leftButtonStr forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
        [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.popUpActionView addSubview:self.cancelButton];
        addToCartStartPoint+=  self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width;
        offSet = self.cancelButton.frame.origin.y ;
    }
    
    self.addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCartBtn.layer.cornerRadius = 3.0f;
    [self.addCartBtn setClipsToBounds:YES];
    [self.addCartBtn setFrame:CGRectMake(addToCartStartPoint, offSet , self.frame.size.width-addToCartStartPoint-10, 50)];
    [self.addCartBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [self.addCartBtn setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    
    if(self.maxSizeCapacity == 2){
        [self.addCartBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        [self.addCartBtn addTarget:self action:@selector(navigateToNextSizePage:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.addCartBtn setTitle:[self.tryAtHomeDataDict objectForKey:@"RightButtonTitle"] forState:UIControlStateNormal];
        [self.addCartBtn addTarget:self action:@selector(addItemIntoCart) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.addCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addCartBtn.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:13.0f];
    [self.popUpActionView addSubview:self.addCartBtn];
    [self addSubview:self.popUpActionView];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.popUpActionView.frame.origin.y + self.popUpActionView.frame.size.height + 10)];
}


- (void)addItemIntoCart{

    if(self.selectedSize){
        [self.selectedSizes addObject:self.selectedSize];
    }
    if([self.selectedSizes count] == self.maxSizeCapacity)
    {
        if(self.addToCartBlock){
            self.addToCartBlock(self.selectedSizes);
        }
    }else{
        NSString *errorString = @"Please select a size";
        CGSize errorSize = [SSUtility getLabelDynamicSize:errorString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if(self.sizeErrorMessage){
            [self.sizeErrorMessage removeFromSuperview];
            self.sizeErrorMessage = nil;
        }
        self.sizeErrorMessage = [SSUtility generateLabel:errorString withRect:CGRectMake(self.sizeBoxScrollView.frame.size.width/2 - errorSize.width/2, self.sizeBoxScrollView.frame.origin.y + self.sizeBoxScrollView.frame.size.height, errorSize.width, errorSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [self.sizeErrorMessage setBackgroundColor:[UIColor clearColor]];
        [self.sizeErrorMessage setTextColor:UIColorFromRGB(kRedColor)];
        [self.sizeErrorMessage setText:errorString];
        [self addSubview:self.sizeErrorMessage];
        [self wiggleView];
    }
}

- (void)cancel:(id)sender{
    if(self.cancePopUpBlock){
        self.cancePopUpBlock();
    }
}

-(void)navigateToNextSizePage:(id)sender{
    
    if(self.sizeErrorMessage){
        [self.sizeErrorMessage removeFromSuperview];
        self.sizeErrorMessage = nil;
    }
    SizeBox *currentSizeBox = [self.sizeBoxArray objectAtIndex:0];
    
    if([currentSizeBox validateSizeSelction]){
    
        if(self.selectedSize){
            [self.selectedSizes removeLastObject];
            [self.selectedSizes addObject:self.selectedSize];
        }
        
        if(self.selectedSize!=nil)
            self.previousSelectedSize = self.selectedSize;
        
        
        SizeBox *nextSizeBox = [self.sizeBoxArray objectAtIndex:1];
        [nextSizeBox updateSizeBoxDataArray:self.dependentArray];
        [nextSizeBox updateDependentSizes:self.dependentArray];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.sizeBoxScrollView setContentOffset:CGPointMake(self.frame.size.width, self.frame.origin.y)];
        [UIView commitAnimations];
        
        [self.cancelButton setTitle:@"BACK" forState:UIControlStateNormal];
        [self.addCartBtn setTitle:[self.tryAtHomeDataDict objectForKey:@"RightButtonTitle"] forState:UIControlStateNormal];
        
        [self.cancelButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(navigateToPreviousSizePage:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.addCartBtn removeTarget:self action:@selector(navigateToNextSizePage:) forControlEvents:UIControlEventTouchUpInside];
        [self.addCartBtn addTarget:self action:@selector(addItemIntoCart) forControlEvents:UIControlEventTouchUpInside];
        
        self.selectedSize = nil;
    }
    else{
        
        NSString *errorString = @"Please select a size.";
        CGSize errorSize = [SSUtility getLabelDynamicSize:errorString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if(self.sizeErrorMessage){
            [self.sizeErrorMessage removeFromSuperview];
            self.sizeErrorMessage = nil;
        }
        
        self.sizeErrorMessage = [SSUtility generateLabel:errorString withRect:CGRectMake(currentSizeBox.frame.size.width/2 - errorSize.width/2, self.sizeBoxScrollView.frame.origin.y + self.sizeBoxScrollView.frame.size.height, errorSize.width, errorSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [self.sizeErrorMessage setBackgroundColor:[UIColor clearColor]];
        [self.sizeErrorMessage setTextColor:UIColorFromRGB(kRedColor)];
        [self.sizeErrorMessage setText:errorString];
        [self addSubview:self.sizeErrorMessage];
        [self wiggleView];
    }
}

-(void)navigateToPreviousSizePage:(id)sender{
    
    if(self.sizeErrorMessage){
        [self.sizeErrorMessage removeFromSuperview];
        self.sizeErrorMessage = nil;
    }
    
    self.dependentArray = [self.fyndaFitData objectForKey:self.previousSelectedSize.sizeDisplay];
    
    SizeBox *previousSizeBox = [self.sizeBoxArray objectAtIndex:0];
    [previousSizeBox updateSizeBoxDataArray:self.productSizeArray];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.sizeBoxScrollView setContentOffset:CGPointMake(0, self.frame.origin.y)];
    [UIView commitAnimations];
    
    if([self.selectedSizes count]>1)// If user has selected from second page then only delete it.
        [self.selectedSizes removeLastObject];
    
    self.selectedSize = nil;
    
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.addCartBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    
    [self.cancelButton removeTarget:self action:@selector(navigateToPreviousSizePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addCartBtn removeTarget:self action:@selector(addItemIntoCart) forControlEvents:UIControlEventTouchUpInside];
    [self.addCartBtn addTarget:self action:@selector(navigateToNextSizePage:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)saveItemToCart{
    
    if([self.selectedSizes count] == self.maxSizeCapacity)
    {
        if(self.addToCartBlock){
            self.addToCartBlock(self.selectedSizes);
        }
    }else{
        NSString *errorString = @"Please select a size.";
        CGSize errorSize = [SSUtility getLabelDynamicSize:errorString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if(self.sizeErrorMessage){
            [self.sizeErrorMessage removeFromSuperview];
            self.sizeErrorMessage = nil;
        }
        
        self.sizeErrorMessage = [SSUtility generateLabel:errorString withRect:CGRectMake(self.sizeButtonContainer.frame.size.width/2 - errorSize.width/2, self.sizeButtonContainer.frame.origin.y + self.sizeButtonContainer.frame.size.height, errorSize.width, errorSize.height) withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [self.sizeErrorMessage setBackgroundColor:[UIColor clearColor]];
        [self.sizeErrorMessage setTextColor:UIColorFromRGB(kRedColor)];
        [self.sizeErrorMessage setText:errorString];
        [self addSubview:self.sizeErrorMessage];
       
    }

}


-(void)showHeader{
    popUpHeaderView = [[PopHeaderView alloc] init];
    [self addSubview:[popUpHeaderView popHeaderViewWithTitle:@"Try @ Home" andImageName:@"TryAtHome" withOrigin:CGPointMake(RelativeSize(-11, 320), self.frame.origin.y-(RelativeSizeHeight(140, 568)))]];
}

-(void)sizeButtonSelected:(id)sender{
    UIButton *selectedSizeButton= (id)sender;
    ProductSize *selectedSize = [self.productSizeArray objectAtIndex:selectedSizeButton.tag];
    NSInteger tagOfButton = selectedSizeButton.tag;

    
        if(self.maxSizeCapacity == 2){
            if ([self.selectedButtons containsObject:[NSString stringWithFormat:@"%ld",(long)tagOfButton]]) {
                [selectedSizeButton setBackgroundColor:[UIColor whiteColor]];
                [selectedSizeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                selectedSizeButton.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
                [self.selectedButtons removeObject:[NSString stringWithFormat:@"%ld",(long)tagOfButton]];
//                [self.selectedSizes removeObject:selectedSizeButton];
                [self.selectedSizes removeObject:selectedSize];
            }else{
                if ([self.selectedButtons count]<2) {
                    [selectedSizeButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
                    selectedSizeButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
                    [selectedSizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.selectedButtons addObject:[NSString stringWithFormat:@"%ld",(long)tagOfButton]];
                    [self.selectedSizes addObject:selectedSize];
                }
            }
        }else{
            
            UIButton *previousBtn = [self.sizeBtnArray objectAtIndex:self.previousSelectedIndex];
            ProductSize *previousSizeData = [self.productSizeArray objectAtIndex:self.previousSelectedIndex];
            [previousBtn setBackgroundColor:[UIColor whiteColor]];
            [previousBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            previousBtn.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
            
            [self.selectedButtons removeObject:[NSString stringWithFormat:@"%ld",(long)previousBtn.tag]];
            [self.selectedSizes removeObject:previousSizeData];
            
            [self.selectedButtons addObject:[NSString stringWithFormat:@"%ld",(long)tagOfButton]];
            [self.selectedSizes addObject:selectedSize];
            
            [selectedSizeButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
            selectedSizeButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
            [selectedSizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
           
        }
    
    
        self.previousSelectedIndex = tagOfButton;
    
    if([self.selectedSizes count] == self.maxSizeCapacity){
        if(self.sizeErrorMessage){
            [self.sizeErrorMessage removeFromSuperview];
            self.sizeErrorMessage = nil;
        }
    }
    
}




- (void)configureForFirstTime{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat tryAtHomeBannerWidth = 200;
    UIImageView *tryAtHomeBanner = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -tryAtHomeBannerWidth/2, 20, tryAtHomeBannerWidth,tryAtHomeBannerWidth)];
    [tryAtHomeBanner setBackgroundColor:[UIColor clearColor]];
    [tryAtHomeBanner setImage:[UIImage imageNamed:@"ScrollView2"]];
    [self addSubview:tryAtHomeBanner];
    
    
    UILabel *heading = [SSUtility generateLabel:@"FYND A FIT" withRect:CGRectMake(self.frame.size.width/2-75, tryAtHomeBanner.frame.origin.y + tryAtHomeBanner.frame.size.height + 10, 150, 30) withFont:[UIFont fontWithName:kMontserrat_Bold size:16.0f]];
    [heading setTextColor:UIColorFromRGB(kTurquoiseColor)];
    [self addSubview:heading];
    
    NSString *guideString = @"Try Multiple Sizes for Perfect Fit";
    CGSize size = [SSUtility getLabelDynamicSize:guideString withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f] withSize:CGSizeMake(self.frame.size.width -40, MAXFLOAT)];
    UILabel *guide = [SSUtility generateLabel:guideString withRect:CGRectMake(self.frame.size.width/2 - size.width/2, heading.frame.origin.y + heading.frame.size.height + 5, size.width, size.height) withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
    [guide setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [guide setNumberOfLines:0];
    [guide setText:guideString];
    [self addSubview:guide];
    
    
    NSString *convenienceFeeString = [self.tryAtHomeDataDict objectForKey:@"convenienceFee"];
    NSString *str = [NSString stringWithFormat:@"Convenience Fee : %@%@",kRupeeSymbol, convenienceFeeString];
    UILabel *convenienceFee = [SSUtility generateLabel:str withRect:CGRectMake(self.frame.size.width/2 - 100, guide.frame.origin.y + guide.frame.size.height + 5, 200, 30) withFont:[UIFont fontWithName:kMontserrat_Light size:15.0f]];
    [convenienceFee setTextColor:UIColorFromRGB(kDarkPurpleColor)];
    [convenienceFee setText:str];
    [self addSubview:convenienceFee];
    
    CGFloat buttonHeight = 70.0f;
    UIButton *gotItButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [gotItButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kTurquoiseColor)] forState:UIControlStateNormal];
    [gotItButton setBackgroundImage:[SSUtility imageWithColor:UIColorFromRGB(kButtonTouchStateColor)] forState:UIControlStateHighlighted];
    [gotItButton setClipsToBounds:YES];
//    [gotItButton setFrame:CGRectMake(10, self.frame.size.height - (buttonHeight+10), self.frame.size.width-20, buttonHeight)];
    [gotItButton setFrame:CGRectMake(0,convenienceFee.frame.origin.y + convenienceFee.frame.size.height + fixComponentPadding, self.frame.size.width, buttonHeight)];
    gotItButton.titleLabel.font = [UIFont fontWithName:kMontserrat_Bold size:15.0f];
    [gotItButton setTitle:@"GOT IT!" forState:UIControlStateNormal];
    [gotItButton addTarget:self action:@selector(clickOnIGotIt) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gotItButton];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, gotItButton.frame.origin.y + gotItButton.frame.size.height)];

}

- (void)clickOnIGotIt{
    self.popUpAction(self.tryHomePopUpType);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentScrollPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)getDependentSize:(ProductSize *)sizeData withSizeBox:(SizeBox *)sizeBox{
    if(self.sizeErrorMessage){
        [self.sizeErrorMessage removeFromSuperview];
        self.sizeErrorMessage = nil;
    }
    self.selectedSize = sizeData;
    
    if(self.fyndaFitData!=nil && sizeBox.tag==0){
        self.dependentArray = [self.fyndaFitData objectForKey:sizeData.sizeDisplay];
    }
  
}

-(void)wiggleView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @4, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.3;
    animation.additive = YES;
    [self.sizeBoxScrollView.layer addAnimation:animation forKey:@"wiggle"];
}
@end

