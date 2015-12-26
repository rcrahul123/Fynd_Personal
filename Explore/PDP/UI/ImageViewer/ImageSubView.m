//
//  ImageSubView.m
//  
//
//  Created by Rahul on 7/10/15.
//
//

#import "ImageSubView.h"

@implementation ImageSubView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)configureWIthImage:(UIImage *)img{

//    self.imageName = name;
    self.imageContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageContainer.delegate = self;
    [self.imageContainer setBackgroundColor:[UIColor clearColor]];
    [self.imageContainer setBounces:true];
    self.imageContainer.showsHorizontalScrollIndicator = NO;
    self.imageContainer.showsVerticalScrollIndicator = NO;
    [self addSubview:self.imageContainer];
    
//    UIImage *image = [UIImage imageNamed:self.imageName];
    UIImage *image = img;
    imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = (CGRect){.origin=CGPointMake(15.0f, 15.0f), .size=CGSizeMake(image.size.width - 30, image.size.height - 30)};
    imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=CGSizeMake(image.size.width - 0, image.size.height - 0)};
    
    
    float deviceAspectRatio = DeviceWidth/kDeviceHeight;
    float imageAspectRatio = image.size.width/image.size.height;
    
    
    CGFloat minScale;

//    if(imageAspectRatio > deviceAspectRatio){
////        imageView.frame = CGRectMake(0, 0, DeviceWidth * image.size.height/kDeviceHeight, kDeviceHeight);
//        imageView.frame = CGRectMake(0, 0,  image.size.width * kDeviceHeight/image.size.height, kDeviceHeight);
//
//        minScale = kDeviceHeight/image.size.height;
//    }else if(imageAspectRatio < deviceAspectRatio){
////        imageView.frame = CGRectMake(0, 0, DeviceWidth, image.size.width * kDeviceHeight/DeviceWidth);
//        imageView.frame = CGRectMake(0, 0, DeviceWidth, image.size.height * DeviceWidth/image.size.width);
//
//        minScale = DeviceWidth/image.size.width;
//    }else{
//        imageView.frame = CGRectMake(0, 0, DeviceWidth, kDeviceHeight);
//        minScale = MIN(DeviceWidth/image.size.width, kDeviceHeight/image.size.height);
//    }
    
    if(imageAspectRatio < deviceAspectRatio){
        //        imageView.frame = CGRectMake(0, 0, DeviceWidth * image.size.height/kDeviceHeight, kDeviceHeight);
        imageView.frame = CGRectMake(0, 0,  image.size.width * kDeviceHeight/image.size.height, kDeviceHeight);
        
        minScale = kDeviceHeight/image.size.height;
    }else if(imageAspectRatio > deviceAspectRatio){
        //        imageView.frame = CGRectMake(0, 0, DeviceWidth, image.size.width * kDeviceHeight/DeviceWidth);
        imageView.frame = CGRectMake(0, 0, DeviceWidth, image.size.height * DeviceWidth/image.size.width);
        
        minScale = DeviceWidth/image.size.width;
    }else{
        imageView.frame = CGRectMake(0, 0, DeviceWidth, kDeviceHeight);
        minScale = MIN(DeviceWidth/image.size.width, kDeviceHeight/image.size.height);
    }
    
    
    [self.imageContainer setBackgroundColor:[UIColor clearColor]];
    
    UIPanGestureRecognizer *thePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    thePanGesture.delegate = self;
    [imageView addGestureRecognizer:thePanGesture];
    // Tell the scroll view the size of the contents
//    self.imageContainer.contentSize = image.size;
    [imageView setContentMode:UIViewContentModeScaleAspectFill];

    //    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    
    [self.imageContainer addSubview:imageView];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.imageContainer addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.imageContainer addGestureRecognizer:twoFingerTapRecognizer];
    // Set up the image we want to scroll & zoom and add it to the scroll view
    
    
//    CGRect scrollViewFrame = self.imageContainer.frame;
//    CGFloat scaleWidth = scrollViewFrame.size.width / self.imageContainer.contentSize.width;
//    CGFloat scaleHeight = scrollViewFrame.size.height / self.imageContainer.contentSize.height;
//    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.imageContainer.minimumZoomScale = 1;
    self.imageContainer.maximumZoomScale = 2.0;
//    self.imageContainer.zoomScale = minScale;
    
    self.originalZoomScale = 1;
    
    [self centerScrollViewContents];
    
//    self.imageContainer.zoomScale = 0.2;
}

-(void)closeImage{
    [self.imageContainer removeFromSuperview];
    self.imageContainer = nil;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.imageContainer.bounds.size;
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    imageView.frame = contentsFrame;
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    zoomRect.size.height = [imageView frame].size.height / scale;
    zoomRect.size.width  = [imageView frame].size.width  / scale;
    center = [imageView convertPoint:center fromView:self.imageContainer];
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    return zoomRect;
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    if(self.imageContainer.minimumZoomScale != self.imageContainer.maximumZoomScale){
    
        float newScale;
        if(self.imageContainer.zoomScale > self.originalZoomScale){
            newScale = self.originalZoomScale;
        }else{
            newScale = self.imageContainer.zoomScale * 4.0;
        }
        
        if (self.imageContainer.zoomScale > self.imageContainer.maximumZoomScale)
        {
            [self.imageContainer setZoomScale:self.imageContainer.minimumZoomScale animated:YES];
        }
        else
        {
            CGRect zoomRect = [self zoomRectForScale:newScale
                                          withCenter:[recognizer locationInView:recognizer.view]];
            [self.imageContainer zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.imageContainer.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.imageContainer.minimumZoomScale);
    [self.imageContainer setZoomScale:newZoomScale animated:YES];
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    lastLocation = self.center;
}
-(void)handlePan:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:self.superview];
    self.center = CGPointMake(lastLocation.x,
                              lastLocation.y + translation.y);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
