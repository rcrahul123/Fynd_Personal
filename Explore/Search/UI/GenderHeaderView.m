//
//  GenderHeaderView.m
//  Explore
//
//  Created by Amboj Goyal on 8/5/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "GenderHeaderView.h"
#import "SSUtility.h"
#import "CustomViewForCategory.h"
#import "GenderHeaderModel.h"
#import "SSLine.h"
@interface GenderHeaderView(){
    NSMutableArray *allCategoryTilesArray;
        CGFloat XMargin;
       CGFloat bottomBarMargin;
}

@end

@implementation GenderHeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


-(void)configureScrollView{
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    if(self.backgroundColor){
        [self.theScrollView setBackgroundColor:self.backgroundColor];
    }else{
        [self.theScrollView setBackgroundColor:[UIColor clearColor]];
    }

    [self.theScrollView setScrollEnabled:TRUE];
    [self.theScrollView setShowsHorizontalScrollIndicator:FALSE];
    [self.theScrollView setDelegate:self];
    
    [self addSubview:self.theScrollView];

}

-(NSArray *)configureViewWithData:(NSArray *)dataArray withSelectedObjectAtIndex:(NSInteger)selectedIndex{
    [self configureScrollView ];
    //Common Part
    allCategoryTilesArray = [[NSMutableArray alloc] initWithCapacity:0];

    if(DeviceWidth >= 375){
        bottomBarMargin = 10.0f;
        
    }else if(DeviceWidth == 320){
        bottomBarMargin = 6.0f;
    }
    XMargin = DeviceWidth *0.12 * 4/[dataArray count];
    
    CGFloat heightForTile = self.frame.size.height-8;
//   UIFont * categoryItemFont = [UIFont variableFontWithName:kMontserrat_Light size:16.0f];

    
    allCategoryTilesArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
    
    
//    CGFloat newOrigin = 5.0f;
    CGFloat newOrigin = 0.0f;

    CGFloat totalWidth = 0.0f;
    
    for (int iCat = 0; iCat<[dataArray count]; iCat ++) {
        GenderHeaderModel *theModel = (GenderHeaderModel *)[dataArray objectAtIndex:iCat];
        CGSize textSizeForItem = [SSUtility getLabelDynamicSize:[theModel.theGenderDisplayName uppercaseString] withFont:[UIFont fontWithName:kMontserrat_Light size:13.65f] withSize:CGSizeMake(MAXFLOAT, 50)];
        
//        CustomViewForCategory *theTile = [[CustomViewForCategory alloc] initWithFrame:CGRectMake(newOrigin, 4, ceilf(sizeForItem.width) + XMargin, heightForTile)];//xmargin
        CustomViewForCategory *theTile = [[CustomViewForCategory alloc] initWithFrame:CGRectMake(DeviceWidth/[dataArray count] * iCat, 0, DeviceWidth/[dataArray count], heightForTile)];//xmargin
        theTile.headerTitleSize = textSizeForItem;
        [theTile configureView];
        [theTile setTag:11+iCat];
        theTile.headerTitle.text = [theModel.theGenderDisplayName uppercaseString];
        theTile.imageName = theModel.theGenderImageName;
        theTile.selectedImageName = theModel.theGenderSelectedImageName;

        [theTile.headerImageView setImage:[UIImage imageNamed:theModel.theGenderImageName]];
        if(self.backgroundColor){
            [self.theScrollView setBackgroundColor:self.backgroundColor];
        }else{
            [theTile setBackgroundColor:[UIColor whiteColor]];
        }
        [theTile addTarget:self action:@selector(changeCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.theScrollView addSubview:theTile];
        [allCategoryTilesArray addObject:theTile];
        newOrigin = theTile.frame.origin.x + theTile.frame.size.width+5;
        totalWidth += theTile.frame.size.width;
    
    }
    //Amboj
//    self.theScrollView.contentSize = CGSizeMake(totalWidth+25, self.frame.size.height);
    self.theScrollView.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
    
    CustomViewForCategory *selectedTile = (CustomViewForCategory *)[allCategoryTilesArray objectAtIndex:selectedIndex];
    [selectedTile.headerImageView setImage:[UIImage imageNamed:selectedTile.selectedImageName]];
    selectedTile.headerTitle.textColor = UIColorFromRGB(kPinkColor);
    

//    self.scrollLineBar = [[UIView alloc] initWithFrame:CGRectMake(selectedTile.frame.origin.x+bottomBarMargin, self.frame.size.height-3, selectedTile.frame.size.width-XMargin+25, 3)];
    self.scrollLineBar = [[UIView alloc] initWithFrame:CGRectMake(selectedTile.frame.origin.x, self.frame.size.height-4, DeviceWidth/[dataArray count], 3)];

    
    [self.scrollLineBar setBackgroundColor:UIColorFromRGB(kPinkColor)];
    [self.theScrollView addSubview:self.scrollLineBar];
    
    SSLine *line = [[SSLine alloc] initWithFrame:CGRectMake(0, self.scrollLineBar.frame.origin.y +self.scrollLineBar.frame.size.height, self.theScrollView.frame.size.width, 1)];
    [self.theScrollView addSubview:line];
    return allCategoryTilesArray;
}

- (void)animateScrollerToPosition:(CGPoint)endPosition withAnimation:(BOOL)theBool{
    if (theBool) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [self.scrollLineBar setFrame:CGRectMake(endPosition.x,self.scrollLineBar.frame.origin.y, self.scrollLineBar.frame.size.width, self.scrollLineBar.frame.size.height)];
        [UIView commitAnimations];
    }else{
        [self.scrollLineBar setFrame:CGRectMake(endPosition.x,self.scrollLineBar.frame.origin.y, self.scrollLineBar.frame.size.width, self.scrollLineBar.frame.size.height)];        
    }

    
}


