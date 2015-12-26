//
//  TipCollectionViewCell.m
//  TabBasedAppSample
//
//  Created by Rahul on 6/25/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "TipCollectionViewCell.h"

@implementation TipCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        containerView = [[UIView alloc] init];
        [self addSubview:containerView];
        
        backgroundImage = [[UIImageView alloc] init];
        [containerView addSubview:backgroundImage];
        
        tipLabel = [[UILabel alloc] init];
        [containerView addSubview:tipLabel];
    }
    return self;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    labelMaxSize = CGSizeZero;
    labelFrame = CGRectZero;
    [containerView setFrame:CGRectZero];
    backgroundImage.image = nil;
    [backgroundImage setFrame:CGRectZero];
    [tipLabel setText:nil];
    [tipLabel setFrame:CGRectZero];
    self.model = nil;
    labelFont =  nil;
    bgImage = nil;
    placeholderImage = nil;
    isImageDownloaded = false;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    placeholderImage = [UIImage imageNamed:@"ImagePlaceholder"];
    labelFont = [UIFont fontWithName:kMontserrat_Bold size:14.0];
    [containerView setFrame:CGRectMake(RelativeSize(3, 320), RelativeSize(4, 320), self.frame.size.width - RelativeSize(6, 320), self.frame.size.height - RelativeSize(8, 320))];

    [backgroundImage setFrame:CGRectMake(RelativeSize(0, 320), RelativeSize(0, 320), containerView.frame.size.width  - RelativeSize(0, 320), containerView.frame.size.height - RelativeSize(0, 320))];

    [containerView setBackgroundColor:[UIColor whiteColor]];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 3.0;

    containerView.layer.shadowColor = UIColorFromRGB(kShadowColor).CGColor;
    [containerView.layer setShadowOpacity:0.1];
    [containerView.layer setShadowOffset:CGSizeMake(0.0, 1.0)];

    if(self.model.tip_text && self.model.tip_text.length > 0){
        [tipLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [tipLabel setNumberOfLines:0];
        [tipLabel setFont:labelFont];
        labelMaxSize = CGSizeMake(containerView.frame.size.width - RelativeSize(10, 320),containerView.frame.size.height);
        labelFrame = [tipLabel.text boundingRectWithSize:labelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:tipLabel.font} context:nil];
        tipLabel.frame = labelFrame;
        [tipLabel setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)];
    }
    
    [backgroundImage sd_setImageWithURL:[NSURL URLWithString:[self.model.image_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            isImageDownloaded = true;
            [backgroundImage setFrame:CGRectMake(RelativeSize(0, 320), RelativeSize(0, 320), containerView.frame.size.width  - RelativeSize(0, 320), containerView.frame.size.height - RelativeSize(0, 320))];
            [backgroundImage setAlpha:0.3];
            [UIView animateWithDuration:0.4 animations:^{
                [backgroundImage setAlpha:1.0];
            }];
        }
    }];

    if(!isImageDownloaded){
//        [backgroundImage setFrame:CGRectMake(self.frame.size.width/2 - placeholderImage.size.width/2, self.frame.size.height/2 - placeholderImage.size.height/2, placeholderImage.size.width, placeholderImage.size.height)];
        NSString *colorStr = @"#C4DDE0";
        [backgroundImage setBackgroundColor:[SSUtility colorFromHexString:colorStr withAlpha:0.2]];
    }
}



@end
