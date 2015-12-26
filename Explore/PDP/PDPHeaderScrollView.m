//
//  PDPHeaderScrollView.m
//  Explore
//
//  Created by Rahul Chaudhari on 23/11/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PDPHeaderScrollView.h"

@implementation PDPHeaderScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame andImageURLs:(NSArray *)array{
    self = [super initWithFrame:frame];
    if(self){
        self.imageURLArray = array;
        self.bounces = NO;
        self.delegate = self;
        self.pagingEnabled = true;
        self.delegate = self;
        [self setBackgroundColor:[UIColor whiteColor]];
        originalFrame = frame;
        [self addCloseButon];
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        prevPage = 0;
        [self addAccessoryViews];
    }
    return self;
}


-(void)addAccessoryViews{
    accessoryContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 30)];
    [accessoryContainer setBackgroundColor:[UIColor clearColor]];
    [self addSubview:accessoryContainer];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, accessoryContainer.frame.size.height/2 - 15, 100, 30)];
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.currentPage = 0;
    [pageControl setNumberOfPages:[self.imageURLArray count]];
    if ([pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        pageControl.currentPageIndicatorTintColor = UIColorFromRGB(kTurquoiseColor);
        pageControl.pageIndicatorTintColor = UIColorFromRGB(kLightGreyColor);
    }
    [accessoryContainer addSubview:pageControl];
    
    UIImage *shareImage = [UIImage imageNamed:@"Share"];
    UIImage *shareTappedImage = [UIImage imageNamed:@"ShareTapped"];
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(accessoryContainer.frame.size.width - shareImage.size.width - 15, accessoryContainer.frame.size.height/2 - shareImage.size.height/2,  shareImage.size.width, shareImage.size.height)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setBackgroundImage:shareImage forState:UIControlStateNormal];
    [shareButton setBackgroundImage:shareTappedImage forState:UIControlStateHighlighted | UIControlStateSelected];
    [shareButton addTarget:self action:@selector(showShareOptions:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryContainer addSubview:shareButton];
    
    if(self.productInformationText!=nil && self.productInformationText.length > 0){
        UIImage *infoImage = [UIImage imageNamed:@"Info"];
        modelInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [modelInfoButton setFrame:CGRectMake(10, accessoryContainer.frame.size.height/2 - infoImage.size.height/2,  infoImage.size.width, infoImage.size.height)];
        [modelInfoButton setBackgroundColor:[UIColor clearColor]];
        [modelInfoButton setBackgroundImage:infoImage forState:UIControlStateNormal];
        [modelInfoButton addTarget:self action:@selector(clickOnInfo:) forControlEvents:UIControlEventTouchUpInside];
        [accessoryContainer addSubview:modelInfoButton];
    }
}


-(void)showShareOptions:(id)sender{
    if (self.theShareBlock) {
        ImageSubModule *subMod = [submoduleArray objectAtIndex:prevPage];
        UIImageView *imageView = [subMod viewWithTag:248];
        self.theShareBlock(imageView.image);
    }
}

- (void)clickOnInfo:(id)sender{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:[NSNumber numberWithInt:ProductInformationOveraly] forKey:@"PopUpType"];
    [params setObject:self.productInformationText forKey:@"PopUpData"];
    self.prodcuDescriptionPopUp = [[PopOverlayHandler alloc] init];
    [self.prodcuDescriptionPopUp presentOverlay:ProductInformationOveraly rootView:self enableAutodismissal:TRUE withUserInfo:params];
}


-(void)setupContainer{
    
    submoduleArray = [[NSMutableArray alloc] init];
    for(int i =0; i < [self.imageURLArray count]; i++){
        ImageSubModule *subModule = [[ImageSubModule alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, DeviceWidth, kDeviceHeight)];
        subModule.maximumZoomScale = 1.0;
        subModule.minimumZoomScale = 1.0;
        subModule.myDelegate = self;
        [subModule.imageView sd_setImageWithURL:[NSURL URLWithString:[[(ImageData *)[self.imageURLArray objectAtIndex:i] imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                [subModule setupScrollViewAfterImageDownload];
            }
        }];
        [self addSubview:subModule];
        [submoduleArray addObject:subModule];
    }
    [self setContentSize:CGSizeMake(self.frame.size.width *  [self.imageURLArray count], self.frame.size.height)];
    [self bringSubviewToFront:accessoryContainer];
}


-(void)pageChanged:(UIPageControl*)thePageControl{
    [self setContentOffset:CGPointMake(self.frame.size.width * thePageControl.currentPage, self.contentOffset.y) animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self bringSubviewToFront:closePopupButton];
    [closePopupButton setFrame:CGRectMake(self.contentOffset.x + self.frame.size.width - 35, closePopupButton.frame.origin.y, closePopupButton.frame.size.width, closePopupButton.frame.size.height)];
    [accessoryContainer setFrame:CGRectMake(self.contentOffset.x, accessoryContainer.frame.origin.y, accessoryContainer.frame.size.width, accessoryContainer.frame.size.height)];
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (prevPage != page) {
        ImageSubModule *module = [submoduleArray objectAtIndex:prevPage];
        module.zoomScale = 1.0;
        prevPage = page;
        pageControl.currentPage = page;
    }
}



-(void)submoduleBeignZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if(!isFullScreen){
        [self goFullScreen];
    }
}

