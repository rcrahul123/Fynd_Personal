//
//  OffersView.m
//  Explore
//
//  Created by Rahul Chaudhari on 15/12/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "OffersView.h"

@implementation OffersView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.containerView = [[UIView alloc] init];
        [self.containerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.containerView];
    
        
        self.imageView = [[UIImageView alloc] init];
        [self.containerView addSubview:self.imageView];
        
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        
        self.containerView = [[UIView alloc] init];
        [self.containerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.containerView];
        
        self.imageView = [[UIImageView alloc] init];
        [self.containerView addSubview:self.imageView];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.containerView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.containerView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    NSString *colorStr = @"#C4DDE0";
    [self.imageView setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    
    
//    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.imageView setFrame:CGRectMake(RelativeSize(4, 320), RelativeSize(4, 320), self.containerView.frame.size.width - RelativeSize(8, 320), self.containerView.frame.size.height - RelativeSize(8, 320))];

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.subTileModel.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.imageView setAlpha:0.3];
        [UIView animateWithDuration:0.4 animations:^{
            [self.imageView setAlpha:1.0];
        }];
    }];
    
    [self setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    
    [[self.containerView layer] setMasksToBounds:YES];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 3.0;
}


@end
