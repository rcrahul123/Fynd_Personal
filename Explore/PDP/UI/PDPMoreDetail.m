//
//  PDPMoreDetail.m
//  ParallexPDPSample
//
//  Created by Pranav on 09/07/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "PDPMoreDetail.h"
#import "GenderHeaderView.h"
#import "GenderHeaderModel.h"

@interface PDPMoreDetail ()
@property (nonatomic,strong) NSMutableArray *dummyData;
//@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *descriptionView;
@property (nonatomic,strong) UIView *headerScrollerView;
@property (nonatomic,strong) NSMutableArray *headerBtnArray;
@property (nonatomic,strong) GenderHeaderView   *detailHeader;
- (void)generateHeaderView;
- (void)displayHeaderInfo:(id)sender;
- (UIView*)genarateHeaderDetail:(NSInteger)index;
@end

#define kHeaderViewHeight 40
@implementation PDPMoreDetail


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //        [self setBackgroundColor:[UIColor orangeColor]];
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)generatePDPMoreDetail{
    [self generateHeaderView];
    self.descriptionView = [self genarateHeaderDetail:0];
    [self addSubview:self.descriptionView];
}



#define kHeaderOptionPadding 10
CGPoint startPosition;
CGPoint endPosition;
- (void)generateHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, kPDPMoreDetailHeader)];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    
    self.headerScrollerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.headerScrollerView setBackgroundColor:UIColorFromRGB(kPinkColor)];
    [self.headerView addSubview:self.headerScrollerView];
    self.headerBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGFloat previousOptionWidth = 0.0f;
    

    for(NSInteger counter=0; counter < [self.productMoreDescription count]; counter++){
        NSDictionary *dict = [self.productMoreDescription objectAtIndex:counter];
        NSString *title = [dict objectForKey:@"title"];
        
        CGSize headerBtnSize = [SSUtility getLabelDynamicSize:title withFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f] withSize:CGSizeMake(MAXFLOAT, 30)];
        UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [header setBackgroundColor:[UIColor clearColor]];
        [header.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:15.0f]];
        header.tag = counter;
        [header setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];


        [header setFrame:CGRectMake(previousOptionWidth + kHeaderOptionPadding, self.headerView.frame.size.height/2 -15, headerBtnSize.width, headerBtnSize.height)];

        if(counter ==0){
            [header setBackgroundColor:[UIColor clearColor]];
            [self.headerScrollerView setFrame:CGRectMake(header.frame.origin.x, self.headerView.frame.size.height-10, header.frame.size.width, 3)];
        }
        [header setTitle:title forState:UIControlStateNormal];
        [header addTarget:self action:@selector(displayHeaderInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:header];
        [self.headerBtnArray addObject:header];
        
        previousOptionWidth += header.frame.size.width + 2*kHeaderOptionPadding;
    }
    [self addSubview:self.headerView];
}






- (void)displayHeaderInfo:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    [btn setTitleColor:UIColorFromRGB(kPinkColor) forState:UIControlStateNormal];
    CGSize scrollerSize = CGSizeMake(btn.frame.size.width, self.headerScrollerView.frame.size.height);
    [self.headerScrollerView setFrame:CGRectMake(self.headerScrollerView.frame.origin.x, self.headerScrollerView.frame.origin.y, scrollerSize.width, scrollerSize.height)];
    CGPoint btnPoint = CGPointMake(btn.frame.origin.x, btn.frame.origin.y);
    [self animateScroller:CGPointMake(0, 0) endPosition:btnPoint];
    self.descriptionView = [self genarateHeaderDetail:btn.tag];
    [self addSubview:self.descriptionView];
    
    for(UIButton *eachButton in self.headerBtnArray){
        if(eachButton !=btn){
            [eachButton setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
        }
    }
    
    if([self.moreDetailDelegate respondsToSelector:@selector(moreInfoTabChanged:)]){
        [self.moreDetailDelegate moreInfoTabChanged:btn.tag];
    }

}


