//
//  SizeBox.m
//  Explore
//
//  Created by Pranav on 30/09/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "SizeBox.h"
#import "SSUtility.h"


@interface SizeBox()
@property (nonatomic,strong) UIView      *sizeButtonContainer;
@property (nonatomic,strong) UILabel     *headigTitle;
@property (nonatomic,strong) UILabel     *convenienceFee;
@property (nonatomic,strong )NSMutableArray *selectedButtons1;
@property (nonatomic,strong) NSMutableArray *selectedSizes1;
@property (nonatomic,strong) NSMutableArray *sizeBtnArray1;
@property (nonatomic,assign) NSInteger      previousSelectedIndex1;
@property (nonatomic,strong) UILabel        *sizeErrorMessage1;

@end
CGFloat fixComponentPadding1 = 10;
#define kSizePadding1 10
@implementation SizeBox
 NSInteger offSet = 0;
- (id)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
    
        self.selectedButtons1 = [[NSMutableArray alloc] init];
        self.selectedSizes1 = [[NSMutableArray alloc] initWithCapacity:0];
        self.sizeBtnArray1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setUpSizeBox{

    if(self.isFyndAFitPopUp){
        NSString *str = nil;
        if(self.sizeBoxTag == 0){
            str= @"Select the first Size";
        }else{
            str= @"Select the second Size";
        }
        CGSize sizeLabelHeadingSize = [SSUtility getLabelDynamicSize:str withFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f] withSize:CGSizeMake(self.frame.size.width - fixComponentPadding1*4, MAXFLOAT)];
        CGRect aRect = CGRectZero;
        self.headigTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - sizeLabelHeadingSize.width/2, aRect.origin.y + aRect.size.height+fixComponentPadding1/2, sizeLabelHeadingSize.width,sizeLabelHeadingSize.height)];
        [self.headigTitle setBackgroundColor:[UIColor clearColor]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        [self.headigTitle setText:str];
        [self.headigTitle setTextAlignment:NSTextAlignmentCenter];
        [self.headigTitle setNumberOfLines:0];
        [self.headigTitle setTextColor:UIColorFromRGB(kSignUpColor)];
        [self.headigTitle setFont:[UIFont fontWithName:kMontserrat_Regular size:14.0f]];
        [self addSubview:self.headigTitle];
    }
    
    offSet = self.headigTitle.frame.origin.y + self.headigTitle.frame.size.height + fixComponentPadding1;
    
    NSInteger sizeQuoitent = [self.sizeBoxData count]/6;
    CGFloat oneSizeButtonWidth = 45;
    
    
    self.sizeButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(10, offSet, self.bounds.size.width-20, (sizeQuoitent+1)*oneSizeButtonWidth + (sizeQuoitent)*fixComponentPadding1)];
    
    
    /*
    //For Center align changes
    NSInteger temp = [self.sizeBoxData count]%6;
    if(temp ==0){
        temp = [self.sizeBoxData count] *oneSizeButtonWidth + ([self.sizeBoxData count]-1)*fixComponentPadding1;
    }
    else if(temp>0 && sizeQuoitent>=1){
        temp = (6*oneSizeButtonWidth) + (6-1)*fixComponentPadding1;
    }
    else{
        temp = (temp*oneSizeButtonWidth) + (temp-1)*fixComponentPadding1;
    }
    
    self.sizeButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, offSet,temp,(sizeQuoitent+1)*oneSizeButtonWidth + (sizeQuoitent)*fixComponentPadding1)];
    [self.sizeButtonContainer setBackgroundColor:[UIColor redColor]];
     */
    [self.sizeButtonContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.sizeButtonContainer];
    
    for(NSInteger counter=0; counter < [self.sizeBoxData count]; counter++){
        
        NSInteger buttonX = counter%5;
        buttonX = (buttonX+1)*kSizePadding1 + buttonX*oneSizeButtonWidth;// For Center align changes
//        buttonX = (buttonX)*kSizePadding1 + buttonX*oneSizeButtonWidth;
        
        NSInteger buttonY = counter/5;
        buttonY = (buttonY * oneSizeButtonWidth) + (buttonY)*fixComponentPadding1;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 5.0f;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:11.0f]];
        [btn addTarget:self action:@selector(sizeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        ProductSize *sizeData = [self.sizeBoxData objectAtIndex:counter];
        [btn setTitle:sizeData.sizeDisplay forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(buttonX, buttonY, 45, 45)];
        [btn setTag:counter];
        
        /* // Keep in mind thet u have commented this.
        if(sizeData.sizeAvailable){
            btn.enabled = TRUE;
            btn.alpha = 1.0f;
        }else{
            btn.enabled = FALSE;
            btn.alpha = 0.2f;
        }
         */
        
        [self.sizeBtnArray1 addObject:btn];
        [self.sizeButtonContainer addSubview:btn];
    }
//    self.sizeButtonContainer.center = CGPointMake(self.center.x,self.sizeButtonContainer.frame.origin.y);
//    [self.sizeButtonContainer setFrame:CGRectMake(self.frame.size.width/2 - self.sizeButtonContainer.frame.size.width/2, self.sizeButtonContainer.frame.origin.y, self.sizeButtonContainer.frame.size.width, self.sizeButtonContainer.frame.size.height)];
    
}

