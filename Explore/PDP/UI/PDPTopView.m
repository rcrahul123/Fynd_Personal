//
//  PDPTopView.m
//  Explore
//
//  Created by Rahul Chaudhari on 25/07/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "PDPTopView.h"

@implementation PDPTopView
@synthesize imageArray;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        self.pdpImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height-20)];
//        [self.pdpImageContainer setBackgroundColor:[UIColor greenColor]];
//        //    scrollViewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height * 0.65)];
//        scrollViewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        
//        scrollViewContainer.bounces = false;
//        scrollViewContainer.clipsToBounds = true;
//        [scrollViewContainer setBackgroundColor:[UIColor whiteColor]];
//        scrollViewContainer.pagingEnabled = true;
//        scrollViewContainer.delegate = self;
//        scrollViewContainer.zoomScale = 1.0;
//        
////        [self.pdpImageContainer addSubview:scrollViewContainer];
//        [self addSubview:scrollViewContainer];
//        
//        //    self.view = scrollViewContainer;
//        
//        self.optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewContainer.frame.size.height + scrollViewContainer.frame.origin.y - 150, self.frame.size.width, 150)];
//        
//  
////        [self.pdpImageContainer addSubview:self.optionsView];
//        [self addSubview:self.optionsView];
//        
//        self.numberOfImages = [self.imageURLArray count];
//        [self loadImages];
//        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.optionsView.frame.size.width/2 - 50, 15, 100, 30)];
//        [self.pageControl setBackgroundColor:[UIColor clearColor]];
//        self.pageControl.currentPage = 0;
//        [self.pageControl setNumberOfPages:[self.imageURLArray count]];
//        [self.optionsView addSubview:self.pageControl];
//        
////        self = scrollViewContainer;
////        self = self.pdpImageContainer;
//        [self setBackgroundColor:[UIColor greenColor]];
    }
    return  self;
}

-(id)initWithImagesArray:(NSArray *)array{
    self = [super init];
    if(self){
        self.imageURLArray = array;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)setupHeaderViewWithFrame:(CGRect)frame{
    
    scrollViewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    scrollViewContainer.bounces = false;
    scrollViewContainer.clipsToBounds = true;

    [scrollViewContainer setBackgroundColor:[UIColor whiteColor]];
    scrollViewContainer.pagingEnabled = true;
    scrollViewContainer.delegate = self;
    scrollViewContainer.zoomScale = 1.0;
    
    [self addSubview:scrollViewContainer];
    
//    self.optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewContainer.frame.size.height + scrollViewContainer.frame.origin.y - 150, scrollViewContainer.frame.size.width, 150)];
    self.optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollViewContainer.frame.size.height + scrollViewContainer.frame.origin.y - 220, scrollViewContainer.frame.size.width, 150)];

    [self.optionsView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.optionsView];
    
    self.numberOfImages = [self.imageURLArray count];
    [self loadImages];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.optionsView.frame.size.width/2 - 50, 15, 100, 30)];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    self.pageControl.currentPage = 0;
    [self.pageControl setNumberOfPages:[self.self.imageURLArray count]];
    [self.optionsView addSubview:self.pageControl];
    
    if ([self.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(kTurquoiseColor);
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(kLightGreyColor);
    }
    [self setBackgroundColor:[UIColor blackColor]];
}