- (void)animateScroller:(CGPoint)startPoint endPosition:(CGPoint)endPosition{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.headerScrollerView setFrame:CGRectMake(endPosition.x,self.headerScrollerView.frame.origin.y, self.headerScrollerView.frame.size.width, self.headerScrollerView.frame.size.height)];
    [UIView commitAnimations];
    
}


- (UIView*)genarateHeaderDetail:(NSInteger)index{
    if(self.descriptionView){
        [self.descriptionView removeFromSuperview];
        self.descriptionView = nil;
    }
    UIButton *bt = (UIButton *)[self.headerBtnArray objectAtIndex:index];
    [bt setTitleColor:UIColorFromRGB(kPinkColor) forState:UIControlStateNormal];
    CGFloat detailViewStartPoint = self.headerView.frame.size.height + self.headerView.frame.origin.y;
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(10,detailViewStartPoint, self.frame.size.width-20 , self.frame.size.height -detailViewStartPoint)];
//    [detailView setBackgroundColor:[UIColor clearColor]];
    
    
    NSDictionary *dict = [self.productMoreDescription objectAtIndex:index];
    NSString *productDescription = [dict objectForKey:@"text"];
    UIFont *productDescriptionFont = [UIFont fontWithName:kMontserrat_Light size:14.0f];

    CGSize aSize = [SSUtility getDynamicSizeWithSpacing:productDescription withFont:productDescriptionFont withSize:CGSizeMake(detailView.frame.size.width-20, MAXFLOAT) spacing:5.0f];

//    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, aSize.width, aSize.height)];
    UILabel *descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, aSize.width, aSize.height)];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSDictionary *tempDict = @{NSFontAttributeName:productDescriptionFont
                               ,NSParagraphStyleAttributeName:paragraphStyle};
    
    
    descriptionLabel.attributedText = [[NSAttributedString alloc]initWithString:productDescription attributes:tempDict];
    
    
//    [description setText:productDescription];
    [descriptionLabel setTextColor:UIColorFromRGB(kGenderSelectorTintColor)];
    [descriptionLabel setFont:productDescriptionFont];
    [detailView addSubview:descriptionLabel];
    
    NSMutableArray *detailData = [dict objectForKey:@"details"];
    CGFloat previousHeight =0;
    previousHeight = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height;
    for(NSInteger counter=0; counter < [detailData count]; counter++){
        NSDictionary *otherParametersDict = [detailData objectAtIndex:counter];
        NSString *keyString = [otherParametersDict objectForKey:@"key"];
        
        CGSize keySize = [SSUtility getLabelDynamicSize:keyString withFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
//        UILabel *key = [[UILabel alloc] initWithFrame:CGRectMake(0, previousHeight+8, 50, 20)];
        UILabel *key = [[UILabel alloc] initWithFrame:CGRectMake(0, previousHeight+8, keySize.width,keySize.height)];
        [key setBackgroundColor:[UIColor clearColor]];
        [key setText:keyString];
        [key setTextColor:UIColorFromRGB(kLightGreyColor)];
        [key setFont:[UIFont fontWithName:kMontserrat_Regular size:13.0f]];
        [detailView addSubview:key];
        
//        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(key.frame.origin.x + key.frame.size.width +20, key.frame.origin.y, 100, 20)];
        NSString *valueString = [otherParametersDict objectForKey:@"value"];
        CGSize valueSize = [SSUtility getLabelDynamicSize:valueString withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, 20)];
//        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(150, key.frame.origin.y, 100, 20)];
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(150, key.frame.origin.y, valueSize.width,valueSize.height)];
        [value setBackgroundColor:[UIColor clearColor]];
        [value setFont:productDescriptionFont];
        [value setText:valueString];
        [value setTextColor:UIColorFromRGB(kLightGreyColor)];
        [detailView addSubview:value];
        
        previousHeight += value.frame.size.height+2;
    }
    previousHeight = previousHeight + 4;
    
    [detailView setFrame:CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y, detailView.frame.size.width, previousHeight)];//10

    //Uncommented by Amboj
