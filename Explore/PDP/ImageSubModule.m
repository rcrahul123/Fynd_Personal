//
//  ImageSubModule.m
//  Explore
//
//  Created by Rahul Chaudhari on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "ImageSubModule.h"

@implementation ImageSubModule

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, placeholder.size.width, placeholder.size.height)];
        [self.imageView setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
        [self.imageView setTag:248];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setUserInteractionEnabled:YES];
        [self addSubview:self.imageView];
        self.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleZoomMode)];
        [self addGestureRecognizer:singleTapGesture];
        doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGesture];
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}



-(void)toggleZoomMode{
    if(self.myDelegate && [self.myDelegate respondsToSelector:@selector(toggleFullScreen)]){
        [self.myDelegate toggleFullScreen];
    }
}


-(void)setupScrollViewAfterImageDownload{
    [self configure];
}


-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
    if(self.myDelegate && [self.myDelegate respondsToSelector:@selector(submoduleBeignZooming:withView:)]){
        [self.myDelegate submoduleBeignZooming:scrollView withView:view];
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

    if(self.myDelegate && [self.myDelegate respondsToSelector:@selector(submoduleDidEndZooming:withView:atScale:)]){
        [self.myDelegate submoduleDidEndZooming:scrollView withView:view atScale:scale];
    }
}



-(void)configure{

    UIImage *image = self.imageView.image;
    float deviceAspectRatio = self.frame.size.width/self.frame.size.height;
    float imageAspectRatio = image.size.width/image.size.height;
    CGFloat minScale;
    if(imageAspectRatio < deviceAspectRatio){
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        minScale = self.frame.size.width/image.size.width;
    }else if(imageAspectRatio > deviceAspectRatio){
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, image.size.height * self.frame.size.width/image.size.width);
        minScale = self.frame.size.width/image.size.width;
    }else{
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        minScale = MIN(self.frame.size.width/image.size.width, self.frame.size.height/image.size.height);
    }
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 2.0;
    self.originalZoomScale = 1;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    zoomRect.size.height = [_imageView frame].size.height / scale;
    zoomRect.size.width  = [_imageView frame].size.width  / scale;
    center = [_imageView convertPoint:center fromView:self];
    zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0));
    return zoomRect;
}


- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    if(self.minimumZoomScale != self.maximumZoomScale){
        
        float newScale;
        if(self.zoomScale > self.originalZoomScale){
            newScale = self.originalZoomScale;
        }else{
            newScale = self.zoomScale * 4.0;
        }
        
        if (self.zoomScale > self.maximumZoomScale)
        {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
        else
        {
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[recognizer locationInView:recognizer.view]];
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

@end
