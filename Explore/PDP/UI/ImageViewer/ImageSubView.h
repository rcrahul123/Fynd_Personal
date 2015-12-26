//
//  ImageSubView.h
//  
//
//  Created by Rahul on 7/10/15.
//
//

#import <UIKit/UIKit.h>

@interface ImageSubView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UIImageView *imageView;
//    UIScrollView *imageContainer;
//    CGFloat originalZoomScale;
    CGPoint lastLocation;
}

@property (nonatomic, strong) UIScrollView *imageContainer;
@property (nonatomic) CGFloat originalZoomScale;
@property (nonatomic, strong) NSString *imageName;

-(void)configureWIthImage:(UIImage *)image;
@end
