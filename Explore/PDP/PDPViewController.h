//
//  PDPViewController.h
//  Explore
//
//  Created by Rahul Chaudhari on 25/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "PDPModel.h"
#import "ProductDetailView.h"

#import "UIScrollView+VGParallaxHeader.h"
#import "UINavigationBar+Transparency.h"

#import "RetunPolicyViewController.h"
#import "FyndActivityItemProvider.h"

#import "PDPHeaderScrollView.h"


#import "PDPTopView.h"

@interface PDPViewController : UIViewController<ProductDetailViewDelegate, UIScrollViewDelegate, PDPHeaderScrollViewDelegate>{
    ProductDetailView *detailView;
    CGFloat headerHeight;
    
    UIActivityIndicatorView *pdpActivityIndicator;
    
    BOOL isDetailViewObserverAdded;
    
    FyndActivityIndicator *pdpLoader;
    
    RetunPolicyViewController *returnController;
    UIImage *imageToBeShared;
    
    
    PDPHeaderScrollView *headerScroller;
    
    PDPTopView *productImageView;    
}

@property (nonatomic, strong) NSString *productURL;
@property (nonatomic, strong) UIScrollView *pdpScrollView;
@property (nonatomic,strong) PDPModel       *productDiscription;
@property (nonatomic,strong) PopOverlayHandler      *popOverHandler;
@property (nonatomic, assign) BOOL isFromSearch;



@end