- (void)setGenderScrollerToDefaultIndex:(NSInteger)index{
    CustomViewForCategory *defaultTile = [allCategoryTilesArray objectAtIndex:index];
    [self updateScroller:defaultTile withAnimation:TRUE];
    
}

-(void)changeCategory:(id)sender{
    
    [self updateScroller:sender withAnimation:TRUE];
    
    if (self.onTapAction) {
        self.onTapAction(sender);
    }
}

-(void)updateScroller:(id)sender withAnimation:(BOOL)aBool{
    CustomViewForCategory *tappedView = (CustomViewForCategory *)sender;
    
    
    tappedView.headerTitle.textColor = UIColorFromRGB(kPinkColor);


//    [self.scrollLineBar setFrame:CGRectMake(self.scrollLineBar.frame.origin.x, self.scrollLineBar.frame.origin.y, tappedView.frame.size.width-XMargin+25, self.scrollLineBar.frame.size.height)]; //5
    [self.scrollLineBar setFrame:CGRectMake(self.scrollLineBar.frame.origin.x, self.scrollLineBar.frame.origin.y, tappedView.frame.size.width, self.scrollLineBar.frame.size.height)]; //5
    
//    CGPoint btnPoint = CGPointMake(tappedView.frame.origin.x+bottomBarMargin, tappedView.frame.origin.y);
    CGPoint btnPoint = CGPointMake(tappedView.frame.origin.x, tappedView.frame.origin.y);
    [self animateScrollerToPosition:btnPoint withAnimation:aBool];
    [tappedView.headerImageView setImage:[UIImage imageNamed:tappedView.selectedImageName]];
    
    for(CustomViewForCategory *eachButton in allCategoryTilesArray){
        if(eachButton !=tappedView){
            NSString *imageName = [[NSString stringWithFormat:@"%@",eachButton.headerTitle.text] capitalizedString];
            [eachButton.headerImageView setImage:[UIImage imageNamed:imageName]];
//            eachButton.headerTitle.textColor = UIColorFromRGB(kSignUpColor);
            eachButton.headerTitle.textColor = UIColorFromRGB(kGenderSelectorTintColor);

        }
    }
    
    CGRect frame1 = CGRectZero;
    frame1.origin.x = tappedView.frame.origin.x-5;
    frame1.origin.y = self.theScrollView.frame.origin.y;
    frame1.size = self.theScrollView.frame.size;
    [self.theScrollView scrollRectToVisible:frame1 animated:aBool];
}

@end