//    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kPDPMoreDetailHeader + detailView.frame.size.height+kPDPElementsPadding)];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, detailViewStartPoint + detailView.frame.size.height+kPDPElementsPadding +3)];
   return detailView;
}



//This Function can be used in future
/*
 - (void)generateHeaderView1{
 
 if(self.detailHeader){
 [self.detailHeader removeFromSuperview];
 self.detailHeader = nil;
 }
 
 
 self.detailHeader = [[GenderHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
 [self.detailHeader setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f]];
 
 //    NSArray *genderArray = [NSArray arrayWithObjects:@"Men",@"Women",@"Boys",@"Girls", nil];
 NSArray *genderArray = [NSArray arrayWithObjects:@"Style Note",@"Product Description",nil];
 
 NSMutableArray *catArray = [[NSMutableArray alloc] initWithCapacity:[genderArray count]];
 for (int catCount = 0; catCount<[genderArray count]; catCount++) {
 GenderHeaderModel *theModel = [[GenderHeaderModel alloc] init];
 //        if([[self.selectedGenderFilter capitalizedString] isEqualToString:[genderArray objectAtIndex:catCount]]){
 //            self.detailHeader.defaultGenderIndex = catCount;
 //        }
 [theModel setTheGenderDisplayName:[genderArray objectAtIndex:catCount]];
 [theModel setTheGenderValue:[genderArray objectAtIndex:catCount]];
 [theModel setTheGenderSelectedImageName:[NSString stringWithFormat:@"%@_selected",[genderArray objectAtIndex:catCount]]];
 [theModel setTheGenderImageName:[genderArray objectAtIndex:catCount]];
 
 [catArray addObject:theModel];
 }
 
 
 NSArray *theDataArray =[self.detailHeader configureViewWithData:catArray withSelectedObjectAtIndex:0];
 [self.detailHeader setGenderScrollerToDefaultIndex:self.detailHeader.defaultGenderIndex];
 self.detailHeader.onTapAction = ^(id sender){
 
 };
 [self addSubview:self.detailHeader];
 
 CGFloat previousOptionWidth = 0.0f;
 for(NSInteger counter=0; counter < [self.productMoreDescription count]; counter++){
 NSDictionary *dict = [self.productMoreDescription objectAtIndex:counter];
 NSString *title = [dict objectForKey:@"title"];
 
 //        CGSize headerBtnSize = [SSUtility getLabelDynamicSize:title withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.headerView.frame.size.width/2, 30)];
 UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
 
 [header setBackgroundColor:[UIColor clearColor]];
 [header.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
 header.tag = counter;
 [header setTitleColor:UIColorFromRGB(kDarkPurpleColor) forState:UIControlStateNormal];
 
 [header setFrame:CGRectMake(previousOptionWidth + kHeaderOptionPadding, self.detailHeader.frame.size.height/2 -15, self.frame.size.width/[self.productMoreDescription count], 30)];
 //        [header setFrame:CGRectMake(previousOptionWidth + kHeaderOptionPadding, self.headerView.frame.size.height/2 -15, headerBtnSize.width, headerBtnSize.height)];
 
 if(counter ==0){
 [header setBackgroundColor:[UIColor clearColor]];
 [self.headerScrollerView setFrame:CGRectMake(header.frame.origin.x, self.headerView.frame.size.height-5, header.frame.size.width, 5)];
 }
 [header setTitle:title forState:UIControlStateNormal];
 [header addTarget:self action:@selector(displayHeaderInfo:) forControlEvents:UIControlEventTouchUpInside];
 [self.headerView addSubview:header];
 [self.headerBtnArray addObject:header];
 
 previousOptionWidth += header.frame.size.width;
 }
 }
 */


@end
