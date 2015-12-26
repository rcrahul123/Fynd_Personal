//
//  ImageSubModule.h
//  Explore
//
//  Created by Rahul Chaudhari on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSubModuleZoomDelegate <NSObject>

-(void)toggleFullScreen;
-(void)submoduleBeignZooming:(UIScrollView *)scrollView withView:(UIView *)view;
-(void)submoduleDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;
@end


@interface ImageSubModule : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    CGPoint lastLocation;
    UITapGestureRecognizer *singleTapGesture;
    UITapGestureRecognizer *doubleTapGesture;
}
@property (nonatomic) CGFloat originalZoomScale;
@property (nonatomic, strong) NSString *imageName;


@property (nonatomic, weak) id<ImageSubModuleZoomDelegate> myDelegate;
@property (nonatomic, strong) UIImageView *imageView;

-(void)setupScrollViewAfterImageDownload;
@end
