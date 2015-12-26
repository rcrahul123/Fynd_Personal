//
//  ImageViewerContainer.h
//  
//
//  Created by Rahul on 7/10/15.
//
//

#import <UIKit/UIKit.h>
#import "ImageSubView.h"

@interface ImageViewerContainer : UIView<UIScrollViewDelegate>{
//    NSMutableArray *imageNameArray;
    UIButton *cancelButton;
    NSInteger selectedPage;
//    UISwipeGestureRecognizer *downsideSwipe;
    
    UIPageControl *pageControl;
}


@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic) NSInteger tappedImageIndex;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array withSelectedIndex:(NSInteger)tag;
@end
