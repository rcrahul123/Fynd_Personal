//
//  ImageViewerContainer.m
//  
//
//  Created by Rahul on 7/10/15.
//
//

#import "ImageViewerContainer.h"

@implementation ImageViewerContainer

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array withSelectedIndex:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if(self){
        self.imageArray = [[NSMutableArray alloc] initWithArray:array];
        selectedPage = tag;
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, 100, 20)];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl setCenter:CGPointMake(self.frame.size.width/2, pageControl.center.y)];
        [pageControl setNumberOfPages:[array count]];
        pageControl.currentPage = selectedPage;
        [self addSubview:pageControl];
        
        if ([pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            pageControl.currentPageIndicatorTintColor = UIColorFromRGB(kTurquoiseColor);
            pageControl.pageIndicatorTintColor = UIColorFromRGB(kLightGreyColor);
        }
        
        [self openImageView];
        
        
//        downsideSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
//        [downsideSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
//        [self addGestureRecognizer:downsideSwipe];

    }
    [self bringSubviewToFront:pageControl];
    return self;
}


-(void)openImageView{
//    self.imageNameArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.containerScrollView.delegate = self;
    [self.containerScrollView setBackgroundColor:[UIColor clearColor]];
    //    [self.containerScrollView setAlpha:0.7];
    [self.containerScrollView setPagingEnabled:YES];
    [self.containerScrollView setShowsHorizontalScrollIndicator:FALSE];
    [self addSubview:self.containerScrollView];
    
    [self.containerScrollView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    [UIView animateWithDuration:0.2 animations:^{
        [self.containerScrollView setTransform:CGAffineTransformMakeScale(1, 1)];
    }];
//    [self.containerScrollView setContentSize:CGSizeMake(self.containerScrollView.frame.size.width * [self.imageNameArray count], self.containerScrollView.frame.size.height)];
    [self.containerScrollView setContentSize:CGSizeMake(self.containerScrollView.frame.size.width * [self.imageArray count], self.containerScrollView.frame.size.height)];
    
//    for(int i = 0; i < [self.imageNameArray count]; i++){
    for(int i = 0; i < [self.imageArray count]; i++){
        ImageSubView *subView = [[ImageSubView alloc] initWithFrame:CGRectMake(i * self.containerScrollView.frame.size.width, 0, self.containerScrollView.frame.size.width, self.containerScrollView.frame.size.height)];
        [subView setTag:i+1];
//        [subView configureWithImageName:[self.imageNameArray objectAtIndex:i]];
        [subView setBackgroundColor:[UIColor whiteColor]];
        if([[self.imageArray objectAtIndex:i] isEqual:[NSNull null]]){
            [subView configureWIthImage:[UIImage imageNamed:@"PDPImagePlaceholder"]];
            subView.imageContainer.maximumZoomScale = 1.0;
            subView.imageContainer.minimumZoomScale = 1.0;

        }else{
            [subView configureWIthImage:[self.imageArray objectAtIndex:i]];
        }
        [self.containerScrollView addSubview:subView];
    }
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.containerScrollView.contentOffset.x + self.containerScrollView.frame.size.width - 45, 5, 40, 40)];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setImage:[UIImage imageNamed:@"CancelFullScreen"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.containerScrollView addSubview:cancelButton];
    [self.containerScrollView setContentOffset:CGPointMake(selectedPage * self.containerScrollView.frame.size.width, self.containerScrollView.contentOffset.y)];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [cancelButton setFrame:CGRectMake(self.containerScrollView.contentOffset.x + self.containerScrollView.frame.size.width - 45, 5, 40, 40)];
    
    NSInteger pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    pageControl.currentPage = pageNumber;

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    ImageSubView *currentSubView = (ImageSubView *)[self.containerScrollView viewWithTag:scrollView.contentOffset.x/scrollView.frame.size.width + 1];
    //    [currentSubView.imageContainer setZoomScale:currentSubView.originalZoomScale];
}

-(void)closeImage{
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.containerScrollView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
                         
                     }completion:^(BOOL finished) {
                         [self.containerScrollView removeFromSuperview];
                         self.containerScrollView = nil;
                         [self removeFromSuperview];
                     }];
    
}

//-(void)dismissView:(id)sender{
//    [UIView animateWithDuration:0.2
//                     animations:^{
//                         [self.containerScrollView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
//                         
//                     }completion:^(BOOL finished) {
//                         [self.containerScrollView removeFromSuperview];
//                         self.containerScrollView = nil;
//                         [self removeFromSuperview];
//                     }];
//
//
//}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
