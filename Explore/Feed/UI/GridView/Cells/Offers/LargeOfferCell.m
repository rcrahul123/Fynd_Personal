//
//  LargeOfferCell.m
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "LargeOfferCell.h"

@implementation LargeOfferCell

-(id)initWithFrame:(CGRect)frame andModel:(OffersTileModel *)model{
    self = [super initWithFrame:frame];
    if(self){
        containerScrollView = [[UIScrollView alloc] init];
        containerScrollView.delegate = self;
        containerScrollView.showsHorizontalScrollIndicator = false;
        containerScrollView.showsVerticalScrollIndicator = false;
        containerScrollView.pagingEnabled = YES;
        containerScrollView.bounces = false;
        [self addSubview:containerScrollView];
        
        pageControl = [[UIPageControl alloc] init];
        [pageControl setUserInteractionEnabled:false];
        [containerScrollView addSubview:pageControl];
        
        self.model = model;
        NSString *colorStr = @"#C4DDE0";
        bgColor = [SSUtility colorFromHexString:colorStr withAlpha:0.2];

        [self configure];

        [containerScrollView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];

//        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


-(void)configure{
    numberOfItems = [self.model.subModuleArray count];
    pageControl.numberOfPages = numberOfItems;
    if(numberOfItems < 2){
        pageControl.hidden = true;
    }
    
    [containerScrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [containerScrollView setContentSize:CGSizeMake(containerScrollView.frame.size.width * numberOfItems, containerScrollView.frame.size.height)];
        
    [pageControl setFrame:CGRectMake(containerScrollView.frame.size.width/2 - 50, containerScrollView.frame.size.height - 30, 100, 20)];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setCurrentPageIndicatorTintColor:UIColorFromRGB(kTurquoiseColor)];

    
    for(int i = 0; i < numberOfItems; i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(containerScrollView.frame.size.width * i, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height - RelativeSize(4, 320))];
        
        NSString *urlString = [(OfferSubTile *)[self.model.subModuleArray objectAtIndex:i] imageURL];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [imageView setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [imageView setAlpha:1.0];
            }];
            
            bgColor = [UIColor whiteColor];
            [containerScrollView setBackgroundColor:bgColor];
            
        }];
        
        imageView.tag = i+1;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [imageView addGestureRecognizer:imageTap];
        [imageView setUserInteractionEnabled:YES];
        [containerScrollView addSubview:imageView];
    }
    [containerScrollView bringSubviewToFront:pageControl];
    [containerScrollView setBackgroundColor:bgColor];
}


-(void)imageTapped:(UIGestureRecognizer *)recognizer{
    NSInteger tag = [recognizer.view tag];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(largeOfferCellTapped:)]){
        [self.delegate largeOfferCellTapped:[self.model.subModuleArray objectAtIndex:tag-1]];
    }
}


#pragma mark - scroll view delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [pageControl setCenter:CGPointMake(containerScrollView.frame.size.width/2 + scrollView.contentOffset.x, pageControl.center.y)];
    NSInteger pageNumber = (int)scrollView.contentOffset.x / (int)scrollView.frame.size.width;
    pageControl.currentPage = pageNumber;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
