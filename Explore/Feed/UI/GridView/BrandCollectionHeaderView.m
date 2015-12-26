//
//  BrandCollectionHeaderView.m
//  BrandCollectionPOC
//
//  Created by Pranav on 23/06/15.
//  Copyright (c) 2015 Pranav. All rights reserved.
//

#import "BrandCollectionHeaderView.h"
//#import "SSUtility.h"

@interface BrandCollectionHeaderView()
@property (nonatomic,strong) NSString *headerTitle;
@property (nonatomic,strong) NSString *headerSubTitle;
@property (nonatomic,strong) NSString *headerImage;
@property (nonatomic,strong) UIImageView    *arcImageView;

@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *subTitleLabel;
@property (nonatomic,strong) UIImageView    *brandLogo;
@property (nonatomic,strong) UIActivityIndicatorView *headerAcivityIndicator;


- (void)configureHeader;
- (void)downloadLogo:(NSString *)imageUrl;

@end

@implementation BrandCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)configureHeader{
    [self clearBrandHeaderData];
    placeHolderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
//    [self.headerImageView setBackgroundColor:[UIColor clearColor]];
    NSString *colorStr = [NSString stringWithFormat:@"#%@", self.productColor];
    [self.headerImageView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    
    [self addSubview:self.headerImageView];
    
    
    self.arcImageView = [[UIImageView alloc] init];
    
    [self.arcImageView setFrame:CGRectMake(0, self.headerImageView.frame.size.height - 20-kExtraPadding, self.headerImageView.frame.size.width, 20)];
    [self.arcImageView setBackgroundColor:[UIColor clearColor]];
    [self.arcImageView setImage:[UIImage imageNamed:@"ArcImage"]];
    [self.headerImageView addSubview:self.arcImageView];
    
//    [self.headerImageView setFrame:CGRectMake(self.frame.size.width/2 - placeHolderImage.size.width/2, self.frame.size.height/2 - 4*placeHolderImage.size.height/2, placeHolderImage.size.width, placeHolderImage.size.height)];
    [self downloadBrandHeader:self.bannerImageUrl curveRequired:TRUE];

    [self.headerImageView addSubview:self.brandLogo];
    [self.headerImageView bringSubviewToFront:self.brandLogo];
    [self sendSubviewToBack:self.headerImageView];
}


- (void)clearBrandHeaderData{
    if(self.headerImageView){
        [self.headerImageView removeFromSuperview];
        self.headerImageView = nil;
    }
    
    if(self.arcImageView){
        [self.arcImageView removeFromSuperview];
        self.arcImageView = nil;
    }
    if(self.brandLogo){
        [self.brandLogo removeFromSuperview];
        self.brandLogo = nil;
    }
}

- (CGFloat)getLogoAspectRatio:(NSString *)aspectRatio andWidth:(CGFloat)width{
    CGFloat height = 0;
    NSArray *ratioArray = [aspectRatio componentsSeparatedByString:@":"];
    height = (width) * [[ratioArray lastObject] floatValue] / [[ratioArray firstObject] floatValue];
    return height;
}


- (void)downloadBrandHeader:(NSString *)imageUrl curveRequired:(BOOL)isCurve{
    
    NSString *dataURL =  imageUrl;

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dataURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
//            [self setBackgroundColor:[UIColor clearColor]];
            _bannerImageDownloded = TRUE;
            [self.headerImageView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            
            [self.headerImageView setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [self.headerImageView setAlpha:1.0];
            }];
        }
    }];
}


- (UIImage *)curvedImage:(UIImage *)anImage{
    UIGraphicsBeginImageContext(anImage.size);
    [anImage drawAtPoint:CGPointZero];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, anImage.size.height-5)];
    [bezierPath addQuadCurveToPoint:CGPointMake(anImage.size.width, anImage.size.height-5) controlPoint:CGPointMake(anImage.size.width/2, anImage.size.height/2)];
    [bezierPath closePath];
    
    // Clip to the bezier path and clear that portion of the image.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context,bezierPath.CGPath);
    CGContextClip(context);
    CGContextClearRect(context,CGRectMake(0,0,anImage.size.width,anImage.size.height));
 
    // Build a new UIImage from the image context.
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