-(void)submoduleDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [scrollView setCenter:CGPointMake(scrollView.frame.origin.x + (self.frame.size.height)/2, self.frame.size.height/2)];
//    [self centerAlignSubView];
}

-(void)addCloseButon{
    closePopupButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentOffset.x + self.frame.size.width - 35, RelativeSizeHeight(12, 667), 30, 30)];
    [closePopupButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:closePopupButton];
    [closePopupButton setImage:[UIImage imageNamed:@"CancelFullScreen"] forState:UIControlStateNormal];
    [closePopupButton setBackgroundColor:[UIColor clearColor]];
    [closePopupButton addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    
    if(!isFullScreen){
        [closePopupButton setHidden:YES];
    }
}


-(void)closePopup{
    [self setFrame:originalFrame];
    self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height);
    [closePopupButton setHidden:TRUE];
    
    [UIView animateWithDuration:0.2 animations:^{
        ImageSubModule *module = [submoduleArray objectAtIndex:prevPage];
        module.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [self topAlignSubview];
        if(self.headerDelegate && [self.headerDelegate respondsToSelector:@selector(exitFullScreenMode:)]){
            [self.headerDelegate exitFullScreenMode:self];
        }
    }];
    isFullScreen = false;
}


-(void)goFullScreen{
    self.frame = CGRectIntegral(self.frame);
    originalFrame = self.frame;

    self.frame = CGRectMake(0, 0, DeviceWidth, kDeviceHeight);
    self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height);

    for(int i = 0; i < [submoduleArray count]; i++){
        ImageSubModule *subMod = [submoduleArray objectAtIndex:i];
        subMod.zoomScale = 1.0;
        [subMod setCenter:CGPointMake(i*self.frame.size.width + self.frame.size.width/2, self.frame.size.height/2)];
    }
    [self centerAlignSubView];
    [self bringSubviewToFront:closePopupButton];

    superView = self.superview;
    [self setFrame:CGRectMake(0, 0, DeviceWidth, kDeviceHeight)];

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [[[window subviews] objectAtIndex:0] addSubview:self];
    
    if([closePopupButton isHidden]){
        [closePopupButton setHidden:FALSE];
    }
    isFullScreen = true;
}

-(void)centerAlignSubView{
    for(int i = 0; i < [submoduleArray count]; i++){
        ImageSubModule *subMod = [submoduleArray objectAtIndex:i];
        UIView *view = [subMod viewWithTag:248];
        [UIView animateWithDuration:0.2 animations:^{
            [view setCenter:CGPointMake(subMod.frame.size.width/2, subMod.frame.size.height/2)];
            [accessoryContainer setFrame:CGRectMake(self.contentOffset.x, self.frame.size.height - RelativeSizeHeight(50, 667), self.frame.size.width, 30)];
            [shareButton setAlpha:0.0];
            [modelInfoButton setAlpha:0.0];
            
        }completion:^(BOOL finished) {
            [shareButton setHidden:true];
            [modelInfoButton setHidden:true];
        }];
    }
}

-(void)topAlignSubview{
    [shareButton setHidden:false];
    [modelInfoButton setHidden:false];

    for(int i = 0; i < [submoduleArray count]; i++){
        ImageSubModule *subMod = [submoduleArray objectAtIndex:i];
        UIView *view = [subMod viewWithTag:248];
        [UIView animateWithDuration:0.2 animations:^{
            [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            [accessoryContainer setFrame:CGRectMake(self.contentOffset.x, self.frame.size.height - 50, self.frame.size.width, 30)];
            [shareButton setAlpha:1.0];
            [modelInfoButton setAlpha:1.0];
        }];
    }
}

-(void)toggleFullScreen{
    if(!isFullScreen){
        [self goFullScreen];
    }else{
        ImageSubModule *module = [submoduleArray objectAtIndex:prevPage];
        if(module.zoomScale == 1){
            [self closePopup];
        }
    }
}
@end
