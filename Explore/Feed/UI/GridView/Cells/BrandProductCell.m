//
//  ProductCell.m
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "BrandProductCell.h"

@interface BrandProductCell ()
@property (nonatomic,strong) UIImageView *productImageView;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation BrandProductCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.productImageView = [[UIImageView alloc] init];
        [self addSubview:self.productImageView];
        
//        self.activityIndicator = [[UIActivityIndicatorView alloc] init];
//        [self addSubview:self.activityIndicator];
        
//        handler = [[SSBaseRequestHandler alloc] init];
        badgeImageView = [[UIImageView alloc] init];
        [self addSubview:badgeImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [self.productImageView setFrame:CGRectMake(0, 0, self.productImageViewSize.width, self.productImageViewSize.height)];
//    [self.productImageView setBackgroundColor:[UIColor clearColor]];
    placeholderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            isImageDownloaded = true;
            [self.productImageView setFrame:CGRectMake(0, 0, self.productImageViewSize.width, self.productImageViewSize.height)];
            //            [self.activityIndicator stopAnimating];
//            [self.contentView setBackgroundColor:[UIColor clearColor]];
            [self.productImageView setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [self.productImageView setAlpha:1.0];
            }];
        }
    }];

    
    if(!isImageDownloaded){
//        [self.productImageView setFrame:CGRectMake(self.productImageViewSize.width/2 - placeholderImage.size.width/2, self.productImageViewSize.height/2 - placeholderImage.size.height/2, placeholderImage.size.width, placeholderImage.size.height)];
        NSString *colorStr = [NSString stringWithFormat:@"#%@", self.productColor];
        [self.productImageView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
    
    
//    if(self.showDiscountBadge){
//        badgeImage = [UIImage imageNamed:@"DiscountBadgeSmall"];
//        [badgeImageView setFrame:CGRectMake(self.frame.size.width - badgeImage.size.width - 3, 0, badgeImage.size.width, badgeImage.size.height)];
//        badgeImageView.image = badgeImage;
//    }

}

- (void)prepareForReuse{
    [self.productImageView setFrame:CGRectZero];
    self.productImageView.image = nil;

    isImageDownloaded = false;
    placeholderImage = nil;
    
    badgeImageView.image = nil;
    [badgeImageView setFrame:CGRectZero];
}

@end
