//
//  PDPHeaderScrollView.h
//  Explore
//
//  Created by Rahul Chaudhari on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSubModule.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PDPModel.h"
#import "PopOverlayHandler.h"


typedef void (^ShareImageBlock)(UIImage *imageToShare);

@protocol PDPHeaderScrollViewDelegate <NSObject>

-(void)exitFullScreenMode:(id)scrollView;
@end

@interface PDPHeaderScrollView : UIScrollView<UIScrollViewDelegate, ImageSubModuleZoomDelegate>{
    CGRect originalFrame;
    UIView *superView;
    NSMutableArray *submoduleArray;
    BOOL isFullScreen;
    UIButton *closePopupButton;
    NSInteger prevPage;
    
    UIView *accessoryContainer;
    UIPageControl *pageControl;
    UIButton *modelInfoButton;
    UIButton *shareButton;
}

@property (nonatomic, strong) NSArray *imageURLArray;

@property (nonatomic, weak) id<PDPHeaderScrollViewDelegate> headerDelegate;
@property (nonatomic,copy)ShareImageBlock theShareBlock;
@property (nonatomic,strong) NSString       *productInformationText;
@property (nonatomic,strong) PopOverlayHandler  *prodcuDescriptionPopUp;


-(id)initWithFrame:(CGRect)frame andImageURLs:(NSArray *)array;
-(void)setupContainer;
@end