-(void)loadImages{
 
    imageArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfImages];
    for(int i = 0; i < self.numberOfImages ; i++){
        [imageArray addObject:[NSNull null]];
    }

    [scrollViewContainer setContentSize:CGSizeMake(scrollViewContainer.frame.size.width * self.numberOfImages, scrollViewContainer.frame.size.height)];
    for (int i = 0; i < self.numberOfImages; i++) {
        CGRect imageFrame = CGRectMake(scrollViewContainer.frame.size.width * i, 0, scrollViewContainer.frame.size.width, scrollViewContainer.frame.size.height);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setTag:i + 1];

        if(self.productInformationText!=nil && self.productInformationText.length > 0){
            UIImage *infoImage = [UIImage imageNamed:@"Info"];
            UIButton *infoIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            [infoIcon setFrame:CGRectMake(10, 10,  infoImage.size.width, infoImage.size.height)];

            
            [infoIcon setBackgroundColor:[UIColor clearColor]];
            [infoIcon setBackgroundImage:infoImage forState:UIControlStateNormal];
            [infoIcon addTarget:self action:@selector(clickOnInfo:) forControlEvents:UIControlEventTouchUpInside];
            [self.optionsView addSubview:infoIcon];

        }
        
        UIImage *shareImage = [UIImage imageNamed:@"Share"];
        UIImage *shareTappedImage = [UIImage imageNamed:@"ShareTapped"];
        UIButton *shareIcon = [[UIButton alloc] initWithFrame:CGRectMake(scrollViewContainer.frame.size.width -(RelativeSize(32, 320)+10), /*infoIcon.frame.origin.y*/10,  shareImage.size.width, shareImage.size.height)];

        [shareIcon setBackgroundColor:[UIColor clearColor]];
        [shareIcon setBackgroundImage:shareImage forState:UIControlStateNormal];
        [shareIcon setBackgroundImage:shareTappedImage forState:UIControlStateHighlighted | UIControlStateSelected];
        [shareIcon addTarget:self action:@selector(showShareOptions:) forControlEvents:UIControlEventTouchUpInside];
        shareIcon.tag = i;
        [self.optionsView addSubview:shareIcon];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"ImagePlaceholder"];
        [imageView setFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width/2 - placeholderImage.size.width/2, imageView.frame.origin.y + imageView.frame.size.height/2 - placeholderImage.size.height/2, placeholderImage.size.width, placeholderImage.size.height)];
        imageView.image = placeholderImage;
        
        if(self.imageURLArray && [self.imageURLArray count]>0)
        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                ImageData *imageDataObject = [self.imageURLArray objectAtIndex:i];
//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageDataObject.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    UIImage *img = [UIImage imageWithData:imageData];
//                   
//                    if(img!=nil)
//                    {
//                        [imageView setFrame:CGRectMake(imageFrame.origin.x, imageFrame.origin.y, DeviceWidth, img.size.height *DeviceWidth/img.size.width)];
//                        [imageView setImage:[UIImage imageWithData:imageData]];
//                        [imageView setContentMode:UIViewContentModeScaleAspectFill];
//                        [imageArray replaceObjectAtIndex:i withObject:imageView.image];
//                    }
//                    
//                });
//            });
            
            
            ImageData *imageDataObject = [self.imageURLArray objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageDataObject.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [imageView setFrame:CGRectMake(imageFrame.origin.x, imageFrame.origin.y, DeviceWidth, image.size.height *DeviceWidth/image.size.width)];
                    [imageView setContentMode:UIViewContentModeScaleAspectFill];
                    [imageArray replaceObjectAtIndex:i withObject:imageView.image];                    
                }
            }];
        }
        
        // Add GestureRecognizer to ImageView
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                              initWithTarget:self
                                                              action:@selector(imageTapped:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTapGestureRecognizer];
        [imageView setUserInteractionEnabled:YES];
        [scrollViewContainer addSubview:imageView];
    }
}

-(void)showShareOptions:(id)sender{
    NSInteger tag = [sender tag];
    if (self.theShareBlock) {
        self.theShareBlock(tag);
    }
}

- (void)clickOnInfo:(id)sender{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:[NSNumber numberWithInt:ProductInformationOveraly] forKey:@"PopUpType"];
    [params setObject:self.productInformationText forKey:@"PopUpData"];
    self.prodcuDescriptionPopUp = [[PopOverlayHandler alloc] init];
    [self.prodcuDescriptionPopUp presentOverlay:ProductInformationOveraly rootView:self enableAutodismissal:TRUE withUserInfo:params];
}

-(void)imageTapped:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *view = (UIImageView *)recognizer.view;

    imageViewer = [[ImageViewerContainer alloc] initWithFrame:[[UIScreen mainScreen] bounds] imageArray:imageArray withSelectedIndex:view.tag - 1];
    [imageViewer setBackgroundColor:[UIColor whiteColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageViewer];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = pageNumber;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