-(void)sizeButtonSelected:(id)sender{
    UIButton *selectedSizeButton= (id)sender;
    [selectedSizeButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    selectedSizeButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
    
    ProductSize *selectedSize = [self.sizeBoxData objectAtIndex:selectedSizeButton.tag];
    NSInteger tagOfButton = selectedSizeButton.tag;
    
    UIButton *previousBtn = [self.sizeBtnArray1 objectAtIndex:self.previousSelectedIndex1];
    ProductSize *previousSizeData = [self.sizeBoxData objectAtIndex:self.previousSelectedIndex1];
    [previousBtn setBackgroundColor:[UIColor whiteColor]];
    [previousBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    previousBtn.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
    
    [self.selectedButtons1 removeObject:[NSString stringWithFormat:@"%ld",(long)previousBtn.tag]];
    [self.selectedSizes1 removeObject:previousSizeData];
    
    [self.selectedButtons1 addObject:[NSString stringWithFormat:@"%ld",(long)tagOfButton]];
    [self.selectedSizes1 addObject:selectedSize];
    
    [selectedSizeButton setBackgroundColor:UIColorFromRGB(kTurquoiseColor)];
    selectedSizeButton.layer.borderColor = UIColorFromRGB(kTurquoiseColor).CGColor;
    [selectedSizeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(self.dependentSizeBock){
        self.dependentSizeBock(selectedSize,self);
    }
    self.previousSelectedIndex1 = tagOfButton;
}


- (void)updateDependentSizes:(NSArray *)array{

//    for(NSInteger i=0; i < [array count]; i++){
//        ProductSize *size = [array objectAtIndex:i];
//    }
    
    NSArray *sizeBoxData1 = array;
    NSInteger sizeQuoitent = [sizeBoxData1 count]/6;
    CGFloat oneSizeButtonWidth = 45;
    if(self.sizeButtonContainer){
        [self.sizeButtonContainer removeFromSuperview];
        self.sizeButtonContainer = nil;
    }
    
    if(self.sizeBtnArray1){
        [self.sizeBtnArray1 removeAllObjects];
        self.sizeBtnArray1 = nil;
    }
    self.sizeBtnArray1 = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    self.sizeButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, offSet, self.bounds.size.width, (sizeQuoitent+1)*oneSizeButtonWidth + (sizeQuoitent)*fixComponentPadding1)];
    [self.sizeButtonContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.sizeButtonContainer];
    
    
    /*
    // For Center align changes
    NSInteger temp = [self.sizeBoxData count]%6;
    if(temp ==0){
        temp = [self.sizeBoxData count] *oneSizeButtonWidth + ([self.sizeBoxData count]-1)*fixComponentPadding1;
    }
    else if(temp>0 && sizeQuoitent>=1){
        temp = (6*oneSizeButtonWidth) + (6-1)*fixComponentPadding1;
    }
    else{
        temp = (temp*oneSizeButtonWidth) + (temp-1)*fixComponentPadding1;
    }
    self.sizeButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, offSet,temp,(sizeQuoitent+1)*oneSizeButtonWidth + (sizeQuoitent)*fixComponentPadding1)];
    [self.sizeButtonContainer setBackgroundColor:[UIColor redColor]];
    */
    

    for(NSInteger counter=0; counter < [self.sizeBoxData count]; counter++){
    
        NSInteger buttonX = counter%5;
        buttonX = (buttonX+1)*kSizePadding1 + buttonX*oneSizeButtonWidth; // For center align changes
//        buttonX = (buttonX)*kSizePadding1 + buttonX*oneSizeButtonWidth;
        NSInteger buttonY = counter/5;
        buttonY = (buttonY * oneSizeButtonWidth) + (buttonY)*fixComponentPadding1;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderColor = UIColorFromRGB(kLightGreyColor).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 5.0f;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:kMontserrat_Regular size:11.0f]];
        [btn addTarget:self action:@selector(sizeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        ProductSize *sizeData = [self.sizeBoxData objectAtIndex:counter];
//        ProductSize *sizeData = [sizeBoxData1 objectAtIndex:counter];
        [btn setTitle:sizeData.sizeDisplay forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(buttonX, buttonY, 45, 45)];
        [btn setTag:counter];
        btn.enabled = TRUE;
        btn.alpha = 1.0f;
        
        [self.sizeBtnArray1 addObject:btn];
        [self.sizeButtonContainer addSubview:btn];
    }
    // For center align changes
//    [self.sizeButtonContainer setFrame:CGRectMake(self.frame.size.width/2 - self.sizeButtonContainer.frame.size.width/2, self.sizeButtonContainer.frame.origin.y, self.sizeButtonContainer.frame.size.width, self.sizeButtonContainer.frame.size.height)];
}


- (void)updateSizeBoxDataArray:(NSArray *)array{
    self.sizeBoxData = [array mutableCopy];
}


- (BOOL)validateSizeSelction{
    BOOL isValid = FALSE;
    if(self.selectedButtons1 && [self.selectedButtons1 count]>0){
        isValid = TRUE;
    }
    return isValid;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
