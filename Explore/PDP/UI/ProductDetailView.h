//
//  ProductDetailView.h
//  ParallexPDPSample
//
//  Created by Pranav on 08/07/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPModel.h"
#import "GridView.h"
#import "UIScrollView+VGParallaxHeader.h"
#import <AudioToolbox/AudioServices.h>

typedef void (^AddCartItem)(NSMutableArray *array,BOOL aBool);
typedef void (^DisplaySizeGuide)();

@protocol  ProductDetailViewDelegate;
@interface ProductDetailView : UIScrollView<GridViewDelegate>{
        PDPPopUpType    popUpType;
    NSTimer *likeTimer;
    
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    
    BOOL isObserverAdded;
}
@property (nonatomic,strong) PDPModel *productData;
@property (nonatomic,unsafe_unretained) id<ProductDetailViewDelegate>detailDelegate;
@property (nonatomic,copy) AddCartItem      addCartItemBlock;
@property (nonatomic,assign) BOOL           isItemAddedIntoCart;

@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@property (nonatomic,strong) UIView       *thirdStripView;
@property (nonatomic,strong) UIView       *secondStripView;
@property (nonatomic,strong) UIView       *firstStripView;
@property (nonatomic,assign) CGRect       originalFrame;
@property (nonatomic, strong) UIView *gridContainerView;

@property (nonatomic, assign) CGRect floatingButtonsStartingFrame;
@property (nonatomic, assign) CGRect floatingButtonsFixedFrame;
@property (nonatomic,strong) UIButton      *addToCartButton;
@property (nonatomic, strong) UILabel      *badgeLabel;

- (void)generateProductInfo;
- (void)updateFloatingButtons:(CGPoint)contenttOffset;
-(void)toggleLike;
- (void)updateAddToCartButton;
-(void)wiggleView;
- (void)pickAtStore:(id)sender;
- (void)addItemToCart:(id)sender;
-(void)updateButtonsFrame:(CGRect)rect;
-(void)removeObserver;

@end

@protocol ProductDetailViewDelegate <NSObject>
//- (void)updateProductInfoLayout:(NSInteger)indexValue;
- (void)updateProductInfoLayout:(NSInteger)indexValue withSimilarProductsContainerHeight:(NSInteger)gridContainerHeight;
//- (void)displayPopUp:(CGRect)anRect index:(NSInteger)withTag;
- (void)displayPopUp:(PDPPopUpType)type withUserInput:(NSMutableDictionary *)dict;
- (void)displayFeedBack;
-(void)showSimilarProductsWithProductURL:(NSString *)URL;
- (void)showSizeGuide:(NSString *)someUrl;
@end





