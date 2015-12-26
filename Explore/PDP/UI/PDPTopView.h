//
//  PDPTopView.h
//  Explore
//
//  Created by Rahul Chaudhari on 25/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewerContainer.h"
#import "PopOverlayHandler.h"
#import "PDPModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef void (^ShareBlock)(NSInteger currentIndex);

@interface PDPTopView : UIView<UIScrollViewDelegate>{
    UIScrollView *scrollViewContainer;
    ImageViewerContainer *imageViewer;
    NSMutableArray *imageArray;
}

@property (nonatomic) NSInteger numberOfImages;
@property (nonatomic, strong) NSArray *imageURLArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSString       *productInformationText;
@property (nonatomic, strong)     NSMutableArray *imageArray;

//@property (nonatomic,strong) UIView *pdpImageContainer;
@property (nonatomic,strong) PopOverlayHandler  *prodcuDescriptionPopUp;
@property (nonatomic,strong) UIView *optionsView;
@property (nonatomic,copy)ShareBlock theShareBlock;


-(id)initWithImagesArray:(NSArray *)array;
-(void)setupHeaderViewWithFrame:(CGRect)frame;
-(void)loadImages;

@end
