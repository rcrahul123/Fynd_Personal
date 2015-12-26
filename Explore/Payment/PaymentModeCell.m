//
//  PaymentModeCell.m
//  Explore
//
//  Created by Pranav on 15/10/15.
//  Copyright © 2015 Rahul. All rights reserved.
//

#import "PaymentModeCell.h"

@interface PaymentModeCell ()
@property (nonatomic,strong) UIImageView *paymentModeImage;
@property (nonatomic,strong) UILabel     *paymentMode;
@end

@implementation PaymentModeCell


- (id)initWithFrame:(CGRect)frame{
    
    if(self == [super initWithFrame:frame]){
    
        self.paymentModeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.paymentModeImage setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.paymentModeImage];
        
        self.paymentMode = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.paymentMode setBackgroundColor:[UIColor clearColor]];
        [self.paymentMode setFont:[UIFont fontWithName:kMontserrat_Light size:14.0f]];
        [self.paymentMode setTextColor:UIColorFromRGB(kDarkPurpleColor)];
        [self.contentView addSubview:self.paymentMode];
        maskLayer = [CAShapeLayer layer];
        
        separatorView = [[UIView alloc] init];
        [self addSubview:separatorView];

    }
    return self;
}


- (void)layoutSubviews{
    
    [self.paymentModeImage setFrame:CGRectMake(10, 8, 30, 30)];
    [self.paymentModeImage setImage:[UIImage imageNamed:self.currentPaymentData.paymentImageName]];
    
    
    CGSize size = [SSUtility getLabelDynamicSize:self.currentPaymentData.paymentDisplayName withFont:[UIFont fontWithName:kMontserrat_Light size:14.0f] withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.paymentMode setText:self.currentPaymentData.paymentDisplayName];
    [self.paymentMode setFrame:CGRectMake(self.paymentModeImage.frame.origin.x + self.paymentModeImage.frame.size.width + 8, 12, size.width, size.height)];
    
    if(self.bendType == CornerBendTypeTop){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(3.0, 3.0)];
        maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        
        [separatorView setFrame:CGRectMake(15, self.frame.size.height - 1, self.frame.size.width - 15, 1)];
        [separatorView setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];

    }else if(self.bendType == CornerBendTypeBottom){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                               cornerRadii:CGSizeMake(3.0, 3.0)];
        maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
    }else{
        [separatorView setFrame:CGRectMake(10, self.frame.size.height - 1, self.frame.size.width - 20, 1)];
        [separatorView setBackgroundColor:UIColorFromRGB(kBackgroundGreyColor)];
    }
    self.clipsToBounds = YES;
}



- (void)prepareForReuse{
    
    [self.paymentModeImage setFrame:CGRectZero];
    [self.paymentMode setFrame:CGRectZero];
    maskLayer.frame = CGRectZero;
    separatorView.frame = CGRectZero;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
